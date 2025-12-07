#!/bin/bash
# Quick Start - Ejecutar Dashboard con información

clear
echo "═══════════════════════════════════════════════════════════════"
echo "  🐧 LINUX SYSTEM MONITOR - DASHBOARD CON WIDGETS FLOTANTES"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "📋 INSTRUCCIONES:"
echo ""
echo "  1️⃣  El dashboard se abrirá en unos segundos"
echo "  2️⃣  Desplázate hacia abajo hasta la sección 'Widgets de Escritorio'"
echo "  3️⃣  Haz clic en los botones para lanzar widgets:"
echo ""
echo "      🔵 CPU    - Monitoreo de procesador"
echo "      🟣 RAM    - Monitoreo de memoria" 
echo "      🟢 Red    - Monitoreo de red"
echo ""
echo "  4️⃣  Cada widget se abrirá como una ventana independiente"
echo "  5️⃣  Arrastra las ventanas a donde quieras en tu escritorio"
echo "  6️⃣  Cierra widgets con el botón X individual"
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo ""
read -p "Presiona ENTER para continuar..." 

echo ""
echo "🚀 Iniciando aplicación..."
echo ""

flutter run -d linux
