const db = require('./server/db.js');

async function dropObsoleteEmployeesTable() {
    try {
        console.log('🗑️ ELIMINANDO TABLA OBSOLETA "employees"');
        console.log('=' .repeat(50));
        
        // Primero verificar qué hay en la tabla
        console.log('📊 Verificando contenido de la tabla obsoleta...');
        try {
            const count = await db.query('SELECT COUNT(*) FROM employees');
            const sample = await db.query('SELECT * FROM employees LIMIT 3');
            
            console.log(`📋 La tabla "employees" tiene ${count.rows[0].count} registros`);
            if (sample.rows.length > 0) {
                console.log('📄 Muestra de registros:');
                sample.rows.forEach((row, i) => {
                    console.log(`  ${i+1}. ${row.first_name} ${row.last_name} (${row.email})`);
                });
            }
        } catch (err) {
            console.log('❌ No se pudo acceder a la tabla employees:', err.message);
            return;
        }
        
        // Confirmar eliminación
        console.log('\n⚠️  IMPORTANTE: Esta tabla será eliminada permanentemente');
        console.log('   Los datos están migrados a "employees_v2"');
        console.log('   Esta operación NO se puede deshacer');
        
        // Eliminar la tabla
        console.log('\n🗑️ Eliminando tabla "employees"...');
        
        await db.query('DROP TABLE IF EXISTS employees CASCADE');
        console.log('✅ Tabla "employees" eliminada exitosamente');
        
        // Verificar que se eliminó
        console.log('\n🔍 Verificando eliminación...');
        const tablesAfter = await db.query(`
            SELECT tablename 
            FROM pg_tables 
            WHERE schemaname = 'public' 
            AND tablename LIKE '%employee%'
        `);
        
        console.log('📋 Tablas restantes relacionadas con employees:');
        tablesAfter.rows.forEach(row => {
            console.log('  -', row.tablename);
        });
        
        console.log('\n🎉 ¡LIMPIEZA COMPLETADA EXITOSAMENTE!');
        console.log('✅ La tabla obsoleta "employees" ha sido eliminada');
        console.log('✅ Solo queda "employees_v2" (la tabla activa)');
        
        process.exit(0);
    } catch (error) {
        console.error('💥 Error durante la eliminación:', error.message);
        process.exit(1);
    }
}

setTimeout(dropObsoleteEmployeesTable, 1000);