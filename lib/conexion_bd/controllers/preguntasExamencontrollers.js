import {pool} from '../db.js';
import express from 'express';
const router = express.Router();

// Obtener todas las preguntas de examen
export const getPreguntasExamen = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM preguntas_examen');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener las preguntas de examen' });
    }
};

// Obtener una pregunta de examen por ID
export const getPreguntaExamenById = async (req, res) => {
    const { cve_pregunta } = req.params;
    try {
        const [rows] = await pool.query('SELECT * FROM preguntas_examen WHERE cve_pregunta = ?', [cve_pregunta]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Pregunta de examen no encontrada' });
        }
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener la pregunta de examen' });
    }
};

// Crear una nueva pregunta de examen
export const postPreguntaExamen = async (req, res) => {
    const { cve_pregunta, cve_examen, pregunta, respuesta_correcta, respuesta_incorrecta1, respuesta_incorrecta2, respuesta_incorrecta3 } = req.body;
    try {
        const [result] = await pool.query('INSERT INTO preguntas_examen (cve_pregunta, cve_examen, pregunta, respuesta_correcta, respuesta_incorrecta1, respuesta_incorrecta2, respuesta_incorrecta3) VALUES (?, ?, ?, ?, ?, ?, ?)', [cve_pregunta, cve_examen, pregunta, respuesta_correcta, respuesta_incorrecta1, respuesta_incorrecta2, respuesta_incorrecta3]);
        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al crear la pregunta de examen' });
    }
};

// Actualizar una pregunta de examen por ID
export const putPreguntaExamen = async (req, res) => {
    const { cve_pregunta } = req.params;
    const { cve_examen, pregunta, respuesta_correcta, respuesta_incorrecta1, respuesta_incorrecta2, respuesta_incorrecta3 } = req.body;
    try {
        const [result] = await pool.query('UPDATE preguntas_examen SET cve_examen = ?, pregunta = ?, respuesta_correcta = ?, respuesta_incorrecta1 = ?, respuesta_incorrecta2 = ?, respuesta_incorrecta3 = ? WHERE cve_pregunta = ?', [cve_examen, pregunta, respuesta_correcta, respuesta_incorrecta1, respuesta_incorrecta2, respuesta_incorrecta3, cve_pregunta]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Pregunta de examen no encontrada' });
        }
        res.json({ message: 'Pregunta de examen actualizada' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al actualizar la pregunta de examen' });
    }
};

// Eliminar una pregunta de examen por ID
export const deletePreguntaExamen = async (req, res) => {
    const { cve_pregunta } = req.params;
    try {
        const [result] = await pool.query('DELETE FROM preguntas_examen WHERE cve_pregunta = ?', [cve_pregunta]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Pregunta de examen no encontrada' });
        }
        res.json({ message: 'Pregunta de examen eliminada' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al eliminar la pregunta de examen' });
    }
};

// Exportar los routers
export default router;