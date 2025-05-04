import { pool } from '../db.js'; // Importar el pool de conexión a la base de datos desde db.js
import express from 'express'; // Importar express para crear el router
const router = express.Router(); // Importar el pool de conexión a la base de datos desde db.js
import bcrypt from 'bcrypt'; // Importar bcrypt para el manejo de contraseñas
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv'; // Importar dotenv para manejar variables de entorno

dotenv.config(); // Configurar dotenv para que lea el archivo .env

// Obtener todos los usuarios
// GET /usuario
export const getusuarios = async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM usuarios');
  res.json(rows);
};

// Obtener un usuario por su cve_usuario
// GET /usuario/:cve_usuario
export const getuser = async (req, res) => {
  const { cve_usuario } = req.params;
  const { rows } = await pool.query('SELECT * FROM usuarios WHERE cve_usuario = $1', [cve_usuario]);

  if (rows.length === 0) {
    return res.status(404).json({ message: 'Usuario no encontrado' });
  }
  res.json(rows[0]);
};

// Crear un nuevo usuario
// POST /usuario
export const createuser = async (req, res) => {
  const { nombre, password, edad, fecha_registro, cve_grado, cve_rol } = req.body;
  const fechaFinal = fecha_registro || new Date().toISOString().slice(0, 19).replace('T', ' ');

  const rolesValidos = [1, 2, 3, 4];
  if (!rolesValidos.includes(cve_rol)) {
    return res.status(400).json({ message: 'Rol inválido. Debe ser 1 (admin), 2 (padre), 3 (niño) o 4 (docente)' });
  }

  if (cve_rol === 3 && (!cve_grado || cve_grado < 1 || cve_grado > 6)) {
    return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6 para usuarios tipo niño.' });
  }

  try {
    const { rows } = await pool.query(
      'INSERT INTO usuarios (nombre, password, edad, fecha_registro, cve_grado, cve_rol) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [nombre, password, edad, fechaFinal, cve_grado ?? null, cve_rol]
    );

    if (rows.length === 0) {
      return res.status(400).json({ message: 'No se creó el usuario' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Error al crear el usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

// Login de usuario con verificación de contraseña
// POST /usuario/login
export const loginuser = async (req, res) => {
  const { password } = req.body;

  try {
    const resultado = await pool.query('SELECT nombre, edad FROM usuarios WHERE password = $1', [password]);
    const usuario = resultado.rows[0];

    if (!usuario) {
      return res.status(404).json({ mensaje: 'Número no encontrado' });
    }

    res.json({
      nombre: usuario.nombre,
      edad: usuario.edad
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: 'Error del servidor' });
  }
}


// Actualizar un usuario por su cve_usuario
// PUT /usuario/:cve_usuario
export const updateuser = async (req, res) => {
  const { cve_usuario } = req.params;
  const { nombre, apellido_paterno, apellido_materno, password, edad, fecha_registro, cve_grado, cve_rol } = req.body;

const fechaFinal = fecha_registro || new Date().toISOString().slice(0, 19).replace('T', ' ');

const rolesValidos = [1, 2, 3, 4];
  if (cve_rol && !rolesValidos.includes(cve_rol)) {
    return res.status(400).json({ message: 'Rol inválido. Debe ser 1 (admin), 2 (padre), 3 (niño) o 4 (docente)' });
  }

if (cve_rol === 3 && (cve_grado < 1 || cve_grado > 6)) {
    return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6 para usuarios tipo niño.' });
  }

  try {
    let hashedPassword = null;

    if (password) {
      const saltRounds = 10;
      hashedPassword = await bcrypt.hash(password, saltRounds);
    }

    const queryParams = [
      nombre,
      apellido_paterno ?? null,
      apellido_materno ?? null,
      hashedPassword,
      edad,
      fechaFinal,
      cve_grado ?? null,
      cve_rol,
      cve_usuario
    ];

    const { rows } = await pool.query(
      `UPDATE usuarios 
       SET 
         nombre = $1,
         apellido_paterno = COALESCE($2, apellido_paterno),
         apellido_materno = COALESCE($3, apellido_materno),
         password = COALESCE($4, password),
         edad = $5,
         fecha_registro = $6,
         cve_grado = $7,
         cve_rol = $8
       WHERE cve_usuario = $9
       RETURNING *`,
      queryParams
    );

  if (rows.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

   res.json(rows[0]);
  } catch (error) {
    console.error('Error al actualizar el usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

// Eliminar un usuario por su cve_usuario
// DELETE /usuario/:cve_usuario
export const deleteuser = async (req, res) => {
  const { cve_usuario } = req.params;
  const { rows } = await pool.query('DELETE FROM usuarios WHERE cve_usuario = $1 RETURNING *', [cve_usuario]);

  if (rows.length === 0) {
    return res.status(404).json({ message: 'Usuario no encontrado' });
  }

  res.json(rows[0]);
};