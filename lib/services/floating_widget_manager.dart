// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:async';
import '../models/system_info.dart';
import '../services/system_monitor_service.dart';
import '../widgets/floating_widgets.dart';

class FloatingWidgetManager {
  static final FloatingWidgetManager _instance = FloatingWidgetManager._internal();
  factory FloatingWidgetManager() => _instance;
  FloatingWidgetManager._internal();

  final List<GlobalKey> _widgetKeys = [];
  Timer? _updateTimer;
  final SystemMonitorService _monitorService = SystemMonitorService();

  // Método para crear una ventana flotante de CPU
  Future<void> createFloatingCpuWidget() async {
    await _createFloatingWindow(
      title: 'CPU Monitor',
      width: 200,
      height: 120,
      child: const _FloatingCpuMonitor(),
    );
  }

  // Método para crear una ventana flotante de RAM
  Future<void> createFloatingRamWidget() async {
    await _createFloatingWindow(
      title: 'RAM Monitor',
      width: 200,
      height: 150,
      child: const _FloatingRamMonitor(),
    );
  }

  // Método para crear una ventana flotante de Red
  Future<void> createFloatingNetworkWidget() async {
    await _createFloatingWindow(
      title: 'Network Monitor',
      width: 200,
      height: 140,
      child: const _FloatingNetworkMonitor(),
    );
  }

  // Método privado para crear ventanas flotantes
  Future<void> _createFloatingWindow({
    required String title,
    required double width,
    required double height,
    required Widget child,
  }) async {
    // Nota: En Flutter desktop, cada ventana requiere su propio proceso
    // Para widgets flotantes reales, necesitarías usar platform channels
    // o crear múltiples instancias de la aplicación
    
    // Por ahora, mostraremos un diálogo overlay
    // Para ventanas separadas reales, mira el ejemplo más abajo
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}

// Widget monitor de CPU interno
class _FloatingCpuMonitor extends StatefulWidget {
  const _FloatingCpuMonitor();

  @override
  State<_FloatingCpuMonitor> createState() => _FloatingCpuMonitorState();
}

class _FloatingCpuMonitorState extends State<_FloatingCpuMonitor> {
  final SystemMonitorService _monitorService = SystemMonitorService();
  CpuInfo _cpuInfo = CpuInfo.empty();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final cpuInfo = await _monitorService.getCpuInfo();
      if (mounted) {
        setState(() {
          _cpuInfo = cpuInfo;
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingCpuWidget(
      onUpdate: (cpuInfo) {}, cpuInfo: _cpuInfo,
    );
  }
}

// Widget monitor de RAM interno
class _FloatingRamMonitor extends StatefulWidget {
  const _FloatingRamMonitor();

  @override
  State<_FloatingRamMonitor> createState() => _FloatingRamMonitorState();
}

class _FloatingRamMonitorState extends State<_FloatingRamMonitor> {
  final SystemMonitorService _monitorService = SystemMonitorService();
  MemoryInfo _memoryInfo = MemoryInfo.empty();
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final memoryInfo = await _monitorService.getMemoryInfo();
      if (mounted) {
        setState(() {
          _memoryInfo = memoryInfo;
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingRamWidget(
      onUpdate: (memoryInfo) {}, memoryInfo: _memoryInfo,
    );
  }
}

// Widget monitor de Red interno
class _FloatingNetworkMonitor extends StatefulWidget {
  const _FloatingNetworkMonitor();

  @override
  State<_FloatingNetworkMonitor> createState() => _FloatingNetworkMonitorState();
}

class _FloatingNetworkMonitorState extends State<_FloatingNetworkMonitor> {
  final SystemMonitorService _monitorService = SystemMonitorService();
  List<NetworkInfo> _networkInfo = [];
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final networkInfo = await _monitorService.getNetworkInfo();
      if (mounted) {
        setState(() {
          _networkInfo = networkInfo;
        });
      }
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingNetworkWidget(
      onUpdate: (networkInfo) {}, networkInfo: [],
    );
  }
}
