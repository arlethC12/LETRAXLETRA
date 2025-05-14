import express from 'express';
import { 
  getmaterias, 
  getmateria, 
  createmateria, 
  deletemateria, 
  updatemateria 
} from '../controllers/materiascontrollers.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';

const router = express.Router();

// Roles:
// 1 = Administrador
// 4 = Docente

// GET una materia por su cve_materia (public access)
router.get('/:cve_materia', getmateria);

// Obtener todas las materias (solo admin y docente)
router.get('/materia', verifyToken, autorizarRol(1, 4), getmaterias);

// Crear una nueva materia (solo admin y docente)
router.post('/materia', verifyToken, autorizarRol(1, 4), createmateria);

// Actualizar una materia (solo admin y docente)
router.put('/materia/:cve_materia', verifyToken, autorizarRol(1, 4), updatemateria);

// Eliminar una materia (solo admin)
router.delete('/materia/:cve_materia', verifyToken, autorizarRol(1), deletemateria);

// Exportar el router
export default router;