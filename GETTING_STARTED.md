# 🎉 ¡Bienvenido a Linux System Monitor Dashboard!

## 🚀 Primera Ejecución - 3 Pasos Simples

### Paso 1: Verificar Flutter
```bash
flutter doctor
```
Si Flutter no está instalado, visita: https://flutter.dev/docs/get-started/install/linux

### Paso 2: Instalar Dependencias
```bash
flutter pub get
```

### Paso 3: ¡Ejecutar!
```bash
# Opción A: Usando el script (recomendado)
./run.sh

# Opción B: Comando directo
flutter run -d linux
```

---

## 📦 Compilar Versión Release (Opcional)

Para crear un ejecutable optimizado:

```bash
# Compilar
./build.sh

# Instalar en el sistema (aparecerá en tu menú de aplicaciones)
./install.sh
```

---

## 🎨 ¿Qué verás?

Una ventana elegante con:
- 📊 **Uso de CPU** total y por cada núcleo
- 💾 **Memoria RAM** con gráfico histórico  
- 🔄 **Swap** y uso de memoria virtual
- 🌐 **Red** con velocidades de descarga/subida
- 💿 **Discos** y espacio disponible
- 🌡️ **Temperaturas** de sensores

---

## 🔧 Sensores de Temperatura (Opcional pero Recomendado)

Para ver información detallada de temperatura:

```bash
# Ubuntu/Debian
sudo apt-get install lm-sensors
sudo sensors-detect

# Fedora
sudo dnf install lm_sensors
sudo sensors-detect

# Arch Linux
sudo pacman -S lm_sensors
sudo sensors-detect
```

Responde "YES" a todas las preguntas durante `sensors-detect`.

---

## 🎮 Controles

- **📌 Botón Pin** (abajo derecha): Mantener ventana siempre visible
- **➖ Botón Minimizar** (abajo derecha): Minimizar a barra de tareas
- **Scroll**: Desplazarse por todas las métricas
- **Redimensionar**: Arrastra los bordes de la ventana

---

## 🆘 Problemas Comunes

### "Command not found: flutter"
```bash
# Instala Flutter o añádelo al PATH
export PATH="$PATH:/path/to/flutter/bin"
```

### "No se muestra información de temperatura"
```bash
# Instala lm-sensors (ver arriba)
sudo apt-get install lm-sensors
sudo sensors-detect
```

### "Error al compilar"
```bash
# Limpia y reinstala
flutter clean
flutter pub get
```

---

## 📚 Documentación Completa

- `README_DASHBOARD.md` - Documentación detallada
- `QUICKSTART.md` - Guía rápida de referencia
- `PROJECT_SUMMARY.md` - Resumen del proyecto

---

## 🎯 Tips de Uso

1. **Para monitoreo constante**: Usa el botón de pin 📌
2. **Para desarrollo**: Deja la app corriendo mientras trabajas
3. **Para rendimiento máximo**: Compila en release con `./build.sh`
4. **Para compartir**: El bundle compilado es portable

---

## 💡 Personalización

Puedes modificar:
- **Intervalo de actualización**: `lib/screens/dashboard_screen.dart` línea ~40
- **Colores del tema**: `lib/main.dart` línea ~60
- **Tamaño de ventana**: `lib/main.dart` línea ~12
- **Historial de gráficos**: `lib/screens/dashboard_screen.dart` línea ~27

---

## 🌟 ¡Disfruta!

Has instalado un monitor de sistema moderno y elegante.

**Sugerencias:**
- Déjalo corriendo para ver patrones de uso
- Úsalo para diagnosticar problemas de rendimiento
- Compártelo con otros usuarios de Linux
- Contribuye con mejoras en GitHub

---

## 📧 Soporte

Si encuentras problemas o tienes sugerencias:
1. Revisa la documentación completa
2. Verifica `flutter doctor`
3. Abre un issue en GitHub

**¡Happy monitoring! 🐧💙**

---

*Linux System Monitor Dashboard - Creado con ❤️ y Flutter*
