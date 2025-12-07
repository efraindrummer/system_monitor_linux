import 'dart:async';
import 'dart:io';
import 'package:process_run/shell.dart';
import '../models/system_info.dart';

class SystemMonitorService {
  final Shell _shell = Shell();
  Map<String, int> _lastNetworkBytes = {};
  DateTime _lastNetworkCheck = DateTime.now();
  Map<String, List<int>> _lastCpuStats = {};

  // CPU Monitoring
  Future<CpuInfo> getCpuInfo() async {
    try {
      // Get CPU model
      final modelResult = await _shell.run('lscpu');
      String model = 'Unknown';
      if (modelResult.isNotEmpty && modelResult.first.outText.isNotEmpty) {
        final lines = modelResult.first.outText.split('\n');
        for (var line in lines) {
          if (line.contains('Model name')) {
            model = line.split(':').last.trim();
            break;
          }
        }
      }

      // Get number of cores
      final coresResult = await _shell.run('nproc');
      int coreCount = int.parse(coresResult.first.outText.trim());

      // Get CPU usage per core
      final statResult = await _shell.run('cat /proc/stat');
      List<String> lines = statResult.first.outText.split('\n');
      
      List<double> usagePerCore = [];
      double totalUsage = 0.0;

      for (var line in lines) {
        if (line.startsWith('cpu') && !line.startsWith('cpu ')) {
          String cpuId = line.split(' ')[0];
          List<int> stats = line
              .split(' ')
              .where((s) => s.isNotEmpty && s != cpuId)
              .map((s) => int.tryParse(s) ?? 0)
              .toList();

          if (stats.length >= 4) {
            double usage = await _calculateCpuUsage(cpuId, stats);
            usagePerCore.add(usage);
          }
        } else if (line.startsWith('cpu ')) {
          List<int> stats = line
              .split(' ')
              .where((s) => s.isNotEmpty && s != 'cpu')
              .map((s) => int.tryParse(s) ?? 0)
              .toList();

          if (stats.length >= 4) {
            totalUsage = await _calculateCpuUsage('cpu', stats);
          }
        }
      }

      return CpuInfo(
        coreCount: coreCount,
        usagePerCore: usagePerCore,
        totalUsage: totalUsage,
        model: model,
      );
    } catch (e) {
      print('Error getting CPU info: $e');
      return CpuInfo.empty();
    }
  }

  Future<double> _calculateCpuUsage(String cpuId, List<int> currentStats) async {
    int idle = currentStats.length > 3 ? currentStats[3] : 0;
    int total = currentStats.reduce((a, b) => a + b);

    if (_lastCpuStats.containsKey(cpuId)) {
      List<int> lastStats = _lastCpuStats[cpuId]!;
      int lastIdle = lastStats.length > 3 ? lastStats[3] : 0;
      int lastTotal = lastStats.reduce((a, b) => a + b);

      int totalDiff = total - lastTotal;
      int idleDiff = idle - lastIdle;

      if (totalDiff > 0) {
        _lastCpuStats[cpuId] = currentStats;
        return ((totalDiff - idleDiff) / totalDiff * 100).clamp(0.0, 100.0);
      }
    }

    _lastCpuStats[cpuId] = currentStats;
    return 0.0;
  }

  // Memory Monitoring
  Future<MemoryInfo> getMemoryInfo() async {
    try {
      final result = await _shell.run('cat /proc/meminfo');
      Map<String, int> memInfo = {};

      for (var line in result.first.outText.split('\n')) {
        if (line.isEmpty) continue;
        var parts = line.split(':');
        if (parts.length == 2) {
          String key = parts[0].trim();
          String value = parts[1].trim().replaceAll('kB', '').trim();
          memInfo[key] = int.tryParse(value) ?? 0;
        }
      }

      int totalMemory = (memInfo['MemTotal'] ?? 0) * 1024;
      int freeMemory = (memInfo['MemAvailable'] ?? 0) * 1024;
      int usedMemory = totalMemory - freeMemory;
      int totalSwap = (memInfo['SwapTotal'] ?? 0) * 1024;
      int freeSwap = (memInfo['SwapFree'] ?? 0) * 1024;
      int usedSwap = totalSwap - freeSwap;

      double memoryPercentage = totalMemory > 0 
          ? (usedMemory / totalMemory * 100) 
          : 0.0;
      double swapPercentage = totalSwap > 0 
          ? (usedSwap / totalSwap * 100) 
          : 0.0;

      return MemoryInfo(
        totalMemory: totalMemory,
        usedMemory: usedMemory,
        freeMemory: freeMemory,
        totalSwap: totalSwap,
        usedSwap: usedSwap,
        memoryPercentage: memoryPercentage,
        swapPercentage: swapPercentage,
      );
    } catch (e) {
      print('Error getting memory info: $e');
      return MemoryInfo.empty();
    }
  }

