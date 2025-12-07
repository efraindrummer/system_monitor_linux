#!/bin/bash

echo "📦 Instalando Linux System Monitor Dashboard..."
echo ""

# Verificar que el ejecutable existe
if [ ! -f "build/linux/x64/release/bundle/dashboard_linux_cpu" ]; then
    echo "❌ Error: No se encontró el ejecutable compilado."
    echo "   Por favor ejecuta primero: ./build.sh"
    exit 1
fi

# Crear directorio de aplicaciones locales si no existe
mkdir -p ~/.local/share/applications

# Obtener la ruta absoluta del proyecto
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Crear archivo .desktop con la ruta correcta
cat > ~/.local/share/applications/linux-system-monitor.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Linux System Monitor
Comment=Monitor elegante del sistema con CPU, RAM, Red, Discos y Temperatura
Exec=${PROJECT_DIR}/build/linux/x64/release/bundle/dashboard_linux_cpu
Icon=utilities-system-monitor
Terminal=false
Categories=System;Monitor;Utility;
Keywords=system;monitor;cpu;ram;network;disk;temperature;
StartupNotify=true
EOF

# Hacer ejecutable
chmod +x ~/.local/share/applications/linux-system-monitor.desktop

# Actualizar base de datos de aplicaciones
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database ~/.local/share/applications
fi

echo "✅ ¡Instalación completada!"
echo ""
echo "Ahora puedes encontrar 'Linux System Monitor' en tu menú de aplicaciones."
echo ""
echo "También puedes:"
echo "  - Buscarlo con el launcher de tu escritorio"
echo "  - Fijarlo a favoritos/dock"
echo "  - Crear atajos de teclado personalizados"
echo ""
echo "Para desinstalar:"
echo "  rm ~/.local/share/applications/linux-system-monitor.desktop"
