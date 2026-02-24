-- Tabla para solicitudes de vacaciones de empleados
CREATE TABLE IF NOT EXISTS employee_vacations (
    id SERIAL PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'Pendiente',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
