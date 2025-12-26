#!/bin/bash

echo "════════════════════════════════════════════════════════════════"
echo "  📤 SUBIR A SNAP STORE"
echo "  System Monitor by @efracode"
echo "════════════════════════════════════════════════════════════════"
echo ""

# Verificar que snapcraft esté instalado
if ! command -v snapcraft &> /dev/null; then
    echo "❌ snapcraft no está instalado"
    exit 1
fi

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

# Buscar el archivo snap
SNAP_FILE=$(ls system-monitor-efracode_*.snap 2>/dev/null | head -1)

if [ ! -f "$SNAP_FILE" ]; then
    echo "❌ No se encontró ningún archivo .snap"
    echo ""
    echo "Primero construye el snap con:"
    echo "  ./build_snap.sh"
    exit 1
fi

echo "📦 Archivo a subir: $SNAP_FILE"
echo "   Tamaño: $(du -h "$SNAP_FILE" | cut -f1)"
echo ""

# Confirmar
read -p "¿Deseas publicar en Snap Store? (s/n): " confirm
if [[ ! $confirm =~ ^[SsYy]$ ]]; then
    echo "Cancelado"
    exit 0
fi

echo ""
echo "📤 Publicando en Snap Store..."
echo ""

# Intentar registrar el nombre (puede fallar si ya está registrado)
echo "📝 Registrando nombre del snap..."
snapcraft register system-monitor-efracode 2>/dev/null || echo "   (Nombre ya registrado)"

echo ""
echo "⬆️  Subiendo snap..."

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
    echo "  💻 sudo snap install system-monitor-efracode"
    echo ""
    echo "Próximos pasos:"
    echo "  1. Ve a https://snapcraft.io/system-monitor-efracode/listing"
    echo "  2. Sube screenshots de la aplicación"
    echo "  3. Completa la descripción y categorías"
    echo "  4. ¡Comparte tu app!"
    echo ""
    echo "Badge para GitHub:"
    echo '  [![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/system-monitor-efracode)'
    echo ""
else
    echo ""
    echo "❌ Error al publicar"
    echo ""
    echo "Posibles causas:"
    echo "  • No tienes permisos para el nombre 'system-monitor-efracode'"
    echo "  • Problemas de red"
    echo "  • El nombre ya está en uso por otro desarrollador"
    echo ""
    echo "Soluciones:"
    echo "  1. Cambia el nombre en snap/snapcraft.yaml"
    echo "  2. Verifica tu autenticación: snapcraft whoami"
    echo "  3. Revisa los logs de error arriba"
    exit 1
fi
