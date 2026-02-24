-- Actualizar tabla equipment para usar employees_v2
-- Primero eliminar la foreign key existente
DO $$
BEGIN
    -- Verificar si existe la constraint y eliminarla
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_name = 'equipment_asignado_id_fkey' 
        AND table_name = 'equipment'
    ) THEN
        ALTER TABLE equipment DROP CONSTRAINT equipment_asignado_id_fkey;
    END IF;
END $$;

-- Actualizar la foreign key para referenciar employees_v2
ALTER TABLE equipment 
ADD CONSTRAINT equipment_asignado_id_fkey 
FOREIGN KEY (asignado_id) REFERENCES employees_v2(id) ON DELETE SET NULL;

-- Opcional: Si existe data en equipment que referencia employees antiguos,
-- podríamos actualizar los IDs, pero como estamos empezando probablemente no hay data

-- Comentario: La tabla equipment ahora referencia correctamente employees_v2