-- Migración 010: Actualizar employees_v2 para usar referencias a mastercode

-- Primero, eliminar la constraint actual de position_id si existe
ALTER TABLE employees_v2 DROP CONSTRAINT IF EXISTS employees_v2_position_id_fkey;
ALTER TABLE employees_v2 DROP CONSTRAINT IF EXISTS employees_v2_department_id_fkey;

-- Agregar las nuevas columnas que referencian mastercode
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS entity_id INTEGER;
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS area_id INTEGER;
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS project_id INTEGER;
ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS cell_id INTEGER;

-- Migrar datos existentes (si los hay) desde department_id a entity_id
-- Solo si department_id existe y tiene datos
DO $$
BEGIN
    -- Verificar si existe la columna department_id
    IF EXISTS (SELECT 1 FROM information_schema.columns 
               WHERE table_name = 'employees_v2' AND column_name = 'department_id') THEN
        
        -- Migrar datos de departments a entity_id usando mastercode
        UPDATE employees_v2 
        SET entity_id = (
            SELECT m.id 
            FROM mastercode m 
            WHERE m.lista = 'Entidad' 
            AND m.item = (
                SELECT d.name 
                FROM entities d 
                WHERE d.id = employees_v2.department_id
            )
            LIMIT 1
        )
        WHERE department_id IS NOT NULL;
        
        -- Mostrar resultado de la migración
        RAISE NOTICE 'Migrados % empleados con entity_id desde department_id', 
            (SELECT COUNT(*) FROM employees_v2 WHERE entity_id IS NOT NULL);
    END IF;
END $$;

-- Migrar position_id existentes para que apunten a mastercode
DO $$
DECLARE
    updated_count INTEGER := 0;
BEGIN
    -- Verificar si hay datos en position_id que necesiten migración
    IF EXISTS (SELECT 1 FROM employees_v2 WHERE position_id IS NOT NULL) THEN
        -- Crear una columna temporal para guardar los IDs antiguos
        ALTER TABLE employees_v2 ADD COLUMN IF NOT EXISTS old_position_id INTEGER;
        
        -- Guardar los IDs antiguos
        UPDATE employees_v2 SET old_position_id = position_id WHERE position_id IS NOT NULL;
        
        -- Actualizar position_id para que apunte a mastercode
        UPDATE employees_v2 
        SET position_id = (
            SELECT m.id 
            FROM mastercode m 
            WHERE m.lista = 'Puestos roles' 
            AND m.item = (
                SELECT p.name 
                FROM positions p 
                WHERE p.id = employees_v2.old_position_id
            )
            LIMIT 1
        )
        WHERE old_position_id IS NOT NULL;
        
        GET DIAGNOSTICS updated_count = ROW_COUNT;
        
        -- Limpiar NULLs donde no se encontró coincidencia
        UPDATE employees_v2 SET position_id = NULL WHERE old_position_id IS NOT NULL AND position_id IS NULL;
        
        RAISE NOTICE 'Migrados % empleados con position_id desde positions a mastercode', updated_count;
        
        -- Eliminar la columna temporal
        ALTER TABLE employees_v2 DROP COLUMN IF EXISTS old_position_id;
    END IF;
END $$;

-- Crear índices para las nuevas columnas
CREATE INDEX IF NOT EXISTS idx_employees_v2_entity_id ON employees_v2(entity_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_area_id ON employees_v2(area_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_project_id ON employees_v2(project_id);
CREATE INDEX IF NOT EXISTS idx_employees_v2_cell_id ON employees_v2(cell_id);

-- Ahora agregar las foreign keys a mastercode (sin constraints estrictos por ahora)
-- Esto permitirá que los valores puedan ser NULL o hacer referencia a mastercode
DO $$
BEGIN
    -- Agregar foreign key para position_id
    ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_position_mastercode 
        FOREIGN KEY (position_id) REFERENCES mastercode(id) ON DELETE SET NULL;
        
    -- Agregar foreign key para entity_id  
    ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_entity_mastercode 
        FOREIGN KEY (entity_id) REFERENCES mastercode(id) ON DELETE SET NULL;
        
    -- Agregar foreign key para area_id
    ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_area_mastercode 
        FOREIGN KEY (area_id) REFERENCES mastercode(id) ON DELETE SET NULL;
        
    -- Agregar foreign key para project_id
    ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_project_mastercode 
        FOREIGN KEY (project_id) REFERENCES mastercode(id) ON DELETE SET NULL;
        
    -- Agregar foreign key para cell_id
    ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_cell_mastercode 
        FOREIGN KEY (cell_id) REFERENCES mastercode(id) ON DELETE SET NULL;
EXCEPTION 
    WHEN duplicate_object THEN
        RAISE NOTICE 'Some foreign keys already exist, skipping...';
END $$;

-- Después de un tiempo, cuando esté seguro de que la migración funcionó,
-- se puede eliminar department_id con: 
-- ALTER TABLE employees_v2 DROP COLUMN IF EXISTS department_id;

COMMIT;