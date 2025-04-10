// Este archivo contiene la lógica para manejar las solicitudes relacionadas con las materias.
// Se encarga de obtener todas las materias y agregar una nueva materia a la base de datos.

// controllers/materiasController.js
const db = require('../db');

// Obtener todas las materias
const obtenerMaterias = async (req, res) => {
  try {
    const materias = await db.obtenerMaterias();
    res.status(200).json(materias);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener las materias' });
  }
};

// Agregar una nueva materia
const agregarMateria = async (req, res) => {
  const { nombre_materia, descripcion, metadata } = req.body;
  try {
    const nuevaMateria = await db.agregarMateria(nombre_materia, descripcion, metadata);
    res.status(201).json(nuevaMateria);
  } catch (err) {
    res.status(500).json({ error: 'Error al agregar la materia' });
  }
};

module.exports = {
  obtenerMaterias,
  agregarMateria
};
