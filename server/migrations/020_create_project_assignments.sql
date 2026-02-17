CREATE TABLE IF NOT EXISTS project_assignments (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    employee_id INTEGER NOT NULL REFERENCES employees_v2(id) ON DELETE CASCADE,
    role VARCHAR(100),
    start_date DATE,
    end_date DATE,
    hours_allocated NUMERIC(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
