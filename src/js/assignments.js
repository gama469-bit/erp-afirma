// assignments.js - Gestión de Asignaciones de Recursos a Proyectos

let currentAssignments = [];
let currentBenchResources = [];
let allProjects = [];

// Cargar asignaciones
async function loadAssignments(filters = {}) {
    const loadingEl = document.getElementById('assignment-grid-loading');
    const tableEl = document.getElementById('assignment-table');
    const emptyEl = document.getElementById('assignment-grid-empty');
    
    if (loadingEl) loadingEl.style.display = 'block';
    if (tableEl) tableEl.style.display = 'none';
    if (emptyEl) emptyEl.style.display = 'none';
    
    try {
        // Cargar todas las asignaciones
        const response = await fetch(window.getApiUrl('/api/projects/assignments'));
        if (!response.ok) throw new Error('Error al cargar asignaciones');
        
        currentAssignments = await response.json();
        
        // Aplicar filtros
        let filteredAssignments = currentAssignments;
        
        if (filters.employee_id) {
            filteredAssignments = filteredAssignments.filter(a => a.employee_id == filters.employee_id);
        }
        
        if (filters.project_id) {
            filteredAssignments = filteredAssignments.filter(a => a.project_id == filters.project_id);
        }
        
        if (filters.status === 'active') {
            filteredAssignments = filteredAssignments.filter(a => a.is_active === true);
        } else if (filters.status === 'completed') {
            filteredAssignments = filteredAssignments.filter(a => a.is_active === false);
        }
        
        if (loadingEl) loadingEl.style.display = 'none';
        
        if (filteredAssignments.length === 0) {
            if (emptyEl) emptyEl.style.display = 'block';
        } else {
            renderAssignmentsTable(filteredAssignments);
            if (tableEl) tableEl.style.display = 'table';
        }
        
        // Cargar indicador de banca
        await loadBenchIndicator();
        
    } catch (err) {
        console.error('Error loading assignments:', err);
        if (loadingEl) loadingEl.style.display = 'none';
        if (emptyEl) {
            emptyEl.style.display = 'block';
            emptyEl.innerHTML = `
                <div style="font-size:48px;margin-bottom:10px">⚠️</div>
                <div style="font-size:18px;margin-bottom:5px;color:#dc3545">Error al cargar asignaciones</div>
                <div style="font-size:14px">${err.message}</div>
            `;
        }
    }
}

// Renderizar tabla de asignaciones
function renderAssignmentsTable(assignments) {
    const tbody = document.getElementById('assignment-table-body');
    if (!tbody) return;
    
    tbody.innerHTML = assignments.map(assignment => `
        <tr>
            <td>${assignment.id}</td>
            <td>${assignment.first_name || ''} ${assignment.last_name || ''}</td>
            <td>${assignment.position || '-'}</td>
            <td>${assignment.project_name || '-'}</td>
            <td>${assignment.role || '-'}</td>
            <td>${assignment.start_date ? new Date(assignment.start_date).toLocaleDateString('es-MX') : '-'}</td>
            <td>${assignment.end_date ? new Date(assignment.end_date).toLocaleDateString('es-MX') : 'Indefinida'}</td>
            <td>${assignment.hours_allocated || '-'} hrs/sem</td>
            <td>
                <span style="padding:4px 8px;border-radius:4px;font-size:12px;font-weight:500;
                    ${assignment.is_active ? 'background:#d4edda;color:#155724' : 'background:#f8d7da;color:#721c24'}">
                    ${assignment.status || (assignment.is_active ? 'Activo' : 'Finalizado')}
                </span>
            </td>
            <td>
                ${assignment.is_active ? `
                    <button onclick="openEditAssignment(${assignment.id})" class="btn-secondary" style="padding:4px 8px;font-size:12px">✏️ Editar</button>
                    <button onclick="finishAssignment(${assignment.id})" class="btn-secondary" style="padding:4px 8px;font-size:12px;background:#dc3545;color:white">🏁 Finalizar</button>
                ` : `
                    <span style="color:#999">Finalizada</span>
                `}
            </td>
        </tr>
    `).join('');
}

