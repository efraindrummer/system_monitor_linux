// ignore_for_file: unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../models/system_info.dart';
import 'dart:ui';

class FloatingWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onClose;

  const FloatingWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      color: Colors.white.withOpacity(0.7),
                      onPressed: onClose,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget de CPU Flotante
class FloatingCpuWidget extends StatefulWidget {
  final Function(CpuInfo) onUpdate;

  const FloatingCpuWidget({
    super.key,
    required this.onUpdate, required CpuInfo cpuInfo,
  });

  @override
  State<FloatingCpuWidget> createState() => _FloatingCpuWidgetState();
}

class _FloatingCpuWidgetState extends State<FloatingCpuWidget> {
  CpuInfo _cpuInfo = CpuInfo.empty();

  @override
  Widget build(BuildContext context) {
    return FloatingWidget(
      title: 'CPU Usage',
      value: '${_cpuInfo.totalUsage.toStringAsFixed(1)}%',
      icon: Icons.memory,
      color: const Color(0xFF00D9FF),
      onClose: () {
        Navigator.of(context).pop();
      },
    );
  }

  void updateCpuInfo(CpuInfo cpuInfo) {
    if (mounted) {
      setState(() {
        _cpuInfo = cpuInfo;
      });
    }
  }
}

// Widget de RAM Flotante
class FloatingRamWidget extends StatefulWidget {
  final Function(MemoryInfo) onUpdate;

  const FloatingRamWidget({
    super.key,
    required this.onUpdate, required MemoryInfo memoryInfo,
  });

  @override
  State<FloatingRamWidget> createState() => _FloatingRamWidgetState();
}

class _FloatingRamWidgetState extends State<FloatingRamWidget> {
  MemoryInfo _memoryInfo = MemoryInfo.empty();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFBB86FC).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFBB86FC).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBB86FC).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.memory,
                        color: Color(0xFFBB86FC),
                        size: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      color: Colors.white.withOpacity(0.7),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'RAM Usage',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_memoryInfo.memoryPercentage.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    color: Color(0xFFBB86FC),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_memoryInfo.usedMemoryGB} / ${_memoryInfo.totalMemoryGB} GB',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateMemoryInfo(MemoryInfo memoryInfo) {
    if (mounted) {
      setState(() {
        _memoryInfo = memoryInfo;
      });
    }
  }
}

// Widget de Red Flotante
class FloatingNetworkWidget extends StatefulWidget {
  final Function(List<NetworkInfo>) onUpdate;

  const FloatingNetworkWidget({
    super.key,
    required this.onUpdate, required List<NetworkInfo> networkInfo,
  });

  @override
  State<FloatingNetworkWidget> createState() => _FloatingNetworkWidgetState();
}

class _FloatingNetworkWidgetState extends State<FloatingNetworkWidget> {
  List<NetworkInfo> _networkInfo = [];

  @override
  Widget build(BuildContext context) {
    final network = _networkInfo.isNotEmpty ? _networkInfo.first : NetworkInfo.empty();
    final downloadSpeed = network.downloadSpeed < 1024
        ? '${network.downloadSpeed.toStringAsFixed(0)} B/s'
        : network.downloadSpeed < 1024 * 1024
            ? '${(network.downloadSpeed / 1024).toStringAsFixed(1)} KB/s'
            : '${(network.downloadSpeed / 1024 / 1024).toStringAsFixed(2)} MB/s';

    return Container(
      width: 200,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF03DAC6).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF03DAC6).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF03DAC6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.wifi,
                        color: Color(0xFF03DAC6),
                        size: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      color: Colors.white.withOpacity(0.7),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Network',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_downward,
                      color: Color(0xFF03DAC6),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      downloadSpeed,
                      style: const TextStyle(
                        color: Color(0xFF03DAC6),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward,
                      color: Color(0xFFFFB74D),
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatSpeed(network.uploadSpeed),
                      style: const TextStyle(
                        color: Color(0xFFFFB74D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatSpeed(double speed) {
    if (speed < 1024) return '${speed.toStringAsFixed(0)} B/s';
    if (speed < 1024 * 1024) return '${(speed / 1024).toStringAsFixed(1)} KB/s';
    return '${(speed / 1024 / 1024).toStringAsFixed(2)} MB/s';
  }

  void updateNetworkInfo(List<NetworkInfo> networkInfo) {
    if (mounted) {
      setState(() {
        _networkInfo = networkInfo;
      });
    }
  }
}
