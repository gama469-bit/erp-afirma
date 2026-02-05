const db = require('./db');

async function createIntegralTestData() {
  console.log('🧪 CREANDO DATOS DE PRUEBA INTEGRALES');
  console.log('=====================================');
  
  try {
    // 1. Crear empleados con diferentes combinaciones de catálogos
    console.log('\n👥 Creando empleados de prueba...');
    
    const testEmployees = [
      {
        first_name: 'Ana',
        last_name: 'Rodríguez',
        email: 'ana.rodriguez.test@afirma.solutions',
        phone: '5512345001',
        entity_id: 1, // AFIRMA MEX
        position_id: 1,
        area_id: 1,
        status: 'Activo',
        created_by: 'integral-test'
      },
      {
        first_name: 'Carlos',
        last_name: 'López',
        email: 'carlos.lopez.test@afirma.solutions',
        phone: '5512345002',
        entity_id: 6, // AFIRMA ESP
        position_id: 2,
        area_id: 2,
        status: 'Activo',
        created_by: 'integral-test'
      },
      {
        first_name: 'Diana',
        last_name: 'Martínez',
        email: 'diana.martinez.test@afirma.solutions',
        phone: '5512345003',
        entity_id: 1,
        position_id: 3,
        area_id: 1,
        project_id: 1,
        status: 'En licencia',
        created_by: 'integral-test'
      }
    ];
    
    const createdEmployees = [];
    
    for (const emp of testEmployees) {
      const result = await db.query(
        `INSERT INTO employees_v2 (first_name, last_name, email, phone, entity_id, position_id, area_id, project_id, status, created_by) 
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING *`,
        [emp.first_name, emp.last_name, emp.email, emp.phone, emp.entity_id, emp.position_id, emp.area_id, emp.project_id, emp.status, emp.created_by]
      );
      createdEmployees.push(result.rows[0]);
      console.log(`✅ Creado: ${result.rows[0].first_name} ${result.rows[0].last_name} (ID: ${result.rows[0].id})`);
    }
    
    // 2. Crear datos en catálogos mastercode
    console.log('\n📋 Creando elementos de catálogo...');
    
    const catalogItems = [
      { lista: 'Areas', item: 'ÁREA DE TESTING' },
      { lista: 'Proyecto', item: 'PROYECTO DE INTEGRACIÓN' },
      { lista: 'Celulas', item: 'CÉLULA DE PRUEBAS' },
      { lista: 'Puestos roles', item: 'QA Engineer' },
      { lista: 'Puestos roles', item: 'Test Manager' }
    ];
    
    const createdCatalogs = [];
    
    for (const item of catalogItems) {
      const result = await db.query(
        `INSERT INTO mastercode (lista, item) VALUES ($1, $2) RETURNING *`,
        [item.lista, item.item]
      );
      createdCatalogs.push(result.rows[0]);
      console.log(`✅ Catálogo creado: ${result.rows[0].lista} - ${result.rows[0].item} (ID: ${result.rows[0].id})`);
    }
    
    // 3. Verificar integridad de datos
    console.log('\n🔍 Verificando integridad de datos...');
    
    const verificationQueries = [
      {
        name: 'Empleados con entidad',
        query: `SELECT COUNT(*) as count FROM employees_v2 e 
                JOIN mastercode m ON e.entity_id = m.id 
                WHERE m.lista = 'Entidad'`
      },
      {
        name: 'Empleados con posición',
        query: `SELECT COUNT(*) as count FROM employees_v2 e 
                JOIN mastercode m ON e.position_id = m.id 
                WHERE m.lista = 'Puestos roles'`
      },
      {
        name: 'Total items mastercode',
        query: `SELECT lista, COUNT(*) as count FROM mastercode GROUP BY lista ORDER BY lista`
      }
    ];
    
    for (const vq of verificationQueries) {
      const result = await db.query(vq.query);
      if (vq.name === 'Total items mastercode') {
        console.log(`✅ ${vq.name}:`);
        result.rows.forEach(row => {
          console.log(`   ${row.lista}: ${row.count} items`);
        });
      } else {
        console.log(`✅ ${vq.name}: ${result.rows[0].count}`);
      }
    }
    
    console.log('\n🎉 DATOS DE PRUEBA INTEGRALES CREADOS EXITOSAMENTE');
    console.log(`📊 Empleados de prueba creados: ${createdEmployees.length}`);
    console.log(`📋 Elementos de catálogo creados: ${createdCatalogs.length}`);
    
  } catch (err) {
    console.error('❌ Error:', err.message);
  } finally {
    process.exit(0);
  }
}

createIntegralTestData();