  // Disk Monitoring
  Future<List<DiskInfo>> getDiskInfo() async {
    try {
      final result = await _shell.run('df -h');
      List<DiskInfo> disks = [];

      for (var line in result.first.outText.split('\n')) {
        if (line.isEmpty || !line.startsWith('/')) continue;
        var parts = line.split(RegExp(r'\s+'));
        if (parts.length >= 6) {
          disks.add(DiskInfo(
            filesystem: parts[0],
            size: parts[1],
            used: parts[2],
            available: parts[3],
            usePercentage: double.tryParse(parts[4].replaceAll('%', '')) ?? 0.0,
            mountPoint: parts[5],
          ));
        }
      }

      return disks;
    } catch (e) {
      print('Error getting disk info: $e');
      return [];
    }
  }

  // Network Monitoring
  Future<List<NetworkInfo>> getNetworkInfo() async {
    try {
      final result = await _shell.run('cat /proc/net/dev');
      List<NetworkInfo> networks = [];
      DateTime now = DateTime.now();
      double timeDiff = now.difference(_lastNetworkCheck).inMilliseconds / 1000.0;

      for (var line in result.first.outText.split('\n').skip(2)) {
        if (line.trim().isEmpty) continue;
        
        var parts = line.split(':');
        if (parts.length != 2) continue;

        String interface = parts[0].trim();
        if (interface == 'lo') continue; // Skip loopback

        var stats = parts[1].trim().split(RegExp(r'\s+'));
        if (stats.length < 9) continue;

        int bytesReceived = int.tryParse(stats[0]) ?? 0;
        int bytesSent = int.tryParse(stats[8]) ?? 0;

        double downloadSpeed = 0.0;
        double uploadSpeed = 0.0;

        String rxKey = '$interface-rx';
        String txKey = '$interface-tx';

        if (_lastNetworkBytes.containsKey(rxKey) && timeDiff > 0) {
          downloadSpeed = (bytesReceived - _lastNetworkBytes[rxKey]!) / timeDiff;
          uploadSpeed = (bytesSent - _lastNetworkBytes[txKey]!) / timeDiff;
        }

        _lastNetworkBytes[rxKey] = bytesReceived;
        _lastNetworkBytes[txKey] = bytesSent;

        networks.add(NetworkInfo(
          interface: interface,
          bytesReceived: bytesReceived,
          bytesSent: bytesSent,
          downloadSpeed: downloadSpeed,
          uploadSpeed: uploadSpeed,
        ));
      }

      _lastNetworkCheck = now;
      return networks;
    } catch (e) {
      print('Error getting network info: $e');
      return [];
    }
  }

  // Temperature Monitoring
  Future<List<TemperatureInfo>> getTemperatureInfo() async {
    try {
      // Try using sensors command
      final result = await _shell.run('sensors');
      
      if (result.first.outText.contains('not_found')) {
        // Fallback to reading thermal zones directly
        return await _getThermalZoneTemperatures();
      }

      List<TemperatureInfo> temperatures = [];
      String currentSensor = '';
      
      for (var line in result.first.outText.split('\n')) {
        if (line.isEmpty) continue;
        
        if (!line.startsWith(' ') && line.contains(':')) {
          currentSensor = line.split(':')[0].trim();
        } else if (line.contains('°C')) {
          var parts = line.split(':');
          if (parts.length >= 2) {
            String sensorName = parts[0].trim();
            String tempStr = parts[1].split('°C')[0].replaceAll(RegExp(r'[^\d.-]'), '').trim();
            double? temp = double.tryParse(tempStr);
            
            if (temp != null) {
              temperatures.add(TemperatureInfo(
                sensor: '$currentSensor - $sensorName',
                temperature: temp,
              ));
            }
          }
        }
      }

      return temperatures.isEmpty ? await _getThermalZoneTemperatures() : temperatures;
    } catch (e) {
      print('Error getting temperature info: $e');
      return await _getThermalZoneTemperatures();
    }
  }

  Future<List<TemperatureInfo>> _getThermalZoneTemperatures() async {
    List<TemperatureInfo> temperatures = [];
    
    try {
      final thermalDir = Directory('/sys/class/thermal');
      if (!await thermalDir.exists()) return temperatures;

      await for (var entity in thermalDir.list()) {
        if (entity is Directory && entity.path.contains('thermal_zone')) {
          try {
            final typeFile = File('${entity.path}/type');
            final tempFile = File('${entity.path}/temp');
            
            if (await typeFile.exists() && await tempFile.exists()) {
              String type = await typeFile.readAsString();
              String tempStr = await tempFile.readAsString();
              
              double temp = double.parse(tempStr.trim()) / 1000.0;
              temperatures.add(TemperatureInfo(
                sensor: type.trim(),
                temperature: temp,
              ));
            }
          } catch (e) {
            // Skip this thermal zone
          }
        }
      }
    } catch (e) {
      print('Error reading thermal zones: $e');
    }

    return temperatures;
  }

  // Get uptime
  Future<String> getUptime() async {
    try {
      final result = await _shell.run('uptime -p');
      return result.first.outText.trim().replaceAll('up ', '');
    } catch (e) {
      return 'Unknown';
    }
  }
}
