import express from 'express';
import {pool} from '../db.js';
import { createuser, getuser, getusuarios } from '../controllers/usuarioscontrollers.js';
const router = express.Router();

import { deleteuser } from '../controllers/usuarioscontrollers.js';
import { updateuser } from '../controllers/usuarioscontrollers.js';

// Definición de las rutas para la API de usuarios
// GET, POST, PUT, DELETE

router.get('/usuario', getusuarios); // Obtener todos los usuarios

router.get('/usuario/:cve_usuario', getuser); // Obtener un usuario por su cve_usuario

router.post('/usuario', createuser); // Crear un nuevo usuario

router.delete('/usuario/:cve_usuario',  deleteuser); // Eliminar un usuario por su cve_usuario

router.put('/usuario/:cve_usuario', updateuser); // Actualizar un usuario por su cve_usuario

export default router;
