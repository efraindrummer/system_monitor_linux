class CpuInfo {
  final int coreCount;
  final List<double> usagePerCore;
  final double totalUsage;
  final String model;

  CpuInfo({
    required this.coreCount,
    required this.usagePerCore,
    required this.totalUsage,
    required this.model,
  });

  factory CpuInfo.empty() {
    return CpuInfo(
      coreCount: 0,
      usagePerCore: [],
      totalUsage: 0.0,
      model: 'Unknown',
    );
  }
}

class MemoryInfo {
  final int totalMemory;
  final int usedMemory;
  final int freeMemory;
  final int totalSwap;
  final int usedSwap;
  final double memoryPercentage;
  final double swapPercentage;

  MemoryInfo({
    required this.totalMemory,
    required this.usedMemory,
    required this.freeMemory,
    required this.totalSwap,
    required this.usedSwap,
    required this.memoryPercentage,
    required this.swapPercentage,
  });

  factory MemoryInfo.empty() {
    return MemoryInfo(
      totalMemory: 0,
      usedMemory: 0,
      freeMemory: 0,
      totalSwap: 0,
      usedSwap: 0,
      memoryPercentage: 0.0,
      swapPercentage: 0.0,
    );
  }

  String get totalMemoryGB => (totalMemory / 1024 / 1024 / 1024).toStringAsFixed(1);
  String get usedMemoryGB => (usedMemory / 1024 / 1024 / 1024).toStringAsFixed(1);
}

class DiskInfo {
  final String filesystem;
  final String size;
  final String used;
  final String available;
  final double usePercentage;
  final String mountPoint;

  DiskInfo({
    required this.filesystem,
    required this.size,
    required this.used,
    required this.available,
    required this.usePercentage,
    required this.mountPoint,
  });
}

class NetworkInfo {
  final String interface;
  final int bytesReceived;
  final int bytesSent;
  final double downloadSpeed;
  final double uploadSpeed;

  NetworkInfo({
    required this.interface,
    required this.bytesReceived,
    required this.bytesSent,
    required this.downloadSpeed,
    required this.uploadSpeed,
  });

  factory NetworkInfo.empty() {
    return NetworkInfo(
      interface: 'Unknown',
      bytesReceived: 0,
      bytesSent: 0,
      downloadSpeed: 0.0,
      uploadSpeed: 0.0,
    );
  }

  String get downloadSpeedMB => (downloadSpeed / 1024 / 1024).toStringAsFixed(2);
  String get uploadSpeedMB => (uploadSpeed / 1024 / 1024).toStringAsFixed(2);
}

class TemperatureInfo {
  final String sensor;
  final double temperature;
  final double? critical;
  final double? high;

  TemperatureInfo({
    required this.sensor,
    required this.temperature,
    this.critical,
    this.high,
  });

  factory TemperatureInfo.empty() {
    return TemperatureInfo(
      sensor: 'Unknown',
      temperature: 0.0,
    );
  }
}
