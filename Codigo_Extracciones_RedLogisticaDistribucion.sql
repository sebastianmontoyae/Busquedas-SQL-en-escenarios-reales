drop table if exists seguimiento cascade;
drop table if exists envios  cascade;
drop table if exists paquetes cascade;
drop table if exists rutas cascade;
drop table if exists vehiculos cascade;
drop table if exists empleados cascade;
drop table if exists sucursales cascade;
drop table if exists clientes cascade;
drop table if exists ciudades cascade;

--creacion de tablas
create table ciudades(id_ciudad serial primary key,
nombre varchar (100) not null,
departamento varchar(100)not null,
pais varchar(60)not null default 'colombia');

create table sucursales(id_sucursales serial primary key,
nombre varchar (40)not null,
direccion varchar(100)not null,
telefono varchar(20),
id_ciudad int references ciudades(id_ciudad));
--id_ciudad de esta tabla es una clave foranea con la tabla ciudades vinculada a la columna id_ciudad

create table clientes (id_cliente serial primary key,
nombre varchar(100)not null,
email varchar (120)unique not null,
telefono varchar(20),
direccion varchar (200),
tipo varchar(20) check(tipo in('natural','empresa'))default'natural',
id_ciudad int references ciudades(id_ciudad),
fecha_registro date default current_date);

create table empleados(id_empleado serial primary key,
nombre varchar(100)not null,
cargo varchar(40)not null,
salario numeric(12,2),
email varchar(120)unique,
id_sucursal int references sucursales(id_sucursales),
fecha_ingreso date default current_date);

create table vehiculos(id_vehiculos serial primary key,
placa varchar(20)unique not null,
tipo varchar(40)check(tipo in('moto','camioneta','furgon','camion')),
capacidad_kg numeric(8,2),
estado varchar(20) check (estado in('disponible','en_ruta','mantenimiento'))default'disponible',
id_sucursal int references sucursales(id_sucursales));

create table rutas(id_ruta serial primary key,
nombre varchar(100)not null,
origen int references ciudades(id_ciudad),
destino int references ciudades(id_ciudad),
distancia_km numeric(8,2),
tiempo_horas numeric(5,2));

create table paquetes( id_paquetes serial primary key,
descripcion varchar(100),
peso_kg numeric(8,2)not null,
alto_cm numeric(6,2),
ancho_cm numeric(6,2),
largo_cm numeric(6,2),
fragil boolean default false);

create table envios( id_envio serial primary key,
codigo varchar(20) unique not null,
id_cliente int references clientes (id_cliente),
id_paquete int references paquetes(id_paquetes),
id_ruta int references rutas(id_ruta),
id_vehiculo int references vehiculos(id_vehiculos),
id_empleado int references empleados(id_empleado),
fecha_envio date default current_date,
fecha_entrega date,
estado varchar(30)check (estado in ('pendiente','en transito','entregado','devuelto','perdido'))default 'pendiente',
valor_flete numeric(12,2),
observaciones text);

create table seguimiento(id_seguimiento serial primary key,
id_envio int references envios(id_envio),
fecha_hora timestamp default current_timestamp,
ubicacion varchar(200),
estado varchar(30),
novedades text);

--insertamos los datos

INSERT INTO ciudades (nombre, departamento) VALUES
('Bogotá',        'Cundinamarca'),
('Medellín',      'Antioquia'),
('Cali',          'Valle del Cauca'),
('Barranquilla',  'Atlántico'),
('Bucaramanga',   'Santander'),
('Pereira',       'Risaralda'),
('Manizales',     'Caldas'),
('Armenia',       'Quindío'),
('Cartagena',     'Bolívar'),
('Cúcuta',        'Norte de Santander');

-- Sucursales
INSERT INTO sucursales (nombre, direccion, telefono, id_ciudad) VALUES
('Sucursal Bogotá Centro',    'Cra 7 # 32-10',       '6011234567', 1),
('Sucursal Medellín El Poblado', 'Cll 10 # 43-20',   '6042345678', 2),
('Sucursal Cali Norte',       'Av 6N # 25-15',       '6023456789', 3),
('Sucursal Barranquilla',     'Cra 54 # 68-30',      '6054567890', 4),
('Sucursal Bucaramanga',      'Cll 35 # 22-11',      '6075678901', 5),
('Sucursal Pereira',          'Av Circunvalar # 10', '6066789012', 6);

