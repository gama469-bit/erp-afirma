const db = require('./server/db');

async function checkAndCreateTable() {
    try {
        // Check if table exists
        const checkResult = await db.query(`
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_name = 'orders_of_work'
            );
        `);
        
        const exists = checkResult.rows[0].exists;
        console.log(`✅ Tabla orders_of_work existe: ${exists}`);
        
        if (!exists) {
            console.log('📋 Creando tabla orders_of_work...');
            
            // Create table
            await db.query(`
                CREATE TABLE orders_of_work (
                    id SERIAL PRIMARY KEY,
                    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
                    ot_code VARCHAR(50) NOT NULL,
                    description TEXT,
                    status VARCHAR(50) DEFAULT 'Pendiente',
                    start_date DATE,
                    end_date DATE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    folio_principal_santec VARCHAR(100),
                    folio_santec VARCHAR(100),
                    nombre_proyecto VARCHAR(255),
                    tipo_servicio VARCHAR(100),
                    tecnologia VARCHAR(100),
                    aplicativo VARCHAR(100),
                    fecha_inicio_santander DATE,
                    fecha_fin_santander DATE,
                    fecha_inicio_proveedor DATE,
                    fecha_fin_proveedor DATE,
                    horas_acordadas DECIMAL(10,2),
                    semaforo_esfuerzo VARCHAR(50),
                    semaforo_plazo VARCHAR(50),
                    lider_delivery VARCHAR(255),
                    autorizacion_rdp VARCHAR(100),
                    responsable_proyecto VARCHAR(255),
                    cbt_responsable VARCHAR(255),
                    proveedor VARCHAR(255),
                    fecha_inicio_real DATE,
                    fecha_fin_real DATE,
                    fecha_entrega_proveedor DATE,
                    dias_desvio_entrega INTEGER,
                    ambiente VARCHAR(100),
                    fecha_creacion DATE,
                    fts TEXT,
                    estimacion_elab_pruebas DECIMAL(10,2),
                    costo_hora_servicio_proveedor DECIMAL(15,2),
                    monto_servicio_proveedor DECIMAL(15,2),
                    monto_servicio_proveedor_iva DECIMAL(15,2),
                    clase_coste VARCHAR(100),
                    folio_pds VARCHAR(100),
                    programa VARCHAR(255),
                    front_negocio VARCHAR(255),
                    vobo_front_negocio VARCHAR(100),
                    fecha_vobo_front_negocio DATE,
                    horas DECIMAL(10,2),
                    porcentaje_ejecucion DECIMAL(5,2)
                );
            `);
            
            console.log('✅ Tabla orders_of_work creada');
            
            // Create indexes
            await db.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_project_id ON orders_of_work(project_id);`);
            await db.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_ot_code ON orders_of_work(ot_code);`);
            await db.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_folio_principal ON orders_of_work(folio_principal_santec);`);
            await db.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_status ON orders_of_work(status);`);
            await db.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_lider_delivery ON orders_of_work(lider_delivery);`);
            await db.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_responsable_proyecto ON orders_of_work(responsable_proyecto);`);
            
            console.log('✅ Índices creados');
        } else {
            // Check columns
            const columnsResult = await db.query(`
                SELECT column_name 
                FROM information_schema.columns 
                WHERE table_name = 'orders_of_work'
                ORDER BY ordinal_position;
            `);
            
            console.log(`📊 Columnas encontradas: ${columnsResult.rows.length}`);
            
            // Check if extended columns exist
            const hasExtended = columnsResult.rows.some(r => r.column_name === 'folio_principal_santec');
            
            if (!hasExtended) {
                console.log('📋 Agregando columnas extendidas...');
                
                await db.query(`
                    ALTER TABLE orders_of_work 
                    ADD COLUMN IF NOT EXISTS folio_principal_santec VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS folio_santec VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS nombre_proyecto VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS tipo_servicio VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS tecnologia VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS aplicativo VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS fecha_inicio_santander DATE,
                    ADD COLUMN IF NOT EXISTS fecha_fin_santander DATE,
                    ADD COLUMN IF NOT EXISTS fecha_inicio_proveedor DATE,
                    ADD COLUMN IF NOT EXISTS fecha_fin_proveedor DATE,
                    ADD COLUMN IF NOT EXISTS horas_acordadas DECIMAL(10,2),
                    ADD COLUMN IF NOT EXISTS semaforo_esfuerzo VARCHAR(50),
                    ADD COLUMN IF NOT EXISTS semaforo_plazo VARCHAR(50),
                    ADD COLUMN IF NOT EXISTS lider_delivery VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS autorizacion_rdp VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS responsable_proyecto VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS cbt_responsable VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS proveedor VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS fecha_inicio_real DATE,
                    ADD COLUMN IF NOT EXISTS fecha_fin_real DATE,
                    ADD COLUMN IF NOT EXISTS fecha_entrega_proveedor DATE,
                    ADD COLUMN IF NOT EXISTS dias_desvio_entrega INTEGER,
                    ADD COLUMN IF NOT EXISTS ambiente VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS fecha_creacion DATE,
                    ADD COLUMN IF NOT EXISTS fts TEXT,
                    ADD COLUMN IF NOT EXISTS estimacion_elab_pruebas DECIMAL(10,2),
                    ADD COLUMN IF NOT EXISTS costo_hora_servicio_proveedor DECIMAL(15,2),
                    ADD COLUMN IF NOT EXISTS monto_servicio_proveedor DECIMAL(15,2),
                    ADD COLUMN IF NOT EXISTS monto_servicio_proveedor_iva DECIMAL(15,2),
                    ADD COLUMN IF NOT EXISTS clase_coste VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS folio_pds VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS programa VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS front_negocio VARCHAR(255),
                    ADD COLUMN IF NOT EXISTS vobo_front_negocio VARCHAR(100),
                    ADD COLUMN IF NOT EXISTS fecha_vobo_front_negocio DATE,
                    ADD COLUMN IF NOT EXISTS horas DECIMAL(10,2),
                    ADD COLUMN IF NOT EXISTS porcentaje_ejecucion DECIMAL(5,2);
                `);
                
                console.log('✅ Columnas extendidas agregadas');
            } else {
                console.log('✅ Columnas extendidas ya existen');
            }
        }
        
    } catch (err) {
        console.error('❌ Error:', err);
        process.exit(1);
    }
}

checkAndCreateTable().then(() => {
    console.log('✅ Verificación completada');
    process.exit(0);
});
