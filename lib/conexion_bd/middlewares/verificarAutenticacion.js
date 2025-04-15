// Middleware que verifica si el usuario está autenticado.
// Se utiliza jsonwebtoken para verificar el token de autenticación enviado en la cabecera de la solicitud. Si el token es válido, se decodifica y se agrega la información del usuario a la solicitud. Si no es válido, se envía una respuesta con el estado 401 y un mensaje de error.

// middlewares/verificarAutenticacion.js
const jwt = require('jsonwebtoken');

// Middleware para verificar si el usuario está autenticado
const verificarAutenticacion = (req, res, next) => {
  const token = req.headers['authorization'];
  
  if (!token) {
    return res.status(403).json({ message: 'Acceso denegado, se requiere un token' });
  }

  try {
    const decoded = jwt.verify(token, 'mi_clave_secreta');
    req.usuario = decoded;
    next();
  } catch (err) {
    return res.status(401).json({ message: 'Token inválido' });
  }
};

module.exports = { verificarAutenticacion };
