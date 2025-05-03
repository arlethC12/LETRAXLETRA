// Author: LxL company
// Fecha: 2023-10-01
// Descrpcion del archivo: Este archivo contiene la configuración del logger 
// para la aplicación, utilizando Winston como biblioteca de registro. 
// El logger está configurado para mostrar mensajes en la consola con un formato específico 
// que incluye la marca de tiempo y el nivel de gravedad del mensaje.

import { createLogger, transports, format } from 'winston';

const logger = createLogger({
  level: 'info',
  format: format.combine(
    format.timestamp(),
    format.colorize(),
    format.printf(({ timestamp, level, message }) => {
      return `[${timestamp}] ${level}: ${message}`;
    })
  ),
  transports: [new transports.Console()]
});

export default logger;
