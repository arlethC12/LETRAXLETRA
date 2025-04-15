// routes/leccionesRoutes.js
const express = require('express');
const router = express.Router();
const leccionesController = require('../controllers/leccionesController');

router.get('/', leccionesController.obtenerLecciones);
router.post('/', leccionesController.agregarLeccion);

module.exports = router;
// Este archivo define las rutas HTTP (GET y POST) y las conecta con los controladores de lecciones.
// Las rutas son utilizadas para manejar las solicitudes HTTP y devolver las respuestas adecuadas.