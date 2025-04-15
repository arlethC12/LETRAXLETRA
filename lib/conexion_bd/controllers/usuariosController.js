// Este archivo contiene la lógica para manejar las solicitudes relacionadas con los usuarios.
// Se encarga de obtener todos los usuarios, buscar un usuario por número de celular y agregar un nuevo usuario a la base de datos.

// controllers/usuariosController.js
const db = require('../db');

// Obtener todos los usuarios
const obtenerUsuarios = async (req, res) => {
  try {
    const usuarios = await db.obtenerUsuarios();
    res.json(usuarios);
  } catch (error) {
    res.status(500).json({ error: 'Error al obtener los usuarios' });
  }
};

// Obtener un usuario por número de celular
const obtenerUsuarioPorNumero = async (req, res) => {
  const { num_cel } = req.params;
  try {
    const usuario = await db.obtenerUsuarioPorNumero(num_cel);
    if (usuario) {
      res.json(usuario);
    } else {
      res.status(404).json({ error: 'Usuario no encontrado' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Error al buscar el usuario' });
  }
};

// Agregar un nuevo usuario
const agregarUsuario = async (req, res) => {
  const { nombre, num_cel, contraseña, edad, cve_grado, apellido_paterno, apellido_materno } = req.body;
  try {
    const nuevoUsuario = await db.agregarUsuario(
      nombre,
      num_cel,
      contraseña,
      edad,
      cve_grado,
      apellido_paterno,
      apellido_materno
    );
    res.status(201).json(nuevoUsuario);
  } catch (error) {
    res.status(500).json({ error: 'Error al crear el usuario' });
  }
};

module.exports = {
  obtenerUsuarios,
  obtenerUsuarioPorNumero,
  agregarUsuario,
};

