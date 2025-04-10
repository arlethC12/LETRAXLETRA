// Este archivo contiene la lógica para manejar las solicitudes relacionadas con los ejercicios.
// Se encarga de obtener todos los ejercicios y agregar un nuevo ejercicio a la base de datos.

// controllers/ejerciciosController.js
const db = require('../db');

// Obtener todos los ejercicios
const obtenerEjercicios = async (req, res) => {
  try {
    const ejercicios = await db.obtenerEjercicios();
    res.status(200).json(ejercicios);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los ejercicios' });
  }
};

// Agregar un nuevo ejercicio
const agregarEjercicio = async (req, res) => {
  const { cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles } = req.body;
  try {
    const nuevoEjercicio = await db.agregarEjercicio(cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles);
    res.status(201).json(nuevoEjercicio);
  } catch (err) {
    res.status(500).json({ error: 'Error al agregar el ejercicio' });
  }
};

module.exports = {
  obtenerEjercicios,
  agregarEjercicio
};
