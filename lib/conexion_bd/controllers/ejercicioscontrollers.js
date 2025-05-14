import {pool} from '../db.js';
import express from 'express';
const router = express.Router();

export const getEjercicios = async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM ejercicios');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener los ejercicios' });
    }
}

export const getEjercicioById = async (req, res) => {
  const cve_ejercicio = parseInt(req.params.cve_ejercicio, 10);
  try {
    const [rows] = await pool.query(
      'SELECT * FROM ejercicios WHERE cve_ejercicio = ?',
      [cve_ejercicio]
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'Ejercicio no encontrado' });
    }
    res.json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Error al obtener el ejercicio' });
  }
};

export const postEjercicio = async (req, res) => {
    const { cve_ejercicio, cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url} = req.body;
    try {
        const [result] = await pool.query('INSERT INTO ejercicios (cve_ejercicio, cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url) VALUES (?, ?, ?, ?, ?, ?)', [cve_ejercicio, cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url]);
        res.status(201).json({ id: result.insertId });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al crear el ejercicio' });
    }
}

export const putEjercicio = async (req, res) => {
    const { cve_ejercicio } = req.params;
    const { cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url } = req.body;
    try {
        const [result] = await pool.query('UPDATE ejercicios SET cve_leccion = ?, pregunta = ?, respuesta_correcta = ?, imagen_url = ?, audio_url = ? WHERE cve_ejercicio = ?', [cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, cve_ejercicio]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Ejercicio no encontrado' });
        }
        res.json({ message: 'Ejercicio actualizado' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al actualizar el ejercicio' });
    }
}  

export const deleteEjercicio = async (req, res) => {
    const { cve_ejercicio } = req.params;
    try {
        const [result] = await pool.query('DELETE FROM ejercicios WHERE cve_ejercicio = ?', [cve_ejercicio]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Ejercicio no encontrado' });
        }
        res.json({ message: 'Ejercicio eliminado' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al eliminar el ejercicio' });
    }
}

export default router;