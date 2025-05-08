import {pool} from '../db.js';
import express from 'express';
const router = express.Router();

// Importar el controlador de lecciones
// Obtener todas las lecciones
export const getlecciones = async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM lecciones');
    if (rows.length === 0) {
        return res.status(404).json({ message: 'No hay lecciones disponibles' });
    }
    res.json(rows); 
}

// Obtener lección por ID
export const getleccion =  async (req, res) => {
    const { cve_leccion } = req.params;
    const {rows} = await pool.query('SELECT * FROM lecciones WHERE cve_leccion = $1', [cve_leccion]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'Lección no encontrada' });
    }
    res.json(rows);
}

// Obtener lecciones por materia
export const getleccionpormateria = async (req, res) => {
    const { cve_materia } = req.params;
    const { rows } = await pool.query('SELECT * FROM lecciones WHERE cve_materia = $1', [cve_materia]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'No hay lecciones disponibles para esta materia' });
    }
    res.json(rows);
}

// Obtener lecciones por grado
export const getleccionporgrado =async (req, res) => {
    const { cve_grado } = req.params;
    const { rows } = await pool.query('SELECT * FROM lecciones WHERE cve_grado = $1', [cve_grado]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'No hay lecciones disponibles para este grado' });
    }
    res.json(rows);
}

// Obtener lecciones por nombre
export const getleccionpornombre = async (req, res) => {
    const { nombre } = req.params;
    const { rows } = await pool.query('SELECT * FROM lecciones WHERE nombre ILIKE $1', [`%${nombre}%`]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'No hay lecciones disponibles con ese nombre' });
    }
    res.json(rows);
}

// Crear lección
export const createleccion = async (req, res) => {
    const { nombre, cve_materia } = req.body;

    // Validación de materia
    const materiasValidas = [1, 2, 3, 4, 5, 6];
    if (!materiasValidas.includes(cve_materia)) {
        console.log('Materia no válida:', cve_materia); // Imprime si la materia es inválida
        return res.status(400).json({ message: 'Materia inválida. Debe ser un número entre 1 y 6' });
    }

    try {
        // Inserción en la base de datos
        const { rows } = await pool.query(
            'INSERT INTO lecciones (nombre, cve_materia) VALUES ($1, $2) RETURNING *',
            [nombre, cve_materia]
        );
        res.json(rows[0]);
    } catch (error) {
        console.error('Error al insertar la lección:', error);
        res.status(500).json({ message: 'Error al insertar la lección' });
    }
}

// Actualizar lección
// Actualizar lección por ID
export const updateleccion = async (req, res) => {
    const { cve_leccion } = req.params;
    const { nombre, cve_materia } = req.body;

    // Validación de materia
    const materiasValidas = [1, 2, 3, 4, 5, 6];
    if (!materiasValidas.includes(cve_materia)) {
        console.log('Materia no válida:', cve_materia); // Imprime si la materia es inválida
        return res.status(400).json({ message: 'Materia inválida. Debe ser un número entre 1 y 6' });
    }

    try {
        // Actualización en la base de datos
        const { rows } = await pool.query(
            'UPDATE lecciones SET nombre = $1, cve_materia = $2 WHERE cve_leccion = $3 RETURNING *',
            [nombre, cve_materia, cve_leccion]
        );
        res.json(rows[0]);
    } catch (error) {
        console.error('Error al actualizar la lección:', error);
        res.status(500).json({ message: 'Error al actualizar la lección' });
    }
}

// Eliminar lección
// Eliminar lección por ID
export const deleteleccion = async (req, res) => {
    const { cve_leccion } = req.params;
    const { rows } = await pool.query('DELETE FROM lecciones WHERE cve_leccion = $1 RETURNING *', [cve_leccion]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'Lección no encontrada' });
    }
    res.json({ message: 'Lección eliminada' });
}

export default router;
// Exportar el router para usarlo en otros archivos