import {express} from 'express';
import {pool} from '../db';
const router = express.Router();
import {getNotificaciones, getNotificacionById, createNotificacion, 
    updateNotificacion, deleteNotificacion} from '../controllers/notificacionescontrollers.js';

// Obtener todas las notificaciones
router.get('/notificaciones', getNotificaciones)

// Obtener una notificación por ID
router.get('/notificaciones/:id', getNotificacionById)

// Crear una notificación
router.post('/notificaciones', createNotificacion)

// Actualizar una notificación
router.put('/notificaciones/:id', updateNotificacion)

// Eliminar una notificación
router.delete('/notificaciones/:id', deleteNotificacion)

export default router;