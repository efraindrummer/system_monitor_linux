#!/bin/bash
# Script para lanzar widgets independientes en el escritorio

# Uso: ./launch_widget.sh [cpu|ram|network]

WIDGET_TYPE=${1:-cpu}
EXECUTABLE="./build/linux/x64/release/bundle/dashboard_linux_cpu"

if [ ! -f "$EXECUTABLE" ]; then
    echo "⚠️  Ejecutable no encontrado. Compilando primero..."
    flutter build linux --release
fi

if [ -f "$EXECUTABLE" ]; then
    echo "🚀 Lanzando widget de $WIDGET_TYPE..."
    "$EXECUTABLE" "$WIDGET_TYPE" &
    echo "✅ Widget lanzado (PID: $!)"
else
    echo "❌ Error: No se pudo compilar la aplicación"
    exit 1
fi
