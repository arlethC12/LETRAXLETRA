// Este archivo define las rutas para las calificaciones
// y las vincula con el controlador correspondiente.


// routes/calificacionesRoutes.js
const express = require('express');
const router = express.Router();
const calificacionesController = require('../controllers/calificacionesController');

router.get('/', calificacionesController.obtenerCalificaciones);
router.post('/', calificacionesController.agregarCalificacion);

module.exports = router;
