// middleware/autorizarRol.js


export function autorizarRol(...rolesPermitidos) {
  return (req, res, next) => {
    if (!req.usuario || !rolesPermitidos.includes(req.usuario.cve_rol)) {
      return res.status(403).json({ mensaje: 'Acceso denegado: rol no autorizado' });
    }
    next();
  };
}
