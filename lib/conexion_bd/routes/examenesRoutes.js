import express from 'express';
const router = express.Router();
import { 
  createExamen, 
  getExamenes, 
  getExamenporClave, 
  getExamenporMateria, 
  updateExamen, 
  deleteExamen 
} from '../controllers/examenescontrollers.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';


// Roles:
// 1 = Administrador
// 4 = Docente

router.get('/examenes', verifyToken, autorizarRol(1, 4), getExamenes); // Obtener todos los exámenes (admin y docente)

router.get('/examenes/:cve_examen', verifyToken, autorizarRol(1, 4, 3), getExamenporClave); // Obtener un examen por su clave (admin, docente, niño)

router.get('/examenes/materia/:cve_materia', verifyToken, autorizarRol(1, 4), getExamenporMateria); // Obtener exámenes por materia (admin y docente)

router.post('/examenes', verifyToken, autorizarRol(1, 4), createExamen); // Crear un nuevo examen (solo admin y docente)

router.put('/examenes/:cve_examen', verifyToken, autorizarRol(1, 4), updateExamen); // Actualizar un examen por su clave (solo admin y docente)

router.delete('/examenes/:cve_examen', verifyToken, autorizarRol(1, 4), deleteExamen); // Eliminar un examen por su clave (solo admin)

export default router;
