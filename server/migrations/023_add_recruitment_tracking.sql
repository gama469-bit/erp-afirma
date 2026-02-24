-- Migración: Agregar campos de tracking de reclutamiento a candidatos
-- Agregamos:
-- 1. recruited_by: VARCHAR - quién reclutó al candidato
-- 2. hired_date: DATE - fecha en que fue contratado

ALTER TABLE candidates 
ADD COLUMN IF NOT EXISTS recruited_by VARCHAR(255) DEFAULT NULL;

ALTER TABLE candidates 
ADD COLUMN IF NOT EXISTS hired_date DATE DEFAULT NULL;

-- Agregar índices para mejorar búsquedas
CREATE INDEX IF NOT EXISTS idx_candidates_status ON candidates(status);
CREATE INDEX IF NOT EXISTS idx_candidates_recruited_by ON candidates(recruited_by);
CREATE INDEX IF NOT EXISTS idx_candidates_hired_date ON candidates(hired_date);
