// Este archivo contiene la lógica para manejar las solicitudes relacionadas con las notificaciones de los usuarios.
// Se encarga de obtener todas las notificaciones y registrar una nueva notificación en la base de datos.

// controllers/notificacionesController.js
const db = require('../db');

// Obtener todas las notificaciones
const obtenerNotificaciones = async (req, res) => {
  try {
    const notificaciones = await db.obtenerNotificaciones();
    res.status(200).json(notificaciones);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las notificaciones' });
  }
};

// Crear una nueva notificación
const agregarNotificacion = async (req, res) => {
  const { cve_usuario, titulo, mensaje } = req.body;
  try {
    const nuevaNotificacion = await db.agregarNotificacion(cve_usuario, titulo, mensaje);
    res.status(201).json(nuevaNotificacion);
  } catch (err) {
    res.status(500).json({ error: 'Error al crear la notificación' });
  }
};

module.exports = {
  obtenerNotificaciones,
  agregarNotificacion
};