-- Clientes
INSERT INTO clientes (nombre, email, telefono, direccion, tipo, id_ciudad) VALUES
('Carlos Gómez',         'carlos.gomez@email.com',    '3001112233', 'Cra 15 # 80-20', 'natural',  1),
('Empresa TextilCol',    'contacto@textilcol.com',    '6012223344', 'Cll 13 # 37-15', 'empresa',  1),
('María Torres',         'maria.torres@email.com',    '3102223344', 'Cll 50 # 12-30', 'natural',  2),
('Distribuidora Pacífico','ventas@distpacífico.com',  '6023334455', 'Av 3N # 18-40',  'empresa',  3),
('Pedro Ramírez',        'pedro.ramirez@email.com',   '3203334455', 'Cra 33 # 45-10', 'natural',  4),
('ImportExport SAS',     'info@importexport.com',     '6014445566', 'Cll 26 # 85-55', 'empresa',  1),
('Laura Sánchez',        'laura.sanchez@email.com',   '3154445566', 'Cll 9 # 39-11',  'natural',  2),
('Grupo Andino Ltda',    'grupo@andino.com',          '6025556677', 'Cra 1 # 5-30',   'empresa',  3),
('Andrés Castillo',      'andres.castillo@email.com', '3006667788', 'Cra 20 # 15-5',  'natural',  5),
('Comercial Caribe',     'ventas@caribe.com',         '6057778899', 'Cll 72 # 43-20', 'empresa',  4);

-- Empleados
INSERT INTO empleados (nombre, cargo, salario, email, id_sucursal, fecha_ingreso) VALUES
('Juan Perez',      'conductor',      2800000, 'juan.perez@logistica.com',      19, '2021-03-15'),
('Ana Martínez',    'coordinadora',   4500000, 'ana.martinez@logistica.com',    19, '2020-01-10'),
('Luis Herrera',    'conductor',      2800000, 'luis.herrera@logistica.com',    20, '2022-06-01'),
('Diana López',     'coordinadora',   4500000, 'diana.lopez@logistica.com',     20, '2019-08-20'),
('Ricardo Mora',    'conductor',      2800000, 'ricardo.mora@logistica.com',    21, '2023-01-05'),
('Sandra Ruiz',     'administradora', 5200000, 'sandra.ruiz@logistica.com',     19, '2018-05-12'),
('Felipe Castro',   'conductor',      2800000, 'felipe.castro@logistica.com',   22, '2022-11-30'),
('Claudia Vargas',  'coordinadora',   4500000, 'claudia.vargas@logistica.com',  21, '2021-07-14'),
('Miguel Ángel',    'conductor',      2800000, 'miguel.angel@logistica.com',    23, '2023-03-20'),
('Patricia Niño',   'administradora', 5200000, 'patricia.nino@logistica.com',   20, '2017-09-01');

-- Vehículos
INSERT INTO vehiculos (placa, tipo, capacidad_kg, estado, id_sucursal) VALUES
('ABC123', 'camioneta',  1000, 'disponible',   19),
('DEF456', 'camion',     5000, 'en_ruta',      19),
('GHI789', 'moto',        50,  'disponible',   20),
('JKL012', 'furgon',     2000, 'disponible',   20),
('MNO345', 'camion',     5000, 'mantenimiento',21),
('PQR678', 'camioneta',  1000, 'en_ruta',      21),
('STU901', 'moto',        50,  'disponible',   22),
('VWX234', 'furgon',     2000, 'disponible',   23),
('YZA567', 'camioneta',  1000, 'disponible',   19),
('BCD890', 'camion',     5000, 'disponible',   22);

-- Rutas
INSERT INTO rutas (nombre, origen, destino, distancia_km, tiempo_horas) VALUES
('Bogotá - Medellín',       1, 2, 415,  8.0),
('Bogotá - Cali',           1, 3, 460,  9.0),
('Bogotá - Barranquilla',   1, 4, 1000, 18.0),
('Medellín - Cali',         2, 3, 420,  8.5),
('Bogotá - Bucaramanga',    1, 5, 390,  7.5),
('Barranquilla - Cartagena',4, 9, 120,  2.5),
('Bogotá - Pereira',        1, 6, 290,  6.0),
('Medellín - Barranquilla', 2, 4, 700, 13.0),
('Cali - Pereira',          3, 6, 210,  4.0),
('Bucaramanga - Cúcuta',    5, 10,200,  4.5);

-- Paquetes
INSERT INTO paquetes (descripcion, peso_kg, alto_cm, ancho_cm, largo_cm, fragil) VALUES
('Documentos legales',        0.5,  5,  25, 35, FALSE),
('Ropa y calzado',            3.0, 30,  40, 50, FALSE),
('Electrodoméstico pequeño',  5.0, 40,  35, 40, TRUE),
('Muestras de tela',          8.0, 20,  60, 80, FALSE),
('Medicamentos',              1.0, 15,  20, 25, TRUE),
('Repuestos automotriz',     15.0, 50,  60, 70, FALSE),
('Equipos de cómputo',       10.0, 45,  50, 60, TRUE),
('Alimentos no perecederos', 20.0, 40,  50, 60, FALSE),
('Piezas industriales',      50.0, 80, 100,120, FALSE),
('Artículos de oficina',      4.0, 30,  35, 45, FALSE);

