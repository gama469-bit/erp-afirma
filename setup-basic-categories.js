// Script para verificar y crear categorías básicas
const { Pool } = require('pg');

const dbConfig = {
    user: 'postgres',
    host: 'localhost',
    database: 'BD_afirma',
    password: 'Sistemas1',
    port: 5432,
};

const pool = new Pool(dbConfig);

async function setupBasicCategories() {
    try {
        console.log('📂 Verificando categorías existentes...');
        
        // Verificar categorías existentes
        const existingResult = await pool.query(`
            SELECT * FROM mastercode 
            WHERE lista = 'inventario de categoria de equipos'
            ORDER BY item
        `);
        
        console.log(`✅ Categorías existentes: ${existingResult.rows.length}`);
        existingResult.rows.forEach(row => {
            console.log(`  - ${row.item} (ID: ${row.id})`);
        });
        
        // Si no hay categorías, crear las básicas
        if (existingResult.rows.length === 0) {
            console.log('\n📝 Creando categorías básicas...');
            
            const basicCategories = [
                'Computo',
                'Mobiliario',
                'Electronico',
                'Herramientas',
                'Vehiculos'
            ];
            
            for (const category of basicCategories) {
                const insertResult = await pool.query(`
                    INSERT INTO mastercode (lista, item, created_at, updated_at)
                    VALUES ('inventario de categoria de equipos', $1, NOW(), NOW())
                    RETURNING id
                `, [category]);
                
                console.log(`  ✅ "${category}" creada con ID: ${insertResult.rows[0].id}`);
            }
            
            console.log('\n✅ Categorías básicas creadas exitosamente');
        } else {
            console.log('\n✅ Las categorías ya existen, no es necesario crear nuevas');
        }
        
        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

setupBasicCategories();