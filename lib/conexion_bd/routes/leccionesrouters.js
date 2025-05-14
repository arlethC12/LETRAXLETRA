import express from 'express';
import { 
  getlecciones, 
  getleccion, 
  getleccionpormateria, 
  getleccionporgrado, 
  getleccionpornombre, 
  createleccion, 
  updateleccion, 
  deleteleccion 
} from '../controllers/leccionescontrollers.js';

import { verifyToken } from '../middleware/tokenverificacion.js';
import { autorizarRol } from '../middleware/autorizarRoles.js';

const router = express.Router();

// Roles:
// 1 = Administrador
// 4 = Docente
// 3 = Niño (lectura y acceso general)

router.get('/lecciones', verifyToken, autorizarRol(1, 4, 3), getlecciones); // Obtener todas las lecciones

router.get('/lecciones/:cve_leccion', verifyToken, autorizarRol(1, 4, 3), getleccion); // Obtener lección por ID

router.get('/lecciones/materia/:cve_materia', verifyToken, autorizarRol(1, 4, 3), getleccionpormateria); // Obtener lecciones por materia

router.get('/lecciones/grado/:cve_grado', verifyToken, autorizarRol(1, 4, 3), getleccionporgrado); // Obtener lecciones por grado

router.get('/lecciones/nombre/:nombre', getleccionpornombre); // Eliminar verifyToken y autorizarRol

router.post('/lecciones', verifyToken, autorizarRol(1, 4), createleccion); // Crear lección (solo admin y docente)

router.put('/lecciones/:cve_leccion', verifyToken, autorizarRol(1, 4), updateleccion); // Actualizar lección (solo admin y docente)

router.delete('/lecciones/:cve_leccion', verifyToken, autorizarRol(1), deleteleccion); // Eliminar lección (solo admin)

export default router;