-- Envíos
INSERT INTO envios (codigo, id_cliente, id_paquete, id_ruta, id_vehiculo, id_empleado, fecha_envio, fecha_entrega, estado, valor_flete, observaciones) VALUES
('ENV-2024-001', 11,  11,  11,  11,  21,  '2024-01-10', '2024-01-11', 'entregado',   35000,  NULL),
('ENV-2024-002', 12,  14,  12,  12,  22,  '2024-01-12', '2024-01-14', 'entregado',   85000,  'Entrega en bodega'),
('ENV-2024-003', 13,  13,  14,  13,  23,  '2024-01-15', NULL,         'en transito', 120000, 'Paquete frágil'),
('ENV-2024-004', 14,  16,  19,  16,  28,  '2024-01-18', '2024-01-19', 'entregado',   95000,  NULL),
('ENV-2024-005', 15,  12,  13,  20, 27,  '2024-01-20', NULL,         'pendiente',   150000, NULL),
('ENV-2024-006', 16,  17,  11,  19,  22,  '2024-02-01', '2024-02-02', 'entregado',   180000, 'Equipo de cómputo'),
('ENV-2024-007', 17,  15,  17,  11,  21,  '2024-02-05', '2024-02-06', 'entregado',   45000,  'Medicamentos urgentes'),
('ENV-2024-008', 18,  19,  12,  12,  22,  '2024-02-10', NULL,         'en transito', 320000, 'Carga pesada'),
('ENV-2024-009', 19,  20, 15,  18,  29,  '2024-02-12', '2024-02-13', 'entregado',   55000,  NULL),
('ENV-2024-010', 20, 18,  16,  20, 27,  '2024-02-15', '2024-02-16', 'entregado',   210000, NULL),
('ENV-2024-011', 11,  12,  17,  14,  22,  '2024-03-01', '2024-03-02', 'entregado',   65000,  NULL),
('ENV-2024-012', 12,  19,  13,  12,  22,  '2024-03-05', NULL,         'devuelto',    380000, 'Dirección incorrecta'),
('ENV-2024-013', 13,  17,  14,  13,  23,  '2024-03-10', '2024-03-11', 'entregado',   160000, NULL),
('ENV-2024-014', 16,  11,  15,  18,  29,  '2024-03-12', '2024-03-13', 'entregado',   38000,  NULL),
('ENV-2024-015', 18,  16,  18,  14,  24,  '2024-03-15', NULL,        'en transito', 275000, NULL);

delete table 
-- Seguimiento
INSERT INTO seguimiento (id_envio, fecha_hora, ubicacion, estado, novedades) VALUES
(52, '2024-01-10 08:00:00', 'Sucursal Bogotá Centro',       'pendiente',    NULL),
(52, '2024-01-10 10:00:00', 'Salida Bogotá',                'en transito',  NULL),
(52, '2024-01-11 09:00:00', 'Llegada Medellín',             'entregado',    NULL),
(54, '2024-01-15 09:00:00', 'Sucursal Medellín El Poblado', 'pendiente',    NULL),
(54, '2024-01-15 11:00:00', 'En ruta Medellín - Cali',      'en transito',  'Paquete frágil, manejo especial'),
(59, '2024-02-10 08:00:00', 'Sucursal Bogotá Centro',       'pendiente',    NULL),
(59, '2024-02-10 12:00:00', 'Salida hacia Cali',            'en transito',  'Carga de 50kg'),
(63,'2024-03-05 09:00:00', 'Sucursal Bogotá Centro',       'pendiente',    NULL),
(63,'2024-03-05 14:00:00', 'En ruta a Barranquilla',       'en transito',  NULL),
(63,'2024-03-07 10:00:00', 'Barranquilla',                 'devuelto',     'Dirección del cliente incorrecta');

select*from envios;
ALTER SEQUENCE ciudades_id_ciudad_seq RESTART WITH 1;
--reinicio los valores de la llave primaria para que esten desde el 1
DELETE FROM ciudades;--elimino los registro generados
INSERT INTO ciudades (nombre, departamento) VALUES
('Bogotá',        'Cundinamarca'),
('Medellín',      'Antioquia'),
('Cali',          'Valle del Cauca'),
('Barranquilla',  'Atlántico'),
('Bucaramanga',   'Santander'),
('Pereira',       'Risaralda'),
('Manizales',     'Caldas'),
('Armenia',       'Quindío'),
('Cartagena',     'Bolívar'),
('Cúcuta',        'Norte de Santander');
select *from empleados;

