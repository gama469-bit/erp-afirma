// licitaciones.js - Gestión de Licitaciones

let currentLicitaciones = [];
let allCelulas = [];

// Cargar licitaciones
async function loadLicitaciones(filters = {}) {
    const loadingEl = document.getElementById('licitacion-grid-loading');
    const tableEl = document.getElementById('licitacion-table');
    const emptyEl = document.getElementById('licitacion-grid-empty');
    
    if (loadingEl) loadingEl.style.display = 'block';
    if (tableEl) tableEl.style.display = 'none';
    if (emptyEl) emptyEl.style.display = 'none';
    
    try {
        const response = await fetch(window.getApiUrl('/api/licitaciones'));
        if (!response.ok) throw new Error('Error al cargar licitaciones');
        
        currentLicitaciones = await response.json();
        
        // Aplicar filtros
        let filteredLicitaciones = currentLicitaciones;
        
        if (filters.name) {
            const searchTerm = filters.name.toLowerCase();
            filteredLicitaciones = filteredLicitaciones.filter(l => 
                (l.nombre && l.nombre.toLowerCase().includes(searchTerm)) ||
                (l.nombre_proyecto && l.nombre_proyecto.toLowerCase().includes(searchTerm))
            );
        }
        
        if (filters.estado) {
            filteredLicitaciones = filteredLicitaciones.filter(l => 
                l.estado === filters.estado
            );
        }
        
        if (loadingEl) loadingEl.style.display = 'none';
        
        if (filteredLicitaciones.length === 0) {
            if (emptyEl) emptyEl.style.display = 'block';
        } else {
            renderLicitacionesTable(filteredLicitaciones);
            if (tableEl) tableEl.style.display = 'table';
        }
        
    } catch (err) {
        console.error('Error loading licitaciones:', err);
        if (loadingEl) loadingEl.style.display = 'none';
        if (emptyEl) {
            emptyEl.style.display = 'block';
            emptyEl.innerHTML = `
                <div style="font-size:48px;margin-bottom:10px">⚠️</div>
                <div style="font-size:18px;margin-bottom:5px;color:#dc3545">Error al cargar licitaciones</div>
                <div style="font-size:14px;color:#6c757d">${err.message}</div>
            `;
        }
    }
}

// Renderizar tabla de licitaciones
function renderLicitacionesTable(licitaciones) {
    const tbody = document.getElementById('licitacion-table-body');
    if (!tbody) return;
    
    tbody.innerHTML = licitaciones.map(licitacion => {
        // Color del badge según estado
        let estadoBadge = '';
        switch (licitacion.estado) {
            case 'Solicitado':
                estadoBadge = '<span style="background:#e0f2fe;color:#0369a1;padding:4px 12px;border-radius:12px;font-size:12px;font-weight:600">📝 Solicitado</span>';
                break;
            case 'En Progreso':
                estadoBadge = '<span style="background:#fef3c7;color:#92400e;padding:4px 12px;border-radius:12px;font-size:12px;font-weight:600">⏳ En Progreso</span>';
                break;
            case 'Adquirida':
                estadoBadge = '<span style="background:#d1fae5;color:#065f46;padding:4px 12px;border-radius:12px;font-size:12px;font-weight:600">✅ Adquirida</span>';
                break;
            case 'No Ganada':
                estadoBadge = '<span style="background:#fee2e2;color:#991b1b;padding:4px 12px;border-radius:12px;font-size:12px;font-weight:600">❌ No Ganada</span>';
                break;
            default:
                estadoBadge = `<span style="background:#f3f4f6;color:#6b7280;padding:4px 12px;border-radius:12px;font-size:12px">${licitacion.estado || 'Sin estado'}</span>`;
        }
        
        return `
            <tr>
                <td>${licitacion.id}</td>
                <td>
                    <div style="font-weight:600;color:#1f2937">${licitacion.nombre || '-'}</div>
                </td>
                <td>${licitacion.nombre_proyecto || '-'}</td>
                <td>
                    ${licitacion.celula_name 
                        ? `<span style="background:#e0f2fe;color:#0369a1;padding:2px 8px;border-radius:4px;font-size:11px">${licitacion.celula_name}</span>`
                        : '<span style="color:#999">Sin célula</span>'
                    }
                </td>
                <td>${licitacion.clientes || '-'}</td>
                <td>${licitacion.responsable_negocio || '-'}</td>
                <td>${estadoBadge}</td>
                <td>
                    <div style="display:flex;gap:8px">
                        <button onclick="viewLicitacion(${licitacion.id})" class="btn-icon" title="Ver detalles">👁️</button>
                        <button onclick="editLicitacion(${licitacion.id})" class="btn-icon" title="Editar">✏️</button>
                        <button onclick="deleteLicitacion(${licitacion.id})" class="btn-icon" title="Eliminar">🗑️</button>
                    </div>
                </td>
            </tr>
        `;
    }).join('');
}

