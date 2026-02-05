// Script para probar las APIs
const db = require('./server/db.js');

async function testAPIs() {
    console.log('🔍 Probando APIs...');
    
    try {
        // Test employees
        console.log('\n1. Probando empleados...');
        const employeesQuery = `
            SELECT 
                e.*,
                ent.item as entity_name,
                pos.item as position_name,
                ar.item as area_name,
                proj.item as project_name,
                c.item as cell_name
            FROM employees_v2 e
            LEFT JOIN mastercode ent ON e.entity_id = ent.id AND ent.lista = 'entities'
            LEFT JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'positions'
            LEFT JOIN mastercode ar ON e.area_id = ar.id AND ar.lista = 'areas'
            LEFT JOIN mastercode proj ON e.project_id = proj.id AND proj.lista = 'projects'  
            LEFT JOIN mastercode c ON e.cell_id = c.id AND c.lista = 'cells'
            ORDER BY e.created_at DESC
            LIMIT 3
        `;
        const employees = await db.query(employeesQuery);
        console.log(`✅ Empleados: ${employees.rows.length} registros`);
        if (employees.rows.length > 0) {
            console.log('   Primer empleado:', {
                id: employees.rows[0].id,
                name: employees.rows[0].first_name + ' ' + employees.rows[0].last_name,
                entity: employees.rows[0].entity_name,
                position: employees.rows[0].position_name
            });
        }

        // Test mastercode entities
        console.log('\n2. Probando catálogo entities...');
        const entities = await db.query('SELECT id, item as name, lista as category FROM mastercode WHERE lista = $1 ORDER BY item LIMIT 5', ['Entidad']);
        console.log(`✅ Entidades: ${entities.rows.length} registros`);
        entities.rows.forEach(e => console.log(`   - ${e.name} (ID: ${e.id})`));

        // Test mastercode positions  
        console.log('\n3. Probando catálogo positions...');
        const positions = await db.query('SELECT id, item as name, lista as category FROM mastercode WHERE lista = $1 ORDER BY item LIMIT 5', ['Puestos roles']);
        console.log(`✅ Posiciones: ${positions.rows.length} registros`);
        positions.rows.forEach(p => console.log(`   - ${p.name} (ID: ${p.id})`));

        // Test inventory
        console.log('\n4. Probando inventario...');
        const inventory = await db.query('SELECT id, equipment_type, brand, model FROM inventory ORDER BY created_at DESC LIMIT 3');
        console.log(`✅ Inventario: ${inventory.rows.length} registros`);
        inventory.rows.forEach(i => console.log(`   - ${i.equipment_type} ${i.brand} ${i.model} (ID: ${i.id})`));

    } catch (error) {
        console.error('❌ Error:', error);
    }
    
    process.exit(0);
}

testAPIs();