// Cargar indicador de banca
async function loadBenchIndicator() {
    try {
        const response = await fetch(window.getApiUrl('/api/employees/unassigned'));
        if (!response.ok) throw new Error('Error al cargar recursos en banca');
        
        const data = await response.json();
        currentBenchResources = data.bench_resources || [];
        
        const indicator = document.getElementById('bench-indicator');
        const countEl = document.getElementById('bench-count');
        
        if (indicator && countEl) {
            countEl.textContent = data.total_available || 0;
            indicator.style.display = data.total_available > 0 ? 'block' : 'none';
        }
    } catch (err) {
        console.error('Error loading bench indicator:', err);
    }
}

// Abrir modal de nueva asignación
function openAssignmentModal() {
    const modal = document.getElementById('assignment-modal');
    const title = document.getElementById('assignment-modal-title');
    const form = document.getElementById('assignment-form');
    
    if (!modal || !title || !form) return;
    
    title.textContent = 'Nueva Asignación';
    form.reset();
    document.getElementById('assignment-id').value = '';
    
    // Ocultar alerta de conflicto
    const alert = document.getElementById('assignment-conflict-alert');
    if (alert) alert.style.display = 'none';
    
    loadProjectsDropdown();
    loadAvailableEmployees();
    
    modal.style.display = 'block';
}

// Cargar proyectos en dropdown
async function loadProjectsDropdown() {
    try {
        const response = await fetch(window.getApiUrl('/api/projects'));
        if (!response.ok) throw new Error('Error al cargar proyectos');
        
        allProjects = await response.json();
        const select = document.getElementById('assignment-project');
        
        if (select) {
            select.innerHTML = '<option value="">Seleccionar proyecto...</option>' +
                allProjects
                    .map(p => `<option value="${p.id}">${p.name}</option>`)
                    .join('');
        }
    } catch (err) {
        console.error('Error loading projects:', err);
    }
}

// Cargar empleados disponibles (sin asignaciones activas)
async function loadAvailableEmployees() {
    try {
        const response = await fetch(window.getApiUrl('/api/employees-v2'));
        if (!response.ok) throw new Error('Error al cargar empleados disponibles');
        
        const employees = await response.json();
        const activeEmployees = employees.filter(e => e.status === 'Activo');
        
        const select = document.getElementById('assignment-employee');
        if (select) {
            select.innerHTML = '<option value="">Seleccionar empleado...</option>' +
                activeEmployees.map(e => 
                    `<option value="${e.id}">${e.first_name} ${e.last_name} - ${e.position_name || 'Sin puesto'}</option>`
                ).join('');
        }
    } catch (err) {
        console.error('Error loading available employees:', err);
    }
}

// Guardar asignación
async function saveAssignment(event) {
    event.preventDefault();
    
    const assignmentId = document.getElementById('assignment-id')?.value;
    const projectId = document.getElementById('assignment-project')?.value;
    const employeeId = document.getElementById('assignment-employee')?.value;
    const role = document.getElementById('assignment-role')?.value;
    const startDate = document.getElementById('assignment-start-date')?.value;
    const endDate = document.getElementById('assignment-end-date')?.value;
    const hours = document.getElementById('assignment-hours')?.value;
    
    if (!projectId || !employeeId || !startDate) {
        Swal.fire({
            icon: 'warning',
            title: 'Campos requeridos',
            text: 'Por favor completa todos los campos requeridos: Proyecto, Empleado y Fecha de inicio'
        });
        return;
    }
    
    const assignmentData = {
        employee_id: parseInt(employeeId),
        role: role || null,
        start_date: startDate,
        end_date: endDate || null,
        hours_allocated: hours ? parseFloat(hours) : null
    };
    
    try {
        const url = window.getApiUrl(`/api/projects/${projectId}/assignments`);
        const method = 'POST';
        
        const response = await fetch(url, {
            method: method,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(assignmentData)
        });
        
        if (response.status === 409) {
            // Conflicto: empleado ya tiene asignación activa
            const error = await response.json();
            showAssignmentConflict(error.details?.message || error.error);
            return;
        }
        
        if (!response.ok) {
            const error = await response.json();
            throw new Error(error.error || 'Error al guardar asignación');
        }
        
        Swal.fire({
            icon: 'success',
            title: 'Asignación guardada',
            text: 'La asignación se guardó correctamente',
            timer: 2000,
            showConfirmButton: false
        });
        closeAssignmentModal(true); // true = skip confirmation
        loadAssignments();
        
    } catch (err) {
        console.error('Error saving assignment:', err);
        Swal.fire({
            icon: 'error',
            title: 'Error al guardar asignación',
            text: err.message
        });
    }
}