// Cargar células para el dropdown
async function loadCelulasForDropdown() {
    try {
        const response = await fetch(window.getApiUrl('/api/mastercode/Celulas'));
        if (!response.ok) throw new Error('Error al cargar células');
        allCelulas = await response.json();
        return allCelulas;
    } catch (err) {
        console.error('Error loading celulas:', err);
        return [];
    }
}

// Ver detalles de licitación
async function viewLicitacion(id) {
    const licitacion = currentLicitaciones.find(l => l.id === id);
    if (!licitacion) {
        alert('Licitación no encontrada');
        return;
    }
    
    const html = `
        <div style="text-align:left;padding:20px">
            <div style="margin-bottom:20px">
                <div style="font-size:12px;color:#6b7280;margin-bottom:4px">Nombre de la Licitación:</div>
                <div style="font-size:18px;font-weight:600;color:#1f2937">${licitacion.nombre || '-'}</div>
            </div>
            
            <div style="margin-bottom:20px">
                <div style="font-size:12px;color:#6b7280;margin-bottom:4px">Nombre del Proyecto:</div>
                <div style="font-size:16px;color:#1f2937">${licitacion.nombre_proyecto || '-'}</div>
            </div>
            
            <div style="margin-bottom:20px">
                <div style="font-size:12px;color:#6b7280;margin-bottom:4px">Célula Asignada:</div>
                <div style="font-size:16px;color:#1f2937">${licitacion.celula_name || 'Sin célula asignada'}</div>
            </div>
            
            <div style="margin-bottom:20px">
                <div style="font-size:12px;color:#6b7280;margin-bottom:4px">Clientes:</div>
                <div style="font-size:16px;color:#1f2937">${licitacion.clientes || '-'}</div>
            </div>
            
            <div style="margin-bottom:20px">
                <div style="font-size:12px;color:#6b7280;margin-bottom:4px">Responsable de Negocio:</div>
                <div style="font-size:16px;color:#1f2937">${licitacion.responsable_negocio || '-'}</div>
            </div>
            
            <div style="margin-bottom:20px">
                <div style="font-size:12px;color:#6b7280;margin-bottom:4px">Estado:</div>
                <div style="font-size:16px;font-weight:600;color:#3b82f6">${licitacion.estado || '-'}</div>
            </div>
            
            <div style="font-size:12px;color:#999;margin-top:20px">
                Creado: ${new Date(licitacion.created_at).toLocaleString('es-MX')}
            </div>
        </div>
    `;
    
    Swal.fire({
        html: html,
        width: 600,
        showConfirmButton: true,
        confirmButtonText: 'Cerrar'
    });
}

