import express from 'express';
import {pool} from '../db.js';
const router = express.Router();

// Definición de las rutas para la API de exámenes
// GET, POST, PUT, DELETE

// Obtener todos los exámenes
// GET /examenes
export const getExamenes = async (req, res) => {

    const {rows} = await pool.query('SELECT * FROM examenes');
    if (rows.length === 0) {
        return res.status(404).json({ message :'No hay exámenes disponibles'});
    }
    res.json(rows);
}

// Obtener un examen por su clave
// GET /examenes/:cve_examen
export const getExamenporClave = async (req, res) => {
    const {cve_examen} = req.params;
    const {rows} = await pool.query('SELECT * FROM examenes Where cve_examen =$1', [cve_examen]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message :'Examen no encontrado'});
    }
    res.json(rows);
}

// Obtener exámenes por materia
// GET /examenes/materia/:cve_materia
export const getExamenporMateria = async (req, res) => {
    const {cve_materia} = req.params;
    const {rows} = await pool.query('SELECT * FROM examenes WHERE cve_materia = $1', [cve_materia]);

    if (rowa.length === 0) {
        return res.status(404).json({ message :'No hay examenes disponibles para esta materia'});
    }
    res.json(rows);
}

// Crear un nuevo examen
// POST /examenes
export const createExamen = async (req, res) => {
    const {cve_examen, cve_materia, nombre_examen, fecha_examen} = req.body;
    const {rows} = await pool.query('INSERT INTO examenes (cve_examen, cve_materia, nombre_examen, fecha_examen) VALUES ($1, $2, $3, $4) RETURNING *', [cve_examen, cve_materia, nombre_examen, fecha_examen]);
    res.status(201).json(rows[0]);
}

// Actualizar un examen por su clave
// PUT /examenes/:cve_examen
export const updateExamen = async (req, res) => {
    const {cve_examen} = req.params;
    const {cve_materia, nombre_examen, fecha_examen} = req.body;
    const {rows} = await pool.query('UPDATE examenes SET cve_materia = $1, nombre_examen = $2, fecha_examen = $3 WHERE cve_examen = $4 RETURNING *', [cve_materia, nombre_examen, fecha_examen, cve_examen]);
    if (rows.length === 0) {
        return res.status(404).json({ message :'Examen no encontrado'});
    }
    res.json(rows[0]);
}

// Eliminar un examen por su clave
// DELETE /examenes/:cve_examen
export const deleteExamen = async (req, res) => {
    const {cve_examen} = req.params;
    const {rows} = await pool.query('DELETE FROM examenes WHERE cve_examen = $1 RETURNING *', [cve_examen]);
    if (rows.length === 0) {
        return res.status(404).json({ message :'Examen no encontrado'});
    }
    res.json({ message :'Examen eliminado'});
}

// Exportar el router para usarlo en otros archivos
export default router;