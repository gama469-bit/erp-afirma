require('dotenv').config();
const db = require('../server/db');

(async () => {
  try {
    console.log('Updating test employees with area, project, and cell data...');
    
    // Get first 3 employees
    const emps = await db.query('SELECT id FROM employees_v2 ORDER BY id LIMIT 3');
    
    if (emps.rowCount === 0) {
      console.log('No employees found');
      process.exit(0);
    }
    
    // Assign area_id=1 (STAFF – PMO), project_id=1 (ADO) to first employee
    await db.query(
      'UPDATE employees_v2 SET area_id = $1, project_id = $2 WHERE id = $3',
      [1, 1, emps.rows[0].id]
    );
    console.log(`✓ Employee ${emps.rows[0].id}: area=STAFF-PMO, project=ADO`);
    
    // Assign area_id=2 (STAFF – RRHH), project_id=2 (ATVANTTI) to second
    if (emps.rows[1]) {
      await db.query(
        'UPDATE employees_v2 SET area_id = $1, project_id = $2 WHERE id = $3',
        [2, 2, emps.rows[1].id]
      );
      console.log(`✓ Employee ${emps.rows[1].id}: area=STAFF-RRHH, project=ATVANTTI`);
    }
    
    // Assign area_id=5 (OPERACIONES), project_id=3 (BANCA/BU) to third
    if (emps.rows[2]) {
      await db.query(
        'UPDATE employees_v2 SET area_id = $1, project_id = $2 WHERE id = $3',
        [5, 3, emps.rows[2].id]
      );
      console.log(`✓ Employee ${emps.rows[2].id}: area=OPERACIONES, project=BANCA/BU`);
    }
    
    console.log('\n✓ Test employees updated successfully');
    process.exit(0);
  } catch (e) {
    console.error('Error:', e.message);
    process.exit(1);
  }
})();