--consultas
--todos los envios con su estado actual
select codigo,estado from envios;
--todo los clientes tipo empresa
select nombre from clientes where tipo='empresa';
--ver vehiculos disponibles ordenados por capacidad
select placa, tipo, capacidad_kg from vehiculos where estado ='disponible'
order by capacidad_kg desc;
--los envios entregado en febrero de 2024
select codigo, fecha_envio, fecha_entrega, valor_flete
from envios where estado='entregado' and fecha_entrega between '2024-02-01'and '2024-02-28';
--los empleados con cargo de conductor y su sucursal
select  e.nombre, e.email, e.cargo, S.NOMBRE as  sucursal  from empleados e join sucursales s on e.id_sucursal=s.id_sucursales where e.cargo='conductor';
--TOTAL DE ENVIOS Y VALOR RECAUDADO
SELECT ESTADO, COUNT(*) AS TOTAL_ENVIOS,
SUM(valor_flete) AS TOTAL_RECAUDADO,
AVG(valor_flete) AS PROMEDIO_FLETE FROM ENVIOS GROUP BY ESTADO
ORDER BY TOTAL_RECAUDADO DESC;
--clientes con mas de un envio y su total pagado
select c.nombre, count(e.id_envio) as total_envios,
sum(e.valor_flete) as total_pagado
from clientes c join envios e on c.id_cliente=e.id_cliente
group by c.nombre having count(e.id_envio)>1
order by total_pagado desc;
--ruta mas usada y su distancia en tiempo
select r.nombre, r.distancia_km, r.tiempo_horas, count (e.id_envio)as veces_usado
from rutas r join envios e on r.id_ruta=e.id_ruta
group by r.nombre, r.distancia_km, r.tiempo_horas
order by veces_usado desc;
--paquetes fragiles que estan en transito
select e.codigo, c.nombre as cliente, p.descripcion, p.peso_kg, r.nombre as ruta
from envios e join clientes c on e.id_cliente=c.id_cliente
join paquetes p on e.id_paquete=p.id_paquetes
join rutas r on e.id_ruta=r.id_ruta
where p.fragil=true and e.estado='en tansito';
--empleados con la cantidad de envios gestionados
select em.nombre, em.cargo, s.nombre as sucursal,
count(e.id_envio) as envios_gestionados,
sum(e.valor_flete) as valor_total_gestionado
from empleados em
left join envios e on em.id_empleado=e.id_empleado
left join sucursales s on em.id_sucursal=s.id_sucursales
group by em.nombre, em.cargo, s.nombre
order by envios_gestionados desc;
--clientes que han pagado el mayor valor en fletes
select nombre, email from clientes
where id_cliente=(select id_cliente from envios group by id_cliente order by sum(valor_flete)
desc limit 1);
--envios con el valor de flete mayor al promedio general
select e.codigo, c.nombre as cliente,e.valor_flete, e.estado
from envios e join clientes c on e.id_cliente=c.id_cliente
where e.valor_flete>(select avg(valor_flete)from envios)
order by e.valor_flete desc;
--rendimientos por sucursal(envios, ingresos, empleados)
select s.nombre as sucursal, count(distinct em.id_empleado) as total_empleados,
count(distinct e.id_envio) as total_envios,
sum(e.valor_flete) as ingresos_totales,
avg(e.valor_flete) as ingreso_promedio from sucursales s
left join empleados em on s.id_sucursales=em.id_sucursal
left join envios e on em.id_empleado=e.id_empleado
group by s.nombre
order by ingresos_totales desc nulls last;
--historial completo de seguimiento de un envio especifico
select e.codigo, c.nombre as cliente,
r.nombre as ruta,
sg.fecha_hora, sg.ubicacion, sg.estado, sg.novedades
from seguimiento sg
join envios e on sg.id_envio=e.id_envio
join clientes c on e.id_cliente=c.id_cliente
join rutas r on e.id_ruta=r.id_ruta
where e.codigo='env-2024-001' order by sg.fecha_hora;
--ciudades origen con mayor volumen de envios usando FILTER
select ci.nombre as ciudad_origen,
count(*) as total_envios,
count(*) filter(where e.estado='entregado') as entregados,
count(*) filter(where e.estado='en transito') as en_transito,
count(*) filter(where e.estado='devuelto') as devueltos,
sum (e.valor_flete) as ingresos_totales
from envios e join rutas r on e.id_ruta=r.id_ruta
join ciudades ci on r.origen=ci.id_ciudad
group by ci.nombre order by total_envios desc;