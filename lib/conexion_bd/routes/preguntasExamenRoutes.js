import express from 'express';
const router = express.Router();

import { 
  getPreguntasExamen, 
  getPreguntaExamenById, 
  postPreguntaExamen, 
  putPreguntaExamen, 
  deletePreguntaExamen 
} from '../controllers/preguntasExamencontrollers.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';

// Roles:
// 1 = Administrador
// 4 = Docente

// Obtener todas las preguntas de examen (solo administrador y docente)
router.get('/preguntas', verifyToken, autorizarRol(1, 4), getPreguntasExamen);

// Obtener una pregunta por ID (solo administrador y docente)
router.get('/preguntas/:cve_pregunta', verifyToken, autorizarRol(1, 4), getPreguntaExamenById);

// Crear una nueva pregunta de examen (solo administrador y docente)
router.post('/preguntas', verifyToken, autorizarRol(1, 4), postPreguntaExamen);

// Actualizar una pregunta de examen (solo administrador y docente)
router.put('/preguntas/:cve_pregunta', verifyToken, autorizarRol(1, 4), putPreguntaExamen);

// Eliminar una pregunta de examen (solo administrador y docente)
router.delete('/preguntas/:cve_pregunta', verifyToken, autorizarRol(1, 4), deletePreguntaExamen);

export default router;
