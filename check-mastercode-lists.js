// Verificar nombres de listas en mastercode
const { Pool } = require('pg');

const dbConfig = {
    user: 'postgres',
    host: 'localhost',
    database: 'BD_afirma',
    password: 'Sistemas1',
    port: 5432,
};

const pool = new Pool(dbConfig);

async function checkMastercodeLists() {
    try {
        console.log('🔍 Verificando listas en mastercode...');
        
        // Obtener todas las listas distintas
        const listsResult = await pool.query(`
            SELECT DISTINCT lista, COUNT(*) as count 
            FROM mastercode 
            GROUP BY lista 
            ORDER BY lista
        `);
        
        console.log(`📋 Listas encontradas: ${listsResult.rows.length}`);
        listsResult.rows.forEach(row => {
            console.log(`  - "${row.lista}" (${row.count} items)`);
        });
        
        // Buscar específicamente categorías de inventario
        console.log('\n🔍 Buscando categorías de inventario...');
        const inventoryResult = await pool.query(`
            SELECT lista, item, id 
            FROM mastercode 
            WHERE lista ILIKE '%inventario%' OR lista ILIKE '%categoria%' OR lista ILIKE '%equip%'
            ORDER BY lista, item
        `);
        
        if (inventoryResult.rows.length > 0) {
            console.log(`📦 Categorías de inventario encontradas: ${inventoryResult.rows.length}`);
            inventoryResult.rows.forEach(row => {
                console.log(`  - Lista: "${row.lista}" | Item: "${row.item}" (ID: ${row.id})`);
            });
        } else {
            console.log('❌ No se encontraron categorías de inventario');
        }
        
        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

checkMastercodeLists();