# 🚛 Sistema de Gestión de Flota y Distribución — TransAndina S.A.S

Proyecto de base de datos relacional construido con **PostgreSQL** que simula el sistema de gestión de distribución de mercancía a nivel nacional de la empresa **TransAndina S.A.S**. Incluye control de flota, conductores, clientes corporativos, centros de distribución, contratos, pagos e incidentes.

---

## 📁 Estructura del repositorio

```
transandina_db/
│
├── transandina_db.sql     # Script principal (tablas, datos y preguntas)
└── README.md              # Documentación del proyecto
```

---

## 🗂️ Diagrama de tablas

```
ciudades
   │
   ├──── centros ────── conductores ────── envios
   │         │                               │
   │      vehiculos ──────────────────────── │
   │                                         │
   └──── clientes ─────────────────────────  │
                                             │
            rutas ──────────────────────────┘
                                             │
          contratos ────────────────────────┘
                                             │
                                    ┌────────┴─────────┐
                                    │                  │
                            detalles_envio          pagos
                                    │
                                incidentes
```

### Relaciones principales

| Tabla            | Se relaciona con                                  |
|------------------|---------------------------------------------------|
| `ciudades`       | `centros`, `clientes`, `rutas`                    |
| `centros`        | `conductores`, `vehiculos`, `envios`              |
| `clientes`       | `contratos`, `envios`                             |
| `conductores`    | `envios`, `incidentes`                            |
| `vehiculos`      | `envios`, `incidentes`                            |
| `rutas`          | `envios`                                          |
| `contratos`      | `envios`                                          |
| `envios`         | `detalles_envio`, `pagos`, `incidentes`           |

---

## 🏗️ Tablas del sistema

| Tabla            | Descripción                                                   |
|------------------|---------------------------------------------------------------|
| `ciudades`       | Ciudades donde opera la empresa con su zona geográfica        |
| `centros`        | Centros de distribución con capacidad en m³                   |
| `clientes`       | Empresas clientes con sector económico                        |
| `conductores`    | Conductores con tipo de licencia y salario                    |
| `vehiculos`      | Flota de transporte con capacidad, consumo y kilometraje      |
| `rutas`          | Rutas entre ciudades con distancia, tiempo y costos de peajes |
| `contratos`      | Contratos con clientes (mensual, anual, por envío)            |
| `envios`         | Registro central de envíos con tipo de carga y valores        |
| `detalles_envio` | Historial de seguimiento de cada envío                        |
| `pagos`          | Registro de pagos por envío con método y estado               |
| `incidentes`     | Accidentes, averías y novedades durante los envíos            |

---

## ▶️ Cómo usar este proyecto

1. Tener instalado **PostgreSQL** y **pgAdmin**
2. Crear una base de datos nueva:
```sql
CREATE DATABASE transandina;
```
3. Conectarse a la base de datos y ejecutar el archivo:
```
transandina_db.sql
```
4. Responder las 25 preguntas de práctica

---

## ❓ 25 Preguntas de práctica

### 🟢 Nivel básico

- **P01** Lista todos los conductores activos con su licencia y centro asignado.
- **P02** Muestra todos los vehículos disponibles ordenados de mayor a menor capacidad en toneladas.
- **P03** Lista los clientes del sector farmacéutico con su email y ciudad.
- **P04** Muestra todos los envíos entregados en febrero de 2024 con su valor de flete.
- **P05** Lista las rutas que tienen más de 5 peajes ordenadas por costo de peajes de mayor a menor.
- **P06** Muestra los contratos activos con su cliente y valor mensual.
- **P07** Lista todos los pagos vencidos con el valor y método de pago.
- **P08** Muestra los vehículos con kilometraje mayor a 200,000 km.

### 🟡 Nivel intermedio

- **P09** Muestra el total de envíos y el valor total de fletes por estado de envío.
- **P10** Lista los conductores con la cantidad de envíos que han realizado, ordenados de mayor a menor. Incluye los que no tienen envíos.
- **P11** Muestra los clientes con más de 2 envíos realizados y el valor total que han pagado en fletes.
- **P12** Calcula el promedio, mínimo y máximo de peso por tipo de carga.
- **P13** Muestra las rutas más utilizadas con su distancia y cuántas veces se han usado.
- **P14** Lista los centros de distribución con la cantidad de vehículos y conductores asignados a cada uno.
- **P15** Muestra los envíos de carga peligrosa con el nombre del conductor, vehículo y ruta utilizada.
- **P16** Calcula el total recaudado por método de pago solo para pagos completados.
- **P17** Lista los envíos que llegaron tarde con el cliente y días de retraso.

### 🔴 Nivel avanzado

- **P18** Muestra el conductor que ha transportado el mayor valor en carga usando una subconsulta.
- **P19** Lista los clientes cuyo valor de flete promedio está por encima del promedio general.
- **P20** Muestra por ciudad de origen: total de envíos, entregados, en tránsito, devueltos y siniestros usando FILTER.
- **P21** Muestra el rendimiento de cada centro de distribución con envíos, ingresos y promedio de peso.
- **P22** Lista los vehículos que han estado en algún incidente con tipo y costo estimado.
- **P23** Muestra los contratos anuales activos con el cliente, valor mensual y cuántos envíos han generado.
- **P24** Calcula el ingreso total por sector de cliente incluyendo solo envíos entregados.
- **P25** Muestra el historial completo del envío ENV-023 uniendo detalles de seguimiento e incidentes.

---

## 🧠 Conceptos cubiertos

| Concepto              | Dónde se aplica                                     |
|-----------------------|-----------------------------------------------------|
| `CREATE TABLE`        | 11 tablas del sistema                               |
| `CHECK`               | Validación de estados, tipos, licencias y emails    |
| `DEFAULT`             | Valores por defecto en fechas, estados y booleanos  |
| `NOT NULL`            | Campos obligatorios en todas las tablas             |
| `REFERENCES`          | Claves foráneas entre todas las tablas              |
| `INSERT INTO`         | Carga de datos reales de prueba                     |
| `SELECT`              | Todas las consultas                                 |
| `WHERE`               | Filtros en consultas básicas                        |
| `ORDER BY`            | Ordenamiento de resultados                          |
| `JOIN`                | Unión de múltiples tablas                           |
| `LEFT JOIN`           | Conductores sin envíos en P10 y P14                 |
| `GROUP BY`            | Agrupación por estado, ciudad, conductor            |
| `HAVING`              | Filtrar grupos en P11                               |
| `FILTER`              | Conteos condicionales por estado en P20             |
| `Subconsultas`        | Conductor con mayor carga en P18 y P19              |
| `BETWEEN`             | Filtros de fechas en P04                            |
| Funciones agregadas   | `count`, `sum`, `avg`, `max`, `min`                 |

---

## 👨‍💻 Autor

**Sebastian Montoya**
Estudiante de PostgreSQL — Proyecto 2 de práctica avanzada.