// Mostrar alerta de conflicto de asignación
function showAssignmentConflict(message) {
    const alert = document.getElementById('assignment-conflict-alert');
    const messageEl = document.getElementById('assignment-conflict-message');
    
    if (alert && messageEl) {
        messageEl.textContent = message;
        alert.style.display = 'block';
        
        // Scroll hacia la alerta
        alert.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
}

// Finalizar asignación
async function finishAssignment(assignmentId) {
    const result = await Swal.fire({
        title: '¿Finalizar asignación?',
        text: 'Se establecerá la fecha fin como hoy',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Sí, finalizar',
        cancelButtonText: 'Cancelar'
    });
    
    if (!result.isConfirmed) return;
    
    const today = new Date().toISOString().split('T')[0];
    
    try {
        const response = await fetch(window.getApiUrl(`/api/projects/assignments/${assignmentId}`), {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ end_date: today })
        });
        
        if (!response.ok) throw new Error('Error al finalizar asignación');
        
        Swal.fire({
            icon: 'success',
            title: 'Asignación finalizada',
            text: 'La asignación se finalizó correctamente',
            timer: 2000,
            showConfirmButton: false
        });
        loadAssignments();
        
    } catch (err) {
        console.error('Error finishing assignment:', err);
        Swal.fire({
            icon: 'error',
            title: 'Error al finalizar asignación',
            text: err.message
        });
    }
}

// Cerrar modal de asignaciones
async function closeAssignmentModal(skipConfirmation = false) {
    if (!skipConfirmation) {
        const result = await Swal.fire({
            title: '¿Cancelar asignación?',
            text: 'Los cambios no guardados se perderán',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Sí, cancelar',
            cancelButtonText: 'Continuar editando',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6'
        });
        if (!result.isConfirmed) return;
    }
    const modal = document.getElementById('assignment-modal');
    if (modal) {
        modal.style.display = 'none';
        const form = document.getElementById('assignment-form');
        if (form) form.reset();
    }
}

// Ver detalles de recursos en banca
async function openBenchModal() {
    const modal = document.getElementById('bench-modal');
    const loadingEl = document.getElementById('bench-grid-loading');
    const tableEl = document.getElementById('bench-table');
    const emptyEl = document.getElementById('bench-grid-empty');
    
    if (!modal) return;
    
    modal.style.display = 'block';
    
    if (loadingEl) loadingEl.style.display = 'block';
    if (tableEl) tableEl.style.display = 'none';
    if (emptyEl) emptyEl.style.display = 'none';
    
    try {
        const response = await fetch(window.getApiUrl('/api/employees/unassigned'));
        if (!response.ok) throw new Error('Error al cargar recursos en banca');
        
        const data = await response.json();
        const resources = data.bench_resources || [];
        
        if (loadingEl) loadingEl.style.display = 'none';
        
        if (resources.length === 0) {
            if (emptyEl) emptyEl.style.display = 'block';
        } else {
            renderBenchTable(resources);
            if (tableEl) tableEl.style.display = 'table';
        }
        
    } catch (err) {
        console.error('Error loading bench resources:', err);
        if (loadingEl) loadingEl.style.display = 'none';
        alert('Error al cargar recursos: ' + err.message);
    }
}

// Renderizar tabla de recursos en banca
function renderBenchTable(resources) {
    const tbody = document.getElementById('bench-table-body');
    if (!tbody) return;
    
    tbody.innerHTML = resources.map(resource => `
        <tr>
            <td>${resource.first_name || ''} ${resource.last_name || ''}</td>
            <td>${resource.position || '-'}</td>
            <td>${resource.area || '-'}</td>
            <td>${resource.entity || '-'}</td>
            <td>${resource.last_assignment_end ? new Date(resource.last_assignment_end).toLocaleDateString('es-MX') : 'Nunca asignado'}</td>
            <td>
                <span style="padding:4px 8px;border-radius:4px;font-size:12px;font-weight:500;background:#fff3cd;color:#856404">
                    ${resource.days_without_project || 0} días
                </span>
            </td>
            <td>
                <button onclick="assignEmployee(${resource.id})" class="btn-primary" style="padding:4px 8px;font-size:12px">
                    ➕ Asignar
                </button>
            </td>
        </tr>
    `).join('');
}

