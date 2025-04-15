// Captura errores globalmente y devuelve una respuesta genérica o específica, 
// dependiendo de la situación.

// middlewares/manejarErrores.js
const manejarErrores = (err, req, res, next) => {
    console.error(err); // Imprimir el error en el servidor
  
    res.status(500).json({
      message: 'Hubo un problema en el servidor. Por favor, inténtalo más tarde.'
    });
  };
  
  module.exports = { manejarErrores };
  