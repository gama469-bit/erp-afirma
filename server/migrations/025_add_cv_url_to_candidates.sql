-- Migración: Agregar campo cv_url a la tabla candidates
-- Agregamos una columna cv_url para almacenar la URL del CV del candidato

ALTER TABLE candidates 
ADD COLUMN IF NOT EXISTS cv_url TEXT DEFAULT NULL;

-- Agregar índice para búsquedas más eficientes
CREATE INDEX IF NOT EXISTS idx_candidates_cv_url ON candidates(cv_url);
