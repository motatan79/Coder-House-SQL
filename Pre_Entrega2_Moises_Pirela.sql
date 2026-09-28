-- Creación de base de datos
create database retail_project;

-- DDL para creación de tablas
-- Tabla clientes
create table if not exists clientes (
	 id_cliente serial primary key not null
	,nombre varchar(250) not null
	,edad int not null check(edad > 18)
	,email varchar(100) unique not null
	,telefono varchar(100)
);

-- Tabla productos
create table if not exists productos (
	 id_producto serial primary key not null
	,nombre VARCHAR(100) not null
	,descripcion VARCHAR(250) not null
	,precio decimal(10, 2) not null check (precio > 0)
	,stock int not null check(stock >= 0)
);

-- Tabla ventas
create table if not exists ventas (
	 id_ventas serial primary key not null
	,fecha timestamp not null
	,id_cliente int not null references clientes (id_cliente)
	,id_producto int not null references productos (id_producto)
);


-- DML para insertar datos 
begin;
	insert into clientes (nombre, edad, email, telefono)
		values (
		('Marcos',	 	36, 'marcos@email.com',	 	'5491112345678'),		
		('Stephanie', 	20, 'stephanie@email.com',	'5491123456789'),		
		('Roger', 		64, 'roger@email.com', 		'5491134567890'),		
		('Fiona', 		25, 'fiona@email.com', 		'5491145678912'),		
		('Frank', 		57, 'frank@email.com', 		'5491156789123')		
);
	insert into productos (nombre, descripcion, precio, stock)
	values (
		('TV',		 	'electronicos', 152.53, 37),
		('laptop',		'computadoras', 289.53, 85),
		('Samsung S8', 	'celulares',	27.62, 	54),
		('Iphone 5', 	'celulares', 	50.58, 	74),
		('Lavaropa', 	'hogar', 		300.75, 14)
);
	insert into ventas (fecha, id_cliente, id_producto)
		values (
		('2021-08-30', 1, 1),
		('2022-09-27', 2, 2),
		('2025-06-27', 3, 3),
		('2026-04-21', 4, 4),
		('2026-04-21', 1, 5),
);
commit;

-- SELECT previo para saber cuantos registros serán afectados por el UPDATE
SELECT *
FROM productos
WHERE precio < 100;

-- UPDATE 
UPDATE productos
SET precio = precio * 1.10
WHERE precio < 100;;

-- DELETE
delete from ventas 
where id_ventas = 1;
