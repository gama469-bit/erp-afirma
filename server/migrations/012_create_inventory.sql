-- Crear tabla de inventario de equipos
CREATE TABLE IF NOT EXISTS inventory (
    id SERIAL PRIMARY KEY,
    equipment_type VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    model VARCHAR(100),
    serial_number VARCHAR(100) UNIQUE,
    asset_tag VARCHAR(50) UNIQUE,
    status VARCHAR(50) DEFAULT 'active',
    location VARCHAR(200),
    assigned_to INTEGER REFERENCES employees_v2(id),
    purchase_date DATE,
    purchase_price DECIMAL(10,2),
    warranty_expiry DATE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar algunos datos de ejemplo (solo si la tabla está vacía)
INSERT INTO inventory (equipment_type, brand, model, serial_number, asset_tag, status, location, purchase_date, purchase_price, warranty_expiry, description)
SELECT * FROM (VALUES 
    ('Laptop', 'Dell', 'Latitude 7420', 'DL123456789', 'IT-001', 'active', 'Oficina Central', '2023-01-15'::DATE, 1200.00, '2026-01-15'::DATE, 'Laptop para desarrollo'),
    ('Monitor', 'Samsung', '24" LED', 'SM987654321', 'IT-002', 'active', 'Oficina Central', '2023-02-20'::DATE, 300.00, '2025-02-20'::DATE, 'Monitor secundario'),
    ('Mouse', 'Logitech', 'MX Master 3', 'LG456789123', 'IT-003', 'active', 'Oficina Central', '2023-03-10'::DATE, 80.00, '2024-03-10'::DATE, 'Mouse inalámbrico'),
    ('Teclado', 'Logitech', 'K380', 'LG789123456', 'IT-004', 'maintenance', 'Almacén TI', '2023-01-25'::DATE, 45.00, '2024-01-25'::DATE, 'Teclado bluetooth en mantenimiento'),
    ('Impresora', 'HP', 'LaserJet Pro', 'HP321654987', 'IT-005', 'active', 'Área Administrativa', '2022-11-30'::DATE, 250.00, '2024-11-30'::DATE, 'Impresora láser compartida')
) AS v(equipment_type, brand, model, serial_number, asset_tag, status, location, purchase_date, purchase_price, warranty_expiry, description)
WHERE NOT EXISTS (SELECT 1 FROM inventory LIMIT 1)
ON CONFLICT (serial_number) DO NOTHING;

-- Crear índices para mejor rendimiento
CREATE INDEX IF NOT EXISTS idx_inventory_equipment_type ON inventory(equipment_type);
CREATE INDEX IF NOT EXISTS idx_inventory_status ON inventory(status);
CREATE INDEX IF NOT EXISTS idx_inventory_assigned_to ON inventory(assigned_to);
CREATE INDEX IF NOT EXISTS idx_inventory_asset_tag ON inventory(asset_tag);