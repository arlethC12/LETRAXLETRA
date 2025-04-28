import {pool} from '../db.js';
import express from 'express';
const router = express.Router();
import { getEjercicios, getEjercicioById, postEjercicio, putEjercicio, deleteEjercicio } from '../controllers/ejercicioscontrollers.js';

// Rutas para los ejercicios
router.get('/ejercicios', getEjercicios);

// Obtener un ejercicio por su ID
router.get('/ejercicios/:cve_ejercicio', getEjercicioById);

// Crear un nuevo ejercicio
router.post('/ejercicios', postEjercicio);

// Actualizar un ejercicio existente
router.put('/ejercicios/:cve_ejercicio', putEjercicio);

// Eliminar un ejercicio
router.delete('/ejercicios/:cve_ejercicio', deleteEjercicio);

export default router;
//         }