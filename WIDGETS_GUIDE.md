# 🪟 Widgets de Escritorio - Guía de Uso

## ¿Qué son los Widgets de Escritorio?

Los widgets de escritorio son **ventanas independientes** que muestran información del sistema en tiempo real. A diferencia de los widgets dentro de la aplicación, estos se pueden:

- ✅ **Arrastrar libremente** por todo el escritorio de Linux
- ✅ **Posicionar en cualquier parte** de la pantalla
- ✅ **Mantener siempre visibles** (always-on-top)
- ✅ **Cerrar independientemente** sin afectar la aplicación principal

## 🎯 Tipos de Widgets Disponibles

### 1. **Widget de CPU** (`cpu`)
Muestra el porcentaje de uso total del procesador en tiempo real.
- 🎨 Color: Cyan (#00D9FF)
- 📊 Actualización cada segundo
- 📏 Tamaño: 250x180 px

### 2. **Widget de RAM** (`ram`)
Muestra el uso de memoria RAM con detalles.
- 🎨 Color: Purple (#BB86FC)
- 📊 Porcentaje y GB usados/totales
- 📏 Tamaño: 250x180 px

### 3. **Widget de Red** (`network`)
Muestra velocidades de descarga y subida en tiempo real.
- 🎨 Color: Teal (#03DAC6)
- 📊 Velocidades en B/s, KB/s o MB/s
- 📏 Tamaño: 250x180 px

## 🚀 Cómo Lanzar Widgets

### Método 1: Desde la Aplicación (Recomendado)

1. Abre el **Dashboard Principal**
2. Ve a la sección "**Widgets de Escritorio**"
3. Haz clic en el botón del widget que quieres lanzar:
   - **CPU** - Lanza widget de procesador
   - **RAM** - Lanza widget de memoria
   - **Red** - Lanza widget de red
4. Una **nueva ventana** aparecerá que puedes arrastrar a cualquier parte del escritorio

### Método 2: Usando el Script

```bash
# Lanzar widget de CPU
./launch_widget.sh cpu

# Lanzar widget de RAM
./launch_widget.sh ram

# Lanzar widget de Red
./launch_widget.sh network
```

### Método 3: Línea de Comandos (Desarrollo)

```bash
# Ejecutar en modo debug
flutter run -d linux cpu

# Ejecutar el binario compilado
./build/linux/x64/release/bundle/dashboard_linux_cpu cpu
```

## 🎮 Controles de los Widgets

Cada widget tiene:
- **Botón de cierre** (X) en la esquina superior derecha
- **Arrastrar**: Haz clic en cualquier parte del widget y arrastra
- **Siempre visible**: Los widgets se mantienen por encima de otras ventanas

## 🏗️ Cómo Funciona (Técnicamente)

### Arquitectura Multi-Ventana

La aplicación detecta argumentos de línea de comandos:

```dart
void main(List<String> args) async {
  if (args.isNotEmpty) {
    // Lanzar en modo widget
    String widgetMode = args[0]; // 'cpu', 'ram', 'network'
    // Crear ventana pequeña
  } else {
    // Lanzar dashboard principal
  }
}
```

### Lanzamiento Independiente

Cuando haces clic en un botón, se ejecuta:

```dart
await Process.start(
  Platform.resolvedExecutable,  // Binario de la app
  [type],                         // Argumento: 'cpu', 'ram', 'network'
  mode: ProcessStartMode.detached, // Proceso independiente
);
```

Esto crea un **proceso completamente separado** con su propia ventana.

## 📊 Características Técnicas

| Característica | Valor |
|---------------|-------|
| **Ventana Principal** | 1200x800 px |
| **Ventana Widget** | 250x180 px |
| **Actualización** | 1 segundo |
| **Barra de título** | Oculta (widgets) |
| **Always on top** | Sí (widgets) |
| **Background** | Transparente con glassmorphism |

## 🛠️ Compilación

Para que los widgets funcionen correctamente, primero compila la aplicación:

```bash
# Compilación Release
flutter build linux --release

# Ubicación del ejecutable
./build/linux/x64/release/bundle/dashboard_linux_cpu
```

## 🐛 Solución de Problemas

### Los widgets no se lanzan

**Problema**: Haces clic pero no aparece nada.

**Solución**:
1. Verifica que la app esté compilada: `flutter build linux --release`
2. Revisa los permisos del ejecutable: `ls -la build/linux/x64/release/bundle/`
3. Verifica errores en consola

### Los widgets aparecen pero no se actualizan

**Problema**: El widget se congela.

**Solución**:
- Los widgets tienen su propio Timer de actualización
- Verifica que `lm-sensors` esté instalado: `sudo apt install lm-sensors`

### Muchos widgets abiertos

**Problema**: Abrí muchos widgets por error.

**Solución**:
```bash
# Cerrar todos los procesos de widgets
pkill -f "dashboard_linux_cpu"
```

## 🎨 Personalización

### Cambiar tamaño de widgets

Edita en `lib/main.dart`:

```dart
windowOptions = WindowOptions(
  size: const Size(300, 200),  // Cambia aquí
  minimumSize: const Size(250, 180),
);
```

### Cambiar posición inicial

Los widgets se centran automáticamente, pero puedes cambiar esto:

```dart
windowOptions = WindowOptions(
  center: false,  // No centrar
  position: const Offset(100, 100),  // Posición X,Y
);
```

## 🔮 Funcionalidades Futuras

- [ ] Widgets persistentes entre reinicios
- [ ] Recordar posición de cada widget
- [ ] Configuración de tamaño personalizado
- [ ] Temas de colores
- [ ] Widgets de disco y temperatura
- [ ] Gráficas en miniatura dentro de widgets

## 📝 Notas Importantes

1. **Cada widget es un proceso independiente**: Consume memoria RAM separada
2. **Limitación de Flutter Desktop**: Flutter no soporta múltiples ventanas nativamente, por eso usamos múltiples procesos
3. **Rendimiento**: Cada widget consume ~50-100 MB de RAM

## 🆘 Ayuda

¿Problemas o sugerencias?

- Revisa la documentación principal: `README.md`
- Consulta el quickstart: `QUICKSTART.md`
- Abre un issue en el repositorio

---

**Hecho con ❤️ por @efracode**
