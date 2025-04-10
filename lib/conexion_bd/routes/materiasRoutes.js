// Este archivo define las rutas HTTP (GET y POST) y las conecta con los controladores de materias.
// Las rutas son utilizadas para manejar las solicitudes HTTP y devolver las respuestas adecuadas.

// routes/materiasRoutes.js
const express = require('express');
const router = express.Router();
const materiasController = require('../controllers/materiasController');

router.get('/', materiasController.obtenerMaterias);
router.post('/', materiasController.agregarMateria);

module.exports = router;
