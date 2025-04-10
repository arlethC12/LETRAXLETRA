// Este archivo contiene la lógica para manejar las solicitudes relacionadas con las preguntas de examen.
// Se encarga de obtener todas las preguntas de examen y agregar una nueva pregunta de examen a la base de datos.

// controllers/preguntasExamenController.js
const db = require('../db');

// Obtener todas las preguntas de examen
const obtenerPreguntasExamen = async (req, res) => {
  try {
    const preguntas = await db.obtenerPreguntasExamenes();
    res.status(200).json(preguntas);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las preguntas de examen' });
  }
};

// Agregar una nueva pregunta de examen
const agregarPreguntaExamen = async (req, res) => {
  const { cve_examen, pregunta, respuesta_correcta, opciones } = req.body;
  try {
    const nuevaPregunta = await db.agregarPreguntaExamen(cve_examen, pregunta, respuesta_correcta, opciones);
    res.status(201).json(nuevaPregunta);
  } catch (err) {
    res.status(500).json({ error: 'Error al agregar la pregunta de examen' });
  }
};

module.exports = {
  obtenerPreguntasExamen,
  agregarPreguntaExamen
};
