// Test para verificar carga de categorías
const express = require('express');
const app = express();
const { Pool } = require('pg');

// Configuración de base de datos
const dbConfig = {
    user: 'postgres',
    host: 'localhost',
    database: 'BD_afirma',
    password: 'Sistemas1',
    port: 5432,
};

const pool = new Pool(dbConfig);

async function testCategorias() {
    try {
        console.log('🧪 Probando categorías desde equipment...');
        
        // Consultar tabla equipment para obtener categorías
        const result = await pool.query(`
            SELECT DISTINCT categoria 
            FROM equipment 
            WHERE categoria IS NOT NULL 
            ORDER BY categoria
        `);
        
        console.log('📊 Categorías encontradas:', result.rows.length);
        result.rows.forEach(row => {
            console.log(`  - "${row.categoria}"`);
        });
        
        console.log('\n✅ Test completado');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error:', error.message);
        process.exit(1);
    }
}

testCategorias();