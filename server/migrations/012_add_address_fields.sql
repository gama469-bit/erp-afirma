-- Agregar campos adicionales de dirección a employees_v2
-- Número exterior, número interior y colonia

ALTER TABLE employees_v2 
ADD COLUMN IF NOT EXISTS exterior_number VARCHAR(10),
ADD COLUMN IF NOT EXISTS interior_number VARCHAR(10),
ADD COLUMN IF NOT EXISTS colonia VARCHAR(100);

-- Crear índices para los nuevos campos
CREATE INDEX IF NOT EXISTS idx_employees_v2_colonia ON employees_v2(colonia);

-- Comentarios para documentar los nuevos campos
COMMENT ON COLUMN employees_v2.exterior_number IS 'Número exterior del domicilio';
COMMENT ON COLUMN employees_v2.interior_number IS 'Número interior del domicilio (apartamento, depto, etc.)';
COMMENT ON COLUMN employees_v2.colonia IS 'Colonia, barrio o fraccionamiento';