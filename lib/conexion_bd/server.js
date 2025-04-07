// Importamos los módulos necesarios
const express = require('express');     // Importa Express para crear el servidor
const { Pool } = require('pg');        // Importa Pool de pg para manejar la conexión a PostgreSQL

// Configuración de la conexión a la base de datos PostgreSQL
const pool = new Pool({
  user: 'postgres',                 // Nombre de usuario de tu base de datos PostgreSQL
  host: 'localhost',                  // Dirección de tu servidor de base de datos (en este caso es local)
  database: 'BD_LxL',       // Nombre de la base de datos a la que te conectarás
  password: 'aydr99',          // Contraseña de la base de datos
  port: 5432,                         // El puerto predeterminado de PostgreSQL (puedes cambiarlo si usas otro)
});

// Verificación de la conexión a la base de datos
pool.connect((err, client, release) => {
  if (err) { // Si hay un error en la conexión
    console.error('Error al conectar a la base de datos', err.stack); // Imprime el error en la consola
  } else {
    console.log('Conexión exitosa a la base de datos'); // Imprime un mensaje si la conexión es exitosa
  }
});

// Configuración del servidor Express
const app = express();                // Creamos una instancia de Express
const PORT = process.env.PORT || 5000; // Establecemos el puerto del servidor (por defecto es 5000)

// Middleware para procesar JSON en las peticiones
app.use(express.json()); // Esto permite que el servidor reciba datos en formato JSON

// Ruta GET para obtener todos los usuarios de la base de datos
app.get('/usuarios', async (req, res) => {
  try {
    // Realizamos una consulta SQL para obtener todos los registros de la tabla 'users'
    const result = await pool.query('SELECT * FROM usuarios');
    
    // Enviamos la respuesta con los datos obtenidos de la base de datos
    res.json(result.rows);  // 'result.rows' contiene los resultados de la consulta
  } catch (err) { // Si hay un error durante la consulta
    console.error('Error al obtener datos', err); // Imprimimos el error en la consola
    res.status(500).send('Error al obtener datos'); // Respondemos con un error 500 al cliente
  }
});

// Ruta POST para crear un nuevo usuario
app.post('/usuarios', async (req, res) => {
  const { nombre, num_cel } = req.body; // Extraemos los datos del cuerpo de la petición

  try {
    // Realizamos una consulta SQL para insertar un nuevo usuario en la tabla 'users'
    const result = await pool.query(
      'INSERT INTO users (nombre, num_cel) VALUES ($1, $2) RETURNING *',
      [nombre, num_cel] // Los valores a insertar
    );

    // Respondemos con el nuevo usuario creado
    res.status(201).json(result.rows[0]);  // 'result.rows[0]' es el primer usuario insertado
  } catch (err) { // Si hay un error durante la consulta
    console.error('Error al crear el usuario', err); // Imprimimos el error en la consola
    res.status(500).send('Error al crear el usuario'); // Respondemos con un error 500 al cliente
  }
});

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`); // Imprimimos un mensaje cuando el servidor esté corriendo
});

let isPoolClosed = false;

// Manejar el cierre de la aplicación
process.on('SIGINT', async () => {
  if (!isPoolClosed) {
    console.log('Cerrando el servidor...');
    isPoolClosed = true;
    await pool.end();
  } else {
    console.log('El pool ya fue cerrado.');
  }
  process.exit();
});
