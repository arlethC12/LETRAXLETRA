import { pool } from '../db.js';
import express from 'express';
const router = express.Router();
import { 
  getEjercicios, 
  getEjercicioById, 
  postEjercicio, 
  putEjercicio, 
  deleteEjercicio 
} from '../controllers/ejercicioscontrollers.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';

// Rutas para los ejercicios
// Solo administradores y docentes pueden crear, actualizar o eliminar ejercicios
router.get('/ejercicios', getEjercicios); // Obtener todos los ejercicios (sin restricciones)

 // Obtener un ejercicio por su ID (sin restricciones)
router.get('/ejercicios/:cve_ejercicio', getEjercicioById);
router.post('/ejercicios', postEjercicio); // Crear un nuevo ejercicio (solo admin y docente)

router.put('/ejercicios/:cve_ejercicio', putEjercicio); // Actualizar un ejercicio (solo admin y docente)

router.delete('/ejercicios/:cve_ejercicio', deleteEjercicio); // Eliminar un ejercicio (solo admin y docente)

export default router;
