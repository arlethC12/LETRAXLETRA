import {pool} from '../db.js';
import express from 'express';
const router = express.Router();

// Obtener todos los registros de progreso
export const getProgresos =async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM progreso');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener los registros de progreso' });
    }
}
// POST - Guardar proceso del usuario
export const postProgresos = async (req, res) => {
  const { cve_usuario, cve_leccion, completado, imagen_url, audio_url, metadata } = req.body;
  try {
    const [result] = await pool.query(
      `INSERT INTO progreso 
        (cve_usuario, cve_leccion, completado, fecha_completado, imagen_url, audio_url, metadata)
       VALUES (?, ?, ?, NOW(), ?, ?, ?)`,
      [cve_usuario, cve_leccion, completado, imagen_url, audio_url, JSON.stringify(metadata)]
    );
    res.status(201).json({ message: 'Progreso guardado', id: result.insertId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al guardar el progreso' });
  }
};

// Obtener un registro de progreso por ID
export const getProgresoporId = async (req, res) => {
    const { cve_progreso } = req.params;
    try {
        const [rows] = await pool.query('SELECT * FROM progreso WHERE cve_progreso = ?', [cve_progreso]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Registro de progreso no encontrado' });
        }
        res.json(rows[0]);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener el registro de progreso' });
    }
}

// Crear un nuevo registro de progreso
export const postProgreso = async (req, res) => {
    const { cve_progreso, cve_usuario, cve_leccion, completado, fecha_completado } = req.body;
    try {
        const [result] = await pool.query('INSERT INTO progreso (cve_progreso, cve_usuario, cve_leccion, completado, fecha_completado) VALUES (?, ?, ?, ?, ?)', [cve_progreso, cve_usuario, cve_leccion, completado, fecha_completado]);
        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al crear el registro de progreso' });
    }
}


// Actualizar un registro de progreso por ID
export const putProgreso = async (req, res) => {
    const { cve_progreso } = req.params;
    const { cve_usuario, cve_leccion, completado, fecha_completado } = req.body;
    try {
        const [result] = await pool.query('UPDATE progreso SET cve_usuario = ?, cve_leccion = ?, completado = ?, fecha_completado = ? WHERE id = ?', [cve_usuario, cve_leccion, completado, fecha_completado, cve_progreso]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Registro de progreso no encontrado' });
        }
        res.json({ message: 'Registro de progreso actualizado' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al actualizar el registro de progreso' });
    }
}

// Eliminar un registro de progreso por ID
export const deleteProgreso = async (req, res) => {
    const {cve_leccion} = req.params;
    try {
        const [result] = await pool.query('DELETE FROM progreso WHERE cve_leccion = ?', [cve_leccion]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Registro de progreso no encontrado' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al eliminar el registro de progreso' });
    }
    res.json({ message: 'Registro de progreso eliminado' });
    }

    export default router;   