-- Eliminar columnas duplicadas de orders_of_work que ya existen en projects
-- Ahora que tenemos la relación M:N, estas columnas son redundantes
-- IMPORTANTE: Usar CASCADE para eliminar todas las dependencias (FKs, constraints, índices)

-- 1. Eliminar project_id (ya no es FK directo, se maneja en project_ot_relations)
-- Usar CASCADE para eliminar el FK constraint automáticamente
ALTER TABLE orders_of_work DROP COLUMN IF EXISTS project_id CASCADE;

-- 2. Eliminar nombre_proyecto (redundante con projects.name)
ALTER TABLE orders_of_work DROP COLUMN IF EXISTS nombre_proyecto CASCADE;

-- 3. Eliminar responsable_proyecto (redundante con projects.project_manager)
ALTER TABLE orders_of_work DROP COLUMN IF EXISTS responsable_proyecto CASCADE;

-- 4. Eliminar cbt_responsable (redundante con projects.cbt_responsible)
ALTER TABLE orders_of_work DROP COLUMN IF EXISTS cbt_responsable CASCADE;

-- NOTA: Mantenemos lider_delivery en orders_of_work porque puede ser específico 
-- de la OT y diferente al project_leader del proyecto

COMMENT ON COLUMN orders_of_work.lider_delivery IS 'Líder de delivery específico de esta OT (puede diferir del project_leader)';
