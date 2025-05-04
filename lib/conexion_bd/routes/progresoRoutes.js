import express from 'express';
import { 
  getProgresos, 
  getProgresoporId, 
  postProgreso, 
  putProgreso, 
  deleteProgreso 
} from '../controllers/progresocontroller.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';

const router = express.Router();

// Roles:
// 1 = Administrador
// 3 = Niño
// 4 = Docente

// Obtener todos los registros de progreso (solo admin y docente)
router.get('/progreso', verifyToken, autorizarRol(1, 4), getProgresos);

// Obtener un registro por ID (niño, docente, admin)
router.get('/progreso/:cve_progreso', verifyToken, autorizarRol(1, 3, 4), getProgresoporId);

// Crear un nuevo registro (niños, admin o docente)
router.post('/progreso', verifyToken, autorizarRol(1, 3, 4), postProgreso);

// Actualizar un registro (docente o admin)
router.put('/progreso/:cve_progreso', verifyToken, autorizarRol(1, 4), putProgreso);

// Eliminar un registro (solo admin)
router.delete('/progreso/:cve_progreso', verifyToken, autorizarRol(1), deleteProgreso);

export default router;
