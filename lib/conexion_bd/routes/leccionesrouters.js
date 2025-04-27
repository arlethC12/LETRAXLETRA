import express from 'express';
import { getlecciones, getleccion, getleccionpormateria, getleccionporgrado, getleccionpornombre, createleccion, updateleccion, deleteleccion } from '../controllers/leccionescontrollers.js'

const router = express.Router();
// Definición de las rutas para la API de lecciones
// GET, POST, PUT, DELETE
// Rutas para las lecciones
// Importar el controlador de lecciones
router.get('/lecciones', getlecciones);// Obtener todas las lecciones


router.get('/lecciones/:cve_leccion', getleccion); // Obtener lección por ID

// Obtener lecciones por materia
router.get('/lecciones/materia/:cve_materia', getleccionpormateria); // Obtener lecciones por materia)

// Obtener lecciones por grado
router.get('/lecciones/grado/:cve_grado', getleccionporgrado); // Obtener lecciones por grado

// Obtener lecciones por nombre
router.get('/lecciones/nombre/:nombre',  getleccionpornombre); // Obtener lecciones por nombre


router.post('/lecciones', createleccion); // Crear lección

// Actualizar lecciones
router.put('/lecciones/:cve_leccion', updateleccion); // Actualizar lección por ID

// Eliminar lecciones
router.delete('/lecciones/:cve_leccion', deleteleccion); // Eliminar lección por ID

export default router;