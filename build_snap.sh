#!/bin/bash

echo "════════════════════════════════════════════════════════════════"
echo "  🔨 CONSTRUIR SNAP LOCALMENTE"
echo "  System Monitor by @efracode"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Verificar que snapcraft esté instalado
if ! command -v snapcraft &> /dev/null; then
    echo "❌ snapcraft no está instalado"
    echo ""
    echo "Ejecuta primero:"
    echo "  ./setup_snapcraft.sh"
    exit 1
fi

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
snapcraft clean 2>/dev/null
echo ""

# Construir el snap en modo destructivo (sin LXD)
echo "🔨 Construyendo snap (modo local)..."
echo "   Esto puede tomar 10-15 minutos..."
echo ""

if snapcraft pack --destructive-mode; then
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "  ✅ SNAP CONSTRUIDO EXITOSAMENTE"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    
    SNAP_FILE=$(ls system-monitor-efracode_*.snap 2>/dev/null | head -1)
    
    if [ -f "$SNAP_FILE" ]; then
        echo "📦 Archivo creado: $SNAP_FILE"
        echo "   Tamaño: $(du -h "$SNAP_FILE" | cut -f1)"
        echo ""
        
        # Preguntar si desea probar localmente
        read -p "¿Deseas instalar y probar el snap localmente? (s/n): " test_local
        if [[ $test_local =~ ^[SsYy]$ ]]; then
            echo ""
            echo "📥 Instalando localmente..."
            sudo snap install "$SNAP_FILE" --dangerous
            echo ""
            echo "✅ Instalado. Prueba con:"
            echo "   system-monitor-efracode"
            echo ""
            echo "Para ver logs:"
            echo "   journalctl -xe | grep system-monitor"
            echo ""
            echo "Para desinstalar:"
            echo "   sudo snap remove system-monitor-efracode"
        fi
        
        echo ""
        echo "Para publicar en Snap Store, ejecuta:"
        echo "  ./upload_snap.sh"
        
    else
        echo "❌ No se encontró el archivo .snap generado"
        exit 1
    fi
else
    echo ""
    echo "❌ Error al construir el snap"
    echo ""
    echo "Soluciones comunes:"
    echo "  1. Verifica que tengas todas las dependencias:"
    echo "     ./setup_snapcraft.sh"
    echo ""
    echo "  2. Verifica que Flutter esté instalado:"
    echo "     flutter --version"
    echo ""
    echo "  3. Revisa el log completo en:"
    echo "     ~/.local/state/snapcraft/log/"
    echo ""
    exit 1
fi
