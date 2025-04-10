// Este archivo define las rutas para manejar las solicitudes relacionadas con los ejercicios.

// routes/ejerciciosRoutes.js
const express = require('express');
const router = express.Router();
const ejerciciosController = require('../controllers/ejerciciosController');

router.get('/', ejerciciosController.obtenerEjercicios);
router.post('/', ejerciciosController.agregarEjercicio);

module.exports = router;
