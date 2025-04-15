// Este archivo define las rutas para la API de Exámenes
// Este archivo define las rutas para manejar las solicitudes relacionadas con los exámenes.

// routes/examenesRoutes.js
const express = require('express');
const router = express.Router();
const examenesController = require('../controllers/examenesController');

router.get('/', examenesController.obtenerExamenes);
router.post('/', examenesController.agregarExamen);

module.exports = router;
