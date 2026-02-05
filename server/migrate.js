require('dotenv').config();
const fs = require('fs');
const path = require('path');
const db = require('./db');

async function runMigrations() {
  try {
    // Array de migraciones en orden
    const migrations = [
      '001_create_employees.sql',
      '002_create_candidates.sql',
      '003_create_departments.sql',
      '004_create_positions.sql',
      '005_create_employees_v2.sql',
      '006_create_employee_relations.sql',
      '007_rename_departments_to_entities.sql',
      '008_create_catalog_tables.sql',
      '009_create_employee_extended_info.sql',
      '010_update_employees_mastercode.sql',
      '011_fix_foreign_keys.sql',
      '012_add_address_fields.sql',
      '013_add_expediente_fields.sql',
      '014_create_equipment.sql',
      '015_update_equipment_for_employees_v2.sql',
      '016_create_employee_vacations.sql',
      '017_alter_employee_vacations_add_id.sql',
      '018_update_employee_vacations.sql',
      '019_create_projects.sql',
      '020_create_project_assignments.sql',
      '021_create_project_indexes.sql',
      '022_create_project_assignment_indexes.sql'
    ];

    for (const migration of migrations) {
      const migrationPath = path.join(__dirname, 'migrations', migration);

      if (!fs.existsSync(migrationPath)) {
        console.warn(`⚠ Archivo no encontrado: ${migration}, saltando...`);
        continue;
      }

      const sql = fs.readFileSync(migrationPath, 'utf8');
      console.log(`Ejecutando migración: ${migration}...`);
      try {
        await db.query(sql);
        console.log(`✓ ${migration} completada`);
      } catch (err) {
        // Permitir migraciones idempotentes: continuar si el objeto ya existe
        const msg = String(err.message || err);
        if (/ya existe|already exists/i.test(msg)) {
          console.warn(`⚠ ${migration}: aviso - ${msg} (continuando)`);
          continue;
        }
        throw err;
      }
    }

    console.log('\n✓ Todas las migraciones completadas exitosamente');
    process.exit(0);
  } catch (err) {
    console.error('✗ Error en migración:', err.message);
    process.exit(1);
  }
}

runMigrations();
