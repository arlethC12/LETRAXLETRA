// Este archivo contiene la lógica para manejar las solicitudes relacionadas con las lecciones.
// Se encarga de obtener todas las lecciones y agregar una nueva lección a la base de datos.

// controllers/leccionesController.js
const db = require('../db');

// Obtener todas las lecciones
const obtenerLecciones = async (req, res) => {
  try {
    const lecciones = await db.obtenerLeccion();
    res.status(200).json(lecciones);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las lecciones' });
  }
};

// Agregar una nueva lección
const agregarLeccion = async (req, res) => {
  const { titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos } = req.body;
  try {
    const nuevaLeccion = await db.agregarLeccion(titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos);
    res.status(201).json(nuevaLeccion);
  } catch (err) {
    res.status(500).json({ error: 'Error al agregar la lección' });
  }
};

module.exports = {
  obtenerLecciones,
  agregarLeccion
};
