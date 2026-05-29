CREATE OR REPLACE VIEW platillo_mas_vendido AS 
SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.disponibilidad, p.receta, SUM(d.cant_prod) AS total_vendido
FROM producto p
JOIN detalle_orden d ON p.id_producto = d.id_producto
WHERE p.tipo_producto = 'PLATILLO'
GROUP BY p.id_producto, p.nombre, p.descripcion, p.precio, p.disponibilidad, p.receta
ORDER BY total_vendido DESC
LIMIT 1;

CREATE OR REPLACE VIEW vista_sim_fac AS 
SELECT o.id_fatura, o.folio, o.fecha_emision, o.rfc