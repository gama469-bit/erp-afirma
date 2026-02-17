-- Agregar columna updated_at a employee_vacations si no existe
ALTER TABLE employee_vacations ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
