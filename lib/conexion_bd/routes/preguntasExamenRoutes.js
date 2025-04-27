import express from 'express';
const router = express.Router();
import { getPreguntasExamen, getPreguntaExamenById, postPreguntaExamen, putPreguntaExamen, deletePreguntaExamen } from '../controllers/preguntasExamencontrollers.js'

// Definición de las rutas para la API de preguntas de examen
    router.get('/preguntas', getPreguntasExamen)

//
router.get('/preguntas/:cve_pregunta', getPreguntaExamenById)

//
router.post('/preguntas', postPreguntaExamen)

//
router.put('/preguntas/:cve_pregunta', putPreguntaExamen)

//
router.delete('/preguntas/:cve_pregunta', deletePreguntaExamen)

// Exportar el router
export default router;