import pg from 'pg';
import { DB_NAME, DB_USER, DB_PORT, DB_HOST, DB_PASSWORD } from '../conexion_bd/config.js';

export const pool = new pg.Pool({
    user: DB_USER,
    host: DB_HOST,
    database: DB_NAME,
    password: DB_PASSWORD,
    port: DB_PORT,

});  