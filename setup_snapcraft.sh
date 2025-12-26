#!/bin/bash

echo "════════════════════════════════════════════════════════════════"
echo "  🔧 CONFIGURACIÓN INICIAL DE SNAPCRAFT"
echo "  System Monitor by @efracode"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Verificar que snapcraft esté instalado
if ! command -v snapcraft &> /dev/null; then
    echo "❌ snapcraft no está instalado"
    echo ""
    echo "Instálalo con:"
    echo "  sudo snap install snapcraft --classic"
    exit 1
fi

echo "✓ snapcraft encontrado"
echo ""

# Instalar dependencias necesarias
echo "📦 Instalando dependencias del sistema..."
sudo apt update
sudo apt install -y \
    clang \
    cmake \
    ninja-build \
    libgtk-3-dev \
    liblzma-dev \
    libstdc++-12-dev \
    lm-sensors

echo ""
echo "✅ Dependencias instaladas"
echo ""

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
snapcraft clean 2>/dev/null
rm -rf parts/ stage/ prime/ *.snap 2>/dev/null

echo ""
echo "✅ Configuración completada"
echo ""
echo "Ahora puedes construir el snap con:"
echo "  ./build_snap.sh"
echo ""
