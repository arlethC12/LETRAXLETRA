// Las rutas son utilizadas para manejar las solicitudes HTTP y devolver las respuestas adecuadas.
// Este archivo define las rutas HTTP (GET y POST) y las conecta con los controladores de usuarios.

// routes/usuariosRoutes.js
const express = require('express');
const router = express.Router();
const usuariosController = require('../controllers/usuariosController');
const { verificarAutenticacion } = require('../middlewares/verificarAutenticacion');
const { validarDatosUsuario } = require('../middlewares/validarDatosUsuario');
const { agregarUsuario } = require('../db');

// Ruta protegida que requiere autenticación
router.get('/perfil', verificarAutenticacion, async (req, res) => {
    try {
      const usuario = req.usuario;  // Los datos del usuario están disponibles desde el middleware
      res.json(usuario);
    } catch (err) {
      res.status(500).json({ message: 'Error al obtener el perfil' });
    }
  });

// Ruta para obtener todos los usuarios
router.get('/', usuariosController.obtenerUsuarios);

// Ruta para obtener un usuario por número de celular
router.get('/:num_cel', usuariosController.obtenerUsuarioPorNumero);

// Ruta para crear un nuevo usuario
router.post('/', usuariosController.agregarUsuario);

module.exports = router;
