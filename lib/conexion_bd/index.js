import express from 'express';
import { PORT } from './config.js';
import usersRoutes from './routes/usuariosroutes.js';
import MateriasRoutes from './routes/materiasroutes.js';
import examenesRoutes from './routes/examenesroutes.js'; // Importar las rutas de exámenes
import leccionesRoutes from './routes/leccionesrouters.js'; // Importar las rutas de lecciones
import preguntasRoutes from './routes/preguntasExamenroutes.js'; // Importar las rutas de preguntas
import resultadosRoutes from './routes/progresoroutes.js'; // Importar las rutas de resultados
import progresoRoutes from './routes/progresoroutes.js'; // Importar las rutas de progreso
import morgan from 'morgan'; // Middleware para logging de peticiones HTTP

const app = express();

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

