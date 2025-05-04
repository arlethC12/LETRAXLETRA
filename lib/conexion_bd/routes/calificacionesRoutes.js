import express from 'express';
const router = express.Router();

import { 
  getCalificaciones, 
  getCalificacionById, 
  postCalificacion, 
  putCalificacion, 
  deleteCalificacion 
} from '../controllers/calificacionescontrollers.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';

// Obtener todas las calificaciones (solo admin y docentes)
router.get('/calificaciones', verifyToken, autorizarRol(1, 4), getCalificaciones);

// Obtener una calificación por su ID (admin, docente y niño)
router.get('/calificaciones/:cve_calificacion', verifyToken, autorizarRol(1, 4, 3), getCalificacionById);

// Crear una nueva calificación (solo admin y docente)
router.post('/calificaciones', verifyToken, autorizarRol(1, 4), postCalificacion);

// Actualizar una calificación (solo admin y docente)
router.put('/calificaciones/:cve_calificacion', verifyToken, autorizarRol(1, 4), putCalificacion);

// Eliminar una calificación (solo admin y docente)
router.delete('/calificaciones/:cve_calificacion', verifyToken, autorizarRol(1, 4), deleteCalificacion);

// Exportar el router
export default router;
