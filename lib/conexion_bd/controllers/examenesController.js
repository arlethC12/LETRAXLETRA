// Este archivo contiene la lógica para manejar las solicitudes relacionadas con los exámenes.
// Se encarga de obtener todos los exámenes y agregar un nuevo examen a la base de datos.


// controllers/examenesController.js
const db = require('../db');

// Obtener todos los exámenes
const obtenerExamenes = async (req, res) => {
  try {
    const examenes = await db.obtenerExamenes();
    res.status(200).json(examenes);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los exámenes' });
  }
};

// Agregar un nuevo examen
const agregarExamen = async (req, res) => {
  const { cve_materia, titulo_materia, detalles } = req.body;
  try {
    const nuevoExamen = await db.agregarExamen(cve_materia, titulo_materia, detalles);
    res.status(201).json(nuevoExamen);
  } catch (err) {
    res.status(500).json({ error: 'Error al agregar el examen' });
  }
};

module.exports = {
  obtenerExamenes,
  agregarExamen
};
