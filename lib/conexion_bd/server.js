// Este archivo es el punto de entrada de la aplicación Express
// y configura las rutas y middleware necesarios para el funcionamiento de la API.

// server.js

const express = require('express');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 5000;

const { manejarErrores } = require('./middlewares/manejarErrores');

// Middleware
app.use(cors());
app.use(express.json());

// Importamos las rutas de los diferentes módulos
const usuariosRoutes = require('./routes/usuariosRoutes');
const materiasRoutes = require('./routes/materiasRoutes');
const leccionesRoutes = require('./routes/leccionesRoutes');
const ejerciciosRoutes = require('./routes/ejerciciosRoutes');
const examenesRoutes = require('./routes/examenesRoutes');
const preguntasExamenRoutes = require('./routes/preguntasExamenRoutes');
const progresoRoutes = require('./routes/progresoRoutes');
const calificacionesRoutes = require('./routes/calificacionesRoutes');
const notificacionesRoutes = require('./routes/notificacionesRoutes');

// Configuramos el almacenamiento en Cloudinary
const multer = require('multer');
const { cloudinary } = require('../conexion_bd/cloudinary');
const { CloudinaryStorage } = require('multer-storage-cloudinary');

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'letraxletra',
    allowed_formats: ['jpg', 'png', 'mp3', 'wav', 'jpeg'],
  },
});

const upload = multer({ storage });

// Rutas
app.use('/api/usuarios', usuariosRoutes);
app.use('/api/materias', materiasRoutes);
app.use('/api/lecciones', leccionesRoutes);
app.use('/api/ejercicios', ejerciciosRoutes);
app.use('/api/examenes', examenesRoutes);
app.use('/api/preguntasExamen', preguntasExamenRoutes);
app.use('/api/progreso', progresoRoutes);
app.use('/api/calificaciones', calificacionesRoutes);
app.use('/api/notificaciones', notificacionesRoutes);

// Ruta base
app.get('/', (req, res) => {
  res.send('¡Bienvenido a la API de Letra x Letra!');
});

// Middleware para manejar errores
app.use(manejarErrores);

// Iniciar servidor
app.listen(port, () => {
  console.log(`Servidor corriendo en http://localhost:${port}`);
});
