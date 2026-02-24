-- Migration 023: Create Authentication Tables
-- Date: 2026-02-05
-- Description: Create users and roles tables for authentication and authorization

-- Create roles table
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    permissions JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL,
    employee_id INTEGER REFERENCES employees_v2(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'Activo' CHECK (status IN ('Activo', 'Inactivo', 'Suspendido')),
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_employee_id ON users(employee_id);

-- Insert default roles
INSERT INTO roles (name, description, permissions) VALUES
('Administrador', 'Acceso total al sistema', '{"employees": ["create", "read", "update", "delete"], "projects": ["create", "read", "update", "delete"], "assignments": ["create", "read", "update", "delete"], "reports": ["read"], "users": ["create", "read", "update", "delete"], "settings": ["read", "update"]}'),
('PMO', 'Project Management Office - Gestión de proyectos y asignaciones', '{"employees": ["read"], "projects": ["create", "read", "update", "delete"], "assignments": ["create", "read", "update", "delete"], "reports": ["read"]}'),
('RH', 'Recursos Humanos - Gestión de empleados', '{"employees": ["create", "read", "update", "delete"], "projects": ["read"], "assignments": ["read"], "reports": ["read"]}'),
('Consulta', 'Solo lectura del sistema', '{"employees": ["read"], "projects": ["read"], "assignments": ["read"], "reports": ["read"]}');

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON roles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Add comment
COMMENT ON TABLE users IS 'System users with authentication credentials';
COMMENT ON TABLE roles IS 'User roles and permissions';
