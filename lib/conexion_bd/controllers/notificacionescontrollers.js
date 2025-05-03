import {express} from 'express';
import {pool} from '../db';
const router = express.Router();

// Crear una notificación
export const createNotificacion = async (req, res) => {
    try {
        const { cve_usuario, titulo, mensaje } = req.body;
        const leido = false;
        const fecha_envio = new Date();
        const query = `
            INSERT INTO notificaciones (cve_usuario, titulo, mensaje, leido, fecha_envio)
            VALUES ($1, $2, $3, $4, $5) RETURNING *`;
        const values = [cve_usuario, titulo, mensaje, leido, fecha_envio];
        const result = await pool.query(query, values);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error('Error al crear la notificación:', error);
        res.status(500).json({ error: 'Error al crear la notificación' });
    }
};

// Obtener todas las notificaciones
export const getNotificaciones = async (req, res) => {
    try {
        const query = 'SELECT * FROM notificaciones';
        const result = await pool.query(query);
        res.status(200).json(result.rows);
    } catch (error) {
        console.error('Error al obtener las notificaciones:', error);
        res.status(500).json({ error: 'Error al obtener las notificaciones' });
    }
};

// Obtener una notificación por ID
export const getNotificacionById = async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'SELECT * FROM notificaciones WHERE cve_notificacion = $1';
        const values = [id];
        const result = await pool.query(query, values);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Notificación no encontrada' });
        }
        res.status(200).json(result.rows[0]);
    } catch (error) {
        console.error('Error al obtener la notificación:', error);
        res.status(500).json({ error: 'Error al obtener la notificación' });
    }
};

// Actualizar una notificación
export const updateNotificacion = async (req, res) => {
    try {
        const { id } = req.params;
        const { cve_usuario, titulo, mensaje, leido } = req.body;
        const query = `
            UPDATE notificaciones 
            SET cve_usuario = $1, titulo = $2, mensaje = $3, leido = $4 
            WHERE cve_notificacion = $5 
            RETURNING *`;
        const values = [cve_usuario, titulo, mensaje, leido, id];
        const result = await pool.query(query, values);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Notificación no encontrada' });
        }
        res.status(200).json(result.rows[0]);
    } catch (error) {
        console.error('Error al actualizar la notificación:', error);
        res.status(500).json({ error: 'Error al actualizar la notificación' });
    }
};

// Eliminar una notificación
export const deleteNotificacion = async (req, res) => {
    try {
        const { id } = req.params;
        const query = 'DELETE FROM notificaciones WHERE cve_notificacion = $1 RETURNING *';
        const values = [id];
        const result = await pool.query(query, values);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Notificación no encontrada' });
        }
        res.status(200).json({ message: 'Notificación eliminada correctamente' });
    } catch (error) {
        console.error('Error al eliminar la notificación:', error);
        res.status(500).json({ error: 'Error al eliminar la notificación' });
    }
};

// Exportar el router (por si se desean usar las rutas directamente)
export default router;
