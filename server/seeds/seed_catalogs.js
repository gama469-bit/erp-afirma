require('dotenv').config();
const db = require('../db');

const entities = [
  'AFIRMA MEX', 'ATVANTTI', 'LEITMOTIV', 'SOFTNERGYS', 'TECNIVA'
];

const positions = [
  'Analista',
  'Analytics',
  'Arquitecto',
  'Auxiliar Adm',
  'Business Ana',
  'Contador',
  'Desarrollador .NET',
  'Desarrollador Android',
  'Desarrollador BI',
  'DESARROLLADOR COBOL',
  'Desarrollador Java',
  'Desarrollador Middleware',
  'Desarrollador PHP',
  'Desarrollador PL/SQL',
  'Desarrollador WEB',
  'DEVOPS UTP',
  'Especialista DBA Oracle',
  'Front End',
  'Functional Lead',
  'Gerente',
  'Gestor de Infraestructura',
  'Gestor de Proyectos',
  'PMO Digital',
  'PO Digital',
  'PROJECT MANAGER',
  'Reclutador',
  'Scrum Master',
  'SEGUROS ZAURICH',
  'Technical Lead',
  'UX'
];

const areas = [
  'STAFF – PMO',
  'STAFF – RRHH',
  'STAFF – TI',
  'STAFF-FINANZAS',
  'OPERACIONES'
];

const projects = [
  'ADO',
  'ATVANTTI',
  'BANCA / BU',
  'BANCA PERSON',
  'BANCA PRIV',
  'BET',
  'BOR',
  'CBT-DIGITAL',
  'DATA LAKE',
  'INTEGRACIÓN',
  'INVERSIONES',
  'LYNX',
  'MIGRACION A',
  'OPICS',
  'PLAYTOPIA',
  'POSEIDON',
  'RECUPERACION',
  'RIESGOS',
  'RPA',
  'SEGUROS INT',
  'SEGUROS ZUR',
  'STAFF'
];

async function upsertList(table, col, values) {
  for (const name of values) {
    const clean = name.trim();
    if (!clean) continue;
    const sql = `INSERT INTO ${table} (${col}) VALUES ($1) ON CONFLICT (${col}) DO NOTHING`;
    await db.query(sql, [clean]);
    console.log(`✓ ${table}: ${clean}`);
  }
}

async function upsertProjects(values) {
  for (const name of values) {
    const clean = name.trim(); if(!clean) continue;
    const sql = `INSERT INTO projects (name) VALUES ($1) ON CONFLICT DO NOTHING`;
    await db.query(sql, [clean]);
    console.log(`✓ projects: ${clean}`);
  }
}

(async ()=>{
  try {
    console.log('Seeding catalogs from image lists...');
    await upsertList('entities', 'name', entities);
    await upsertList('positions', 'name', positions);
    await upsertList('areas', 'name', areas);
    await upsertProjects(projects);
    console.log('✓ Seed completed');
    process.exit(0);
  } catch (e) {
    console.error('Seed error:', e.message);
    process.exit(1);
  }
})();
