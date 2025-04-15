//Middleware para validar los datos que se reciben al registrar un nuevo usuario.
// Se utiliza express-validator para validar los campos del cuerpo de la solicitud y asegurarse de que cumplen con los requisitos establecidos. Si hay errores, se envía una respuesta con el estado 400 y los errores encontrados. Si no hay errores, se llama a la siguiente función middleware.
//   console.log(`Servidor escuchando en http://localhost:${port}`);

// middlewares/validarDatosUsuario.js
const { check, validationResult } = require('express-validator');

const validarDatosUsuario = [
  check('nombre').not().isEmpty().withMessage('El nombre es obligatorio'),
  check('num_cel').isNumeric().withMessage('El número de celular debe ser un valor numérico'),
  check('contraseña').isLength({ min: 6 }).withMessage('La contraseña debe tener al menos 6 caracteres'),
  check('edad').isInt({ min: 6 }).withMessage('La edad debe ser un número entero mayor o igual a 6'),

  (req, res, next) => {
    const errores = validationResult(req);
    if (!errores.isEmpty()) {
      return res.status(400).json({ errores: errores.array() });
    }
    next();
  }
];

module.exports = { validarDatosUsuario };
