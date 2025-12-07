#!/bin/bash

echo "🔨 Compilando Linux System Monitor Dashboard (Release)..."
echo ""

cd "$(dirname "$0")"

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    exit 1
fi

# Limpiar build anterior
echo "🧹 Limpiando compilaciones anteriores..."
flutter clean

# Instalar dependencias
echo "📦 Instalando dependencias..."
flutter pub get

# Compilar en modo release
echo ""
echo "🏗️  Compilando en modo release..."
echo "   Esto puede tomar varios minutos..."
echo ""
flutter build linux --release

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Compilación exitosa!"
    echo ""
    echo "📁 El ejecutable está en:"
    echo "   build/linux/x64/release/bundle/dashboard_linux_cpu"
    echo ""
    echo "Para ejecutar:"
    echo "   ./build/linux/x64/release/bundle/dashboard_linux_cpu"
    echo ""
    echo "Para crear un paquete instalable:"
    echo "   cd build/linux/x64/release"
    echo "   tar -czf dashboard-linux-monitor.tar.gz bundle/"
else
    echo ""
    echo "❌ Error en la compilación"
    exit 1
fi
