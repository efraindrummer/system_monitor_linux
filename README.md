# System Monitor by @efracode

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/system-monitor-efracode)

Un elegante dashboard de monitoreo del sistema para Linux con diseño empresarial profesional.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Linux-orange)
![Flutter](https://img.shields.io/badge/Flutter-3.10.3%2B-02569B?logo=flutter)

## ✨ Características

### 🖥️ Monitoreo en Tiempo Real

- **CPU**: Uso por núcleo con gráficos animados
- **Memoria**: RAM y Swap con estadísticas detalladas
- **Red**: Velocidades de descarga y subida
- **Discos**: Uso de particiones y espacio disponible
- **Temperatura**: Monitoreo térmico del sistema

### 🪟 Widgets Flotantes

- Widgets independientes para CPU, RAM y Red
- Arrastrables por todo el escritorio
- Siempre visibles (always-on-top)
- Actualización cada segundo

### 🎨 Diseño

- Interfaz empresarial moderna
- Modo claro profesional
- Gráficos con historial de 60 segundos
- Paleta de colores corporativa

## 🚀 Instalación

### Desde Snap Store (Recomendado)

```bash
sudo snap install system-monitor-efracode
```

### Desde el código fuente

```bash
git clone https://github.com/efraindrummer/system_monitor_linux.git
cd system_monitor_linux
flutter build linux --release
./install.sh
```

## 🎯 Uso

Ejecutar: `system-monitor-efracode`

## 📦 Publicar

```bash
./publish_to_snap.sh
```

## 📝 Licencia

MIT License - @efracode

---

Hecho con ❤️ por @efracode
