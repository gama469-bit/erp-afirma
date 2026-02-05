const db = require('./db');

async function crearDatosPrueba() {
  console.log('🧪 Iniciando creación de datos de prueba...');
  
  try {
    // Crear 3 empleados de prueba con referencias válidas a mastercode
    const empleados = [
      {
        first_name: 'Ana',
        last_name: 'García López',
        email: 'ana.garcia@afirma.test',
        phone: '5551234567',
        personal_phone: '5559876543',
        position_id: 7,  // Director de Operaciones
        entity_id: 1,    // AFIRMA MEX
        area_id: 55,     // OPERACIONES
        project_id: 56,  // BANCA / BU
        birth_date: '1985-03-15',
        employee_code: 'TEST001',
        status: 'Activo'
      },
      {
        first_name: 'Carlos',
        last_name: 'Rodríguez Méndez',
        email: 'carlos.rodriguez@afirma.test',
        phone: '5552345678',
        personal_phone: '5558765432',
        position_id: 9,  // Gerente
        entity_id: 2,    // ATVANTTI
        area_id: 54,     // STAFF-FINANZAS
        project_id: 57,  // BANCA PERSON
        birth_date: '1990-07-22',
        employee_code: 'TEST002',
        status: 'Activo'
      },
      {
        first_name: 'María',
        last_name: 'Hernández Silva',
        email: 'maria.hernandez@afirma.test',
        phone: '5553456789',
        personal_phone: '5557654321',
        position_id: 10, // PMO Digital
        entity_id: 3,    // TECNIVA
        area_id: 53,     // STAFF – TI
        project_id: 58,  // BANCA PRIV
        birth_date: '1988-11-08',
        employee_code: 'TEST003',
        status: 'Activo'
      }
    ];

    console.log('📝 Creando empleados de prueba...');
    
    for (let i = 0; i < empleados.length; i++) {
      const emp = empleados[i];
      const result = await db.query(`
        INSERT INTO employees_v2 
        (first_name, last_name, email, phone, personal_phone, position_id, entity_id, area_id, project_id, birth_date, employee_code, status)
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
        RETURNING id, first_name, last_name
      `, [
        emp.first_name, emp.last_name, emp.email, emp.phone, emp.personal_phone,
        emp.position_id, emp.entity_id, emp.area_id, emp.project_id, emp.birth_date, emp.employee_code, emp.status
      ]);
      
      console.log(`✅ Empleado ${i+1} creado: ${result.rows[0].first_name} ${result.rows[0].last_name} (ID: ${result.rows[0].id})`);
    }

    // Verificar los empleados creados con sus datos relacionados
    console.log('\n📋 Verificando empleados creados con datos relacionados:');
    const verification = await db.query(`
      SELECT e.id, e.first_name, e.last_name, e.email,
             mp.item as position_name,
             me.item as entity_name,
             ma.item as area_name,
             mpr.item as project_name,
             e.status
      FROM employees_v2 e
      LEFT JOIN mastercode mp ON e.position_id = mp.id AND mp.lista = 'Puestos roles'
      LEFT JOIN mastercode me ON e.entity_id = me.id AND me.lista = 'Entidad'
      LEFT JOIN mastercode ma ON e.area_id = ma.id AND ma.lista = 'Areas'
      LEFT JOIN mastercode mpr ON e.project_id = mpr.id AND mpr.lista = 'Proyecto'
      WHERE e.email LIKE '%@afirma.test'
      ORDER BY e.id DESC
      LIMIT 3
    `);

    verification.rows.forEach((emp, index) => {
      console.log(`\n👤 Empleado ${index + 1}:`);
      console.log(`   Nombre: ${emp.first_name} ${emp.last_name}`);
      console.log(`   Email: ${emp.email}`);
      console.log(`   Entidad: ${emp.entity_name || 'N/A'}`);
      console.log(`   Posición: ${emp.position_name || 'N/A'}`);
      console.log(`   Área: ${emp.area_name || 'N/A'}`);
      console.log(`   Proyecto: ${emp.project_name || 'N/A'}`);
      console.log(`   Estado: ${emp.status}`);
    });

    console.log('\n✅ Datos de prueba creados exitosamente!');

  } catch (error) {
    console.error('❌ Error creando datos de prueba:', error);
  } finally {
    process.exit(0);
  }
}

crearDatosPrueba();