// Script para diagnosticar datos faltantes en empleados
const db = require('./server/db.js');

async function diagnosticarDatos() {
    console.log('🔍 Diagnosticando datos faltantes...');
    
    try {
        // 1. Verificar empleados sin relaciones
        console.log('\n1. Empleados con/sin relaciones:');
        const empleadosSinRelaciones = await db.query(`
            SELECT 
                COUNT(*) as total,
                COUNT(entity_id) as con_entidad,
                COUNT(position_id) as con_posicion,
                COUNT(area_id) as con_area,
                COUNT(project_id) as con_proyecto,
                COUNT(cell_id) as con_celula
            FROM employees_v2
        `);
        console.log('Estadísticas:', empleadosSinRelaciones.rows[0]);

        // 2. Mostrar algunos empleados con sus IDs de relaciones
        console.log('\n2. Muestra de empleados y sus IDs de relación:');
        const muestra = await db.query(`
            SELECT 
                id,
                first_name,
                last_name,
                entity_id,
                position_id,
                area_id,
                project_id,
                cell_id
            FROM employees_v2 
            ORDER BY id DESC 
            LIMIT 5
        `);
        muestra.rows.forEach(emp => {
            console.log(`   ${emp.first_name} ${emp.last_name} (ID: ${emp.id})`);
            console.log(`     Entity: ${emp.entity_id}, Position: ${emp.position_id}, Area: ${emp.area_id}`);
            console.log(`     Project: ${emp.project_id}, Cell: ${emp.cell_id}`);
        });

        // 3. Verificar si existen los IDs en mastercode
        console.log('\n3. Verificando mastercode:');
        const entityIds = await db.query("SELECT COUNT(*) as total FROM mastercode WHERE lista = 'Entidad'");
        console.log(`   Entidades en mastercode: ${entityIds.rows[0].total}`);
        
        const positionIds = await db.query("SELECT COUNT(*) as total FROM mastercode WHERE lista = 'Puestos roles'");
        console.log(`   Posiciones en mastercode: ${positionIds.rows[0].total}`);

        // 4. Probar query completa como en la API
        console.log('\n4. Probando query de la API:');
        const apiQuery = `
            SELECT 
                e.id,
                e.first_name,
                e.last_name,
                ent.item as entity_name,
                pos.item as position_name,
                ar.item as area_name,
                proj.item as project_name,
                c.item as cell_name
            FROM employees_v2 e
            LEFT JOIN mastercode ent ON e.entity_id = ent.id AND ent.lista = 'Entidad'
            LEFT JOIN mastercode pos ON e.position_id = pos.id AND pos.lista = 'Puestos roles'
            LEFT JOIN mastercode ar ON e.area_id = ar.id AND ar.lista = 'Areas'
            LEFT JOIN mastercode proj ON e.project_id = proj.id AND proj.lista = 'Proyecto'  
            LEFT JOIN mastercode c ON e.cell_id = c.id AND c.lista = 'Celulas'
            ORDER BY e.id DESC
            LIMIT 3
        `;
        
        const resultadoAPI = await db.query(apiQuery);
        console.log('Resultado API (3 primeros empleados):');
        resultadoAPI.rows.forEach(emp => {
            console.log(`   ${emp.first_name} ${emp.last_name}:`);
            console.log(`     Entidad: ${emp.entity_name || 'NULL'}`);
            console.log(`     Posición: ${emp.position_name || 'NULL'}`);
            console.log(`     Área: ${emp.area_name || 'NULL'}`);
            console.log(`     Proyecto: ${emp.project_name || 'NULL'}`);
            console.log(`     Célula: ${emp.cell_name || 'NULL'}`);
        });

        // 5. Sugerencia de corrección
        console.log('\n5. 💡 Sugerencia:');
        if (empleadosSinRelaciones.rows[0].con_entidad == 0) {
            console.log('   ❌ Los empleados no tienen entity_id asignado');
            console.log('   ✅ Solución: Asignar entidades a los empleados');
        }

    } catch (error) {
        console.error('❌ Error:', error);
    }
    
    process.exit(0);
}

diagnosticarDatos();