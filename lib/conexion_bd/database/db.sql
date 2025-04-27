
--Usuarios


create table usuarios (
    cve_usuario serial primary key,
    nombre varchar(100) not null,
    password varchar(10) not null,
    edad integer,
    fecha_registro timestamp default current_timestamp,
    cve_grado integer references grados(cve_grado),
    cve_rol integer references roles(cve_rol),
    apellido_paterno varchar(100),
    apellido_materno varchar(100)
);


insert into usuarios (nombre, password, edad, cve_grado, cve_rol, apellido_paterno, apellido_materno) 
values ('Ariel', '9617587458', 20, 1, 1, 'Luna', 'Rojas');