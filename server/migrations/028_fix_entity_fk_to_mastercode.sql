-- Migration: Change entity_id FK from entities to mastercode
-- Date: 2026-02-18
-- Description: Fix entity_id FK to use mastercode instead of entities table
--              This makes it consistent with other catalog fields (area_id, position_id, etc.)
--              which all use mastercode as the single source of truth.
--
-- Problem:
--   - employees_v2 has 4 FKs to mastercode (area, cell, position, project)
--   - employees_v2 has 1 FK to entities (entity) <- INCONSISTENT
--   - Form loads from mastercode but FK validates against entities
--
-- Solution: Change FK to point to mastercode for consistency

-- Step 1: Sync entities data to mastercode (safety check)
INSERT INTO mastercode (id, lista, item)
SELECT id, 'Entidad', name
FROM entities
WHERE id NOT IN (SELECT id FROM mastercode WHERE lista = 'Entidad')
ON CONFLICT (id) DO NOTHING;

-- Step 2: Remove old FK constraint to entities table (employees_v2)
ALTER TABLE employees_v2 
DROP CONSTRAINT IF EXISTS employees_v2_entity_id_fkey;

-- Step 3: Add proper FK constraint to mastercode (employees_v2)
ALTER TABLE employees_v2
ADD CONSTRAINT fk_employees_v2_entity_mastercode 
FOREIGN KEY (entity_id) 
REFERENCES mastercode(id) 
ON DELETE SET NULL;

-- Step 4: Update positions table for consistency
ALTER TABLE positions
DROP CONSTRAINT IF EXISTS positions_department_id_fkey;

ALTER TABLE positions
ADD CONSTRAINT fk_positions_entity_mastercode
FOREIGN KEY (entity_id)
REFERENCES mastercode(id)
ON DELETE SET NULL;

-- Verification
DO $$
BEGIN
    RAISE NOTICE '═══════════════════════════════════════════════════════════';
    RAISE NOTICE '✅ Migration 028 complete';
    RAISE NOTICE '═══════════════════════════════════════════════════════════';
    RAISE NOTICE 'Changes:';
    RAISE NOTICE '  • employees_v2.entity_id → mastercode(id)';
    RAISE NOTICE '  • positions.entity_id → mastercode(id)';
    RAISE NOTICE '  • Now consistent with area_id, cell_id, position_id, project_id';
    RAISE NOTICE '═══════════════════════════════════════════════════════════';
END $$;