// Asignar empleado desde la modal de banca
function assignEmployee(employeeId) {
    closeBenchModal();
    openAssignmentModal();
    
    // Pre-seleccionar el empleado
    setTimeout(() => {
        const select = document.getElementById('assignment-employee');
        if (select) {
            select.value = employeeId;
        }
    }, 100);
}

// Cerrar modal de banca
function closeBenchModal() {
    const modal = document.getElementById('bench-modal');
    if (modal) modal.style.display = 'none';
}

// Cargar dropdowns de filtros
async function loadAssignmentFilters() {
    try {
        // Cargar empleados
        const empResponse = await fetch(window.getApiUrl('/api/employees-v2'));
        if (empResponse.ok) {
            const employees = await empResponse.json();
            const empSelect = document.getElementById('filter-assignment-employee');
            if (empSelect) {
                empSelect.innerHTML = '<option value="">👤 Todos los empleados</option>' +
                    employees.map(e => `<option value="${e.id}">${e.first_name} ${e.last_name || ''}</option>`).join('');
            }
        }
        
        // Cargar proyectos
        const projResponse = await fetch(window.getApiUrl('/api/projects'));
        if (projResponse.ok) {
            const projects = await projResponse.json();
            const projSelect = document.getElementById('filter-assignment-project');
            if (projSelect) {
                projSelect.innerHTML = '<option value="">📋 Todos los proyectos</option>' +
                    projects.map(p => `<option value="${p.id}">${p.name}</option>`).join('');
            }
        }
    } catch (err) {
        console.error('Error loading assignment filters:', err);
    }
}

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Botón agregar asignación
    const addBtn = document.getElementById('add-assignment-btn');
    if (addBtn) {
        addBtn.addEventListener('click', openAssignmentModal);
    }
    
    // Botón cerrar modal
    const closeBtn = document.getElementById('assignment-modal-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', async () => await closeAssignmentModal());
    }
    
    // Botón cancelar
    const cancelBtn = document.getElementById('assignment-cancel');
    if (cancelBtn) {
        cancelBtn.addEventListener('click', async () => await closeAssignmentModal());
    }
    
    // Formulario
    const form = document.getElementById('assignment-form');
    if (form) {
        form.addEventListener('submit', saveAssignment);
    }
    
    // Botón ver detalles de banca
    const viewBenchBtn = document.getElementById('view-bench-details');
    if (viewBenchBtn) {
        viewBenchBtn.addEventListener('click', openBenchModal);
    }
    
    // Botón cerrar modal de banca
    const closeBenchBtn = document.getElementById('bench-modal-close');
    if (closeBenchBtn) {
        closeBenchBtn.addEventListener('click', closeBenchModal);
    }
    
    // Botones de filtros
    const searchBtn = document.getElementById('filter-assignment-search-btn');
    if (searchBtn) {
        searchBtn.addEventListener('click', () => {
            const filters = {
                employee_id: document.getElementById('filter-assignment-employee')?.value,
                project_id: document.getElementById('filter-assignment-project')?.value,
                status: document.getElementById('filter-assignment-status')?.value
            };
            loadAssignments(filters);
        });
    }
    
    const clearBtn = document.getElementById('filter-assignment-clear-btn');
    if (clearBtn) {
        clearBtn.addEventListener('click', () => {
            document.getElementById('filter-assignment-employee').value = '';
            document.getElementById('filter-assignment-project').value = '';
            document.getElementById('filter-assignment-status').value = '';
            loadAssignments();
        });
    }
    
    // Botón asignar recurso desde modal de proyecto
    const projectAddAssignmentBtn = document.getElementById('project-add-assignment');
    if (projectAddAssignmentBtn) {
        projectAddAssignmentBtn.addEventListener('click', openAssignmentModalFromProject);
    }
});

