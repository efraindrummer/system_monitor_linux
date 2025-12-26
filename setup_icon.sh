#!/bin/bash
# Script para configurar el icono de la aplicación

echo "🎨 Configurando icono de la aplicación..."
echo ""

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Verificar que el icono existe
if [ ! -f "${PROJECT_DIR}/assets/images/app_icon.png" ]; then
    echo "❌ Error: No se encontró el icono en assets/images/app_icon.png"
    exit 1
fi

echo "✓ Icono encontrado: ${PROJECT_DIR}/assets/images/app_icon.png"

# Copiar icono a recursos de Linux
echo "✓ Copiando icono a linux/runner/resources/"
mkdir -p "${PROJECT_DIR}/linux/runner/resources"
cp "${PROJECT_DIR}/assets/images/app_icon.png" "${PROJECT_DIR}/linux/runner/resources/app_icon.png"

# Copiar icono al sistema
echo "✓ Instalando icono en el sistema..."
mkdir -p ~/.local/share/icons/hicolor/256x256/apps
cp "${PROJECT_DIR}/assets/images/app_icon.png" ~/.local/share/icons/hicolor/256x256/apps/dashboard-linux-cpu.png

# Actualizar caché de iconos
if command -v gtk-update-icon-cache &> /dev/null; then
    echo "✓ Actualizando caché de iconos..."
    gtk-update-icon-cache ~/.local/share/icons/hicolor/ -f -t 2>/dev/null
fi

echo ""
echo "✅ ¡Icono configurado exitosamente!"
echo ""
echo "El icono aparecerá en:"
echo "  - Barra de título de la ventana"
echo "  - Menú de aplicaciones (después de instalar con ./install.sh)"
echo "  - Barra de tareas cuando la aplicación esté corriendo"
echo ""
