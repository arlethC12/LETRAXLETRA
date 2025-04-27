import {pool} from '../db.js';
import express from 'express';
const router = express.Router();

export const getCalificaciones = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM calificaciones');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener las calificaciones' });
    }
}

export const getCalificacionById = async (req, res) => {
    const { cve_calificacion } = req.params;
    try {
        const [rows] = await pool.query('SELECT * FROM calificaciones WHERE cve_calificacion = ?', [cve_calificacion]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Calificación no encontrada' });
        }
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener la calificación' });
    }
}

export const postCalificacion = async (req, res) => {
    const { cve_calificacion, cve_usuario, cve_examen, calificacion, fecha_calificacion } = req.body;
    try {
        const [result] = await pool.query('INSERT INTO calificaciones (cve_calificacion, cve_usuario, cve_examen, calificacion, fecha_calificacion) VALUES (?, ?, ?, ?, ?)', [cve_calificacion, cve_usuario, cve_examen, calificacion, fecha_calificacion]);
        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al crear la calificación' });
    }
}

export const putCalificacion = async (req, res) => {
    const { cve_calificacion } = req.params;
    const { cve_usuario, cve_examen, calificacion, fecha_calificacion } = req.body;
    try {
        const [result] = await pool.query('UPDATE calificaciones SET cve_usuario = ?, cve_examen = ?, calificacion = ?, fecha_calificacion = ? WHERE cve_calificacion = ?', [cve_usuario, cve_examen, calificacion, fecha_calificacion, cve_calificacion]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Calificación no encontrada' });
        }
        res.json({ message: 'Calificación actualizada' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al actualizar la calificación' });
    }
}

export const deleteCalificacion = async (req, res) => {
    const { cve_calificacion } = req.params;
    try {
        const [result] = await pool.query('DELETE FROM calificaciones WHERE cve_calificacion = ?', [cve_calificacion]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Calificación no encontrada' });
        }
        res.json({ message: 'Calificación eliminada' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al eliminar la calificación' });
    }
}

// Exportar el router
export default router;