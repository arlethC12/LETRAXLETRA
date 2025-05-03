import express from 'express';
import { 
  getmaterias, 
  getmateria, 
  createmateria, 
  deletemateria, 
  updatemateria 
} from '../controllers/materiascontrollers.js';

import { verifyToken } from '../middleware/verifyToken.js';
import { autorizarRol } from '../middleware/autorizarRol.js';

const router = express.Router();

// Roles:
// 1 = Administrador
// 4 = Docente

// Obtener todas las materias (solo admin y docente)
router.get('/materia', verifyToken, autorizarRol(1, 4), getmaterias);

// Obtener una materia por su cve_materia (solo admin y docente)
router.get('/materia/:cve_materia', verifyToken, autorizarRol(1, 4), getmateria);

// Crear una nueva materia (solo admin y docente)
router.post('/materia', verifyToken, autorizarRol(1, 4), createmateria);

// Actualizar una materia (solo admin y docente)
router.put('/materia/:cve_materia', verifyToken, autorizarRol(1, 4), updatemateria);

// Eliminar una materia (solo admin)
router.delete('/materia/:cve_materia', verifyToken, autorizarRol(1), deletemateria);

// Exportar el router
export default router;
