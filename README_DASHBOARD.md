# 🖥️ Linux System Monitor Dashboard

Un dashboard elegante y moderno para monitorear el rendimiento del sistema en Linux, construido con Flutter.

![Dashboard Preview](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

## ✨ Características

### 📊 Monitoreo Completo del Sistema

- **CPU**: 
  - Uso total y por núcleo individual
  - Gráfico en tiempo real del historial de uso
  - Identificación del modelo de CPU
  - Visualización circular del porcentaje por núcleo

- **Memoria RAM y Swap**:
  - Uso de RAM con gráfico de tendencia
  - Monitoreo de memoria Swap
  - Visualización en GB y porcentajes

- **Red**:
  - Velocidad de descarga y subida en tiempo real
  - Gráficos combinados de tráfico de red
  - Monitoreo por interfaz de red
  - Formato automático (B/s, KB/s, MB/s)

- **Discos**:
  - Uso de espacio por partición
  - Barras de progreso con colores de advertencia
  - Información de puntos de montaje
  - Tamaños formateados automáticamente

- **Temperatura**:
  - Sensores de temperatura del sistema
  - Indicadores de color según temperatura
  - Soporte para múltiples sensores

### 🎨 Diseño Elegante

- **Tema Oscuro Moderno**: Interfaz oscura profesional con acentos de color
- **Animaciones Fluidas**: Transiciones suaves en todos los componentes
- **Gráficos en Tiempo Real**: Visualización con fl_chart
- **Diseño Responsive**: Se adapta a diferentes tamaños de ventana
- **Tarjetas Elegantes**: Cada métrica en su propia tarjeta con bordes de color

### 🪟 Funcionalidades de Ventana

- **Modo Siempre Visible**: Pin para mantener la ventana encima de todas las demás
- **Minimización Rápida**: Botón flotante para minimizar
- **Ventana Configurable**: Tamaño mínimo y redimensionable
- **Control de Ventana**: Gestión completa con window_manager

## 🚀 Instalación

### Prerequisitos

```bash
# Flutter debe estar instalado
flutter --version

# Comandos del sistema necesarios (generalmente ya están instalados):
# - lscpu, nproc, cat
# - df, uptime
# - sensors (opcional, para temperaturas avanzadas)
```

### Instalación de sensors (opcional)

Para obtener información detallada de temperatura:

```bash
# Ubuntu/Debian
sudo apt-get install lm-sensors
sudo sensors-detect

# Fedora
sudo dnf install lm_sensors
sudo sensors-detect

# Arch Linux
sudo pacman -S lm_sensors
sudo sensors-detect
```

### Clonar y ejecutar

```bash
# Clonar el repositorio
git clone <tu-repositorio>
cd dashboard_linux_cpu

# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run -d linux

# Compilar release
flutter build linux --release

# El ejecutable estará en:
# build/linux/x64/release/bundle/dashboard_linux_cpu
```

## 📦 Dependencias

- **fl_chart** (^0.69.2): Gráficos elegantes y animados
- **window_manager** (^0.5.1): Control de ventana nativa
- **process_run** (^1.2.0): Ejecución de comandos del sistema

## 🎯 Uso

### Controles

- **📌 Botón Pin**: Mantiene la ventana siempre visible encima de otras
- **➖ Botón Minimizar**: Minimiza la ventana a la barra de tareas
- **Scroll**: Desplázate para ver todas las métricas

### Interpretación de Colores

#### CPU y Memoria
- 🟢 **Verde** (0-30%): Uso bajo
- 🟠 **Naranja** (30-60%): Uso moderado
- 🔴 **Rojo** (60-100%): Uso alto

#### Discos
- 🟢 **Verde** (<70%): Espacio disponible
- 🟠 **Naranja** (70-85%): Considerar limpiar
- 🔴 **Rojo** (>85%): Espacio crítico

#### Temperatura
- 🔵 **Azul** (<50°C): Temperatura fría
- 🟢 **Verde** (50-70°C): Temperatura normal
- 🟠 **Naranja** (70-85°C): Temperatura elevada
- 🔴 **Rojo** (>85°C): Temperatura alta

## 🏗️ Arquitectura

```
lib/
├── main.dart                          # Punto de entrada con window_manager
├── models/
│   └── system_info.dart              # Modelos de datos del sistema
├── services/
│   └── system_monitor_service.dart   # Servicio de monitoreo
├── screens/
│   └── dashboard_screen.dart         # Pantalla principal
└── widgets/
    ├── system_widgets.dart           # Widgets de métricas
    └── charts.dart                   # Gráficos reutilizables
```

### Flujo de Datos

1. **SystemMonitorService** lee información del sistema mediante comandos nativos de Linux
2. Los datos se procesan y convierten en modelos tipados
3. **DashboardScreen** actualiza cada segundo
4. El historial se mantiene para los gráficos (últimos 60 puntos)
5. Los widgets se actualizan automáticamente con `setState`

## 🔧 Personalización

### Cambiar Intervalo de Actualización

En `dashboard_screen.dart`:

```dart
// Cambiar de 1 segundo a otro valor
_updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
  _updateSystemInfo();
});
```

### Modificar Tamaño de Ventana

En `main.dart`:

```dart
WindowOptions windowOptions = const WindowOptions(
  size: Size(1400, 900),  // Cambiar tamaño
  minimumSize: Size(1000, 700),  // Cambiar mínimo
  // ...
);
```

### Personalizar Colores

En `main.dart`, modifica el tema:

```dart
theme: ThemeData.dark().copyWith(
  scaffoldBackgroundColor: const Color(0xFF0A0E27), // Tu color
  colorScheme: ColorScheme.dark(
    primary: Colors.teal,  // Cambiar color primario
    // ...
  ),
),
```

## 🐛 Solución de Problemas

### No se muestra información de temperatura

```bash
# Instalar lm-sensors
sudo apt-get install lm-sensors
sudo sensors-detect

# Seguir las instrucciones del asistente
```

### Comandos no encontrados

Asegúrate de tener las herramientas básicas:

```bash
# Verificar comandos
which lscpu nproc df uptime
```

### Problemas de permisos

Algunos archivos del sistema requieren permisos de lectura:

```bash
# Verificar permisos
ls -la /proc/stat /proc/meminfo /proc/net/dev
```

## 🚀 Mejoras Futuras

- [ ] Exportar reportes del sistema
- [ ] Configuración de alertas personalizadas
- [ ] Historial persistente de métricas
- [ ] Monitoreo de procesos individuales
- [ ] Widget de escritorio minimalista
- [ ] Soporte para múltiples temas
- [ ] Notificaciones del sistema
- [ ] Gráficos históricos (24h, 7d, 30d)

## 📝 Licencia

Este proyecto está bajo la licencia MIT.

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 💡 Inspiración

Este proyecto fue creado para llenar el vacío de aplicaciones de monitoreo del sistema modernas y elegantes en Linux. Mientras que existen muchas herramientas de monitoreo, la mayoría tienen interfaces anticuadas o carecen de diseño moderno.

## 📧 Contacto

Si tienes preguntas o sugerencias, no dudes en abrir un issue en GitHub.

---

**Hecho con ❤️ y Flutter para la comunidad Linux**
