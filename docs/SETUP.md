# 🔧 Guía de Configuración - SAM AT+

Esta guía detalla el proceso completo para configurar el proyecto SAM AT+ desde cero.

## 📋 Tabla de Contenidos

1. [Prerrequisitos](#prerrequisitos)
2. [Configuración del Entorno](#configuración-del-entorno)
3. [Configuración de Firebase](#configuración-de-firebase)
4. [Configuración de Supabase](#configuración-de-supabase)
5. [Configuración de Google Apps Script](#configuración-de-google-apps-script)
6. [Variables de Entorno](#variables-de-entorno)
7. [Solución de Problemas](#solución-de-problemas)

---

## Prerrequisitos

### Software Requerido

| Software | Versión Mínima | Enlace |
|----------|---------------|--------|
| Flutter SDK | 3.7.2+ | [Instalación](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.7.2+ | Incluido con Flutter |
| Git | 2.x+ | [Descargar](https://git-scm.com/) |
| IDE | VS Code o Android Studio | - |

### Verificar Instalación

```bash
# Verificar Flutter
flutter --version

# Verificar Dart
dart --version

# Verificar que todo esté correctamente configurado
flutter doctor
```

---

## Configuración del Entorno

### 1. Clonar el Repositorio

```bash
git clone https://github.com/jozzer182/SAM_AT.git
cd SAM_AT
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Crear Archivo de Variables de Entorno

```bash
# Copiar plantilla
cp .env.example .env

# Editar con tu editor favorito
code .env  # VS Code
notepad .env  # Windows
nano .env  # Linux/macOS
```

---

## Configuración de Firebase

### Paso 1: Crear Proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Click en "Agregar proyecto"
3. Ingresa un nombre para tu proyecto
4. (Opcional) Habilita Google Analytics
5. Click en "Crear proyecto"

### Paso 2: Registrar App Web

1. En el panel del proyecto, click en el ícono Web (`</>`)
2. Ingresa un nickname para tu app (ej: "SAM AT Web")
3. (Opcional) Configura Firebase Hosting
4. Click en "Registrar app"

### Paso 3: Copiar Credenciales

Firebase te mostrará un objeto de configuración similar a:

```javascript
const firebaseConfig = {
  apiKey: "AIza...",
  authDomain: "tu-proyecto.firebaseapp.com",
  projectId: "tu-proyecto",
  storageBucket: "tu-proyecto.appspot.com",
  messagingSenderId: "123456789",
  appId: "1:123456789:web:abc123"
};
```

Copia estos valores a tu archivo `.env`:

```env
FIREBASE_API_KEY=AIza...
FIREBASE_APP_ID=1:123456789:web:abc123
FIREBASE_MESSAGING_SENDER_ID=123456789
FIREBASE_PROJECT_ID=tu-proyecto
FIREBASE_AUTH_DOMAIN=tu-proyecto.firebaseapp.com
FIREBASE_STORAGE_BUCKET=tu-proyecto.appspot.com
```

### Paso 4: Configurar Authentication

1. En Firebase Console, ve a "Authentication"
2. Click en "Comenzar"
3. Habilita el método "Correo electrónico/contraseña"
4. (Opcional) Configura otros proveedores

### Paso 5: Configurar Firestore (si es necesario)

1. Ve a "Firestore Database"
2. Click en "Crear base de datos"
3. Selecciona modo de inicio (producción o prueba)
4. Selecciona ubicación del servidor

---

## Configuración de Supabase

> ⚠️ **Nota:** Supabase solo es necesario si utilizas el módulo LCL.

### Paso 1: Crear Proyecto

1. Ve a [Supabase Dashboard](https://app.supabase.com/)
2. Click en "New Project"
3. Completa los detalles del proyecto
4. Espera a que se aprovisione la base de datos

### Paso 2: Obtener Credenciales

1. Ve a "Settings" > "API"
2. Copia los valores:
   - **Project URL**: `https://xxxx.supabase.co`
   - **anon public key**: `eyJhbG...`

### Paso 3: Agregar a Variables de Entorno

```env
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Paso 4: Crear Tablas (si es necesario)

Ejecuta las migraciones SQL necesarias en el editor de SQL de Supabase.

---

## Configuración de Google Apps Script

Los endpoints de Google Apps Script se utilizan para integración con hojas de cálculo de Google.

### Paso 1: Crear Script

1. Ve a [Google Apps Script](https://script.google.com/)
2. Crea un nuevo proyecto
3. Implementa la lógica necesaria

### Paso 2: Desplegar como Web App

1. Click en "Implementar" > "Nueva implementación"
2. Selecciona "Aplicación web"
3. Configura:
   - **Ejecutar como**: Tu cuenta
   - **Quién tiene acceso**: Cualquier persona
4. Click en "Implementar"
5. Copia la URL del despliegue

### Paso 3: Agregar URLs a Variables de Entorno

```env
API_ENVIAR_SOLPE=https://script.google.com/macros/s/ID_SCRIPT_1/exec
API_FEM=https://script.google.com/macros/s/ID_SCRIPT_2/exec
API_SAM=https://script.google.com/macros/s/ID_SCRIPT_3/exec
API_SAMAT=https://script.google.com/macros/s/ID_SCRIPT_4/exec
```

---

## Variables de Entorno

### Archivo `.env` Completo

```env
# ========================================
# Firebase Configuration
# ========================================
FIREBASE_API_KEY=tu_api_key_aqui
FIREBASE_APP_ID=tu_app_id_aqui
FIREBASE_MESSAGING_SENDER_ID=tu_sender_id_aqui
FIREBASE_PROJECT_ID=tu_project_id_aqui
FIREBASE_AUTH_DOMAIN=tu_project_id.firebaseapp.com
FIREBASE_STORAGE_BUCKET=tu_project_id.appspot.com
FIREBASE_MEASUREMENT_ID=tu_measurement_id_aqui

# ========================================
# Google Apps Script APIs
# ========================================
API_ENVIAR_SOLPE=https://script.google.com/macros/s/TU_ID/exec
API_FEM=https://script.google.com/macros/s/TU_ID/exec
API_SAM=https://script.google.com/macros/s/TU_ID/exec
API_SAMAT=https://script.google.com/macros/s/TU_ID/exec

# ========================================
# Supabase Configuration
# ========================================
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu_anon_key_aqui
```

### Validación de Variables

La aplicación validará automáticamente las variables de entorno al iniciar. Si faltan variables, verás un mensaje en la consola indicando cuáles faltan.

---

## Solución de Problemas

### Error: "Missing environment variables"

**Síntoma:** La aplicación muestra un error de variables de entorno faltantes.

**Solución:**
1. Verifica que existe el archivo `.env` en la raíz del proyecto
2. Verifica que todas las variables están definidas
3. Asegúrate de que `.env` está en la lista de assets en `pubspec.yaml`

### Error: "Firebase not initialized"

**Síntoma:** Error al intentar usar Firebase.

**Solución:**
1. Verifica las credenciales de Firebase en `.env`
2. Asegúrate de que `dotenv.load()` se ejecuta antes de `Firebase.initializeApp()`

### Error: "Supabase connection failed"

**Síntoma:** No se pueden cargar datos de Supabase.

**Solución:**
1. Verifica la URL y anon key de Supabase
2. Verifica que las tablas existen en la base de datos
3. Revisa las políticas de RLS en Supabase

### Error en Web: "CORS blocked"

**Síntoma:** Las peticiones a APIs externas fallan por CORS.

**Solución:**
1. Configura las cabeceras CORS en tus Google Apps Scripts
2. Usa un proxy para desarrollo local

---

## 🆘 Soporte

Si encuentras problemas no cubiertos en esta guía:

1. Revisa los [Issues](https://github.com/jozzer182/SAM_AT/issues) existentes
2. Crea un nuevo Issue con detalles del problema
3. Incluye logs y pasos para reproducir

---

*Última actualización: Diciembre 2025*

