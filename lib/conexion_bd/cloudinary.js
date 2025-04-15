// Este archivo configura la conexión a Cloudinary para almacenar imágenes y audios.

// lib/conexion_bd/cloudinary.js
const cloudinary = require('cloudinary').v2;

cloudinary.config({
  cloud_name: 'dijux84v0',
  api_key: '511611753444554',
  api_secret: '-w1ONJpHIfaliecyh_Hz4CtcP9g'
});

module.exports = { cloudinary };
