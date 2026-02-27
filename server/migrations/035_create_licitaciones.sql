-- Migración 035: Crear tabla de licitaciones
-- Gestión de solicitudes de licitaciones vinculadas a células y proyectos

CREATE TABLE IF NOT EXISTS licitaciones (
    id SERIAL PRIMARY KEY,
    
    -- Información básica
    nombre VARCHAR(255) NOT NULL,
    nombre_proyecto VARCHAR(255) NOT NULL,
    clientes TEXT,
    responsable_negocio VARCHAR(255),
    
    -- Relación con célula
    celula_id INTEGER REFERENCES mastercode(id) ON DELETE SET NULL,
    
    -- Estado de la licitación
    estado VARCHAR(50) DEFAULT 'Solicitado',
    
    -- Metadatos
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(255),
    updated_by VARCHAR(255),
    
    -- Constraint para validar estados
    CONSTRAINT valid_licitacion_estado CHECK (estado IN ('Solicitado', 'En Progreso', 'Adquirida', 'No Ganada'))
);

-- Índices para optimizar búsquedas
CREATE INDEX IF NOT EXISTS idx_licitaciones_celula_id ON licitaciones(celula_id);
CREATE INDEX IF NOT EXISTS idx_licitaciones_estado ON licitaciones(estado);
CREATE INDEX IF NOT EXISTS idx_licitaciones_created_at ON licitaciones(created_at);
CREATE INDEX IF NOT EXISTS idx_licitaciones_nombre ON licitaciones(nombre);

-- Comentarios para documentación
COMMENT ON TABLE licitaciones IS 'Tabla para gestión de solicitudes de licitaciones y propuestas comerciales';
COMMENT ON COLUMN licitaciones.celula_id IS 'Referencia a la célula organizacional responsable';
COMMENT ON COLUMN licitaciones.estado IS 'Estado del proceso: Solicitado, En Progreso, Adquirida, No Ganada';
