import express from 'express';
import helmet from 'helmet'; // Middleware para proteger la aplicación de vulnerabilidades comunes
import { PORT } from './config.js';
import cors from './middleware/cors.js';
import limiter from './middleware/rateLimit.js';
import logger from './middleware/logger.js';
import usersRoutes from './routes/usuariosroutes.js';
import MateriasRoutes from './routes/materiasroutes.js';
import examenesRoutes from './routes/examenesroutes.js'; // Importar las rutas de exámenes
import leccionesRoutes from './routes/leccionesrouters.js'; // Importar las rutas de lecciones
import preguntasRoutes from './routes/preguntasExamenroutes.js'; // Importar las rutas de preguntas
import resultadosRoutes from './routes/progresoroutes.js'; // Importar las rutas de resultados
import progresoRoutes from './routes/progresoroutes.js'; // Importar las rutas de progreso
import morgan from 'morgan'; // Middleware para logging de peticiones HTTP

const app = express();

app.use(cors); // Usar el middleware de CORS para permitir solicitudes desde un dominio específico
app.use(limiter);   // Usar el middleware de rate limiting para limitar las peticiones a la API

app.use(helmet()); // Usar helmet para proteger la aplicación de vulnerabilidades comunes

app.use(express.json()); // Middleware para parsear el cuerpo de las peticiones JSON

app.use(morgan('dev')); // Usar morgan para logging de peticiones en desarrollo
app.use(usersRoutes);
app.use(MateriasRoutes); // Asegúrate de importar y usar las rutas de materias
app.use(examenesRoutes); // Usar las rutas de exámenes
app.use(leccionesRoutes); // Usar las rutas de lecciones
app.use(preguntasRoutes); // Usar las rutas de preguntas
app.use(resultadosRoutes); // Usar las rutas de resultados
app.use(progresoRoutes); // Usar las rutas de progreso


app.listen(PORT);
console.log("Server is running on port", PORT);

