const express = require('express');
const { agregarUsuario, obtenerUsuarios, obtenerUsuarioPorNumero, agregarMateria,
  agregarLeccion, agregarEjercicio, agregarExamen, agregarPreguntaExamen, agregarProgreso,
  agregarCalificacion, agregarNotificacion, agregarLogro, agregarRoles, } = require('./db'); // Importamos las funciones del archivo db.js

const app = express();
const PORT = 5000;

app.use(express.json());

const { agregarRoles } = require('./db');

// Ruta para agregar un usuario
app.post('/usuarios', async (req, res) => {
  const { nombre, num_cel, contraseña, edad, cve_grado, apellido_paterno, apellido_materno } = req.body;
  try {
    const nuevoUsuario = await agregarUsuario(nombre, num_cel, contraseña, edad, cve_grado, apellido_paterno, apellido_materno);
    res.status(201).json(nuevoUsuario);
  } catch (err) {
    res.status(500).send('Error al agregar usuario');
  }
});

// Ruta para obtener todos los usuarios
app.get('/usuarios', async (req, res) => {
  try {
    const usuarios = await obtenerUsuarios();
    res.status(200).json(usuarios);
  } catch (err) {
    res.status(500).send('Error al obtener usuarios');
  }
});

// Ruta para obtener un usuario por número de celular
app.get('/usuarios/:num_cel', async (req, res) => {
  const { num_cel } = req.params;
  try {
    const usuario = await obtenerUsuarioPorNumero(num_cel);
    if (usuario) {
      res.status(200).json(usuario);
    } else {
      res.status(404).send('Usuario no encontrado');
    }
  } catch (err) {
    res.status(500).send('Error al obtener usuario');
  }
  
});

// Rutas de materias
app.post('/materias', async (req, res) => {
  const { nombre_materia, descripcion, metadata } = req.body;
  try {
    const nuevaMateria = await agregarMateria(nombre_materia, descripcion, metadata);
    res.status(201).json(nuevaMateria);
  } catch (err) {
    res.status(500).send('Error al agregar materia');
  }
});

// Rutas de lecciones
app.post('/lecciones', async (req, res) => {
  const { titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos } = req.body;
  try {
    const nuevaLeccion = await agregarLeccion(titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos);
    res.status(201).json(nuevaLeccion);
  } catch (err) {
    res.status(500).send('Error al agregar lección');
  }
});

// Rutas de ejercicios
app.post('/ejercicios', async (req, res) => {
  const { cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles } = req.body;
  try {
    const nuevoEjercicio = await agregarEjercicio(cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles);
    res.status(201).json(nuevoEjercicio);
  } catch (err) {
    res.status(500).send('Error al agregar ejercicio');
  }
});

// Rutas de exámenes
app.post('/examenes', async (req, res) => {
  const { cve_materia, titulo_materia, detalles } = req.body;
  try {
    const nuevoExamen = await agregarExamen(cve_materia, titulo_materia, detalles);
    res.status(201).json(nuevoExamen);
  } catch (err) {
    res.status(500).send('Error al agregar examen');
  }
});

// Rutas de preguntas de examen
app.post('/preguntas_examen', async (req, res) => {
  const { cve_examen, pregunta, respuesta_correcta, opciones } = req.body;
  try {
    const nuevaPregunta = await agregarPreguntaExamen(cve_examen, pregunta, respuesta_correcta, opciones);
    res.status(201).json(nuevaPregunta);
  } catch (err) {
    res.status(500).send('Error al agregar pregunta de examen');
  }
});

// Rutas de progreso
app.post('/progreso', async (req, res) => {
  const { cve_usuario, cve_leccion, completado, fecha_completado } = req.body;
  try {
    const nuevoProgreso = await agregarProgreso(cve_usuario, cve_leccion, completado, fecha_completado);
    res.status(201).json(nuevoProgreso);
  } catch (err) {
    res.status(500).send('Error al registrar progreso');
  }
});

// Rutas de calificación
app.post('/calificaciones', async (req, res) => {
  const { cve_usuario, cve_leccion, calificacion } = req.body;
  try {
    const nuevaCalificacion = await agregarCalificacion(cve_usuario, cve_leccion, calificacion);
    res.status(201).json(nuevaCalificacion);
  } catch (err) {
    res.status(500).send('Error al registrar calificación');
  }
});

// Rutas de notificaciones
app.post('/notificaciones', async (req, res) => {
  const { cve_usuario, titulo, mensaje } = req.body;
  try {
    const nuevaNotificacion = await agregarNotificacion(cve_usuario, titulo, mensaje);
    res.status(201).json(nuevaNotificacion);
  } catch (err) {
    res.status(500).send('Error al crear notificación');
  }
});

// Rutas de logros
app.post('/logros', async (req, res) => {
  const { nombre_logro, descripcion } = req.body;
  try {
    const nuevoLogro = await agregarLogro(nombre_logro, descripcion);
    res.status(201).json(nuevoLogro);
  } catch (err) {
    res.status(500).send('Error al crear logro');
  }
});

// Rutas de roles
app.post('/roles', async (req, res) => {
  const { cve_usuario, nombre_rol, descripcion} = req.body;
  try {
    const nuevoRol = await agregarRoles(cve_usuario, nombre_rol, descripcion);
    res.status(201).json(nuevoRol);
  } catch (err) {
    res.status(500).send('Error al agregar rol');
  }
});


// Inicia el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});
