-- Alterar tabla para agregar employee_id y FK
ALTER TABLE employee_vacations ADD COLUMN IF NOT EXISTS employee_id INTEGER;
-- Opcional: Si employees_v2 existe y quieres FK
-- ALTER TABLE employee_vacations ADD CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employees_v2(id);
