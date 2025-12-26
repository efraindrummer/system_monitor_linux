# 📦 Guía de Publicación en Snap Store

## Sistema de Nombres

**Nombre de la App**: System Monitor @efracode  
**ID del Snap**: `system-monitor-efracode`  
**ID de la Aplicación**: `com.efracode.systemmonitor`

## Requisitos Previos

### 1. Instalar snapcraft

```bash
sudo snap install snapcraft --classic
```

### 2. Crear cuenta en Snapcraft

1. Ve a https://snapcraft.io/
2. Crea una cuenta o inicia sesión
3. Acepta los términos del desarrollador

### 3. Autenticarse

```bash
snapcraft login
```

## Construcción del Snap

### Paso 1: Limpiar builds anteriores

```bash
snapcraft clean
```

### Paso 2: Construir el snap

```bash
snapcraft
```

Esto creará un archivo `.snap` en el directorio actual, por ejemplo:
`system-monitor-efracode_1.0.0_amd64.snap`

### Paso 3: Probar localmente

```bash
sudo snap install system-monitor-efracode_1.0.0_amd64.snap --dangerous
```

Ejecutar:
```bash
system-monitor-efracode
```

## Publicación en Snap Store

### Paso 1: Registrar el nombre

```bash
snapcraft register system-monitor-efracode
```

### Paso 2: Subir a la tienda

```bash
snapcraft upload system-monitor-efracode_1.0.0_amd64.snap --release=stable
```

O subir a diferentes canales:
```bash
# Canal beta
snapcraft upload system-monitor-efracode_1.0.0_amd64.snap --release=beta

# Canal edge (desarrollo)
snapcraft upload system-monitor-efracode_1.0.0_amd64.snap --release=edge
```

### Paso 3: Verificar en la tienda

Tu app estará disponible en:
```
https://snapcraft.io/system-monitor-efracode
```

## Instalación por Usuarios

Una vez publicado, los usuarios pueden instalar con:

```bash
sudo snap install system-monitor-efracode
```

## Actualizar Versión

1. Actualiza el número de versión en `snap/snapcraft.yaml`
2. Reconstruye:
   ```bash
   snapcraft clean
   snapcraft
   ```
3. Sube la nueva versión:
   ```bash
   snapcraft upload system-monitor-efracode_1.1.0_amd64.snap --release=stable
   ```

## Información Adicional en la Tienda

Para mejorar tu listado en Snap Store:

### Agregar screenshots

1. Ve a https://snapcraft.io/system-monitor-efracode/listing
2. Sube capturas de pantalla de la aplicación
3. Agrega descripciones

### Recomendaciones de screenshots:
- Dashboard principal mostrando gráficos de CPU
- Vista de memoria RAM y Swap
- Widgets flotantes en acción
- Gráfico de red en tiempo real
- Monitoreo de temperaturas

### Tamaño recomendado:
- 1920x1080 o 1280x720
- Formato PNG o JPG
- Máximo 2MB por imagen

## Metadatos Importantes

Asegúrate de tener en `snapcraft.yaml`:

- ✅ `name`: Nombre único del snap
- ✅ `summary`: Descripción corta (máx 79 caracteres)
- ✅ `description`: Descripción detallada
- ✅ `icon`: Ruta al icono de la app
- ✅ `grade`: `stable` para producción
- ✅ `confinement`: `strict` para mayor seguridad

## Verificación de la Aplicación

Antes de publicar, verifica:

1. **Permisos necesarios** (plugs en snapcraft.yaml):
   - ✅ network - Para monitoreo de red
   - ✅ hardware-observe - Para CPU y temperatura
   - ✅ system-observe - Para info del sistema
   - ✅ mount-observe - Para info de discos

2. **Funcionalidad**:
   - ✅ La app inicia correctamente
   - ✅ Todos los gráficos se muestran
   - ✅ Los widgets flotantes funcionan
   - ✅ El icono aparece correctamente

3. **Calidad**:
   - ✅ Sin crashes
   - ✅ Rendimiento aceptable
   - ✅ Interfaz responsive

## Promoción

Una vez publicado, comparte en:

- Twitter/X con #Linux #SystemMonitor #Flutter
- Reddit en r/linux, r/FlutterDev
- LinkedIn
- Blog personal
- GitHub README con badge del Snap Store

### Badge para README:

```markdown
[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/system-monitor-efracode)
```

## Soporte

- Documentación oficial: https://snapcraft.io/docs
- Foro: https://forum.snapcraft.io/
- Chat: https://webchat.freenode.net/?channels=snapcraft

## Notas Importantes

1. **Primera revisión**: Puede tomar 1-3 días para revisión manual
2. **Actualizaciones**: Son automáticas para usuarios
3. **Canales**: Usa edge → beta → candidate → stable
4. **Licencia**: Asegúrate de tener una licencia clara (MIT recomendada)

¡Buena suerte con tu publicación! 🚀
