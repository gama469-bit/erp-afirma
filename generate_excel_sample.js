/**
 * Script para generar archivo Excel de ejemplo para importación
 * Uso: node generate_excel_sample.js
 */

const XLSX = require('xlsx');
const path = require('path');

// Datos de ejemplo para empleados
const employeesSample = [
  {
    'Nombre': 'Juan',
    'Apellido': 'García López',
    'Email': 'juan.garcia@afirma.com',
    'Teléfono': '+57-1-1234567',
    'Posición': 'Desarrollador Senior',
    'Departamento': 'Desarrollo'
  },
  {
    'Nombre': 'María',
    'Apellido': 'Rodríguez Martínez',
    'Email': 'maria.rodriguez@afirma.com',
    'Teléfono': '+57-1-2345678',
    'Posición': 'Desarrollador Junior',
    'Departamento': 'Desarrollo'
  },
  {
    'Nombre': 'Carlos',
    'Apellido': 'Martínez Torres',
    'Email': 'carlos.martinez@afirma.com',
    'Teléfono': '+57-1-3456789',
    'Posición': 'Diseñador UX/UI',
    'Departamento': 'Diseño'
  },
  {
    'Nombre': 'Patricia',
    'Apellido': 'López Fernández',
    'Email': 'patricia.lopez@afirma.com',
    'Teléfono': '+57-1-4567890',
    'Posición': 'Project Manager',
    'Departamento': 'Gestión'
  },
  {
    'Nombre': 'Roberto',
    'Apellido': 'Sánchez García',
    'Email': 'roberto.sanchez@afirma.com',
    'Teléfono': '+57-1-5678901',
    'Posición': 'Especialista RRHH',
    'Departamento': 'Recursos Humanos'
  }
];

// Datos de ejemplo para candidatos
const candidatesSample = [
  {
    'Nombre': 'Sofia',
    'Apellido': 'Pérez Gómez',
    'Email': 'sofia.perez@external.com',
    'Teléfono': '3001112233',
    'Posición': 'Desarrollador Backend',
    'Estado': 'Entrevista',
    'Notas': 'Candidato con buena experiencia en Node.js'
  },
  {
    'Nombre': 'Miguel',
    'Apellido': 'Torres Castillo',
    'Email': 'miguel.torres@external.com',
    'Teléfono': '3002223344',
    'Posición': 'Diseñador Gráfico',
    'Estado': 'En revisión',
    'Notas': 'Portfolio impresionante'
  },
  {
    'Nombre': 'Laura',
    'Apellido': 'Hernández López',
    'Email': 'laura.hernandez@external.com',
    'Teléfono': '3003334455',
    'Posición': 'Contabilista',
    'Estado': 'Oferta',
    'Notas': 'Se envió oferta el 2024-11-10'
  }
];

try {
  // Crear workbook con dos hojas
  const wb = XLSX.utils.book_new();
  
  // Hoja de empleados
  const wsEmployees = XLSX.utils.json_to_sheet(employeesSample);
  XLSX.utils.book_append_sheet(wb, wsEmployees, 'Empleados');
  
  // Hoja de candidatos
  const wsCandidates = XLSX.utils.json_to_sheet(candidatesSample);
  XLSX.utils.book_append_sheet(wb, wsCandidates, 'Candidatos');
  
  // Ajustar ancho de columnas
  wsEmployees['!cols'] = [
    { wch: 15 },
    { wch: 20 },
    { wch: 25 },
    { wch: 18 },
    { wch: 25 },
    { wch: 15 }
  ];
  
  wsCandidates['!cols'] = [
    { wch: 15 },
    { wch: 20 },
    { wch: 25 },
    { wch: 18 },
    { wch: 25 },
    { wch: 15 },
    { wch: 35 }
  ];
  
  // Guardar archivo
  const filePath = path.join(__dirname, 'employees_sample.xlsx');
  XLSX.writeFile(wb, filePath);
  
  console.log(`✓ Archivo Excel generado: ${filePath}`);
  console.log(`  - Hoja "Empleados": ${employeesSample.length} registros`);
  console.log(`  - Hoja "Candidatos": ${candidatesSample.length} registros`);
} catch (err) {
  console.error('Error generando archivo Excel:', err.message);
  process.exit(1);
}