// Abrir modal para agregar licitación
async function openAddLicitacionModal() {
    // Cargar células
    const celulas = await loadCelulasForDropdown();
    
    const celulasOptions = celulas.map(c => `<option value="${c.id}">${c.item}</option>`).join('');
    
    const { value: formValues } = await Swal.fire({
        title: 'Nueva Solicitud de Licitación',
        html: `
            <div style="text-align:left;padding:0 20px">
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Nombre de la Licitación *</label>
                    <input id="swal-nombre" class="swal2-input" placeholder="Nombre de la licitación" style="width:100%;margin:0">
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Célula</label>
                    <select id="swal-celula" class="swal2-input" style="width:100%;margin:0">
                        <option value="">Sin célula asignada</option>
                        ${celulasOptions}
                    </select>
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Nombre del Proyecto *</label>
                    <input id="swal-proyecto" class="swal2-input" placeholder="Nombre del proyecto" style="width:100%;margin:0">
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Clientes</label>
                    <textarea id="swal-clientes" class="swal2-textarea" placeholder="Nombres de los clientes" style="width:100%;margin:0;min-height:60px"></textarea>
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Responsable de Negocio</label>
                    <input id="swal-responsable" class="swal2-input" placeholder="Nombre del responsable" style="width:100%;margin:0">
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Estado *</label>
                    <select id="swal-estado" class="swal2-select" style="width:100%;margin:0">
                        <option value="Solicitado">Solicitado</option>
                        <option value="En Progreso">En Progreso</option>
                        <option value="Adquirida">Adquirida</option>
                        <option value="No Ganada">No Ganada</option>
                    </select>
                </div>
            </div>
        `,
        width: 600,
        focusConfirm: false,
        showCancelButton: true,
        confirmButtonText: 'Crear',
        cancelButtonText: 'Cancelar',
        preConfirm: () => {
            const nombre = document.getElementById('swal-nombre').value;
            const celula_id = document.getElementById('swal-celula').value;
            const nombre_proyecto = document.getElementById('swal-proyecto').value;
            const clientes = document.getElementById('swal-clientes').value;
            const responsable_negocio = document.getElementById('swal-responsable').value;
            const estado = document.getElementById('swal-estado').value;
            
            if (!nombre || !nombre_proyecto) {
                Swal.showValidationMessage('Los campos Nombre y Nombre del Proyecto son requeridos');
                return false;
            }
            
            return { nombre, celula_id, nombre_proyecto, clientes, responsable_negocio, estado };
        }
    });
    
    if (formValues) {
        try {
            const response = await fetch(window.getApiUrl('/api/licitaciones'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formValues)
            });
            
            if (!response.ok) throw new Error('Error al crear licitación');
            
            Swal.fire({
                icon: 'success',
                title: 'Licitación creada',
                text: 'La licitación se creó correctamente',
                timer: 2000,
                showConfirmButton: false
            });
            
            loadLicitaciones();
        } catch (err) {
            console.error('Error creating licitacion:', err);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'No se pudo crear la licitación: ' + err.message
            });
        }
    }
}

// Editar licitación
async function editLicitacion(id) {
    const licitacion = currentLicitaciones.find(l => l.id === id);
    if (!licitacion) {
        alert('Licitación no encontrada');
        return;
    }
    
    // Cargar células
    const celulas = await loadCelulasForDropdown();
    const celulasOptions = celulas.map(c => 
        `<option value="${c.id}" ${c.id == licitacion.celula_id ? 'selected' : ''}>${c.item}</option>`
    ).join('');
    
    const { value: formValues } = await Swal.fire({
        title: 'Editar Licitación',
        html: `
            <div style="text-align:left;padding:0 20px">
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Nombre de la Licitación *</label>
                    <input id="swal-nombre" class="swal2-input" value="${licitacion.nombre || ''}" placeholder="Nombre de la licitación" style="width:100%;margin:0">
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Célula</label>
                    <select id="swal-celula" class="swal2-input" style="width:100%;margin:0">
                        <option value="">Sin célula asignada</option>
                        ${celulasOptions}
                    </select>
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Nombre del Proyecto *</label>
                    <input id="swal-proyecto" class="swal2-input" value="${licitacion.nombre_proyecto || ''}" placeholder="Nombre del proyecto" style="width:100%;margin:0">
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Clientes</label>
                    <textarea id="swal-clientes" class="swal2-textarea" placeholder="Nombres de los clientes" style="width:100%;margin:0;min-height:60px">${licitacion.clientes || ''}</textarea>
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Responsable de Negocio</label>
                    <input id="swal-responsable" class="swal2-input" value="${licitacion.responsable_negocio || ''}" placeholder="Nombre del responsable" style="width:100%;margin:0">
                </div>
                
                <div style="margin-bottom:16px">
                    <label style="display:block;margin-bottom:4px;font-weight:600;font-size:14px">Estado *</label>
                    <select id="swal-estado" class="swal2-select" style="width:100%;margin:0">
                        <option value="Solicitado" ${licitacion.estado === 'Solicitado' ? 'selected' : ''}>Solicitado</option>
                        <option value="En Progreso" ${licitacion.estado === 'En Progreso' ? 'selected' : ''}>En Progreso</option>
                        <option value="Adquirida" ${licitacion.estado === 'Adquirida' ? 'selected' : ''}>Adquirida</option>
                        <option value="No Ganada" ${licitacion.estado === 'No Ganada' ? 'selected' : ''}>No Ganada</option>
                    </select>
                </div>
            </div>
        `,
        width: 600,
        focusConfirm: false,
        showCancelButton: true,
        confirmButtonText: 'Guardar',
        cancelButtonText: 'Cancelar',
        preConfirm: () => {
            const nombre = document.getElementById('swal-nombre').value;
            const celula_id = document.getElementById('swal-celula').value;
            const nombre_proyecto = document.getElementById('swal-proyecto').value;
            const clientes = document.getElementById('swal-clientes').value;
            const responsable_negocio = document.getElementById('swal-responsable').value;
            const estado = document.getElementById('swal-estado').value;
            
            if (!nombre || !nombre_proyecto) {
                Swal.showValidationMessage('Los campos Nombre y Nombre del Proyecto son requeridos');
                return false;
            }
            
            return { nombre, celula_id, nombre_proyecto, clientes, responsable_negocio, estado };
        }
    });
    
    if (formValues) {
        try {
            const response = await fetch(window.getApiUrl(`/api/licitaciones/${id}`), {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(formValues)
            });
            
            if (!response.ok) throw new Error('Error al actualizar licitación');
            
            Swal.fire({
                icon: 'success',
                title: 'Licitación actualizada',
                text: 'La licitación se actualizó correctamente',
                timer: 2000,
                showConfirmButton: false
            });
            
            loadLicitaciones();
        } catch (err) {
            console.error('Error updating licitacion:', err);
            Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'No se pudo actualizar la licitación: ' + err.message
            });
        }
    }
}

