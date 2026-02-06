// test-create-assignments.js - Crear datos de prueba para asignaciones
const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'BD_afirma',
    password: process.env.DB_PASSWORD || 'password',
    port: 5432,
});

async function createTestAssignments() {
    const client = await pool.connect();
    
    try {
        console.log('🔄 Creando datos de prueba para asignaciones...\n');
        
        // Obtener empleados existentes
        const employeesResult = await client.query(
            'SELECT id, first_name, last_name FROM employees_v2 WHERE status = $1 LIMIT 8',
            ['Activo']
        );
        
        if (employeesResult.rowCount === 0) {
            console.log('⚠️  No hay empleados activos. Ejecuta primero el script de seed.');
            return;
        }
        
        console.log(`✅ Encontrados ${employeesResult.rowCount} empleados activos\n`);
        
        // Obtener proyectos existentes o crear algunos
        let projectsResult = await client.query('SELECT id, name FROM projects LIMIT 5');
        
        if (projectsResult.rowCount === 0) {
            console.log('📋 Creando proyectos de prueba...');
            
            const projects = [
                { name: 'Proyecto Alpha', description: 'Sistema de gestión empresarial', status: 'En Progreso', start_date: '2024-01-01', end_date: '2024-12-31' },
                { name: 'Proyecto Beta', description: 'Portal de clientes', status: 'En Progreso', start_date: '2024-02-01', end_date: '2024-10-31' },
                { name: 'Proyecto Gamma', description: 'Aplicación móvil', status: 'Planificación', start_date: '2024-03-01', end_date: '2024-11-30' },
                { name: 'Proyecto Delta', description: 'Integración de sistemas', status: 'En Progreso', start_date: '2023-12-01', end_date: '2024-08-31' },
                { name: 'Proyecto Epsilon', description: 'Migración a la nube', status: 'Completado', start_date: '2023-06-01', end_date: '2024-01-31' },
            ];
            
            for (const project of projects) {
                await client.query(
                    `INSERT INTO projects (name, description, status, start_date, end_date) 
                     VALUES ($1, $2, $3, $4, $5)`,
                    [project.name, project.description, project.status, project.start_date, project.end_date]
                );
                console.log(`   ✅ Creado: ${project.name}`);
            }
            
            projectsResult = await client.query('SELECT id, name FROM projects LIMIT 5');
            console.log(`\n✅ ${projectsResult.rowCount} proyectos listos\n`);
        }
        
        const employees = employeesResult.rows;
        const projects = projectsResult.rows;
        
        // Limpiar asignaciones existentes (opcional)
        await client.query('DELETE FROM project_assignments');
        console.log('🗑️  Asignaciones anteriores eliminadas\n');
        
        console.log('📊 Creando asignaciones de prueba...\n');
        
        // Crear asignaciones variadas
        const assignments = [
            // Proyecto Alpha - 3 recursos activos
            { project_id: projects[0].id, employee_id: employees[0].id, role: 'Líder Técnico', start_date: '2024-01-15', end_date: null, hours_allocated: 40 },
            { project_id: projects[0].id, employee_id: employees[1].id, role: 'Desarrollador Senior', start_date: '2024-01-20', end_date: null, hours_allocated: 40 },
            { project_id: projects[0].id, employee_id: employees[2].id, role: 'QA Engineer', start_date: '2024-02-01', end_date: null, hours_allocated: 30 },
            
            // Proyecto Beta - 2 recursos activos
            { project_id: projects[1].id, employee_id: employees[3].id, role: 'Frontend Developer', start_date: '2024-02-15', end_date: null, hours_allocated: 40 },
            { project_id: projects[1].id, employee_id: employees[4].id, role: 'UX Designer', start_date: '2024-02-20', end_date: null, hours_allocated: 35 },
            
            // Proyecto Gamma - 1 recurso activo
            { project_id: projects[2].id, employee_id: employees[5].id, role: 'Analista', start_date: '2024-03-01', end_date: null, hours_allocated: 25 },
            
            // Proyecto Delta - 1 recurso activo + 1 finalizado
            { project_id: projects[3].id, employee_id: employees[6].id, role: 'Arquitecto', start_date: '2023-12-15', end_date: null, hours_allocated: 40 },
            { project_id: projects[3].id, employee_id: employees[1].id, role: 'Desarrollador', start_date: '2023-12-15', end_date: '2024-01-15', hours_allocated: 40 },
            
            // Proyecto Epsilon - Completado (asignaciones finalizadas)
            { project_id: projects[4].id, employee_id: employees[0].id, role: 'DevOps Engineer', start_date: '2023-06-01', end_date: '2024-01-31', hours_allocated: 35 },
            { project_id: projects[4].id, employee_id: employees[3].id, role: 'Cloud Specialist', start_date: '2023-06-15', end_date: '2024-01-31', hours_allocated: 40 },
        ];
        
        let createdCount = 0;
        for (const assignment of assignments) {
            try {
                await client.query(
                    `INSERT INTO project_assignments (project_id, employee_id, role, start_date, end_date, hours_allocated)
                     VALUES ($1, $2, $3, $4, $5, $6)`,
                    [assignment.project_id, assignment.employee_id, assignment.role, assignment.start_date, assignment.end_date, assignment.hours_allocated]
                );
                
                const projectName = projects.find(p => p.id === assignment.project_id)?.name || 'Unknown';
                const employeeName = employees.find(e => e.id === assignment.employee_id);
                const empName = employeeName ? `${employeeName.first_name} ${employeeName.last_name}` : 'Unknown';
                const status = assignment.end_date ? '🔴 Finalizado' : '🟢 Activo';
                
                console.log(`   ${status} | ${projectName} → ${empName} (${assignment.role})`);
                createdCount++;
            } catch (err) {
                console.log(`   ⚠️  Error: ${err.message}`);
            }
        }
        
        console.log(`\n✅ ${createdCount} asignaciones creadas exitosamente\n`);
        
        // Resumen
        const summaryResult = await client.query(`
            SELECT 
                COUNT(*) as total,
                COUNT(*) FILTER (WHERE end_date IS NULL OR end_date >= CURRENT_DATE) as active,
                COUNT(*) FILTER (WHERE end_date < CURRENT_DATE) as completed
            FROM project_assignments
        `);
        
        const summary = summaryResult.rows[0];
        console.log('📊 RESUMEN:');
        console.log(`   Total de asignaciones: ${summary.total}`);
        console.log(`   Asignaciones activas: ${summary.active}`);
        console.log(`   Asignaciones finalizadas: ${summary.completed}`);
        
        // Recursos en banca
        const benchResult = await client.query(`
            SELECT COUNT(*) as bench_count
            FROM employees_v2 e
            WHERE e.status = 'Activo'
            AND NOT EXISTS (
                SELECT 1 FROM project_assignments pa
                WHERE pa.employee_id = e.id
                AND (pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE)
            )
        `);
        
        console.log(`   Recursos en banca: ${benchResult.rows[0].bench_count}\n`);
        
        console.log('✅ Datos de prueba creados exitosamente\n');
        console.log('🎯 Ahora puedes abrir http://127.0.0.1:8082 y navegar a:');
        console.log('   - Asignaciones: Ver todas las asignaciones');
        console.log('   - Reportes: Ver análisis y estadísticas');
        console.log('   - Proyectos: Ver proyectos y sus recursos (tab Asignaciones)');
        console.log('   - Empleados: Ver empleados y su historial (tab Asignaciones)\n');
        
    } catch (err) {
        console.error('❌ Error:', err);
    } finally {
        client.release();
        await pool.end();
    }
}

createTestAssignments();
