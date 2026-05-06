--questions
-- P01: Lista todos los conductores activos con su licencia y centro asignado.
select nombre, cedula, licencia from conductores where activo=true;
-- P02: Muestra todos los vehículos disponibles ordenados de mayor a menor capacidad en toneladas.
select placa, marca,capacidad_ton from vehiculos where estado='disponible' order by capacidad_ton desc;
-- P03: Lista los clientes del sector farmacéutico con su email y ciudad.
select cl.razon_social, cl.id_cliente as codigo_cliente, cl.email, ci.nombre from clientes cl join ciudades ci on cl._ciudad=ci.id_ciudad where cl.sector='faramaceutico';
-- P04: Muestra todos los envíos entregados en febrero de 2024 con su valor de flete.
select codigo, valor_flete, estado, fecha_entrega from envios where estado='entregado' and fecha_entrega between '01-02-2024' and '29-02-2024';
-- P05: Lista las rutas que tienen más de 5 peajes ordenadas por costo de peajes de mayor a menor.
select nombre, peajes, costo_peajes from rutas where peajes>5 order by costo_peajes desc;
-- P06: Muestra los contratos activos con su cliente y valor mensual.
select co.id_contrato, co.estado, co.valor_mensual, cl.razon_social from clientes cl join contratos co on cl.id_cliente=co.id_cliente where co.estado='activo';
-- P07: Lista todos los pagos vencidos con el valor y método de pago.
select id_pago, estado, valor, metodo from pagos where estado='vencido';
-- P08: Muestra los vehículos con kilometraje mayor a 200,000 km.
select * from vehiculos where kilometraje>200000 order by kilometraje desc;
-- -------------------------------------------------------
-- NIVEL INTERMEDIO
-- -------------------------------------------------------

-- P09: Muestra el total de envíos y el valor total de fletes por estado de envío.
select  estado, count(*) as total_envios, sum(valor_flete) as valor_fletes from envios group by estado;
-- P10: Lista los conductores con la cantidad de envíos que han realizado,
--      ordenados de mayor a menor. Incluye los que no tienen envíos.
select co.nombre, count(e.id_envio) as total_envios from conductores co join envios e on co.id_conductor=e.id_conductor group by co.nombre order by total_envios desc;
-- P11: Muestra los clientes con más de 2 envíos realizados
--      y el valor total que han pagado en fletes.
select c.razon_social,
sum(e.valor_flete) as valor_fletes, 
count (e.id_envio) as total_envios
from envios e join clientes c  on c.id_cliente=e.id_cliente 
group by c.razon_social 
having count(e.id_envio)>2 order by total_envios desc;
-- P12: Calcula el promedio, mínimo y máximo de peso por tipo de carga.
select tipo_carga, avg(peso_ton) as promedio, min(peso_ton) as peso_minimo, max(peso_ton) as peso_maximo from envios group by tipo_carga;
-- P13: Muestra las rutas más utilizadas con su distancia y cuántas veces se han usado.
select r.nombre, count (e.id_ruta) as veces_uso, r.distancia_km from rutas r join envios e on e.id_ruta=r.id_ruta group by r.nombre, r.distancia_km order by veces_uso limit 1;
-- P14: Lista los centros de distribución con la cantidad de vehículos
--      y conductores asignados a cada uno.
select ce.nombre, count(v.id_vehiculo) as cantidad_vehiculos, count(co.id_conductor) as conductores from conductores co join vehiculos v join centros ce on ce.id_centro=v.id_centro on v.id_centro=co.id_centro group by ce.nombre;
-- P15: Muestra los envíos de carga peligrosa con el nombre del conductor,
--      vehículo y ruta utilizada.
select e.id_envio, r.nombre, c.nombre, v.placa 
from envios e join rutas r on e.id_ruta=r.id_ruta
join conductores c on e.id_conductor=c.id_conductor
join vehiculos v on e.id_vehiculo=v.id_vehiculo 
where e.tipo_carga='peligrosa';
-- P16: Calcula el total recaudado por método de pago solo para pagos completados.
select sum(valor) as total_recaudo, metodo from pagos  where estado='pagado' group by metodo;
-- P17: Lista los envíos que llegaron tarde (fecha_entrega mayor a fecha_prometida)
--      con el cliente y días de retraso.
select cl.razon_social, e.id_envio, (e.fecha_entrega-e.fecha_prometida) as dias_retraso from envios e join clientes cl on e.id_cliente=cl.id_cliente where e.fecha_entrega>e.fecha_prometida;
-- -------------------------------------------------------
-- NIVEL AVANZADO
-- -------------------------------------------------------

-- P18: Muestra el conductor que ha transportado el mayor valor en carga
--      usando una subconsulta.
select c.nombre, c.cedula from conductores c where c.id_conductor=(select id_conductor from envios group by id_conductor order by sum(valor_carga) desc limit 1);
-- P19: Lista los clientes cuyo valor de flete promedio está por encima
--      del promedio general de todos los envíos.
select cl.razon_social, avg(e.valor_flete) as promedio_cliente from clientes cl
join envios e on cl.id_cliente=e.id_cliente group by cl.razon_social
having avg(e.valor_flete)>(select avg(valor_flete)from envios );
-- P20: Muestra por ciudad de origen de la ruta: total de envíos,
--      cuántos fueron entregados, en tránsito, devueltos y siniestros
--      usando FILTER.
select ci.nombre as ciudad_origen,
count (*) as total_envios,
count(*) filter(where e.estado='entregado') as entregados,
count(*) filter(where e.estado='en_transito')as en_transito,
count(*) filter(where e.estado='devuelto')as devueltos,
count(*) filter(where e.estado='siniestro')as siniestros from envios e join rutas r on e.id_ruta=r.id_ruta
join ciudades ci on r.id_origen=ci.id_ciudad group by ci.nombre order by total_envios desc;
-- P21: Muestra el rendimiento de cada centro de distribución:
--      total de envíos despachados, ingresos generados y
--      promedio de peso por envío.
select ce.nombre as centro_distribucion,
count (*) as total_envios,
sum(e.valor_flete) as ingresos,
avg(e.peso_ton) as promedio_peso
from centros ce left join envios e on ce.id_centro=e.id_centro_origen
group by ce.nombre order by total_envios desc;
-- P22: Lista los vehículos que han estado en algún incidente
--      con el tipo de incidente y costo estimado.
select v.placa, i.id_incidente, i.costo_estimado from vehiculos v join incidentes i on v.id_vehiculo=i.id_vehiculo
order by v.placa;
-- P23: Muestra los contratos anuales activos con el cliente,
--      valor mensual y cuántos envíos han generado hasta la fecha.
select co.codigo, cl.razon_social, co.id_contrato, count(e.id_envio) as total_envios
from contratos co join clientes cl on co.id_cliente=cl.id_cliente
left join envios e on co.id_contrato=e.id_contrato where co.tipo='anual' and co.estado='activo' group by co.codigo, cl.razon_social,co.id_contrato;
-- P24: Calcula el ingreso total por sector de cliente
--      (retail, farmacéutico, alimentario, etc.)
--      incluyendo solo los envíos entregados.
select cl.sector, sum(e.valor_flete) as ingresos_totales from clientes cl join envios e
on cl.id_cliente=e.id_cliente where e.estado='entregado' group by cl.sector order by ingresos_totales desc;
