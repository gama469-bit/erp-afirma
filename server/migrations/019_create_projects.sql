CREATE TABLE IF NOT EXISTS projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    area_id INTEGER REFERENCES mastercode(id) ON DELETE SET NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50) DEFAULT 'Planificación',
    manager_id INTEGER REFERENCES employees_v2(id) ON DELETE SET NULL,
    project_manager VARCHAR(255),
    project_leader VARCHAR(255),
    cbt_responsible VARCHAR(255),
    user_assigned VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
