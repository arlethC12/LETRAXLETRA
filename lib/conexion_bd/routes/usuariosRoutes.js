import express from 'express';
import { createuser, 
    getuser, 
    getusuarios,  
    loginuser, 
    deleteuser, 
    updateuser} from '../controllers/usuarioscontrollers.js';
const router = express.Router();

import { verifyToken } from '../middleware/verifyToken.js';
import { autorizarRol } from '../middleware/autorizarRol.js';

// Rutas protegidas y públicas usando roles por número
// 1 = Administrador, 2 = Padre, 3 = Niño, 4 = Docente

router.get('/usuario', verifyToken, autorizarRol(1), getusuarios); // Solo administrador

router.get('/usuario/:cve_usuario', getuser); // Público (o protegido si lo decides)

router.post('/usuario', createuser); // Registro público

router.post('/usuario/login', loginuser); // Login público

router.delete('/usuario/:cve_usuario', verifyToken, autorizarRol(1), deleteuser); // Solo administrador

router.put('/usuario/:cve_usuario', verifyToken, autorizarRol(1, 4), updateuser); // Admin y docentes

export default router;
