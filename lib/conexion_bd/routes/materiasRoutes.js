import express from 'express';
import {pool} from '../db.js';
const router = express.Router();
import { getmaterias } from '../controllers/materiascontrollers.js';
import { getmateria } from '../controllers/materiascontrollers.js';
import { createmateria } from '../controllers/materiascontrollers.js';
import { deletemateria } from '../controllers/materiascontrollers.js';
import { updatemateria } from '../controllers/materiascontrollers.js';

router.get('/materia', getmaterias); // Obtener todas las materias


router.get('/materia/:cve_materia', getmateria); // Obtener una materia por su cve_materia

router.post('/materia', createmateria); // Crear una nueva materia

router.put('/materia/:cve_materia', async (req, res) => {
    const { cve_materia } = req.params;
    const { nombre, cve_grado } = req.body;

    // Validación de grado
    const gradosValidos = [1, 2, 3, 4, 5, 6];
    if (!gradosValidos.includes(cve_grado)) {
        console.log('Grado no válido:', cve_grado); // Imprime si el grado es inválido
        return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6' });
    }

    try {
        // Actualización en la base de datos
        const { rows } = await pool.query(
            'UPDATE materias SET nombre = $1, cve_grado = $2 WHERE cve_materia = $3 RETURNING *',
            [nombre, cve_grado, cve_materia]
        );

        if (rows.length === 0) {
            return res.status(404).json({ message: 'Materia no encontrada' });
        }
        res.json(rows[0]);
    } catch (error) {
        console.error('Error al actualizar la materia:', error);
        res.status(500).json({ message: 'Error al actualizar la materia' });
    }
});

router.delete('/materia/:cve_materia', deletemateria); // Eliminar una materia por su cve_materia

// Exportar el router para usarlo en otros archivos
// Esto es necesario para que el router funcione correctamente en la aplicación principal
export default router;