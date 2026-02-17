-- Crear tabla mastercode unificada
CREATE TABLE IF NOT EXISTS mastercode (
    id SERIAL PRIMARY KEY,
    lista VARCHAR(50) NOT NULL,
    item VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índice para búsquedas eficientes
CREATE INDEX IF NOT EXISTS idx_mastercode_lista ON mastercode(lista);
CREATE INDEX IF NOT EXISTS idx_mastercode_lista_item ON mastercode(lista, item);

-- Migrar datos existentes de las tablas individuales (solo si existen y mastercode está vacío)
DO $$
BEGIN
    IF (SELECT COUNT(*) FROM mastercode) = 0 THEN
        -- Entidades
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'entities') THEN
            INSERT INTO mastercode (lista, item) 
            SELECT 'Entidad', name FROM entities WHERE name IS NOT NULL 
            ON CONFLICT DO NOTHING;
        END IF;
        
        -- Posiciones
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'positions') THEN
            INSERT INTO mastercode (lista, item) 
            SELECT 'Puestos roles', name FROM positions WHERE name IS NOT NULL 
            ON CONFLICT DO NOTHING;
        END IF;
        
        -- Areas (si existe la tabla)
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'areas') THEN
            INSERT INTO mastercode (lista, item) 
            SELECT 'Areas', name FROM areas WHERE name IS NOT NULL 
            ON CONFLICT DO NOTHING;
        END IF;
        
        -- Proyectos (si existe la tabla)
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'projects') THEN
            INSERT INTO mastercode (lista, item) 
            SELECT 'Proyecto', name FROM projects WHERE name IS NOT NULL 
            ON CONFLICT DO NOTHING;
        END IF;
        
        -- Células (si existe la tabla)
        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'cells') THEN
            INSERT INTO mastercode (lista, item) 
            SELECT 'Celulas', name FROM cells WHERE name IS NOT NULL 
            ON CONFLICT DO NOTHING;
        END IF;
    END IF;
END $$;

-- Poblar con datos del Excel adjunto
INSERT INTO mastercode (lista, item) VALUES
-- Entidades
('Entidad', 'AFIRMA MEX'),
('Entidad', 'ATVANTTI'),
('Entidad', 'LEITMOTIV'),
('Entidad', 'SOFTNERGYSOLUTIONS'),
('Entidad', 'TECNIVA'),

-- Puestos roles
('Puestos roles', 'Analista'),
('Puestos roles', 'Analista'),
('Puestos roles', 'Arquitecto'),
('Puestos roles', 'Auxiliar Administrativo'),
('Puestos roles', 'Business Analyst'),
('Puestos roles', 'Contador'),
('Puestos roles', 'Desarrollador .NET'),
('Puestos roles', 'Desarrollador Android'),
('Puestos roles', 'Desarrollador BI'),
('Puestos roles', 'Desarrollador COBOL'),
('Puestos roles', 'Desarrollador Java'),
('Puestos roles', 'Desarrollador Middleware'),
('Puestos roles', 'Desarrollador PHP'),
('Puestos roles', 'Desarrollador PL/SQL'),
('Puestos roles', 'Desarrollador WEB'),
('Puestos roles', 'DEVOPS UTP'),
('Puestos roles', 'Especialista DBA Oracle'),
('Puestos roles', 'Front End'),
('Puestos roles', 'Functional Lead'),
('Puestos roles', 'Gerente'),
('Puestos roles', 'Gestor de Infraestructura'),
('Puestos roles', 'Gestor de Proyectos'),
('Puestos roles', 'PMO Digital'),
('Puestos roles', 'PO Digital'),
('Puestos roles', 'PROJECT MANAGER'),
('Puestos roles', 'Reclutador'),
('Puestos roles', 'Scrum Master'),
('Puestos roles', 'SEGUROS ZURICH'),
('Puestos roles', 'Technical Lead'),
('Puestos roles', 'UX'),

-- Areas
('Areas', 'STAFF – PMO'),
('Areas', 'STAFF – RRHH'),
('Areas', 'STAFF – TI'),
('Areas', 'STAFF-FINANZAS'),
('Areas', 'OPERACIONES'),

-- Proyectos
('Proyecto', 'ADO'),
('Proyecto', 'ATVANTTI'),
('Proyecto', 'BANCA // BUSCANDO_PRO'),
('Proyecto', 'BANCA PERSONAL'),
('Proyecto', 'BANCA PRIVADA'),
('Proyecto', 'BET'),
('Proyecto', 'BOR'),
('Proyecto', 'CBT-DIGITAL'),
('Proyecto', 'DATA LAKE'),
('Proyecto', 'INTEGRACIÓN SERVICIOS'),
('Proyecto', 'INVERSIONES'),
('Proyecto', 'LYNX'),
('Proyecto', 'MIGRACION AGAVE'),
('Proyecto', 'OPICS'),
('Proyecto', 'PLAYTOPIA'),
('Proyecto', 'POSEIDON'),
('Proyecto', 'RECUPERACIONES'),
('Proyecto', 'RIESGOS'),
('Proyecto', 'RPA'),
('Proyecto', 'SEGUROS INTERNO'),
('Proyecto', 'SEGUROS ZURICH'),
('Proyecto', 'STAFF')

ON CONFLICT DO NOTHING;

-- Actualizar timestamp en cambios
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_mastercode_updated_at BEFORE UPDATE
    ON mastercode FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();