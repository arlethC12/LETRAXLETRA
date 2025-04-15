// File: lib/conexion_bd/routes/progresoRoutes.js
// Este archivo define las rutas para las operaciones relacionadas con el progreso de los usuarios.
// Utiliza el controlador `progresoController` para manejar las solicitudes HTTP.

// routes/progresoRoutes.js
const express = require('express');
const router = express.Router();
const progresoController = require('../controllers/progresoController');

router.get('/', progresoController.obtenerProgreso);
router.post('/', progresoController.agregarProgreso);

module.exports = router;
