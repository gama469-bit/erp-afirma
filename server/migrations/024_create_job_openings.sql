-- Migración: Crear tabla de vacantes/ofertas de empleo
-- Estructura con dos secciones: Datos para envío y Perfil

CREATE TABLE IF NOT EXISTS job_openings (
    id SERIAL PRIMARY KEY,
    
    -- Sección 1: Datos para envío
    company VARCHAR(255) NOT NULL,
    contact_person_name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    cell_area VARCHAR(255),
    office_location VARCHAR(255),
    work_modality VARCHAR(100),
    salary NUMERIC(10, 2),
    
    -- Sección 2: Perfil
    position_name VARCHAR(255) NOT NULL,
    role VARCHAR(255),
    years_experience VARCHAR(100),
    technical_tools TEXT,
    basic_knowledge TEXT,
    desirable_code VARCHAR(255),
    
    -- Metadatos
    status VARCHAR(50) DEFAULT 'Activa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    CONSTRAINT valid_status CHECK (status IN ('Activa', 'Inactiva', 'Cubierta', 'Cancelada','Deleted'))
);

-- Crear índices para mejorar búsquedas
CREATE INDEX IF NOT EXISTS idx_job_openings_status ON job_openings(status);
CREATE INDEX IF NOT EXISTS idx_job_openings_company ON job_openings(company);
CREATE INDEX IF NOT EXISTS idx_job_openings_position ON job_openings(position_name);
CREATE INDEX IF NOT EXISTS idx_job_openings_created_at ON job_openings(created_at);
