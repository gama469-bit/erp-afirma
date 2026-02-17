-- Agregar campos de expediente a employees_v2
-- Documentos e información personal adicional

ALTER TABLE employees_v2 
ADD COLUMN IF NOT EXISTS curp VARCHAR(18),
ADD COLUMN IF NOT EXISTS rfc VARCHAR(13),
ADD COLUMN IF NOT EXISTS nss VARCHAR(11),
ADD COLUMN IF NOT EXISTS passport VARCHAR(20),
ADD COLUMN IF NOT EXISTS gender VARCHAR(20),
ADD COLUMN IF NOT EXISTS marital_status VARCHAR(20),
ADD COLUMN IF NOT EXISTS nationality VARCHAR(50),
ADD COLUMN IF NOT EXISTS blood_type VARCHAR(5);

-- Crear índices para los nuevos campos importantes
CREATE INDEX IF NOT EXISTS idx_employees_v2_curp ON employees_v2(curp);
CREATE INDEX IF NOT EXISTS idx_employees_v2_rfc ON employees_v2(rfc);
CREATE INDEX IF NOT EXISTS idx_employees_v2_nss ON employees_v2(nss);

-- Comentarios para documentar los nuevos campos
COMMENT ON COLUMN employees_v2.curp IS 'Clave Única de Registro de Población';
COMMENT ON COLUMN employees_v2.rfc IS 'Registro Federal de Contribuyentes';
COMMENT ON COLUMN employees_v2.nss IS 'Número de Seguro Social';
COMMENT ON COLUMN employees_v2.passport IS 'Número de pasaporte';
COMMENT ON COLUMN employees_v2.gender IS 'Género del empleado';
COMMENT ON COLUMN employees_v2.marital_status IS 'Estado civil';
COMMENT ON COLUMN employees_v2.nationality IS 'Nacionalidad';
COMMENT ON COLUMN employees_v2.blood_type IS 'Tipo de sangre';