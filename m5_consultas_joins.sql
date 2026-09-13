-- ============================================================
-- M5 - Consultas con JOINs
-- ------------------------------------------------------------
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Cruza ventas con clientes, productos y categorias para obtener
-- una fila enriquecida: fecha, cliente, ciudad, producto, categoria,
-- cantidad, precio unitario y total de venta.
-- ------------------------------------------------------------
SELECT
    v.fecha_venta      AS Fecha,
    v.id_cliente       AS ID_Cliente,
    c.ciudad           AS Ciudad_Cliente,
    p.nombre_producto  AS Producto,
    cat.nombre_categoria AS Categoria,
    v.cantidad         AS Cantidad,
    v.precio_unitario  AS Precio_Unitario,
    (v.cantidad * v.precio_unitario) AS Total_Venta
FROM ventas v
INNER JOIN clientes c   ON v.id_cliente = c.id_cliente
INNER JOIN productos p  ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta;


-- ------------------------------------------------------------
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Clientes registrados que todavía no hicieron ninguna compra
-- ------------------------------------------------------------
SELECT
    c.nombre         AS Nombre,
    c.email          AS Email,
    c.fecha_registro AS Fecha_Registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;


-- ------------------------------------------------------------
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Productos del catálogo que no tienen ninguna venta registrada
-- ------------------------------------------------------------
SELECT
    p.nombre_producto    AS Producto,
    cat.nombre_categoria AS Categoria,
    p.precio             AS Precio
FROM productos p
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v        ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;


-- ------------------------------------------------------------
-- Consulta 4: Consolidado por canal (UNION ALL)
-- La columna "canal" no existe en las tablas: se crea como valor
-- literal en cada SELECT. Se separan las ventas por período
-- (primera vs segunda quincena de marzo, único mes disponible
-- en los datos de muestra) y se totaliza por canal.
-- ------------------------------------------------------------
WITH ventas_canal AS (
    SELECT
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Primera Quincena' AS canal
    FROM ventas
    WHERE fecha_venta < '2024-03-10'

    UNION ALL

    SELECT
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Segunda Quincena' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-10'
)
SELECT
    canal,
    SUM(total) AS Total_Facturado
FROM ventas_canal
GROUP BY canal;