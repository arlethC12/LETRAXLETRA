import {pool} from '../db.js';
import express from 'express';
const router = express.Router();

import {getProgresos, getProgresoporId, postProgreso, 
    putProgreso, deleteProgreso} from '../controllers/progresocontroller.js';

// Obtener todos los registros de progreso
router.get('/progreso', getProgresos);

// Obtener un registro de progreso por ID
router.get('/progreso/:id', getProgresoporId);

// Crear un nuevo registro de progreso
router.post('/progreso', postProgreso);

// Actualizar un registro de progreso por ID
router.put('/progreso/:id', putProgreso);

// Eliminar un registro de progreso por ID
router.delete('/progreso/:id', deleteProgreso);

export default router;