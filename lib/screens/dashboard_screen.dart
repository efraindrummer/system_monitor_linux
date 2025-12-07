// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:io';
import '../models/system_info.dart';
import '../services/system_monitor_service.dart';
import '../widgets/system_widgets.dart';
import '../widgets/charts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final SystemMonitorService _monitorService = SystemMonitorService();
  Timer? _updateTimer;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  CpuInfo _cpuInfo = CpuInfo.empty();
  MemoryInfo _memoryInfo = MemoryInfo.empty();
  List<DiskInfo> _diskInfo = [];
  List<NetworkInfo> _networkInfo = [];
  List<TemperatureInfo> _temperatureInfo = [];
  String _uptime = 'Loading...';

  // History for charts (last 60 data points)
  final List<double> _cpuHistory = List.generate(60, (_) => 0.0);
  final List<double> _memoryHistory = List.generate(60, (_) => 0.0);
  final List<double> _downloadHistory = List.generate(60, (_) => 0.0);
  final List<double> _uploadHistory = List.generate(60, (_) => 0.0);

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _initializeMonitoring();
  }

  void _initializeMonitoring() {
    _updateSystemInfo();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateSystemInfo();
    });
  }

  Future<void> _updateSystemInfo() async {
    try {
      final cpuInfo = await _monitorService.getCpuInfo();
      final memoryInfo = await _monitorService.getMemoryInfo();
      final diskInfo = await _monitorService.getDiskInfo();
      final networkInfo = await _monitorService.getNetworkInfo();
      final temperatureInfo = await _monitorService.getTemperatureInfo();
      final uptime = await _monitorService.getUptime();

      setState(() {
        _cpuInfo = cpuInfo;
        _memoryInfo = memoryInfo;
        _diskInfo = diskInfo;
        _networkInfo = networkInfo;
        _temperatureInfo = temperatureInfo;
        _uptime = uptime;
        _isLoading = false;

        // Update history
        _cpuHistory.removeAt(0);
        _cpuHistory.add(cpuInfo.totalUsage);

        _memoryHistory.removeAt(0);
        _memoryHistory.add(memoryInfo.memoryPercentage);

        if (networkInfo.isNotEmpty) {
          _downloadHistory.removeAt(0);
          _downloadHistory.add(networkInfo.first.downloadSpeed);

          _uploadHistory.removeAt(0);
          _uploadHistory.add(networkInfo.first.uploadSpeed);
        }
      });
    } catch (e) {
      print('Error updating system info: $e');
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseController.value * 0.1),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1976D2),
                            const Color(0xFF667EEA),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1976D2).withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.monitor_heart_outlined,
                        color: Color(0xFF1976D2),
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Inicializando Sistema...',
                style: TextStyle(
                  color: Color(0xFF546E7A),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
          slivers: [
            _buildGlassAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Top Stats Row
                _buildTopStatsRow(),
                const SizedBox(height: 16),
                
                // Widget Controls
                _buildWidgetControls(),
                const SizedBox(height: 24),

                // CPU Section
                _buildGlassSectionTitle('Procesador', Icons.memory, const Color(0xFF1976D2)),
                const SizedBox(height: 16),
                _buildGlassCard(
                  child: Column(
                    children: [
                      _buildCpuHeader(),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 120,
                        child: CpuUsageChart(cpuHistory: _cpuHistory),
                      ),
                      const SizedBox(height: 20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _cpuInfo.coreCount > 8 ? 6 : 4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: _cpuInfo.usagePerCore.length,
                        itemBuilder: (context, index) {
                          return CpuCoreWidget(
                            coreNumber: index,
                            usage: _cpuInfo.usagePerCore[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Memory and Network Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildGlassSectionTitle('Memoria', Icons.memory_outlined, const Color(0xFF0288D1)),
                          const SizedBox(height: 16),
                          _buildGlassCard(
                            child: Column(
                              children: [
                                _buildMemoryStats(),
                                const SizedBox(height: 16),
                                SizedBox(
                                  height: 100,
                                  child: MemoryUsageChart(memoryHistory: _memoryHistory),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          _buildGlassSectionTitle('Red', Icons.wifi, const Color(0xFF00ACC1)),
                          const SizedBox(height: 16),
                          _buildGlassCard(
                            child: Column(
                              children: [
                                if (_networkInfo.isNotEmpty) ...[
                                  _buildNetworkStats(),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 100,
                                    child: NetworkUsageChart(
                                      downloadHistory: _downloadHistory,
                                      uploadHistory: _uploadHistory,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Disks Section
                _buildGlassSectionTitle('Almacenamiento', Icons.storage, const Color(0xFFFB8C00)),
                const SizedBox(height: 16),
                ..._diskInfo.map((disk) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DiskUsageWidget(
                        filesystem: disk.filesystem,
                        size: disk.size,
                        used: disk.used,
                        percentage: disk.usePercentage,
                        mountPoint: disk.mountPoint,
                      ),
                    )),
                const SizedBox(height: 24),

                // Temperature Section
                if (_temperatureInfo.isNotEmpty) ...[
                  _buildGlassSectionTitle('Temperatura', Icons.thermostat, const Color(0xFFFF5252)),
                  const SizedBox(height: 16),
                  _buildGlassCard(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _temperatureInfo.map((temp) => 
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _getColorForTemp(temp.temperature).withOpacity(0.2),
                                _getColorForTemp(temp.temperature).withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getColorForTemp(temp.temperature).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thermostat,
                                color: _getColorForTemp(temp.temperature),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${temp.temperature.toStringAsFixed(1)}°C',
                                style: TextStyle(
                                  color: _getColorForTemp(temp.temperature),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
        ),
        child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1976D2).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.monitor_heart_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Monitor',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C3E50),
                      fontSize: 18,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Panel Empresarial',
                    style: TextStyle(
                      color: Color(0xFF78909C),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF1976D2), size: 18),
              const SizedBox(width: 8),
              Text(
                _uptime,
                style: const TextStyle(
                  color: Color(0xFF546E7A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTopStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMiniStat(
            'CPU',
            '${_cpuInfo.totalUsage.toStringAsFixed(1)}%',
            Icons.memory,
            const Color(0xFF1976D2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMiniStat(
            'RAM',
            '${_memoryInfo.usedMemoryGB} GB',
            Icons.dns,
            const Color(0xFF0288D1),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMiniStat(
            'Red',
            _networkInfo.isNotEmpty ? '${(_networkInfo.first.downloadSpeed / 1024 / 1024).toStringAsFixed(1)} MB/s' : '0 MB/s',
            Icons.wifi,
            const Color(0xFF00ACC1),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF78909C),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCpuHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _cpuInfo.model,
                style: const TextStyle(
                  color: Color(0xFF546E7A),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${_cpuInfo.coreCount} Núcleos',
                style: const TextStyle(
                  color: Color(0xFF90A4AE),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1976D2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF1976D2).withOpacity(0.3),
            ),
          ),
          child: Text(
            '${_cpuInfo.totalUsage.toStringAsFixed(1)}%',
            style: const TextStyle(
              color: Color(0xFF1976D2),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemoryStats() {
    return Column(
      children: [
        _buildMemoryBar(
          'RAM',
          _memoryInfo.memoryPercentage,
          '${_memoryInfo.usedMemoryGB} / ${_memoryInfo.totalMemoryGB} GB',
          const Color(0xFF0288D1),
        ),
        const SizedBox(height: 16),
        _buildMemoryBar(
          'Swap',
          _memoryInfo.swapPercentage,
          '${(_memoryInfo.usedSwap / 1024 / 1024 / 1024).toStringAsFixed(1)} / ${(_memoryInfo.totalSwap / 1024 / 1024 / 1024).toStringAsFixed(1)} GB',
          const Color(0xFF9C27B0),
        ),
      ],
    );
  }

  Widget _buildMemoryBar(String label, double percentage, String detail, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFECEFF1),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          detail,
          style: const TextStyle(
            color: Color(0xFF90A4AE),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkStats() {
    if (_networkInfo.isEmpty) return const SizedBox();
    
    final network = _networkInfo.first;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildNetworkIndicator(
                '↓ Download',
                network.downloadSpeed,
                const Color(0xFF00ACC1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNetworkIndicator(
                '↑ Upload',
                network.uploadSpeed,
                const Color(0xFFFB8C00),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          network.interface,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkIndicator(String label, double speed, Color color) {
    String formattedSpeed = speed < 1024
        ? '${speed.toStringAsFixed(0)} B/s'
        : speed < 1024 * 1024
            ? '${(speed / 1024).toStringAsFixed(1)} KB/s'
            : '${(speed / 1024 / 1024).toStringAsFixed(2)} MB/s';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formattedSpeed,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getColorForTemp(double temp) {
    if (temp < 50) return const Color(0xFF00ACC1);
    if (temp < 70) return const Color(0xFF4CAF50);
    if (temp < 85) return const Color(0xFFFB8C00);
    return const Color(0xFFFF5252);
  }

  // Widget Controls para crear widgets flotantes
  Widget _buildWidgetControls() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.widgets_outlined,
                  color: Color(0xFF1976D2),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Widgets de Escritorio',
                style: TextStyle(
                  color: Color(0xFF2C3E50),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildWidgetButton(
                'CPU',
                Icons.memory,
                const Color(0xFF1976D2),
                () => _showFloatingWidget('cpu'),
              ),
              _buildWidgetButton(
                'RAM',
                Icons.dns,
                const Color(0xFF0288D1),
                () => _showFloatingWidget('ram'),
              ),
              _buildWidgetButton(
                'Red',
                Icons.wifi,
                const Color(0xFF00ACC1),
                () => _showFloatingWidget('network'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.launch,
                color: color.withOpacity(0.6),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFloatingWidget(String type) async {
    // Lanzar una nueva instancia de la aplicación en modo widget
    // Esto crea una ventana completamente independiente que se puede arrastrar por el escritorio
    try {
      final executable = Platform.resolvedExecutable;
      await Process.start(
        executable,
        [type],
        mode: ProcessStartMode.detached,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Widget de ${type.toUpperCase()} lanzado'),
            duration: const Duration(seconds: 2),
            backgroundColor: _getColorForWidgetType(type).withOpacity(0.9),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al lanzar widget: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  Color _getColorForWidgetType(String type) {
    switch (type) {
      case 'cpu':
        return const Color(0xFF1976D2);
      case 'ram':
        return const Color(0xFF0288D1);
      case 'network':
        return const Color(0xFF00ACC1);
      default:
        return Colors.blue;
    }
  }
}
