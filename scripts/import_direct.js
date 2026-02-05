require('dotenv').config();
const XLSX = require('xlsx');
const path = require('path');
const db = require('../server/db');

(async () => {
  try {
    const filePath = path.join(__dirname, '..', 'employees_sample.xlsx');
    const workbook = XLSX.readFile(filePath);
    const sheetName = workbook.SheetNames[0];
    const worksheet = workbook.Sheets[sheetName];
    const data = XLSX.utils.sheet_to_json(worksheet);

    const results = [];
    const errors = [];

    // helper functions copied from server/api.js
    const normalizeDateInput = (value) => {
      if (!value) return null;
      const s = String(value).trim();
      if (!s) return null;
      const d = new Date(s);
      if (isNaN(d.getTime())) return null;
      return d.toISOString().split('T')[0];
    };
    const isFutureDate = (dateStr) => {
      if (!dateStr) return false;
      const d = new Date(dateStr);
      if (isNaN(d.getTime())) return false;
      const today = new Date();
      const dd = new Date(d.getFullYear(), d.getMonth(), d.getDate());
      const td = new Date(today.getFullYear(), today.getMonth(), today.getDate());
      return dd > td;
    };

    async function findOrCreateEntity(name) {
      if (!name) return null;
      const clean = String(name).trim();
      if (!clean) return null;
      try {
        const found = await db.query('SELECT id FROM entities WHERE LOWER(name) = LOWER($1) LIMIT 1', [clean]);
        if (found.rowCount > 0) return found.rows[0].id;
        const inserted = await db.query('INSERT INTO entities (name) VALUES ($1) RETURNING id', [clean]);
        return inserted.rows[0].id;
      } catch (err) {
        console.error('Error resolving/creating entity', err.message);
        return null;
      }
    }

    async function findOrCreatePosition(name, entity_id) {
      if (!name) return null;
      const clean = String(name).trim();
      if (!clean) return null;
      try {
        const found = await db.query('SELECT id FROM positions WHERE LOWER(name) = LOWER($1) LIMIT 1', [clean]);
        if (found.rowCount > 0) return found.rows[0].id;
        const inserted = await db.query(
          'INSERT INTO positions (name, entity_id) VALUES ($1, $2) RETURNING id',
          [clean, entity_id || null]
        );
        return inserted.rows[0].id;
      } catch (err) {
        console.error('Error resolving/creating position', err.message);
        return null;
      }
    }

    for (let i = 0; i < data.length; i++) {
      const row = data[i];
      try {
        const rawFullName = (row['Nombre del empleado'] || row['Nombre'] || row['nombre'] || row['name'] || row['NombreEmpleado'] || '').toString().trim();
        let first_name = '';
        let last_name = '';
        if (rawFullName) {
          const parts = rawFullName.split(/\s+/);
          first_name = parts.shift() || '';
          last_name = parts.join(' ') || '';
        } else {
          first_name = (row['Nombre'] || row['nombre'] || row['first_name'] || row['First Name'] || '').toString().trim();
          last_name = (row['Apellido'] || row['apellido'] || row['last_name'] || row['Last Name'] || '').toString().trim();
        }
        // Ensure last_name is not empty to satisfy DB NOT NULL constraints
        if (!last_name) {
          last_name = '(Sin Apellido)';
        }
        // Get email - prioritize work email (Correo de trabajo)
        const workEmail = (row['Correo de trabajo'] || row['Correo trabajo'] || '').toString().trim();
        const personalEmail = (row['Correo electrónico personal'] || row['Correo personal'] || '').toString().trim();
        const email = workEmail || personalEmail || (first_name + '.' + last_name + '@afirma-solutions.com').toLowerCase();
        const phone = (row['Teléfono laboral'] || row['Teléfono'] || row['telefono'] || row['teléfono'] || row['phone'] || row['Phone'] || '').toString().trim();
        const personal_phone = (row['Teléfono personal'] || row['Personal Phone'] || row['personal_phone'] || row['celular'] || '').toString().trim();
        const employee_code = (row['Código'] || row['Codigo'] || row['employee_code'] || row['Código empleado'] || '').toString().trim();
        const positionName = (row['Posición'] || row['posición'] || row['position'] || row['Position'] || row['Cargo'] || row['cargo'] || '').toString().trim();
        const entityName = (row['Área'] || row['Departamento'] || row['departamento'] || row['department'] || '').toString().trim();
        const hire_date = (row['Fecha de ingreso'] || row['Fecha ingreso'] || row['Fecha contratación'] || row['hire_date'] || row['Fecha de contratación'] || row['Hire Date'] || row['hireDate'] || '').toString().trim();
        const start_date = (row['Fecha de asignación'] || row['Fecha asignación'] || row['Fecha inicio'] || row['start_date'] || row['Fecha de inicio'] || '').toString().trim();
        const birth_date = (row['Fecha nacimiento'] || row['birth_date'] || row['Fecha de nacimiento'] || '').toString().trim();
        const address = (row['Dirección'] || row['direccion'] || row['address'] || '').toString().trim();
        const city = (row['Ciudad'] || row['city'] || '').toString().trim();
        const state = (row['Estado'] || row['state'] || '').toString().trim();
        const postal_code = (row['Postal'] || row['postal_code'] || row['Código postal'] || '').toString().trim();
        const country = (row['País'] || row['Pais'] || row['country'] || '').toString().trim();
        const employment_type = (row['Tipo empleo'] || row['employment_type'] || row['Tipo de empleo'] || '').toString().trim();
        const contract_end_date = (row['Fin contrato'] || row['contract_end_date'] || '').toString().trim();
        const statusVal = (row['Estado'] || row['status'] || '').toString().trim() || 'Activo';
        const cliente = (row['CLIENTE'] || row['Cliente'] || row['client'] || '').toString().trim();
        const celula = (row['Célula'] || row['Celula'] || '').toString().trim();
        const proyecto = (row['Proyecto'] || row['Project'] || '').toString().trim();
        const tarifa = (row['Tarifa inicial de contratación'] || row['Tarifa'] || row['Tarifa inicial'] || '').toString().trim();
        const sgmm = (row['SGMM'] || '').toString().trim();
        const vida = (row['vida'] || row['Vida'] || '').toString().trim();
        const cpa_cpe = (row['CPA / CPE'] || row['CPA'] || row['CPE'] || '').toString().trim();
        const correo_con_cliente = (row['Correo con cliente'] || row['Correo cliente'] || '').toString().trim();
        const correo_trabajo = (row['Correo de trabajo'] || row['Correo trabajo'] || row['Correo laboral'] || row['Correo'] || row['Correo electrónico laboral'] || '').toString().trim();
        const correo_personal = (row['Correo electrónico personal'] || row['Correo personal'] || row['Personal Email'] || '').toString().trim();

        if (email) {
          const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          if (!emailRe.test(String(email))) {
            errors.push({ row: i + 1, error: `Invalid email: ${email}` });
            continue;
          }
        }
        // Use finalEmail instead

        let hireDateForInsert = null;
        const hireNorm = normalizeDateInput(hire_date);
        if (hireNorm) {
          if (isFutureDate(hireNorm)) {
            hireDateForInsert = new Date().toISOString().split('T')[0];
          } else {
            hireDateForInsert = hireNorm;
          }
        }
        // Ensure hire_date is set (required by DB)
        if (!hireDateForInsert) {
          hireDateForInsert = new Date().toISOString().split('T')[0];
        }

        const resolvedEntityId = entityName ? await findOrCreateEntity(entityName) : null;
        const resolvedPositionId = positionName ? await findOrCreatePosition(positionName, resolvedEntityId) : null;

        // Insert employee_v2
        try {
          const insertRes = await db.query(
            `INSERT INTO employees_v2 (
               first_name, last_name, email, phone, personal_phone,
               employee_code, position_id, entity_id,
               hire_date, start_date, birth_date,
               address, city, state, postal_code, country,
               employment_type, contract_end_date, status, created_by
             ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20) RETURNING *`,
            [
              first_name || null,
              last_name || null,
              email || null,
              phone || null,
              personal_phone || null,
              employee_code || null,
              resolvedPositionId || null,
              resolvedEntityId || null,
              hireDateForInsert || null,
              start_date || null,
              birth_date || null,
              address || null,
              city || null,
              state || null,
              postal_code || null,
              country || 'Colombia',
              employment_type || 'Permanente',
              contract_end_date || null,
              statusVal || 'Activo',
              'import_direct'
            ]
          );
          results.push(insertRes.rows[0]);

          const newEmp = insertRes.rows[0];

          const meta = {
            cliente: cliente || undefined,
            celula: celula || undefined,
            proyecto: proyecto || undefined,
            sgmm: sgmm || undefined,
            vida: vida || undefined,
            cpa_cpe: cpa_cpe || undefined,
            correo_con_cliente: correo_con_cliente || undefined,
            correo_personal: correo_personal || undefined,
            original_row: row
          };

          await db.query(
            `INSERT INTO employee_documents (employee_id, document_type, notes) VALUES ($1,$2,$3)`,
            [newEmp.id, 'import_meta', JSON.stringify(meta)]
          );

          const tarifaNum = parseFloat(String(tarifa).replace(/[^0-9\.-]+/g,''));
          if (!isNaN(tarifaNum) && tarifaNum > 0) {
            const effDate = hireDateForInsert || new Date().toISOString().split('T')[0];
            await db.query(
              `INSERT INTO salary_history (employee_id, salary_amount, currency, effective_date, reason, notes, created_by)
               VALUES ($1,$2,$3,$4,$5,$6,$7)`,
              [newEmp.id, tarifaNum, 'COP', effDate, 'Tarifa inicial importada', JSON.stringify({source_row: row}), 'import_direct']
            );
          }

        } catch (err) {
          errors.push({ row: i + 1, error: err.message });
        }
      } catch (err) {
        errors.push({ row: i + 1, error: err.message });
      }
    }

    console.log(JSON.stringify({ imported: results.length, total: data.length, results, errors }, null, 2));
    process.exit(0);
  } catch (err) {
    console.error('Fatal import error:', err.message);
    process.exit(1);
  }
})();
