#!/bin/bash

echo "🚀 Iniciando Linux System Monitor Dashboard..."
echo ""

cd "$(dirname "$0")"

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado. Por favor instala Flutter primero."
    echo "   Visita: https://flutter.dev/docs/get-started/install/linux"
    exit 1
fi

# Verificar dependencias
echo "📦 Verificando dependencias..."
flutter pub get

# Compilar y ejecutar
echo ""
echo "🏃 Ejecutando en modo debug..."
echo ""
flutter run -d linux

# Si el usuario presiona Ctrl+C
echo ""
echo "👋 Dashboard cerrado. ¡Hasta pronto!"
