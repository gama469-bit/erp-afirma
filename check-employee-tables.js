const db = require('./server/db.js');

async function checkEmployeeTables() {
    try {
        console.log('🔍 Verificando tablas de employees...');
        
        // Verificar qué tablas existen
        const tables = await db.query(`
            SELECT tablename 
            FROM pg_tables 
            WHERE schemaname = 'public' 
            AND tablename LIKE '%employee%'
        `);
        
        console.log('📋 Tablas encontradas:');
        tables.rows.forEach(row => {
            console.log('  -', row.tablename);
        });
        
        // Verificar si la tabla employees (sin _v2) tiene datos
        try {
            const employeesCount = await db.query('SELECT COUNT(*) FROM employees');
            console.log(`\n📊 Registros en tabla "employees": ${employeesCount.rows[0].count}`);
        } catch (err) {
            console.log('\n❌ Tabla "employees" no existe o no accesible');
        }
        
        // Verificar si la tabla employees_v2 tiene datos
        try {
            const employeesV2Count = await db.query('SELECT COUNT(*) FROM employees_v2');
            console.log(`📊 Registros en tabla "employees_v2": ${employeesV2Count.rows[0].count}`);
        } catch (err) {
            console.log('❌ Tabla "employees_v2" no existe o no accesible');
        }
        
        process.exit(0);
    } catch (error) {
        console.error('💥 Error:', error.message);
        process.exit(1);
    }
}

setTimeout(checkEmployeeTables, 1000);