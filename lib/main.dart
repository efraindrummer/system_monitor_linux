// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure window
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1200, 800),
    minimumSize: Size(800, 600),
    center: true,
    backgroundColor: Color(0xFF0A0E27),
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    title: 'Linux System Monitor by @efracode',
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linux System Monitor by @efracode',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF00D9FF),
          secondary: const Color(0xFFBB86FC),
          surface: Colors.grey[900]!,
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
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isActive
              ? [
                  const Color(0xFF00D9FF).withOpacity(0.3),
                  const Color(0xFF667EEA).withOpacity(0.3),
                ]
              : [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? const Color(0xFF00D9FF).withOpacity(0.3)
                : Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: isActive ? 2 : 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
