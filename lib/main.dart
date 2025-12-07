// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/dashboard_screen.dart';
import 'widgets/floating_widgets.dart';
import 'dart:async';
import 'services/system_monitor_service.dart';
import 'models/system_info.dart';

// Argumentos: flutter run -d linux --dart-define=WIDGET_MODE=cpu
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure window
  await windowManager.ensureInitialized();

  // Detectar modo widget desde argumentos
  String? widgetMode;
  if (args.isNotEmpty) {
    widgetMode = args[0]; // cpu, ram, network
  }
  
  // Configuración de ventana según el modo
  WindowOptions windowOptions;
  
  if (widgetMode != null && ['cpu', 'ram', 'network'].contains(widgetMode)) {
    // Ventana pequeña para widgets flotantes
    windowOptions = WindowOptions(
      size: const Size(250, 180),
      minimumSize: const Size(200, 150),
      center: false,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      title: 'Widget - ${widgetMode.toUpperCase()}',
      alwaysOnTop: true,
    );
  } else {
    // Ventana principal del dashboard
    windowOptions = const WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(800, 600),
      center: true,
      backgroundColor: Color(0xFF0A0E27),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Linux System Monitor by @efracode',
    );
  }

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MyApp(widgetMode: widgetMode));
}

class MyApp extends StatefulWidget {
  final String? widgetMode;
  
  const MyApp({super.key, this.widgetMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  bool _isAlwaysOnTop = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  void _toggleAlwaysOnTop() async {
    setState(() {
      _isAlwaysOnTop = !_isAlwaysOnTop;
    });
    await windowManager.setAlwaysOnTop(_isAlwaysOnTop);
  }

  Widget _buildStandaloneWidget(String mode) {
    return StandaloneWidgetApp(widgetMode: mode);
  }

  @override
  Widget build(BuildContext context) {
    // Si es modo widget, mostrar widget flotante independiente
    if (widget.widgetMode != null) {
      return MaterialApp(
        title: 'Widget - ${widget.widgetMode}',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildStandaloneWidget(widget.widgetMode!),
        ),
      );
    }
    
    // Dashboard principal
    return MaterialApp(
      title: 'Linux System Monitor by @efracode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1976D2),
          secondary: const Color(0xFF0288D1),
          surface: Colors.white,
          background: const Color(0xFFF5F7FA),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: const Color(0xFF2C3E50),
          onBackground: const Color(0xFF2C3E50),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF2C3E50),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: const DashboardScreen(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildGlassFAB(
              icon: _isAlwaysOnTop ? Icons.push_pin : Icons.push_pin_outlined,
              onPressed: _toggleAlwaysOnTop,
              isActive: _isAlwaysOnTop,
            ),
            const SizedBox(height: 12),
            _buildGlassFAB(
              icon: Icons.minimize_rounded,
              onPressed: () async {
                await windowManager.minimize();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassFAB({
    required IconData icon,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? const Color(0xFF1976D2) : Colors.white,
        border: Border.all(
          color: isActive ? const Color(0xFF1976D2) : const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive 
                ? const Color(0xFF1976D2).withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF546E7A),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}

// Widget independiente que se ejecuta en su propia ventana
class StandaloneWidgetApp extends StatefulWidget {
  final String widgetMode;

  const StandaloneWidgetApp({super.key, required this.widgetMode});

  @override
  State<StandaloneWidgetApp> createState() => _StandaloneWidgetAppState();
}

class _StandaloneWidgetAppState extends State<StandaloneWidgetApp> {
  final SystemMonitorService _monitorService = SystemMonitorService();
  Timer? _updateTimer;
  
  CpuInfo _cpuInfo = CpuInfo.empty();
  MemoryInfo _memoryInfo = MemoryInfo.empty();
  List<NetworkInfo> _networkInfo = [];

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _updateData();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateData();
    });
  }

  Future<void> _updateData() async {
    switch (widget.widgetMode) {
      case 'cpu':
        final cpuInfo = await _monitorService.getCpuInfo();
        if (mounted) {
          setState(() {
            _cpuInfo = cpuInfo;
          });
        }
        break;
      case 'ram':
        final memoryInfo = await _monitorService.getMemoryInfo();
        if (mounted) {
          setState(() {
            _memoryInfo = memoryInfo;
          });
        }
        break;
      case 'network':
        final networkInfo = await _monitorService.getNetworkInfo();
        if (mounted) {
          setState(() {
            _networkInfo = networkInfo;
          });
        }
        break;
    }
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.widgetMode) {
      case 'cpu':
        return FloatingCpuWidget(cpuInfo: _cpuInfo, onUpdate: (CpuInfo p1) {  },);
      case 'ram':
        return FloatingRamWidget(memoryInfo: _memoryInfo, onUpdate: (MemoryInfo p1) {  },);
      case 'network':
        return FloatingNetworkWidget(networkInfo: _networkInfo, onUpdate: (List<NetworkInfo> p1) {  },);
      default:
        return const Center(
          child: Text('Widget no soportado'),
        );
    }
  }
}
