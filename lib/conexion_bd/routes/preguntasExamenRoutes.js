// File: lib/conexion_bd/routes/preguntasExamenRoutes.js
// Este archivo define las rutas para manejar las solicitudes relacionadas con las preguntas de los exámenes.

// routes/preguntasExamenRoutes.js
const express = require('express');
const router = express.Router();
const preguntasExamenController = require('../controllers/preguntasExamenController');

router.get('/', preguntasExamenController.obtenerPreguntasExamen);
router.post('/', preguntasExamenController.agregarPreguntaExamen);

module.exports = router;
