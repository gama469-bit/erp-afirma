// Script para agregar campos adicionales a la tabla projects
const { Pool } = require('pg');

const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'BD_afirma',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || 'password'
});

async function addProjectFields() {
    const client = await pool.connect();
    
    try {
        console.log('🔧 Agregando campos a la tabla projects...');
        
        // Verificar si las columnas ya existen
        const checkColumns = await client.query(`
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_name = 'projects' 
            AND column_name IN ('project_manager', 'project_leader', 'cbt_responsible', 'user_assigned')
        `);
        
        const existingColumns = checkColumns.rows.map(row => row.column_name);
        console.log('📋 Columnas existentes:', existingColumns);
        
        // Agregar columnas que no existen
        const columnsToAdd = [
            { name: 'project_manager', type: 'TEXT', description: 'Responsable de Proyecto' },
            { name: 'project_leader', type: 'TEXT', description: 'Líder de Proyecto' },
            { name: 'cbt_responsible', type: 'TEXT', description: 'CBT Responsable' },
            { name: 'user_assigned', type: 'TEXT', description: 'Usuario' }
        ];
        
        for (const column of columnsToAdd) {
            if (!existingColumns.includes(column.name)) {
                console.log(`➕ Agregando columna ${column.name} (${column.description})...`);
                await client.query(`
                    ALTER TABLE projects 
                    ADD COLUMN ${column.name} ${column.type}
                `);
                console.log(`✅ Columna ${column.name} agregada exitosamente`);
            } else {
                console.log(`⏭️  Columna ${column.name} ya existe, omitiendo...`);
            }
        }
        
        // Verificar la estructura final
        const finalStructure = await client.query(`
            SELECT column_name, data_type 
            FROM information_schema.columns 
            WHERE table_name = 'projects' 
            ORDER BY ordinal_position
        `);
        
        console.log('\n📊 Estructura final de la tabla projects:');
        finalStructure.rows.forEach(col => {
            console.log(`   - ${col.column_name}: ${col.data_type}`);
        });
        
        console.log('\n✅ ¡Proceso completado exitosamente!');
        
    } catch (err) {
        console.error('❌ Error al agregar campos:', err);
        throw err;
    } finally {
        client.release();
        await pool.end();
    }
}

addProjectFields().catch(console.error);
