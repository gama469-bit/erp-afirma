require('dotenv').config();
const db = require('./server/db');

async function testQuery() {
  try {
    console.log('🔍 Testing assignments query...');
    
    const result = await db.query(
      `SELECT pa.id, pa.project_id, pa.employee_id, pa.role, pa.start_date, pa.end_date, pa.hours_allocated,
              e.first_name, e.last_name, e.email, e.employee_code,
              p.name as project_name,
              mc_position.item as position,
              mc_area.item as area,
              mc_entity.item as entity,
              CASE 
                WHEN pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE THEN true
                ELSE false
              END as is_active,
              CASE
                WHEN pa.end_date IS NULL THEN 'Sin fecha fin'
                WHEN pa.end_date >= CURRENT_DATE THEN 'Activo'
                ELSE 'Finalizado'
              END as status
       FROM project_assignments pa
       INNER JOIN employees_v2 e ON pa.employee_id = e.id
       INNER JOIN projects p ON pa.project_id = p.id
       LEFT JOIN mastercode mc_position ON e.position_id = mc_position.id
       LEFT JOIN mastercode mc_area ON e.area_id = mc_area.id
       LEFT JOIN mastercode mc_entity ON e.entity_id = mc_entity.id
       ORDER BY pa.start_date DESC, e.first_name, e.last_name`
    );
    
    console.log('✅ Query successful!');
    console.log(`📊 Found ${result.rows.length} assignments`);
    if (result.rows.length > 0) {
      console.log('Sample:', result.rows[0]);
    }
    
    process.exit(0);
  } catch (err) {
    console.error('❌ Query failed:', err.message);
    console.error('Stack:', err.stack);
    process.exit(1);
  }
}

testQuery();
