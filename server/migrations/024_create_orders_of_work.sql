-- Tabla de Órdenes de Trabajo (OT) para proyectos
CREATE TABLE IF NOT EXISTS orders_of_work (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    ot_code VARCHAR(50) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'Pendiente',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_orders_of_work_project_id ON orders_of_work(project_id);
