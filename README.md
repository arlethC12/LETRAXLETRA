# 🎓 LETRAXLETRA - Aplicación Educativa Móvil

Una aplicación móvil interactiva diseñada para niños de nivel preescolar, que facilita el aprendizaje continuo de letras (vocales) y números a través de juegos, videos educativos y actividades multimodales.

## 📋 Tabla de Contenidos
- [Descripción General](#descripción-general)
- [Características Principales](#características-principales)
- [Stack Tecnológico](#stack-tecnológico)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Requisitos Previos](#requisitos-previos)
- [Instalación](#instalación)
- [Configuración de la Base de Datos](#configuración-de-la-base-de-datos)
- [Uso](#uso)
- [Contribución](#contribución)
- [Licencia](#licencia)

## 🎯 Descripción General

**LETRAXLETRA** es una plataforma educativa móvil que combina:
- 📚 Lecciones interactivas de vocales (A, E, I, O, U)
- 🎮 Juegos educativos para reforzar el aprendizaje
- 🎬 Videos educativos por cada vocal
- 🔊 Reconocimiento de voz y síntesis de texto a voz
- 🎨 Interfaz amigable y colorida (tema naranja)
- 👤 Sistema de avatares personalizables
- 📊 Seguimiento de progreso del usuario

**Objetivo:** Promover el aprendizaje continuo y divertido de lectoescritura en niños preescolares mediante una experiencia multimedia completa.

## ✨ Características Principales

### Frontend (Flutter)
- ✅ **Lecciones de Vocales:** Cinco módulos interactivos (A, E, I, O, U)
- ✅ **Juegos Educativos:** 
  - Arrastre de letras
  - Escritura en pizarra
  - Selección múltiple
  - Explosión de burbujas
  - Reconocimiento de imágenes
- ✅ **Multimedia:**
  - Videos educativos por vocal
  - Audio dinámico y narración
  - Sonidos de refuerzo positivo
- ✅ **Reconocimiento de Voz:** Integración con Speech-to-Text
- ✅ **Síntesis de Voz:** Flutter TTS para narración
- ✅ **Avatares Personalizables:** Con temas temáticos (jaguar, puma, tucán)
- ✅ **Interfaz Responsiva:** Se adapta a diferentes tamaños de pantalla
- ✅ **Persistencia de Datos:** Guardado local con SharedPreferences

### Backend (Node.js)
- ✅ **API REST:** Endpoints para gestión de usuarios y progreso
- ✅ **Autenticación:** Sistema de registro y login
- ✅ **Base de Datos:** PostgreSQL para almacenamiento persistente
- ✅ **Logging:** Winston para monitoreo
- ✅ **CORS:** Habilitado para conectividad móvil
- ✅ **Morgan:** HTTP request logger

## 🛠 Stack Tecnológico

### Frontend
- **Framework:** Flutter 3.7.0+
- **Lenguaje:** Dart
- **Dependencias Principales:**
  - `flutter_tts`: Síntesis de voz (v4.2.2)
  - `speech_to_text`: Reconocimiento de voz (v7.0.0)
  - `video_player`: Reproducción de videos (v2.9.5)
  - `audioplayers`: Reproducción de audio (v6.4.0)
  - `responsive_framework`: Diseño responsivo (v1.5.1)
  - `shared_preferences`: Almacenamiento local (v2.5.3)
  - `confetti`: Efectos visuales (v0.8.0)
  - `flutter_screenutil`: Escalado de UI (v5.8.4)
  - `font_awesome_flutter`: Iconos (v10.5.0)
  - `flutter_native_splash`: Splash screen (v2.4.5)

### Backend
- **Runtime:** Node.js 18+
- **Framework:** Express.js v5.1.0
- **Base de Datos:** PostgreSQL 12+
- **Dependencias:**
  - `pg`: PostgreSQL client (v8.15.6)
  - `cors`: CORS middleware (v2.8.5)
  - `morgan`: HTTP logger (v1.10.0)
  - `dotenv`: Variables de entorno (v16.5.0)
  - `winston`: Logger (v3.17.0)

## 📁 Estructura del Proyecto

```
LETRAXLETRA/
├── 📱 Frontend (Flutter)
│   ├── lib/
│   │   ├── main.dart                 # Punto de entrada de la app
│   │   ├── avatar.dart              # Gestión de avatares
│   │   ├── registro.dart            # Registro de usuarios
│   │   ├── niveles.dart             # Sistema de niveles
│   │   ├── pvocales.dart            # Pantalla principal de vocales
│   │   ├── escritura.dart           # Ejercicios de escritura
│   │   ├── resga.dart               # Reconocimiento de letras
│   │   ├── resnum.dart              # Reconocimiento de números
│   │   ├── recovoz.dart             # Reconocimiento de voz
│   │   ├── voces.dart               # Gestión de audio
│   │   ├── Continuara.dart          # Continuidad de juego
│   │   ├── vocalA/                  # Módulo vocal A
│   │   ├── vocalE/                  # Módulo vocal E
│   │   ├── vocalI/                  # Módulo vocal I
│   │   ├── vocalO/                  # Módulo vocal O
│   │   ├── vocalU/                  # Módulo vocal U
│   │   ├── Juegos/                  # Juegos educativos
│   │   ├── modulo1exam/             # Módulo de exámenes
│   │   └── conexion_bd/             # Conexión a base de datos
│   ├── assets/                       # Recursos multimedia
│   │   ├── images/                  # Imágenes (animales, letras)
│   │   ├── audios/                  # Archivos de audio (.mp3, .m4a)
│   │   │   ├── VocalA/
│   │   │   ├── VocalE/
│   │   │   ├── VocalI/
│   │   │   ├── VocalO/
│   │   │   └── VocalU/
│   │   └── videos/                  # Videos educativos (.mp4)
│   ├── pubspec.yaml                 # Dependencias Flutter
│   ├── pubspec.lock                 # Lock file
│   ├── analysis_options.yaml        # Linter rules
│   └── android/                      # Configuración Android
│
├── 🖥️ Backend (Node.js)
│   ├── lib/conexion_bd/
│   │   ├── index.js                 # Servidor Express
│   │   ├── package.json             # Dependencias Node
│   │   ├── .env                     # Variables de entorno
│   │   └── routes/                  # Endpoints API (recomendado)
│   │       ├── usuarios.js
│   │       ├── progreso.js
│   │       └── juegos.js
│   └── README.md                    # Documentación backend
│
├── 📄 Configuración del Proyecto
│   ├── .gitignore
│   ├── .metadata
│   ├── devtools_options.yaml
│   ├── README.md
│   └── package.json                 # Root dependencies (si aplica)

```

## 📋 Recursos en Activos
- **Imágenes:** 50+ archivos (animales temáticos: jaguar, puma, tucán, etc.)
- **Audio:** 50+ archivos de narración y efectos de sonido
- **Videos:** 5 videos educativos (uno por vocal)
- **Iconos:** Diseño personalizado con Font Awesome

## ⚙️ Requisitos Previos

### Sistema Operativo
- Windows 10+, macOS 10.13+, o Linux
- 8GB RAM mínimo
- 10GB espacio en disco

### Software Requerido
1. **Flutter SDK** (v3.7.0+)
   - Descargar desde: https://flutter.dev/docs/get-started/install
   - Verificar: `flutter --version`

2. **Dart SDK** (incluido en Flutter)
   - Verificar: `dart --version`

3. **Android Studio** (para Android)
   - Descargar desde: https://developer.android.com/studio
   - Configurar emulador Android

4. **Xcode** (para iOS - solo macOS)
   - Descargar desde: Mac App Store

5. **Node.js** (v18+) para backend
   - Descargar desde: https://nodejs.org

6. **PostgreSQL** (v12+) para base de datos
   - Descargar desde: https://www.postgresql.org/download/

7. **Git** para control de versiones
   - Descargar desde: https://git-scm.com

## 📥 Instalación

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/arlethC12/LETRAXLETRA.git
cd LETRAXLETRA
````

### Paso 2: Configurar Flutter (Frontend)
```bash
# Verificar instalación de Flutter
flutter doctor

# Obtener dependencias
flutter pub get

# Generar archivos necesarios
flutter pub global activate intl_utils
flutter pub run intl_utils:generate
```

### Paso 3: Configurar Node.js Backend
```bash
cd lib/conexion_bd

# Instalar dependencias
npm install

# Crear archivo .env
cp .env.example .env
```

### Paso 4: Configurar Variables de Entorno
Editar `lib/conexion_bd/.env`:
```env
# Base de Datos PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_NAME=letraxletra_db
DB_USER=postgres
DB_PASSWORD=tu_contraseña

# Servidor
PORT=3000
NODE_ENV=development

# Logging
LOG_LEVEL=info
```

### Paso 5: Configurar Base de Datos (ver sección siguiente)

## 🗄️ Configuración de la Base de Datos

### Paso 1: Instalar y Configurar PostgreSQL
```bash
# En Windows (si se descargó)
# Ejecutar instalador y seguir instrucciones

# En macOS
brew install postgresql
brew services start postgresql

# En Linux (Ubuntu/Debian)
sudo apt-get install postgresql postgresql-contrib
sudo systemctl start postgresql
```

### Paso 2: Crear Base de Datos
```bash
# Acceder a PostgreSQL
psql -U postgres

# Crear base de datos
CREATE DATABASE letraxletra_db;

# Crear usuario (si no existe)
CREATE USER tu_usuario WITH PASSWORD 'tu_contraseña';

# Asignar permisos
ALTER ROLE tu_usuario SET client_encoding TO 'utf8';
ALTER ROLE tu_usuario SET default_transaction_isolation TO 'read committed';
ALTER ROLE tu_usuario SET default_transaction_deferrable TO on;
ALTER ROLE tu_usuario SET default_time_zone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE letraxletra_db TO tu_usuario;

# Salir
\q
```

### Paso 3: Crear Tablas (Recomendado)
Crear archivo `lib/conexion_bd/schema.sql`:
```sql
-- Tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    avatar VARCHAR(100),
    nivel INT DEFAULT 1,
    puntos INT DEFAULT 0,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de progreso
CREATE TABLE progreso (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES usuarios(id),
    vocal CHAR(1),
    actividad VARCHAR(100),
    completado BOOLEAN DEFAULT FALSE,
    fecha_completado TIMESTAMP,
    puntos_obtenidos INT DEFAULT 0
);

-- Tabla de juegos
CREATE TABLE juegos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion TEXT,
    tipo VARCHAR(50),
    dificultad INT,
    puntos_maximos INT
);
```

Ejecutar:
```bash
psql -U tu_usuario -d letraxletra_db -f lib/conexion_bd/schema.sql
```

## 🚀 Uso

### Ejecutar Backend
```bash
cd lib/conexion_bd
npm run dev          # Desarrollo con auto-reload
# o
npm start            # Producción
```
El servidor estará disponible en: `http://localhost:3000`

### Ejecutar Frontend

#### En Emulador Android
```bash
flutter run -d emulator
```

#### En Dispositivo Android Real
```bash
flutter run
```

#### En iOS (macOS)
```bash
flutter run -d ios
```

#### En Web (desarrollo)
```bash
flutter run -d chrome
```

### Acceder a la Aplicación
1. Crear cuenta de usuario
2. Seleccionar avatar
3. Comenzar con lecciones de vocales
4. Jugar y completar actividades
5. Visualizar progreso

## 📚 Módulos Principales

### 1. **Lecciones de Vocales**
- Cada vocal tiene su propio módulo
- Incluye: video, narración, imágenes relacionadas
- Actividades: escritura, selección, reconocimiento

### 2. **Juegos Educativos**
- Arrastre de letras
- Explosión de burbujas
- Escritura en pizarra
- Selección múltiple
- Reconocimiento de voz

### 3. **Sistema de Avatares**
- Personajes temáticos (animales de la selva)
- Desbloqueables con progreso

### 4. **Seguimiento de Progreso**
- Puntos por actividad completada
- Niveles desbloqueables
- Guardado automático

## 🤝 Contribución

Para contribuir al proyecto:

1. **Fork el repositorio**
   ```bash
   git clone https://github.com/tu_usuario/LETRAXLETRA.git
   ```

2. **Crear rama para tu feature**
   ```bash
   git checkout -b feature/mi-nueva-funcionalidad
   ```

3. **Hacer cambios y commits**
   ```bash
   git add .
   git commit -m "Descripción clara del cambio"
   ```

4. **Push a tu rama**
   ```bash
   git push origin feature/mi-nueva-funcionalidad
   ```

5. **Crear Pull Request**
   - Ir a GitHub
   - Crear PR con descripción detallada

### Estándares de Código
- Usar nombres descriptivos
- Comentar código complejo
- Seguir Flutter/Dart conventions
- Probar cambios antes de push

## 📖 Recursos Útiles

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Express.js Guide](https://expressjs.com)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
- [Material Design](https://material.io/design)

## 📄 Licencia

Este proyecto está bajo licencia [Especificar Licencia - ej: MIT, Apache 2.0].

## 👨‍💻 Autores

**Arleth Castro** - [GitHub](https://github.com/arlethC12)
**Areli Díaz** - [GitHub](https://github.com/AreliJMZ)
**Ariadna Domínguez** - [GitHub](https://github.com/AriadnaYD)

---

**Última actualización:** 2026-03-18 20:50:44
**Versión:** 1.0.0
