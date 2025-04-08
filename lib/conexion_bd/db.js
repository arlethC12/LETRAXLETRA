const { Pool } = require('pg'); // Importamos Pool de pg para manejar las conexiones

// Configuración de la conexión a la base de datos PostgreSQL
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'BD_LxL',
  password: 'aydr99',
  port: 5432,
});

// Consultas

// Crear un nuevo usuario
const agregarUsuario = async (nombre, num_cel, contraseña, edad, cve_grado, apellido_paterno = '', apellido_materno = '') => {
  try {
    const result = await pool.query(
      'INSERT INTO usuarios (nombre, num_cel, contraseña, edad, cve_grado, apellido_paterno, apellido_materno) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [nombre, num_cel, contraseña, edad, cve_grado, apellido_paterno, apellido_materno]
    );
    return result.rows[0]; // Devuelve el usuario creado
  } catch (err) {
    console.error('Error al agregar usuario:', err);
    throw err;
  }
};

// Agregar una nueva materia
const agregarMateria = async (nombre_materia, descripcion, metadata) => {
    try {
      const result = await pool.query(
        'INSERT INTO materias (nombre_materia, descripcion, metadata) VALUES ($1, $2, $3) RETURNING *',
        [nombre_materia, descripcion, metadata]
      );
      return result.rows[0]; // Devuelve la materia creada
    } catch (err) {
      console.error('Error al agregar materia:', err);
      throw err;
    }
  };

  // Agregar una nueva lección
const agregarLeccion = async (titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos) => {
    try {
      const result = await pool.query(
        'INSERT INTO lecciones (titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
        [titulo_leccion, descripcion, cve_materia, imagen_url, audio_url, datos]
      );
      return result.rows[0]; // Devuelve la lección creada
    } catch (err) {
      console.error('Error al agregar lección:', err);
      throw err;
    }
  };

  // Agregar un nuevo ejercicio
const agregarEjercicio = async (cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles) => {
    try {
      const result = await pool.query(
        'INSERT INTO ejercicios (cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
        [cve_leccion, pregunta, respuesta_correcta, imagen_url, audio_url, detalles]
      );
      return result.rows[0]; // Devuelve el ejercicio creado
    } catch (err) {
      console.error('Error al agregar ejercicio:', err);
      throw err;
    }
  };

  // Agregar un nuevo examen
const agregarExamen = async (cve_materia, titulo_materia, detalles) => {
    try {
      const result = await pool.query(
        'INSERT INTO examenes (cve_materia, titulo_materia, detalles) VALUES ($1, $2, $3) RETURNING *',
        [cve_materia, titulo_materia, detalles]
      );
      return result.rows[0]; // Devuelve el examen creado
    } catch (err) {
      console.error('Error al agregar examen:', err);
      throw err;
    }
  };

  // Agregar una nueva pregunta de examen
const agregarPreguntaExamen = async (cve_examen, pregunta, respuesta_correcta, opciones) => {
    try {
      const result = await pool.query(
        'INSERT INTO preguntas_examen (cve_examen, pregunta, respuesta_correcta, opciones) VALUES ($1, $2, $3, $4) RETURNING *',
        [cve_examen, pregunta, respuesta_correcta, opciones]
      );
      return result.rows[0]; // Devuelve la pregunta de examen creada
    } catch (err) {
      console.error('Error al agregar pregunta de examen:', err);
      throw err;
    }
  };

  // Registrar el progreso de un usuario en una lección
const agregarProgreso = async (cve_usuario, cve_leccion, completado, fecha_completado) => {
    try {
      const result = await pool.query(
        'INSERT INTO progreso (cve_usuario, cve_leccion, completado, fecha_completado) VALUES ($1, $2, $3, $4) RETURNING *',
        [cve_usuario, cve_leccion, completado, fecha_completado]
      );
      return result.rows[0]; // Devuelve el progreso registrado
    } catch (err) {
      console.error('Error al registrar progreso:', err);
      throw err;
    }
  };

  // Registrar la calificación de un usuario en una lección
const agregarCalificacion = async (cve_usuario, cve_leccion, calificacion) => {
    try {
      const result = await pool.query(
        'INSERT INTO calificaciones (cve_usuario, cve_leccion, calificacion) VALUES ($1, $2, $3) RETURNING *',
        [cve_usuario, cve_leccion, calificacion]
      );
      return result.rows[0]; // Devuelve la calificación registrada
    } catch (err) {
      console.error('Error al registrar calificación:', err);
      throw err;
    }
  };

  // Crear una nueva notificación para un usuario
