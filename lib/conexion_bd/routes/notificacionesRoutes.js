// Este archivo define las rutas para las notificaciones en la API de Express
// // y las asocia con los controladores correspondientes.

// routes/notificacionesRoutes.js
const express = require('express');
const router = express.Router();
const notificacionesController = require('../controllers/notificacionesController');

router.get('/', notificacionesController.obtenerNotificaciones);
router.post('/', notificacionesController.agregarNotificacion);

module.exports = router;
