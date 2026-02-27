-- Agregar campo COSTO a la tabla orders_of_work
-- Migración 032: Costo individual de cada orden de trabajo

-- 1. Agregar columna costo_ot
ALTER TABLE orders_of_work ADD COLUMN IF NOT EXISTS costo_ot NUMERIC(15, 2);

-- 2. Índice para optimizar sumas por proyecto
CREATE INDEX IF NOT EXISTS idx_orders_of_work_costo ON orders_of_work(costo_ot) WHERE costo_ot IS NOT NULL;

-- 3. Comentario para documentación
COMMENT ON COLUMN orders_of_work.costo_ot IS 'Costo individual de la orden de trabajo';
