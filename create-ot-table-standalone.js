const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'BD_afirma',
    password: 'password',
    port: 5432
});

async function createTable() {
    console.log('📋 Creando tabla orders_of_work...');
    
    const client = await pool.connect();
    try {
        await client.query(`
            CREATE TABLE IF NOT EXISTS orders_of_work (
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
        
        await client.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_project_id ON orders_of_work(project_id);`);
        await client.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_ot_code ON orders_of_work(ot_code);`);
        await client.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_folio_principal ON orders_of_work(folio_principal_santec);`);
        await client.query(`CREATE INDEX IF NOT EXISTS idx_orders_of_work_status ON orders_of_work(status);`);
        
        console.log('✅ Índices creados');
        console.log('✅ Todo completado exitosamente');
        
    } catch (err) {
        if (err.message && err.message.includes('ya existe')) {
            console.log('✅ La tabla ya existe');
        } else {
            console.error('❌ Error:', err.message);
            throw err;
        }
    } finally {
        client.release();
        await pool.end();
    }
}

createTable()
    .then(() => process.exit(0))
    .catch(err => {
        console.error('Error fatal:', err);
        process.exit(1);
    });
