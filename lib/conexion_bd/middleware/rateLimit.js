// Rate limiting middleware que limita el número de peticiones a la API
// para prevenir ataques de denegación de servicio (DoS) o abuso de la API

import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Demasiadas peticiones desde esta IP, intenta más tarde.',
});

export default limiter;
