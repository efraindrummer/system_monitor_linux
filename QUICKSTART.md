# 🚀 Guía Rápida - Linux System Monitor Dashboard

## Ejecución Rápida

### Opción 1: Script de ejecución (Recomendado)
```bash
./run.sh
```

### Opción 2: Comando Flutter directo
```bash
flutter run -d linux
```

## Compilar versión Release

### Opción 1: Script de compilación
```bash
./build.sh
```

### Opción 2: Comando Flutter directo
```bash
flutter build linux --release
```

El ejecutable estará en:
```
build/linux/x64/release/bundle/dashboard_linux_cpu
```

## Características Principales

### 📊 Monitorea:
- ✅ **CPU**: Uso total y por cada núcleo
- ✅ **RAM**: Uso de memoria con gráficos
- ✅ **Swap**: Monitoreo de memoria virtual
- ✅ **Red**: Velocidad de descarga/subida
- ✅ **Discos**: Espacio usado por partición
- ✅ **Temperatura**: Sensores del sistema

### 🎨 Interfaz:
- ✅ Tema oscuro elegante
- ✅ Gráficos en tiempo real (fl_chart)
- ✅ Actualización cada segundo
- ✅ Colores según nivel de uso
- ✅ Diseño responsive

### 🪟 Controles:
- 📌 **Botón Pin**: Mantener siempre visible
- ➖ **Botón Minimizar**: Ocultar en barra de tareas
- 🔄 **Scroll**: Ver todas las métricas

## Requisitos del Sistema

### Obligatorios:
- Flutter SDK (Linux)
- Comandos: `lscpu`, `nproc`, `cat`, `df`, `uptime`

### Opcionales:
```bash
# Para temperaturas avanzadas (recomendado)
sudo apt-get install lm-sensors
sudo sensors-detect
```

## Interpretación de Colores

### CPU, RAM, Red:
- 🟢 **Verde** (0-30%): Uso bajo
- 🟠 **Naranja** (30-60%): Uso moderado  
- 🔴 **Rojo** (60-100%): Uso alto

### Discos:
- 🟢 **Verde** (<70%): OK
- 🟠 **Naranja** (70-85%): Atención
- 🔴 **Rojo** (>85%): Crítico

### Temperatura:
- 🔵 **Azul** (<50°C): Frío
- 🟢 **Verde** (50-70°C): Normal
- 🟠 **Naranja** (70-85°C): Elevado
- 🔴 **Rojo** (>85°C): Alto

## Atajos de Teclado

Actualmente no hay atajos configurados. Los controles son mediante botones flotantes.

## Rendimiento

- **Actualización**: 1 segundo
- **Historial**: Últimos 60 segundos
- **Uso de recursos**: Mínimo (~30-50 MB RAM)
- **CPU**: <1% en idle

## Troubleshooting

### No arranca
```bash
# Verificar Flutter
flutter doctor

# Reinstalar dependencias
flutter pub get
```

### No muestra temperaturas
```bash
# Instalar lm-sensors
sudo apt-get install lm-sensors
sudo sensors-detect
```

### Comandos no encontrados
```bash
# Verificar herramientas básicas
which lscpu nproc df uptime cat
```

## Estructura del Proyecto

```
lib/
├── main.dart                    # Entrada + window_manager
├── models/system_info.dart      # Modelos de datos
├── services/
│   └── system_monitor_service.dart  # Lee info del sistema
├── screens/
│   └── dashboard_screen.dart    # UI principal
└── widgets/
    ├── system_widgets.dart      # Tarjetas de métricas
    └── charts.dart              # Gráficos reutilizables
```

## Dependencias

- `fl_chart: ^0.69.2` - Gráficos
- `window_manager: ^0.5.1` - Control de ventana
- `process_run: ^1.2.0` - Comandos del sistema

## Más Información

Ver `README_DASHBOARD.md` para documentación completa.

---

**¡Disfruta monitoreando tu sistema Linux! 🐧**
