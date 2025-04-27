import express from 'express';
import {pool} from '../db.js';
const router = express.Router();

// Definición de las rutas para la API de materias
// GET, POST, PUT, DELETE

// GET todas las materias
// Esta función obtiene todas las materias de la base de datos
export const getmaterias = async (req, res) => {
    const {rows} = await pool.query('SELECT * FROM materias');
    if (rows.length === 0) {
        return res.status(404).json({ message: 'No hay materias disponibles' });
    }
    res.json(rows);
}

// GET una materia por su cve_materia
// Esta función obtiene una materia específica de la base de datos utilizando su cve_materia
export const getmateria = async (req, res) => {
    const { cve_materia } = req.params;
    const {rows} = await pool.query('SELECT * FROM materias WHERE cve_materia = $1', [cve_materia]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'Materia no encontrada' });
    }
    res.json(rows);
}

// POST crear una nueva materia
// Esta función crea una nueva materia en la base de datos
export const createmateria = async (req, res) => {
    const { nombre, cve_grado } = req.body;

    // Validación de grado
    const gradosValidos = [1, 2, 3, 4, 5, 6];
    if (!gradosValidos.includes(cve_grado)) {
        console.log('Grado no válido:', cve_grado); // Imprime si el grado es inválido
        return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6' });
    }

    try {
        // Inserción en la base de datos
        const { rows } = await pool.query(
            'INSERT INTO materias (nombre, cve_grado) VALUES ($1, $2) RETURNING *',
            [nombre, cve_grado]
        );
        res.json(rows[0]);
    } catch (error) {
        console.error('Error al insertar la materia:', error);
        res.status(500).json({ message: 'Error al insertar la materia' });
    }
}

// PUT actualizar una materia por su cve_materia
// Esta función actualiza una materia existente en la base de datos utilizando su cve_materia
export const updatemateria = async (req, res) => {
    const { cve_materia } = req.params;
    const { nombre, cve_grado } = req.body;

    // Validación de grado
    const gradosValidos = [1, 2, 3, 4, 5, 6];
    if (!gradosValidos.includes(cve_grado)) {
        console.log('Grado no válido:', cve_grado); // Imprime si el grado es inválido
        return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6' });
    }

    try {
        // Actualización en la base de datos
        const { rows } = await pool.query(
            'UPDATE materias SET nombre = $1, cve_grado = $2 WHERE cve_materia = $3 RETURNING *',
            [nombre, cve_grado, cve_materia]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Materia no encontrada' });
        }
        res.json(rows[0]);
    } catch (error) {
        console.error('Error al actualizar la materia:', error);
        res.status(500).json({ message: 'Error al actualizar la materia' });
    }
}

// DELETE eliminar una materia por su cve_materia
// Esta función elimina una materia de la base de datos utilizando su cve_materia
export const deletemateria = async (req, res) => {
    const { cve_materia } = req.params;
    const { rowCount } = await pool.query('DELETE FROM materias WHERE cve_materia = $1 RETURNING *', [cve_materia]);

    if (rowCount === 0) {
        return res.status(404).json({ message: 'Materia no encontrada' });
    }
    res.json({ message: 'Materia eliminada' });
}

// Exportar el router para usarlo en otros archivos
// Esto es necesario para que el router funcione correctamente en la aplicación principal
export default router;