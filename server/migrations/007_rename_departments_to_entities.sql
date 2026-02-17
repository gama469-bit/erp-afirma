-- Rename departments to entities and department_id to entity_id across schema
BEGIN;

-- Rename table departments -> entities
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema='public' AND table_name='departments'
  ) AND NOT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_schema='public' AND table_name='entities'
  ) THEN
    ALTER TABLE departments RENAME TO entities;
  END IF;
END$$;

-- Rename column positions.department_id -> positions.entity_id
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema='public' AND table_name='positions' AND column_name='department_id'
  ) THEN
    ALTER TABLE positions RENAME COLUMN department_id TO entity_id;
  END IF;
END$$;

-- Rename column employees_v2.department_id -> employees_v2.entity_id
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_schema='public' AND table_name='employees_v2' AND column_name='department_id'
  ) THEN
    ALTER TABLE employees_v2 RENAME COLUMN department_id TO entity_id;
  END IF;
END$$;

-- Rename indexes if they used the old column names
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_class WHERE relname = 'idx_positions_department_id') THEN
    ALTER INDEX idx_positions_department_id RENAME TO idx_positions_entity_id;
  END IF;
  IF EXISTS (SELECT 1 FROM pg_class WHERE relname = 'idx_employees_v2_department_id') THEN
    ALTER INDEX idx_employees_v2_department_id RENAME TO idx_employees_v2_entity_id;
  END IF;
END$$;

COMMIT;
