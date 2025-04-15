// Este archivo contiene la lógica para manejar las solicitudes relacionadas con las calificaciones de los usuarios.
// Se encarga de obtener todas las calificaciones y registrar una nueva calificación en la base de datos.

// controllers/calificacionesController.js
const db = require('../db');

// Obtener todas las calificaciones
const obtenerCalificaciones = async (req, res) => {
  try {
    const calificaciones = await db.obtenerCalificaciones();
    res.status(200).json(calificaciones);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las calificaciones' });
  }
};

// Registrar una calificación
const agregarCalificacion = async (req, res) => {
  const { cve_usuario, cve_leccion, calificacion } = req.body;
  try {
    const nuevaCalificacion = await db.agregarCalificacion(cve_usuario, cve_leccion, calificacion);
    res.status(201).json(nuevaCalificacion);
  } catch (err) {
    res.status(500).json({ error: 'Error al registrar la calificación' });
  }
};

module.exports = {
  obtenerCalificaciones,
  agregarCalificacion
};
