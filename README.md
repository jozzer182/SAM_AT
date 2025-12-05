# SAM AT+ 🏗️

<div align="center">

<img src="images/tower.png" alt="SAM AT+ Logo" width="120"/>

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![Google Apps Script](https://img.shields.io/badge/Google_Apps_Script-4285F4?style=for-the-badge&logo=google&logoColor=white)

**Sistema de Administración de Materiales para Asistencia Técnica**

Sistema integral para el control y seguimiento de registros de materiales en operaciones de asistencia técnica.

[Características](#-características) • [Instalación](#-instalación) • [Configuración](#-configuración) • [Uso](#-uso) • [Arquitectura](#-arquitectura)

</div>

---

## 📋 Descripción

**SAM AT+** es una aplicación multiplataforma desarrollada en Flutter para la gestión y control de materiales en operaciones de asistencia técnica. Permite el seguimiento de inventarios, gestión de planillas, control de deudas operativas y mucho más.

## ✨ Características

### Gestión de Materiales
- 📦 **Inventario** - Control completo de existencias
- 📝 **Planillas** - Gestión de documentos y registros
- 🔄 **Remisiones** - Seguimiento de entregas y movimientos
- 📊 **MB51/MB52** - Reportes de movimientos de materiales

### Control Operativo
- 💰 **Deuda Operativa** - Seguimiento de pendientes por operador
- 🏪 **Deuda Almacén** - Control de faltantes en almacén
- 📈 **Deuda Bruta** - Reportes consolidados de deudas

### Funcionalidades Adicionales
- 🔐 **Autenticación** - Sistema de login con Firebase Auth
- 🎨 **Temas personalizables** - Modo oscuro y colores personalizados
- 📱 **Multiplataforma** - Soporte para Web, Android, iOS y Desktop
- 🔍 **LCL** - Consulta de localizaciones
- 🎫 **Tokens de seguridad** - Sistema de autorización para operaciones sensibles

## 🛠️ Stack Tecnológico

| Tecnología | Uso |
|------------|-----|
| **Flutter** | Framework de desarrollo multiplataforma |
| **Dart** | Lenguaje de programación |
| **Firebase** | Autenticación, Firestore, Hosting |
| **Supabase** | Base de datos PostgreSQL |
| **Google Apps Script** | APIs de integración con hojas de cálculo |
| **BLoC** | Gestión de estado |

## 📂 Arquitectura del Proyecto

```
lib/
├── bloc/                    # Gestión de estado (BLoC pattern)
│   ├── main_bloc.dart
│   ├── main_event.dart
│   └── main_state.dart
├── Home/                    # Pantalla principal
├── Log/                     # Autenticación
│   ├── login_page.dart
│   ├── auth_services.dart
│   └── register_screen.dart
├── resources/               # Configuraciones y utilidades
│   ├── env_config.dart      # Variables de entorno
│   └── constants/
│       └── apis.dart
├── planilla/               # Módulo de planillas
├── inventario/             # Módulo de inventario
├── remisiones/             # Módulo de remisiones
├── deuda_operativa/        # Módulo de deuda operativa
├── deuda_almacen/          # Módulo de deuda almacén
├── lcl/                    # Módulo LCL
└── main.dart               # Punto de entrada
```

## 🚀 Instalación

### Prerrequisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.7.2)
- [Dart SDK](https://dart.dev/get-dart) (>=3.7.2)
- Cuenta de Firebase
- Cuenta de Supabase (opcional, para módulo LCL)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/jozzer182/SAM_AT.git
   cd SAM_AT
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar variables de entorno** (ver sección [Configuración](#-configuración))

4. **Ejecutar la aplicación**
   ```bash
   # Web
   flutter run -d chrome
   
   # Android
   flutter run -d android
   
   # iOS
   flutter run -d ios
   ```

## ⚙️ Configuración

### Variables de Entorno

1. **Copiar el archivo de ejemplo**
   ```bash
   cp .env.example .env
   ```

2. **Editar `.env` con tus credenciales**
   ```env
   # Firebase Configuration
   FIREBASE_API_KEY=tu_api_key
   FIREBASE_APP_ID=tu_app_id
   FIREBASE_MESSAGING_SENDER_ID=tu_sender_id
   FIREBASE_PROJECT_ID=tu_project_id
   FIREBASE_AUTH_DOMAIN=tu_project.firebaseapp.com
   FIREBASE_STORAGE_BUCKET=tu_project.appspot.com
   
   # Google Apps Script APIs
   API_ENVIAR_SOLPE=https://script.google.com/macros/s/TU_ID/exec
   API_FEM=https://script.google.com/macros/s/TU_ID/exec
   API_SAM=https://script.google.com/macros/s/TU_ID/exec
   API_SAMAT=https://script.google.com/macros/s/TU_ID/exec
   
   # Supabase Configuration
   SUPABASE_URL=https://tu-proyecto.supabase.co
   SUPABASE_ANON_KEY=tu_anon_key
   ```

### Configuración de Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita Authentication con Email/Password
4. Copia las credenciales de tu app web a `.env`

### Configuración de Supabase (Opcional)

1. Ve a [Supabase Dashboard](https://app.supabase.com/)
2. Crea un nuevo proyecto
3. Copia la URL y Anon Key a `.env`

Para más detalles, consulta [docs/SETUP.md](docs/SETUP.md).

## 📱 Plataformas Soportadas

| Plataforma | Estado |
|------------|--------|
| Web | ✅ Completo |
| Android | ⚠️ En desarrollo |
| iOS | ⚠️ En desarrollo |
| macOS | ⚠️ En desarrollo |
| Windows | ⚠️ En desarrollo |
| Linux | ⚠️ En desarrollo |

## 🔧 Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Compilar para web
flutter build web

# Ejecutar tests
flutter test

# Analizar código
flutter analyze

# Formatear código
dart format lib/
```

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto es privado y de uso interno.

## 📞 Contacto

**Desarrollador:** [@jozzer182](https://github.com/jozzer182)

---

<div align="center">

Hecho con ❤️ usando Flutter

</div>
