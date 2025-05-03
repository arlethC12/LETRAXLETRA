// routes/notificaciones.routes.js

import express from 'express';
import { pool } from '../db.js';
import {
  getNotificaciones,
  getNotificacionById,
  createNotificacion,
  updateNotificacion,
  deleteNotificacion
} from '../controllers/notificacionescontrollers.js';

import { verifyToken } from '../middleware/verifyToken.js';
import { autorizarRol } from '../middleware/autorizarRol.js';

const router = express.Router();

// Roles:
// 1 = Administrador
// 2 = Padre
// 3 = Niño
// 4 = Docente

// Obtener todas las notificaciones
router.get('/notificaciones', verifyToken, autorizarRol(1, 3), getNotificaciones);

// Obtener una notificación por ID
router.get('/notificaciones/:id', verifyToken, autorizarRol(1), getNotificacionById);

// Crear una notificación 
router.post('/notificaciones', verifyToken, autorizarRol(1), createNotificacion);

// Actualizar una notificación
router.put('/notificaciones/:id', verifyToken, autorizarRol(1), updateNotificacion);

// Eliminar una notificación
router.delete('/notificaciones/:id', verifyToken, autorizarRol(1, 2, 3, 4), deleteNotificacion);

export default router;
