CREATE DATABASE retail_project_db;

-- Conectarse a la nueva base de datos
\c retail_project_db;

-- DDL para creación de tablas
-- Tabla clientes
CREATE TABLE IF NOT EXISTS clientes (
	 id_cliente serial primary key not null
	,nombre varchar(250) not null
	,edad int not null check(edad > 18)
	,email varchar(100) unique not null
	,telefono varchar(100)
);

-- Tabla categorias
CREATE TABLE IF NOT EXISTS categorias (
	 id_categoria serial primary key not null
	,nombre VARCHAR(250) not null
);

-- Tabla productos
CREATE TABLE IF NOT EXISTS productos (
	 id_producto serial primary key not null
	,nombre VARCHAR(100) not null
	,id_categoria int not NULL REFERENCES categorias (id_categoria)
	,precio decimal(10, 2) not null check (precio > 0)
	,stock int not null check(stock >= 0)
);

-- Tabla ventas
CREATE TABLE IF NOT EXISTS ventas (
	 id_venta serial primary key not null
	,fecha timestamp not null
	,id_cliente int not null references clientes (id_cliente)
	,id_producto int not null references productos (id_producto)
);

-- DML para insertar datos 

BEGIN;
INSERT INTO clientes (nombre, edad, email, telefono)
VALUES
    ('Marcos', 36, 'marcos@email.com', '5491112345678'),
    ('Stephanie', 20, 'stephanie@email.com', '5491123456789'),
    ('Roger', 64, 'roger@email.com', '5491134567890'),
    ('Fiona', 25, 'fiona@email.com', '5491145678912'),
    ('Frank', 57, 'frank@email.com', '5491156789123'),
    ('Laura', 32, 'laura@email.com', '5491167891234'),
    ('Carlos', 42, 'carlos@email.com', '5491178912345'),
    ('Sofia', 29, 'sofia@email.com', '5491189123456'),
    ('Andres', 45, 'andres@email.com', '5491191234567'),
    ('Gabriela', 38, 'gabriela@email.com', '5491101234567'),
    ('Daniel', 51, 'daniel@email.com', '5491112233445'),
    ('Valentina', 23, 'valentina@email.com', '5491122334455'),
    ('Martin', 34, 'martin@email.com', '5491133445566'),
    ('Camila', 27, 'camila@email.com', '5491144556677'),
    ('Fernando', 48, 'fernando@email.com', '5491155667788'),
    ('Lucia', 31, 'lucia@email.com', '5491166778899'),
    ('Pablo', 55, 'pablo@email.com', '5491177889900'),
    ('Natalia', 40, 'natalia@email.com', '5491188990011'),
    ('Diego', 26, 'diego@email.com', '5491199001122'),
    ('Victoria', 33, 'victoria@email.com', '5491100112233')
;

INSERT INTO categorias (nombre)
VALUES
    ('electronicos'),
    ('computadoras'),
    ('celulares'),
    ('hogar'),
    ('electrodomesticos'),
    ('audio'),
    ('video'),
    ('fotografia'),
    ('gaming'),
    ('accesorios'),
    ('iluminacion'),
    ('muebles'),
    ('cocina'),
    ('deportes'),
    ('juguetes'),
    ('herramientas'),
    ('oficina'),
    ('belleza'),
    ('indumentaria'),
    ('automotor')
;

INSERT INTO productos (nombre, id_categoria, precio, stock)
VALUES
    ('TV', 1, 152.53, 37),
    ('laptop', 2, 289.53, 85),
    ('Samsung S8', 3, 27.62, 54),
    ('Iphone 5', 3, 50.58, 74),
    ('Lavaropa', 4, 300.75, 14),
    ('Heladera', 5, 450.00, 20),
    ('Auriculares', 6, 35.90, 60),
    ('Monitor LED', 7, 180.00, 25),
    ('Camara digital', 8, 320.00, 12),
    ('Consola', 9, 499.99, 18),
    ('Mouse', 10, 15.50, 100),
    ('Lampara LED', 11, 22.75, 80),
    ('Sofa', 12, 650.00, 8),
    ('Licuadora', 13, 45.00, 30),
    ('Bicicleta', 14, 280.00, 15),
    ('Lego', 15, 65.00, 40),
    ('Taladro', 16, 120.00, 22),
    ('Escritorio', 17, 210.00, 10),
    ('Secador de pelo', 18, 55.00, 35),
    ('Campera', 19, 95.00, 50)
;

INSERT INTO ventas (fecha, id_cliente, id_producto)
VALUES
    ('2021-08-30', 1, 1),
    ('2022-09-27', 2, 2),
    ('2025-06-27', 3, 3),
    ('2026-04-21', 4, 4),
    ('2026-04-21', 1, 5),
    ('2026-05-02', 1, 1),
    ('2026-05-05', 2, 2),
    ('2026-05-08', 3, 3),
    ('2026-05-10', 4, 4),
    ('2026-05-12', 5, 5),
    ('2026-05-15', 6, 6),
    ('2026-05-18', 7, 7),
    ('2026-05-20', 8, 8),
    ('2026-05-22', 9, 9),
    ('2026-05-25', 10, 10),
    ('2026-05-27', 1, 1),
    ('2026-05-29', 2, 2),
    ('2026-06-01', 3, 3),
    ('2026-06-03', 11, 11),
    ('2026-06-05', 12, 12)
;
COMMIT;

/*
 Las 3 consultas requeridas

Rentabilidad por categoría: unir ventas, productos y categorias; mostrar nombre de categoría, unidades vendidas e ingreso total;
filtrar por categorías que superen un umbral de ventas que vos definas.
*/
SELECT 
	UPPER(c.nombre) AS categoria
	,COUNT(v.id_venta) AS unidades_vendidas
	,SUM(p.precio) AS ingreso_total
FROM
	ventas v
JOIN productos p ON v.id_producto = p.id_producto
JOIN categorias c ON p.id_categoria = c.id_categoria
GROUP BY 1
HAVING SUM(p.precio) > 150
ORDER BY 3 DESC 
;

/*
Clientes sin compras: usando LEFT JOIN o subconsulta, identificar clientes registrados que aún no realizaron ninguna compra.
*/
SELECT 
		c.*
		,COALESCE(v.id_cliente::text, 'Sin Compras') AS estado_compra
FROM clientes c  
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL
ORDER BY c.id_cliente
;

/*
Top de compras por cliente: unir clientes, ventas y productos; mostrar nombre del cliente, producto que más veces compró y fecha de su última transacción.
Pista: el producto que más veces compró sale con una subconsulta correlacionada en el SELECT,
como el ejemplo del producto más caro de cada categoría (unidad "Subconsultas y operadores de conjuntos", sección 2.4). 
Para cada cliente, agrupá sus ventas por producto, ordená por la cantidad de compras (COUNT(*)) de mayor a menor y quedate con el primero (LIMIT 1).
La última transacción sale con MAX(fecha).
*/

SELECT
     c.nombre AS cliente
    ,(
        SELECT UPPER(p.nombre)
        FROM ventas v2
        INNER JOIN productos p ON v2.id_producto = p.id_producto
        WHERE v2.id_cliente = c.id_cliente
        GROUP BY p.id_producto, p.nombre
        ORDER BY COUNT(*) DESC, p.nombre
        LIMIT 1
    ) AS producto_mas_comprado
    ,(
        SELECT MAX(v3.fecha)
        FROM ventas v3
        WHERE v3.id_cliente = c.id_cliente
    ) AS ultima_transaccion

FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM ventas v
    WHERE v.id_cliente = c.id_cliente
)
ORDER BY c.nombre
;
