#!/bin/bash

echo "════════════════════════════════════════════════════════════════"
echo "  📦 PUBLICACIÓN EN SNAP STORE"
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

# Verificar autenticación
echo "🔐 Verificando autenticación..."
if ! snapcraft whoami &> /dev/null; then
    echo "❌ No estás autenticado en Snapcraft"
    echo ""
    echo "Inicia sesión con:"
    echo "  snapcraft login"
    exit 1
fi

SNAPCRAFT_USER=$(snapcraft whoami | grep "email" | cut -d':' -f2 | xargs)
echo "✓ Autenticado como: $SNAPCRAFT_USER"
echo ""

# Limpiar builds anteriores
echo "🧹 Limpiando builds anteriores..."
snapcraft clean 2>/dev/null
echo ""

# Construir el snap
echo "🔨 Construyendo snap..."
echo "   Esto puede tomar varios minutos..."
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
        read -p "¿Deseas probar el snap localmente antes de publicar? (s/n): " test_local
        if [[ $test_local =~ ^[SsYy]$ ]]; then
            echo ""
            echo "📥 Instalando localmente..."
            sudo snap install "$SNAP_FILE" --dangerous
            echo ""
            echo "✓ Instalado. Prueba con: system-monitor-efracode"
            echo ""
            read -p "Presiona ENTER cuando termines de probar..."
        fi
        
        # Preguntar si desea publicar
        echo ""
        read -p "¿Deseas publicar en Snap Store ahora? (s/n): " publish
        if [[ $publish =~ ^[SsYy]$ ]]; then
            echo ""
            echo "📤 Publicando en Snap Store..."
            echo ""
            
            # Intentar registrar el nombre (puede fallar si ya está registrado)
            snapcraft register system-monitor-efracode 2>/dev/null
            
            # Subir y publicar
            if snapcraft upload "$SNAP_FILE" --release=stable; then
                echo ""
                echo "════════════════════════════════════════════════════════════════"
                echo "  🎉 ¡PUBLICADO EXITOSAMENTE!"
                echo "════════════════════════════════════════════════════════════════"
                echo ""
                echo "Tu aplicación está disponible en:"
                echo "  🌐 https://snapcraft.io/system-monitor-efracode"
                echo ""
                echo "Los usuarios pueden instalarla con:"
                echo "  sudo snap install system-monitor-efracode"
                echo ""
                echo "Próximos pasos:"
                echo "  1. Ve a https://snapcraft.io/system-monitor-efracode/listing"
                echo "  2. Sube screenshots de la aplicación"
                echo "  3. Completa la descripción y categorías"
                echo "  4. ¡Comparte tu app!"
                echo ""
            else
                echo ""
                echo "❌ Error al publicar"
                echo "   Revisa los mensajes de error arriba"
            fi
        else
            echo ""
            echo "El snap está listo en: $SNAP_FILE"
            echo ""
            echo "Para publicar manualmente más tarde:"
            echo "  snapcraft upload $SNAP_FILE --release=stable"
        fi
    else
        echo "❌ No se encontró el archivo .snap generado"
    fi
else
    echo ""
    echo "❌ Error al construir el snap"
    echo "   Revisa los mensajes de error arriba"
    exit 1
fi
