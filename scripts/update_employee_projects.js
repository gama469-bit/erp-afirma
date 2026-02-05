require('dotenv').config();
const db = require('../server/db');

// Mapeo de empleados a proyectos según la imagen proporcionada
const employeeProjects = [
  { name: 'JORGE GUILLERMO GARC STAFF – PMO', project: 'ADO' },
  { name: 'HECTOR MARTINEZ STAFF-FINANZAS', project: null },
  { name: 'SANDRA IVONNE GOS STAFF – TI', project: null },
  { name: 'JUAN CARLOS VALLE STAFF – TI', project: null },
  { name: 'RAYMUNDO MARTI POSEIDON', project: 'POSEIDON' },
  { name: 'ARMANDO ALONSO MIGRACION A', project: 'MIGRACION A' },
  { name: 'SAUL CASTILLO HER STAFF – TI', project: null },
  { name: 'ROBERTO BLANCO C STAFF – TI', project: null },
  { name: 'ILSE NARVAEZ ABUÑ STAFF – RRHH', project: null },
  { name: 'FERNANDO GARRID STAFF – RRHH', project: null },
  { name: 'LUIS ALAMARIZ HE RAMOS', project: 'RAMOS' },
  { name: 'RAMIRO TORRES M SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'FERNANDO JOSE AL STAFF – TI', project: null },
  { name: 'OSCAR ABARCA MI ATVANTTI', project: 'ATVANTTI' },
  { name: 'JESUS ANDRES PEZ BET', project: 'BET' },
  { name: 'ANA LUCIEL MORE RPA', project: 'RPA' },
  { name: 'MIGUEL ANGEL DEL STAFF – RRHH', project: null },
  { name: 'GUSTAVO HERNAN STAFF – TI', project: null },
  { name: 'MARCO PAULO CA SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'MARISELA MONTES RIESGOS', project: 'RIESGOS' },
  { name: 'JORGE SAUL FERNA SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'ELSA MARIA FONG ATVANTTI', project: 'ATVANTTI' },
  { name: 'FATIMA NATALIA ATVANTTI', project: 'ATVANTTI' },
  { name: 'GABRIELA ROSAS ATVANTTI', project: 'ATVANTTI' },
  { name: 'RODRIGO MENDOZ SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'SARAI GONZALEZ STAFF – TI', project: null },
  { name: 'SAMUEL LOPEZ PEÑ BANCA // BU', project: 'BANCA // BU' },
  { name: 'MIGUEL CRUZ JACOB STAFF', project: 'STAFF' },
  { name: 'MIGUEL ANGEL DEL BET', project: 'BET' },
  { name: 'GERALDINE VALLE SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'ISAAC YAEL MARTI STAFF-FINANZAS', project: null },
  { name: 'JUAN VALDOVINO SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'HECTOR GABRIEL DE SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'EMANUEL GARRID INVERSIONES', project: 'INVERSIONES' },
  { name: 'CARLOS ALBERTO SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'OSWALDO CRUZ NA OPICS', project: 'OPICS' },
  { name: 'GERARDO ULISES RECUPERACION', project: 'RECUPERACION' },
  { name: 'GALGANI MONTES ATVANTTI', project: 'ATVANTTI' },
  { name: 'ERICK JONATHAN STAFF – TI', project: null },
  { name: 'ANDRES HERNANDE SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'PATRICK FERNANDO PLAYTOPIA', project: 'PLAYTOPIA' },
  { name: 'FERNANDO MANUE BOR', project: 'BOR' },
  { name: 'MIGUEL ANGEL ES SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'JORGE OMAR LOP BANCA PRIV', project: 'BANCA PRIV' },
  { name: 'IVAN RODRIGUEZ A SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'ERICK SANCHEZ TUR BANCA PERSON', project: 'BANCA PERSON' },
  { name: 'ERICK MISAEL ROME SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'ROGELIO MARTINEZ STAFF – PMO', project: null },
  { name: 'MARIO CARLOS VALIBOR', project: 'VALIBOR' },
  { name: 'JOSHUA ALBERTO SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'ERICK ALEJANDRO CBT-DIGITAL', project: 'CBT-DIGITAL' },
  { name: 'JORGE ARTURO CAS SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'MAURICIO CAMELO DATA LAKE', project: 'DATA LAKE' },
  { name: 'AGUSTIN SEVILLA SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'ERIC RICARDO COL BOR', project: 'BOR' },
  { name: 'BRIAN ALEXIS MUÑ BOR', project: 'BOR' },
  { name: 'MIGUEL ANGEL ES SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'CARLOS ANDRES BE SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'RAMON MENDEZ P SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'OMAR ALBERTO SA SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'YAIR ALEJANDRO SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'LUZ MARIA ELIAS SE RPA', project: 'RPA' },
  { name: 'JORGE LUIS GUAR OPICS', project: 'OPICS' },
  { name: 'EDUARDO PASTOR ATVANTTI', project: 'ATVANTTI' },
  { name: 'OSCAR ULISES ACU SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'LAURA FABIOLA VAL STAFF – PMO', project: null },
  { name: 'VIVIANA LIZETH SA SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'AARON SOTO BARR ATVANTTI', project: 'ATVANTTI' },
  { name: 'JOSE ANGEL NOR CBT-DIGITAL', project: 'CBT-DIGITAL' },
  { name: 'CYNTHIA IVONNE POSEIDON', project: 'POSEIDON' },
  { name: 'EDUARDO BERNAB STAFF – TI', project: null },
  { name: 'PERLA VALENTIN SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'AURORA FLORES ES BANCA PERSON', project: 'BANCA PERSON' },
  { name: 'JOSE MIGUEL COR BANCA PERSON', project: 'BANCA PERSON' },
  { name: 'JESUS ADOLFO HE PLAYTOPIA', project: 'PLAYTOPIA' },
  { name: 'LUIS ALBERTO GRI SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'BRAYAN GARCIA GO STAFF', project: 'STAFF' },
  { name: 'BISMAN ABIMAEL CBT-DIGITAL', project: 'CBT-DIGITAL' },
  { name: 'MARIA GAUDINO LESTAFF – PMO', project: null },
  { name: 'MARILIA GABRIELA RECUPERACION', project: 'RECUPERACION' },
  { name: 'ABIGAIL GARIBAY POSEIDON', project: 'POSEIDON' },
  { name: 'JOSE IVAN ROBLE BANCA PRIV', project: 'BANCA PRIV' },
  { name: 'ALEXANDER MART RECUPERACION', project: 'RECUPERACION' },
  { name: 'EMMANUEL ROME BOR', project: 'BOR' },
  { name: 'DANIELA HERRERA STAFF – PMO', project: null },
  { name: 'ALBERTO DE JESUS INTEGRACIÓN', project: 'INTEGRACIÓN' },
  { name: 'EDUARDO SANTIAG INTEGRACIÓN', project: 'INTEGRACIÓN' },
  { name: 'JUAN ANTONIO C SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'CHRISTOPHER TO SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'EFREN TORRES PER SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'GLADYS RAMONA OPICS', project: 'OPICS' },
  { name: 'JUAN CARLOS ROBL SEGUROS ZUR', project: 'SEGUROS ZUR' },
  { name: 'CARLO IVAN CORT DATA LAKE', project: 'DATA LAKE' },
  { name: 'LUCERO RUBY GAC RIESGOS', project: 'RIESGOS' },
  { name: 'DENISSE ZUÑIGA SA SEGUROS INT', project: 'SEGUROS INT' },
  { name: 'MIRIAM AREVALO STAFF – PMO', project: null },
  { name: 'CESAR IVAN ROMER RPA', project: 'RPA' },
  { name: 'JOSHUA GONZALE INVERSIONES', project: 'INVERSIONES' },
  { name: 'MONICA FAIVET JAS STAFF', project: 'STAFF' },
  { name: 'ELIEZER SANTIAGO STAFF – PMO', project: null },
  { name: 'CYNTHIA GARCIA ATVANTTI', project: 'ATVANTTI' },
  { name: 'GABRIELA CRUZ TUL', project: 'TUL' },
  { name: 'MIGUEL ANGEL IHE ATVANTTI', project: 'ATVANTTI' },
  { name: 'ISREL URBINA ECH ATVANTTI', project: 'ATVANTTI' },
  { name: 'JAVIER PEREZ BARR ATVANTTI', project: 'ATVANTTI' },
  { name: 'MARIA FERNANDA', project: null },
  { name: 'MAURICIO ANGEL ATVANTTI', project: 'ATVANTTI' },
  { name: 'FERNANDO GARCIA RPA', project: 'RPA' },
  { name: 'JESUS ADAIR VELA BOR', project: 'BOR' }
];

async function updateEmployeeProjects() {
  try {
    console.log('Actualizando proyectos de empleados (deja null donde no cuadra)...\n');

    let updated = 0;
    let blanks = 0;
    const pendientes = [];

    for (const item of employeeProjects) {
      const rawName = item.name.trim();
      const parts = rawName.split(/\s+/);
      const proyectoTexto = item.project ? item.project.trim() : '';

      // Resolver proyecto (si viene texto)
      let projectId = null;
      if (proyectoTexto) {
        const projectResult = await db.query(
          'SELECT id FROM projects WHERE LOWER(name) = LOWER($1) LIMIT 1',
          [proyectoTexto]
        );
        if (projectResult.rowCount > 0) {
          projectId = projectResult.rows[0].id;
        }
      }

      // Heurísticas de búsqueda de empleado: probar combinaciones incrementales
      let employeeResult = null;
      const maxTokens = Math.min(parts.length, 5);
      for (let i = 2; i <= maxTokens; i++) {
        const fragment = parts.slice(0, i).join(' ');
        employeeResult = await db.query(
          `SELECT id, first_name, last_name FROM employees_v2
           WHERE LOWER(first_name || ' ' || last_name) LIKE LOWER($1)
           ORDER BY id LIMIT 1`,
          [`%${fragment.toLowerCase()}%`]
        );
        if (employeeResult.rowCount > 0) break;
      }

      if (!employeeResult || employeeResult.rowCount === 0) {
        // No se encontró empleado: registrar pendiente
        pendientes.push({ origen: rawName, motivo: 'Empleado no encontrado', proyectoDeseado: proyectoTexto || null });
        blanks++;
        continue; // no podemos asignar ni limpiar porque desconocemos el id
      }

      const employee = employeeResult.rows[0];

      if (projectId) {
        await db.query('UPDATE employees_v2 SET project_id = $1 WHERE id = $2', [projectId, employee.id]);
        console.log(`✓ ${employee.first_name} ${employee.last_name} → ${proyectoTexto}`);
        updated++;
      } else {
        // Proyecto faltante o vacío: dejar null explícitamente
        await db.query('UPDATE employees_v2 SET project_id = NULL WHERE id = $1', [employee.id]);
        console.log(`· ${employee.first_name} ${employee.last_name}: NULL (pendiente asignar proyecto: ${proyectoTexto || '—'})`);
        pendientes.push({ empleado: `${employee.first_name} ${employee.last_name}`, origen: rawName, motivo: projectId === null && proyectoTexto ? 'Proyecto no existe en catálogo' : 'Proyecto vacío', proyectoDeseado: proyectoTexto || null });
        blanks++;
      }
    }

    // Guardar pendientes a archivo JSON
    const fs = require('fs');
    const outputPath = __dirname + '/pending_project_assignments.json';
    fs.writeFileSync(outputPath, JSON.stringify({ fecha: new Date().toISOString(), pendientes }, null, 2), 'utf8');

    console.log(`\nResumen:`);
    console.log(`  - ${updated} empleados con proyecto asignado`);
    console.log(`  - ${blanks} entradas pendientes (ver pending_project_assignments.json)`);
    console.log(`Archivo generado: ${outputPath}`);
    process.exit(0);
  } catch (e) {
    console.error('Error:', e.message);
    process.exit(1);
  }
}

updateEmployeeProjects();
