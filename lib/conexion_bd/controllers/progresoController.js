// controllers/progresoController.js
// Este archivo contiene la lógica para manejar las solicitudes relacionadas con el progreso de los usuarios.
// Se encarga de obtener todos los progresos y registrar el progreso de un usuario en la base de datos.

// controllers/progresoController.js
const db = require('../db');

// Obtener todos los progresos
const obtenerProgreso = async (req, res) => {
  try {
    const progresos = await db.obtenerProgreso();
    res.status(200).json(progresos);
  } catch (err) {
    res.status(500).json({ error: 'Error al obtener los progresos' });
  }
};

// Registrar el progreso de un usuario
const agregarProgreso = async (req, res) => {
  const { cve_usuario, cve_leccion, completado, fecha_completado } = req.body;
  try {
    const nuevoProgreso = await db.agregarProgreso(cve_usuario, cve_leccion, completado, fecha_completado);
    res.status(201).json(nuevoProgreso);
  } catch (err) {
    res.status(500).json({ error: 'Error al registrar el progreso' });
  }
};

module.exports = {
  obtenerProgreso,
  agregarProgreso
};
