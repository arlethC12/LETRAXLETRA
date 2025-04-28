import {pool} from '../db.js';
import express from 'express';
const router = express.Router();


// Obtener todos los usuarios
// GET /usuario
export const getusuarios = async (req, res) => {
 const {rows} = await pool.query('SELECT * FROM usuarios');
  res.json(rows);
}

// Obtener un usuario por su cve_usuario
// GET /usuario/:cve_usuario
export const getuser = async (req, res) => {
    const { cve_usuario } = req.params;
    const {rows} = await pool.query('SELECT * FROM usuarios WHERE cve_usuario = $1', [cve_usuario]);
    
    if (rows.length === 0) {
        return res.status(404).json({ message: 'Usuario no encontrado' });
    }
    res.json(rows);
}

// Crear un nuevo usuario
// POST /usuario
export const createuser = async (req, res) => {
    const { nombre, password, edad, fecha_registro, cve_grado, cve_rol } = req.body;
  
    // Si no se proporciona fecha_registro, asignamos la fecha actual sin zona horaria
    const fechaFinal = fecha_registro || new Date().toISOString().slice(0, 19).replace('T', ' '); // Fecha actual en formato sin zona horaria
  
    // Imprimir los datos recibidos
    console.log('Datos recibidos:', req.body);
  
    // Validación de rol
    const rolesValidos = [1, 2, 3, 4];
    if (!rolesValidos.includes(cve_rol)) {
      console.log('Rol no válido:', cve_rol); // Imprime si el rol es inválido
      return res.status(400).json({ message: 'Rol inválido. Debe ser 1 (admin), 2 (padre), 3 (niño) o 4 (docente)' });
    }
  
    // Validación de grado (solo obligatorio para niños/alumnos)
    if (cve_rol === 3) { // Rol de los niños
      console.log('Validando grado para niño...'); // Imprime que estamos validando el grado para el rol 3
      if (!cve_grado || cve_grado < 1 || cve_grado > 6) {
        console.log('Grado inválido:', cve_grado); // Imprime si el grado es inválido
        return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6 para usuarios tipo niño.' });
      }
    }
     try {
        // Inserción en la base de datos
        const { rows } = await pool.query(
          'INSERT INTO usuarios (nombre, password, edad, fecha_registro, cve_grado, cve_rol) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
          [
            nombre, 
            password, 
            edad, 
            fechaFinal, // Fecha sin zona horaria
            cve_grado ?? null, // Si el grado no aplica (por ejemplo, para roles que no son niños), se pone null
            cve_rol
          ]
        );
    
        // Verificación de éxito
        if (rows.length === 0) {
          return res.status(404).json({ message: 'No se creó el usuario' });
        }
    
        // Respuesta con el usuario creado
        res.json(rows[0]);
      } catch (error) {
        console.error('Error al crear el usuario:', error);
        res.status(500).json({ message: 'Error del servidor' });
      }
}

// Eliminar un usuario por su cve_usuario
// DELETE /usuario/:cve_usuario
export const deleteuser = async (req, res) => {
  const { cve_usuario} = req.params;
  const {rowCount} = await pool.query('DELETE FROM usuarios Where cve_usuario = $1 RETURNING *', [cve_usuario]);
  if (rowCount === 0) {
    return res.status(404).json({ message: 'Usuario no encontrado' });
  }
  res.json({ message: 'Usuario eliminado' });
  res.json(rows);
}

// Actualizar un usuario por su cve_usuario
// PUT /usuario/:cve_usuario
export const updateuser = async (req, res) => {
  const { cve_usuario } = req.params; // Obtener el cve_usuario de los parámetros de la URL
  const { nombre, apellido_paterno, apellido_materno, password, edad, fecha_registro, cve_grado, cve_rol } = req.body; // Obtener los datos del cuerpo de la solicitud

  // Si no se proporciona fecha_registro, usamos la fecha actual sin zona horaria
  const fechaFinal = fecha_registro || new Date().toISOString().slice(0, 19).replace('T', ' ');

  // Validación de rol
  const rolesValidos = [1, 2, 3, 4];
  if (cve_rol && !rolesValidos.includes(cve_rol)) {
    return res.status(400).json({ message: 'Rol inválido. Debe ser 1 (admin), 2 (padre), 3 (niño) o 4 (docente)' });
  }

  // Validación de grado (solo obligatorio para niños/alumnos)
  if (cve_rol === 3 && (cve_grado < 1 || cve_grado > 6)) {
    return res.status(400).json({ message: 'Grado inválido. Debe ser un número entre 1 y 6 para usuarios tipo niño.' });
  }

  try {
    // Composición de la consulta para actualizar solo los campos proporcionados
    const queryParams = [
      nombre, 
      apellido_paterno ?? null, 
      apellido_materno ?? null, 
      password, 
      edad, 
      fechaFinal, 
      cve_grado ?? null, 
      cve_rol, 
      cve_usuario
    ];

    const { rows } = await pool.query(
      'UPDATE usuarios SET nombre = $1, apellido_paterno = COALESCE($2, apellido_paterno), apellido_materno = COALESCE($3, apellido_materno), password = $4, edad = $5, fecha_registro = $6, cve_grado = $7, cve_rol = $8 WHERE cve_usuario = $9 RETURNING *',
      queryParams
    );

    // Verificamos si el usuario fue encontrado y actualizado
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    // Respondemos con los datos del usuario actualizado
    res.json(rows[0]);
  } catch (error) {
    console.error('Error al actualizar el usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
}

export default router;
// export default router;