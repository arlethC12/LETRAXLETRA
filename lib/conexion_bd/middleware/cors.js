// Este archivo es un middleware de CORS para permitir solicitudes desde un dominio específico
// y habilitar el uso de credenciales (cookies, autenticación HTTP, etc.)
//
// Importar el paquete cors para manejar CORS (Cross-Origin Resource Sharing)

import cors from 'cors';

const corsOptions = cors({
  origin: 'https://LetraxLetra.com',
  credentials: true
});

export default corsOptions;
