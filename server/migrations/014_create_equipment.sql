-- Crear tabla de equipos
CREATE TABLE IF NOT EXISTS equipment (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    marca VARCHAR(100),
    modelo VARCHAR(100),
    serie VARCHAR(100),
    categoria VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(255),
    asignado_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
    estado VARCHAR(50) DEFAULT 'Activo',
    valor DECIMAL(10,2),
    fecha_compra DATE,
    observaciones TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para optimizar búsquedas
CREATE INDEX IF NOT EXISTS idx_equipment_codigo ON equipment(codigo);
CREATE INDEX IF NOT EXISTS idx_equipment_categoria ON equipment(categoria);
CREATE INDEX IF NOT EXISTS idx_equipment_estado ON equipment(estado);
CREATE INDEX IF NOT EXISTS idx_equipment_asignado_id ON equipment(asignado_id);

-- Trigger para actualizar updated_at
CREATE OR REPLACE FUNCTION update_equipment_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE OR REPLACE TRIGGER equipment_updated_at
    BEFORE UPDATE ON equipment
    FOR EACH ROW
    EXECUTE FUNCTION update_equipment_updated_at();