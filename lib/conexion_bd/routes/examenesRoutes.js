import express from 'express';
const router = express.Router();
import {createExamen, getExamenes, getExamenporClave, 
    getExamenporMateria, updateExamen, deleteExamen} from '../controllers/examenescontrollers.js';


// Obtener todos los exámenes
router.get('/examenes', getExamenes)

// Obtener un examen por su clave
router.get('examenes/:cve_examen', getExamenporClave)

// Obtener exámenes por materia
router.get('/examenes/materia/:cve_materia', getExamenporMateria)

// Crear un nuevo examen
router.post('/examenes', createExamen)

// Actualizar un examen por su clave
router.put('/examenes/:cve_examen', updateExamen)

// Eliminar un examen por su clave
router.delete('/examenes/:cve_examen', deleteExamen)

// Exportar el router
export default router;

