-- Actualizar todas las OTs que tienen costo_ot NULL a 0
UPDATE orders_of_work 
SET costo_ot = 0 
WHERE costo_ot IS NULL;

-- Verificar el resultado
SELECT COUNT(*) as total_ots, 
       SUM(CASE WHEN costo_ot IS NULL THEN 1 ELSE 0 END) as nulls,
       SUM(CASE WHEN costo_ot = 0 THEN 1 ELSE 0 END) as zeros,
       SUM(CASE WHEN costo_ot > 0 THEN 1 ELSE 0 END) as with_cost
FROM orders_of_work;