// Exponer funciones globalmente
window.loadAssignments = loadAssignments;
window.openAssignmentModal = openAssignmentModal;
window.closeAssignmentModal = closeAssignmentModal;
window.assignEmployee = assignEmployee;
window.finishAssignment = finishAssignment;
window.openBenchModal = openBenchModal;
window.closeBenchModal = closeBenchModal;
window.loadAssignmentFilters = loadAssignmentFilters;
window.loadEmployeeAssignments = loadEmployeeAssignments;
window.loadProjectAssignments = loadProjectAssignments;

// Cargar asignaciones de un empleado específico (para modal de empleado)
async function loadEmployeeAssignments(employeeId) {
    const loadingEl = document.getElementById('employee-assignments-loading');
    const emptyEl = document.getElementById('employee-assignments-empty');
    const containerEl = document.getElementById('employee-assignments-container');
    const tbodyEl = document.getElementById('employee-assignments-tbody');
    
    if (!employeeId) {
        if (emptyEl) emptyEl.style.display = 'block';
        if (loadingEl) loadingEl.style.display = 'none';
        if (containerEl) containerEl.style.display = 'none';
        return;
    }
    
    if (loadingEl) loadingEl.style.display = 'block';
    if (emptyEl) emptyEl.style.display = 'none';
    if (containerEl) containerEl.style.display = 'none';
    
    try {
        const response = await fetch(window.getApiUrl(`/api/employees/${employeeId}/assignments`));
        if (!response.ok) throw new Error('Error al cargar asignaciones del empleado');
        
        const data = await response.json();
        const assignments = data.assignments || [];
        const summary = data.summary || {};
        
        if (loadingEl) loadingEl.style.display = 'none';
        
        if (assignments.length === 0) {
            if (emptyEl) emptyEl.style.display = 'block';
        } else {
            // Actualizar resumen
            document.getElementById('emp-total-projects').textContent = summary.total_projects || 0;
            document.getElementById('emp-active-projects').textContent = summary.active_projects || 0;
            document.getElementById('emp-completed-projects').textContent = summary.completed_projects || 0;
            document.getElementById('emp-total-hours').textContent = summary.total_hours_allocated || 0;
            
            // Renderizar tabla
            if (tbodyEl) {
                tbodyEl.innerHTML = assignments.map(a => `
                    <tr>
                        <td>${a.project_name || '-'}</td>
                        <td>${a.role || '-'}</td>
                        <td>${a.start_date ? new Date(a.start_date).toLocaleDateString('es-MX') : '-'}</td>
                        <td>${a.end_date ? new Date(a.end_date).toLocaleDateString('es-MX') : 'Indefinida'}</td>
                        <td>${a.hours_allocated || '-'} hrs/sem</td>
                        <td>
                            <span style="padding:4px 8px;border-radius:4px;font-size:12px;font-weight:500;
                                ${a.is_active ? 'background:#d4edda;color:#155724' : 'background:#f8d7da;color:#721c24'}">
                                ${a.is_active ? 'Activo' : 'Finalizado'}
                            </span>
                        </td>
                    </tr>
                `).join('');
            }
            
            if (containerEl) containerEl.style.display = 'block';
        }
        
    } catch (err) {
        console.error('Error loading employee assignments:', err);
        if (loadingEl) loadingEl.style.display = 'none';
        if (emptyEl) {
            emptyEl.style.display = 'block';
            emptyEl.innerHTML = `
                <div style="font-size:32px;margin-bottom:10px;color:#dc3545">⚠️</div>
                <div>Error al cargar asignaciones: ${err.message}</div>
            `;
        }
    }
}

