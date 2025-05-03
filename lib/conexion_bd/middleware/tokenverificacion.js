import jwt from 'jsonwebtoken';

export const verifyToken = (req, res, next) => {
  const token = req.headers['authorization'];

  if (!token) {
    return res.status(403).json({ mensaje: 'Token no proporcionado' });
  }

  const tokenSinBearer = token.replace('Bearer ', '');

  try {
    const decoded = jwt.verify(tokenSinBearer, process.env.JWT_SECRET);
    req.usuario = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ mensaje: 'Token inválido o expirado' });
  }
};