// Eliminar licitación
async function deleteLicitacion(id) {
    const licitacion = currentLicitaciones.find(l => l.id === id);
    if (!licitacion) {
        alert('Licitación no encontrada');
        return;
    }
    
    const result = await Swal.fire({
        title: '¿Eliminar licitación?',
        html: `
            <p>¿Estás seguro de eliminar la licitación "<strong>${licitacion.nombre}</strong>"?</p>
            <p style="color:#dc3545;font-size:14px">⚠️ Esta acción no se puede deshacer</p>
        `,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar',
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6'
    });
    
    if (!result.isConfirmed) return;
    
    try {
        const response = await fetch(window.getApiUrl(`/api/licitaciones/${id}`), {
            method: 'DELETE'
        });
        
        if (!response.ok) throw new Error('Error al eliminar licitación');
        
        Swal.fire({
            icon: 'success',
            title: 'Licitación eliminada',
            text: 'La licitación se eliminó correctamente',
            timer: 2000,
            showConfirmButton: false
        });
        
        loadLicitaciones();
    } catch (err) {
        console.error('Error deleting licitacion:', err);
        Swal.fire({
            icon: 'error',
            title: 'Error',
            text: 'No se pudo eliminar la licitación: ' + err.message
        });
    }
}

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Botón agregar licitación
    const addBtn = document.getElementById('add-licitacion-btn');
    if (addBtn) {
        addBtn.addEventListener('click', openAddLicitacionModal);
    }
    
    // Botón buscar
    const searchBtn = document.getElementById('filter-licitacion-search-btn');
    if (searchBtn) {
        searchBtn.addEventListener('click', () => {
            const name = document.getElementById('filter-licitacion-name')?.value || '';
            const estado = document.getElementById('filter-licitacion-estado')?.value || '';
            loadLicitaciones({ name, estado });
        });
    }
    
    // Botón limpiar filtros
    const clearBtn = document.getElementById('filter-licitacion-clear-btn');
    if (clearBtn) {
        clearBtn.addEventListener('click', () => {
            const nameInput = document.getElementById('filter-licitacion-name');
            const estadoSelect = document.getElementById('filter-licitacion-estado');
            if (nameInput) nameInput.value = '';
            if (estadoSelect) estadoSelect.value = '';
            loadLicitaciones();
        });
    }
});

// Exponer funciones globalmente
window.loadLicitaciones = loadLicitaciones;
window.viewLicitacion = viewLicitacion;
window.editLicitacion = editLicitacion;
window.deleteLicitacion = deleteLicitacion;
window.openAddLicitacionModal = openAddLicitacionModal;
