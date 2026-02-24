-- Migración 011: Limpiar foreign key constraints duplicadas
-- Eliminar constraints viejas que apuntan a tablas individuales

-- Eliminar constraints hacia tablas viejas
ALTER TABLE employees_v2 DROP CONSTRAINT IF EXISTS employees_v2_area_id_fkey;
ALTER TABLE employees_v2 DROP CONSTRAINT IF EXISTS employees_v2_cell_id_fkey;
ALTER TABLE employees_v2 DROP CONSTRAINT IF EXISTS employees_v2_project_id_fkey;

-- Verificar que las constraints hacia mastercode estén funcionando
DO $$
BEGIN
    -- Verificar que existan las constraints hacia mastercode
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conrelid = 'employees_v2'::regclass 
        AND confrelid = 'mastercode'::regclass 
        AND conname = 'fk_employees_v2_area_mastercode'
    ) THEN
        ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_area_mastercode 
            FOREIGN KEY (area_id) REFERENCES mastercode(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conrelid = 'employees_v2'::regclass 
        AND confrelid = 'mastercode'::regclass 
        AND conname = 'fk_employees_v2_cell_mastercode'
    ) THEN
        ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_cell_mastercode 
            FOREIGN KEY (cell_id) REFERENCES mastercode(id) ON DELETE SET NULL;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conrelid = 'employees_v2'::regclass 
        AND confrelid = 'mastercode'::regclass 
        AND conname = 'fk_employees_v2_project_mastercode'
    ) THEN
        ALTER TABLE employees_v2 ADD CONSTRAINT fk_employees_v2_project_mastercode 
            FOREIGN KEY (project_id) REFERENCES mastercode(id) ON DELETE SET NULL;
    END IF;
END $$;

COMMIT;