const agregarNotificacion = async (cve_usuario, titulo, mensaje) => {
    try {
      const result = await pool.query(
        'INSERT INTO notificaciones (cve_usuario, titulo, mensaje) VALUES ($1, $2, $3) RETURNING *',
        [cve_usuario, titulo, mensaje]
      );
      return result.rows[0]; // Devuelve la notificación creada
    } catch (err) {
      console.error('Error al crear notificación:', err);
      throw err;
    }
  };

  // Crear un nuevo logro
const agregarLogro = async (nombre_logro, descripcion) => {
    try {
      const result = await pool.query(
        'INSERT INTO logros (nombre_logro, descripcion) VALUES ($1, $2) RETURNING *',
        [nombre_logro, descripcion]
      );
      return result.rows[0]; // Devuelve el logro creado
    } catch (err) {
      console.error('Error al crear logro:', err);
      throw err;
    }
  };

  // Agregar un nuevo rol
const agregarRoles = async (cve_usuario, nombre_rol, descripcion) => {
    try {
      const result = await pool.query(
        'INSERT INTO roles (cve_usuario, nombre_rol, descripcion) VALUES ($1, $2, $3) RETURNING *',
        [cve_usuario, nombre_rol, descripcion]
      );
      return result.rows[0]; // Devuelve el rol creado
    } catch (err) {
      console.error('Error al agregar rol:', err);
      throw err;
    }
  };
  
  

// Obtener todos los usuarios
const obtenerUsuarios = async () => {
  try {
    const result = await pool.query('SELECT * FROM usuarios');
    return result.rows;
  } catch (err) {
    console.error('Error al obtener usuarios:', err);
    throw err;
  }
};

// Obtener todas las materias
const obtenerMaterias = async () => {
    try {
      const result = await pool.query('SELECT * FROM materias');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener las materias:', err);
      throw err;
    }
  };
  
  // Obtener todas las lecciones
const obtenerLeccion = async () => {
    try {
      const result = await pool.query('SELECT * FROM lecciones');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener las lecciones:', err);
      throw err;
    }
  };
  
    // Obtener todas los roles
const obtenerRoles = async () => {
    try {
      const result = await pool.query('SELECT * FROM roles');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener los roles:', err);
      throw err;
    }
  };
  
  // Obtener todas los ejercicios
const obtenerEjercicios = async () => {
    try {
      const result = await pool.query('SELECT * FROM ejercicios');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener los ejercicios', err);
      throw err;
    }
  };

   // Obtener todos los examenes
const obtenerExamenes = async () => {
    try {
      const result = await pool.query('SELECT * FROM examenes');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener los examenes', err);
      throw err;
    }
  };

    // Obtener todas las preguntas del examen
const obtenerPreguntasExamenes = async () => {
    try {
      const result = await pool.query('SELECT * FROM preguntas_examen');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener las preguntas de los examenes', err);
      throw err;
    }
  };

     // Obtener todos los progresos
const obtenerProgreso = async () => {
    try {
      const result = await pool.query('SELECT * FROM progreso');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener los progresos', err);
      throw err;
    }
  };

      // Obtener todas las calificaciones
const obtenerCalificaciones = async () => {
    try {
      const result = await pool.query('SELECT * FROM calificaciones');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener las calificaciones', err);
      throw err;
    }
  };

       // Obtener todas las notificaciones
const obtenerNotificaciones = async () => {
    try {
      const result = await pool.query('SELECT * FROM notificaciones');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener las notificaciones', err);
      throw err;
    }
  };

         // Obtener todas las notificaciones
const obtenerLogros = async () => {
    try {
      const result = await pool.query('SELECT * FROM logros');
      return result.rows;
    } catch (err) {
      console.error('Error al obtener los logros', err);
      throw err;
    }
  };

// Obtener un usuario por su número de celular
const obtenerUsuarioPorNumero = async (num_cel) => {
  try {
    const result = await pool.query('SELECT * FROM usuarios WHERE num_cel = $1', [num_cel]);
    return result.rows[0];
  } catch (err) {
    console.error('Error al obtener usuario:', err);
    throw err;
  }
};

// Exportar las funciones para que puedan ser usadas en otros archivos
module.exports = {
    agregarUsuario,
    obtenerUsuarios,
    obtenerUsuarioPorNumero,
    obtenerMaterias,
    obtenerLeccion,
    obtenerRoles,
    obtenerCalificaciones,
    obtenerEjercicios,
    obtenerLogros,
    obtenerNotificaciones,
    obtenerPreguntasExamenes,
    obtenerProgreso,
    obtenerExamenes,
    agregarMateria,
    agregarLeccion,
    agregarEjercicio,
    agregarExamen,
    agregarPreguntaExamen,
    agregarProgreso,
    agregarCalificacion,
    agregarNotificacion,
    agregarLogro,
    agregarRoles,
  };  