// Cargar asignaciones de un proyecto específico (para modal de proyecto)
async function loadProjectAssignments(projectId) {
    const loadingEl = document.getElementById('project-assignments-loading');
    const emptyEl = document.getElementById('project-assignments-empty');
    const tableEl = document.getElementById('project-assignments-table');
    const tbodyEl = document.getElementById('project-assignments-tbody');
    
    if (!projectId) {
        if (emptyEl) emptyEl.style.display = 'block';
        if (loadingEl) loadingEl.style.display = 'none';
        if (tableEl) tableEl.style.display = 'none';
        return;
    }
    
    if (loadingEl) loadingEl.style.display = 'block';
    if (emptyEl) emptyEl.style.display = 'none';
    if (tableEl) tableEl.style.display = 'none';
    
    try {
        const response = await fetch(window.getApiUrl(`/api/projects/${projectId}/assignments`));
        if (!response.ok) throw new Error('Error al cargar asignaciones del proyecto');
        
        const assignments = await response.json();
        
        if (loadingEl) loadingEl.style.display = 'none';
        
        if (assignments.length === 0) {
            if (emptyEl) emptyEl.style.display = 'block';
        } else {
            if (tbodyEl) {
                tbodyEl.innerHTML = assignments.map(a => `
                    <tr>
                        <td>${a.first_name || ''} ${a.last_name || ''}</td>
                        <td>${a.position || '-'}</td>
                        <td>${a.role || '-'}</td>
                        <td>${a.start_date ? new Date(a.start_date).toLocaleDateString('es-MX') : '-'}</td>
                        <td>${a.end_date ? new Date(a.end_date).toLocaleDateString('es-MX') : 'Indefinida'}</td>
                        <td>${a.hours_allocated || '-'} hrs/sem</td>
                        <td>
                            <span style="padding:4px 8px;border-radius:4px;font-size:12px;font-weight:500;
                                ${a.is_active ? 'background:#d4edda;color:#155724' : 'background:#f8d7da;color:#721c24'}">
                                ${a.status || (a.is_active ? 'Activo' : 'Finalizado')}
                            </span>
                        </td>
                        <td>
                            ${a.is_active ? `
                                <button onclick="finishAssignmentFromProject(${a.id})" class="btn-secondary" style="padding:4px 8px;font-size:12px;background:#dc3545;color:white">
                                    🏁 Finalizar
                                </button>
                            ` : `<span style="color:#999">Finalizada</span>`}
                        </td>
                    </tr>
                `).join('');
            }
            
            if (tableEl) tableEl.style.display = 'table';
        }
        
    } catch (err) {
        console.error('Error loading project assignments:', err);
        if (loadingEl) loadingEl.style.display = 'none';
        if (emptyEl) {
            emptyEl.style.display = 'block';
            emptyEl.innerHTML = `
                <div style="font-size:32px;margin-bottom:10px;color:#dc3545">⚠️</div>
                <div>Error al cargar asignaciones: ${err.message}</div>
            `;
        }
    }
}

// Finalizar asignación desde el modal de proyecto
async function finishAssignmentFromProject(assignmentId) {
    const result = await Swal.fire({
        title: '¿Finalizar asignación?',
        text: 'Se establecerá la fecha fin como hoy',
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: 'Sí, finalizar',
        cancelButtonText: 'Cancelar'
    });
    
    if (!result.isConfirmed) return;
    
    const today = new Date().toISOString().split('T')[0];
    
    try {
        const response = await fetch(window.getApiUrl(`/api/projects/assignments/${assignmentId}`), {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ end_date: today })
        });
        
        if (!response.ok) throw new Error('Error al finalizar asignación');
        
        Swal.fire({
            icon: 'success',
            title: 'Asignación finalizada',
            text: 'La asignación se finalizó correctamente',
            timer: 2000,
            showConfirmButton: false
        });
        
        // Recargar asignaciones del proyecto actual
        const projectId = document.getElementById('project-id').value;
        if (projectId) {
            loadProjectAssignments(projectId);
        }
        
    } catch (err) {
        console.error('Error finishing assignment:', err);
        alert('Error: ' + err.message);
    }
}

// Manejar botón "Asignar Recurso" desde modal de proyecto
function openAssignmentModalFromProject() {
    const projectId = document.getElementById('project-id').value;
    
    if (!projectId) {
        alert('Primero guarda el proyecto antes de asignar recursos');
        return;
    }
    
    // Cerrar modal de proyecto
    const projectModal = document.getElementById('project-modal');
    if (projectModal) projectModal.style.display = 'none';
    
    // Abrir modal de asignación
    openAssignmentModal();
    
    // Pre-seleccionar el proyecto
    setTimeout(() => {
        const projectSelect = document.getElementById('assignment-project');
        if (projectSelect) {
            projectSelect.value = projectId;
        }
    }, 100);
}

// Exponer funciones adicionales
window.finishAssignmentFromProject = finishAssignmentFromProject;
window.openAssignmentModalFromProject = openAssignmentModalFromProject;
