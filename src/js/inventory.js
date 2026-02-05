// =====================================================
// GESTIÓN DE INVENTARIO DE EQUIPOS - RECONSTRUIDO
// Sistema limpio y modular para la gestión completa de equipos
// =====================================================

console.log('📦 Sistema de inventario iniciado');

// =====================================================
// CONFIGURACIÓN Y VARIABLES GLOBALES
// =====================================================

const INVENTORY_CONFIG = {
    API_BASE: 'http://localhost:3000/api',
    ENDPOINTS: {
        EMPLOYEES: '/employees-v2',
        INVENTORY: '/inventory',
        CATEGORIES: '/mastercode/inventario-categorias'
    },
    STATES: {
        LOADING: 'loading',
        READY: 'ready',
        ERROR: 'error',
        EMPTY: 'empty'
    }
};

// Estado global del módulo
const InventoryState = {
    equipmentData: [],
    employeesData: [],
    categoriesData: [],
    currentState: INVENTORY_CONFIG.STATES.LOADING,
    currentEditingId: null
};

// =====================================================
// UTILIDADES Y HELPERS
// =====================================================

const InventoryHelpers = {
    // Formatear estado en español
    formatStatus(status) {
        const statusMap = {
            'active': 'Activo',
            'inactive': 'Inactivo',
            'maintenance': 'Mantenimiento',
            'retired': 'Baja'
        };
        return statusMap[status?.toLowerCase()] || status || 'Sin estado';
    },

    // Formatear valor monetario
    formatCurrency(value) {
        if (!value) return '$0.00';
        return new Intl.NumberFormat('es-MX', {
            style: 'currency',
            currency: 'MXN'
        }).format(value);
    },

    // Formatear fecha
    formatDate(date) {
        if (!date) return 'No especificada';
        return new Date(date).toLocaleDateString('es-ES');
    },

    // Obtener empleado por ID
    getEmployeeById(id) {
        return InventoryState.employeesData.find(emp => emp.id == id);
    },

    // Mostrar notificación
    showNotification(message, type = 'info') {
        console.log(`${type.toUpperCase()}: ${message}`);
        // Aquí se puede agregar sistema de notificaciones visual
    },

    // Validar equipo
    validateEquipment(equipment) {
        const errors = [];
        
        if (!equipment.codigo?.trim()) errors.push('Código es requerido');
        if (!equipment.nombre?.trim()) errors.push('Nombre es requerido');
        if (!equipment.categoria?.trim()) errors.push('Categoría es requerida');
        
        return errors;
    }
};

// =====================================================
// SERVICIOS API
// =====================================================

const InventoryAPI = {
    // Cargar empleados
    async loadEmployees() {
        try {
            const response = await fetch(`${INVENTORY_CONFIG.API_BASE}${INVENTORY_CONFIG.ENDPOINTS.EMPLOYEES}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const employees = await response.json();
            return employees.map(emp => ({
                id: emp.id,
                firstName: emp.first_name || '',
                lastName: emp.last_name || '',
                fullName: `${emp.first_name || ''} ${emp.last_name || ''}`.trim() || 'Sin nombre',
                email: emp.email || '',
                position: emp.position_name || '',
                department: emp.department_name || ''
            }));
        } catch (error) {
            console.error('❌ Error cargando empleados:', error);
            throw error;
        }
    },

    // Cargar equipos
    async loadEquipment() {
        try {
            const response = await fetch(`${INVENTORY_CONFIG.API_BASE}${INVENTORY_CONFIG.ENDPOINTS.INVENTORY}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const equipment = await response.json();
            return equipment.map(eq => ({
                id: eq.id,
                codigo: eq.codigo || '',
                nombre: eq.nombre || '',
                marca: eq.marca || '',
                modelo: eq.modelo || '',
                serie: eq.serie || '',
                categoria: eq.categoria || '',
                ubicacion: eq.ubicacion || '',
                empleadoId: eq.empleado_id || null,
                estado: eq.estado || 'active',
                valor: eq.valor || 0,
                fechaCompra: eq.fecha_compra || null,
                descripcion: eq.descripcion || ''
            }));
        } catch (error) {
            console.error('❌ Error cargando equipos:', error);
            throw error;
        }
    },

    // Cargar categorías
    async loadCategories() {
        try {
            const response = await fetch(`${INVENTORY_CONFIG.API_BASE}${INVENTORY_CONFIG.ENDPOINTS.CATEGORIES}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const categories = await response.json();
            return categories.map(cat => cat.name || cat.nombre || cat).filter(Boolean);
        } catch (error) {
            console.error('❌ Error cargando categorías:', error);
            // Categorías por defecto
            return ['Computo', 'Mobiliario', 'Electronico', 'Herramientas', 'Vehiculos'];
        }
    },

    // Guardar equipo
    async saveEquipment(equipment) {
        try {
            const url = equipment.id 
                ? `${INVENTORY_CONFIG.API_BASE}${INVENTORY_CONFIG.ENDPOINTS.INVENTORY}/${equipment.id}`
                : `${INVENTORY_CONFIG.API_BASE}${INVENTORY_CONFIG.ENDPOINTS.INVENTORY}`;
            
            const method = equipment.id ? 'PUT' : 'POST';
            
            const response = await fetch(url, {
                method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    codigo: equipment.codigo,
                    nombre: equipment.nombre,
                    marca: equipment.marca,
                    modelo: equipment.modelo,
                    serie: equipment.serie,
                    categoria: equipment.categoria,
                    ubicacion: equipment.ubicacion,
                    empleado_id: equipment.empleadoId || null,
                    estado: equipment.estado,
                    valor: equipment.valor,
                    fecha_compra: equipment.fechaCompra,
                    descripcion: equipment.descripcion
                })
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return await response.json();
        } catch (error) {
            console.error('❌ Error guardando equipo:', error);
            throw error;
        }
    },

    // Eliminar equipo
    async deleteEquipment(id) {
        try {
            const response = await fetch(`${INVENTORY_CONFIG.API_BASE}${INVENTORY_CONFIG.ENDPOINTS.INVENTORY}/${id}`, {
                method: 'DELETE'
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            return true;
        } catch (error) {
            console.error('❌ Error eliminando equipo:', error);
            throw error;
        }
    }
};

// =====================================================
// GESTIÓN DE VISTA
// =====================================================

const InventoryView = {
    // Elementos DOM
    elements: {
        get loadingDiv() { return document.getElementById('equipment-grid-loading'); },
        get tableDiv() { return document.getElementById('equipment-table'); },
        get tableBody() { return document.getElementById('equipment-table-body'); },
        get emptyDiv() { return document.getElementById('equipment-grid-empty'); },
        get errorDiv() { return document.getElementById('equipment-grid-error'); },
        get errorMessage() { return document.getElementById('equipment-error-message'); }
    },

    // Mostrar estado de carga
    showLoading() {
        this.hideAll();
        this.elements.loadingDiv && (this.elements.loadingDiv.style.display = 'block');
        console.log('📄 Mostrando estado de carga...');
    },

    // Mostrar tabla con datos
    showTable() {
        this.hideAll();
        this.elements.tableDiv && (this.elements.tableDiv.style.display = 'table');
        console.log('📋 Mostrando tabla de equipos');
    },

    // Mostrar estado vacío
    showEmpty() {
        this.hideAll();
        this.elements.emptyDiv && (this.elements.emptyDiv.style.display = 'block');
        console.log('📭 Mostrando estado vacío');
    },

    // Mostrar error
    showError(message) {
        this.hideAll();
        if (this.elements.errorDiv) {
            this.elements.errorDiv.style.display = 'block';
            if (this.elements.errorMessage) {
                this.elements.errorMessage.textContent = message || 'Error desconocido';
            }
        }
        console.error('❌ Mostrando error:', message);
    },

    // Ocultar todos los estados
    hideAll() {
        const elements = Object.values(this.elements);
        elements.forEach(el => el && (el.style.display = 'none'));
    },

    // Renderizar tabla de equipos
    renderEquipmentTable() {
        if (!this.elements.tableBody) {
            console.error('❌ Elemento tabla no encontrado');
            return;
        }

        if (InventoryState.equipmentData.length === 0) {
            this.showEmpty();
            return;
        }

        const tbody = this.elements.tableBody;
        tbody.innerHTML = '';

        InventoryState.equipmentData.forEach(equipment => {
            const employee = InventoryHelpers.getEmployeeById(equipment.empleadoId);
            const row = document.createElement('tr');
            
            row.innerHTML = `
                <td>${equipment.codigo}</td>
                <td>${equipment.nombre}</td>
                <td>${equipment.marca}</td>
                <td>${equipment.modelo}</td>
                <td>${equipment.serie}</td>
                <td>${equipment.categoria}</td>
                <td>${equipment.ubicacion}</td>
                <td>${employee ? employee.fullName : 'Sin asignar'}</td>
                <td>
                    <span class="status-badge status-${equipment.estado}">
                        ${InventoryHelpers.formatStatus(equipment.estado)}
                    </span>
                </td>
                <td>${InventoryHelpers.formatCurrency(equipment.valor)}</td>
                <td>${InventoryHelpers.formatDate(equipment.fechaCompra)}</td>
                <td>
                    <button onclick="InventoryController.editEquipment(${equipment.id})" 
                            class="btn-edit" title="Editar">✏️</button>
                    <button onclick="InventoryController.deleteEquipment(${equipment.id})" 
                            class="btn-delete" title="Eliminar">🗑️</button>
                </td>
            `;
            
            tbody.appendChild(row);
        });

        this.showTable();
        console.log(`📊 Tabla renderizada con ${InventoryState.equipmentData.length} equipos`);
    },

    // Llenar selects de empleados
    populateEmployeeSelects() {
        const selects = document.querySelectorAll('#filter-equipment-assigned, #equipment-assigned');
        
        selects.forEach(select => {
            if (!select) return;
            
            // Limpiar opciones existentes (excepto la primera)
            while (select.children.length > 1) {
                select.removeChild(select.lastChild);
            }
            
            // Agregar empleados
            InventoryState.employeesData.forEach(employee => {
                const option = document.createElement('option');
                option.value = employee.id;
                option.textContent = employee.fullName;
                select.appendChild(option);
            });
        });
        
        console.log('👥 Selects de empleados actualizados');
    },

    // Llenar selects de categorías
    populateCategorySelects() {
        const selects = document.querySelectorAll('#filter-equipment-category, #equipment-category');
        
        selects.forEach(select => {
            if (!select) return;
            
            // Limpiar opciones existentes (excepto la primera)
            while (select.children.length > 1) {
                select.removeChild(select.lastChild);
            }
            
            // Agregar categorías
            InventoryState.categoriesData.forEach(category => {
                const option = document.createElement('option');
                option.value = category;
                option.textContent = category;
                select.appendChild(option);
            });
        });
        
        console.log('📂 Selects de categorías actualizados');
    }
};

// =====================================================
// FUNCIONES PRINCIPALES SIMPLIFICADAS
// =====================================================

// Función principal para cargar inventario (llamada desde HTML)
async function loadInventoryFromDatabase() {
    console.log('📦 Iniciando carga de inventario...');
    
    try {
        // Mostrar estado de carga
        showLoadingState();
        
        // Cargar datos del servidor
        const [equipment, employees, categories] = await Promise.all([
            fetchEquipment(),
            fetchEmployees(), 
            fetchCategories()
        ]);
        
        // Actualizar estado global
        InventoryState.equipmentData = equipment;
        InventoryState.employeesData = employees;
        InventoryState.categoriesData = categories;
        
        // Renderizar interfaz
        populateSelects();
        renderEquipmentTable();
        
        console.log('✅ Inventario cargado exitosamente');
        console.log(`  📦 ${equipment.length} equipos`);
        console.log(`  👥 ${employees.length} empleados`);
        console.log(`  📂 ${categories.length} categorías`);
        
    } catch (error) {
        console.error('❌ Error cargando inventario:', error);
        showErrorState(error.message);
    }
}

// Funciones auxiliares para cargar datos
async function fetchEquipment() {
    console.log('📦 Cargando equipos...');
    const response = await fetch('http://localhost:3000/api/equipment');
    if (!response.ok) throw new Error(`Error HTTP ${response.status}: ${response.statusText}`);
    const data = await response.json();
    return data.map(eq => ({
        id: eq.id,
        codigo: eq.codigo || '',
        nombre: eq.nombre || '',
        marca: eq.marca || '',
        modelo: eq.modelo || '',
        serie: eq.serie || '',
        categoria: eq.categoria || '',
        ubicacion: eq.ubicacion || '',
        empleadoId: eq.empleado_id || eq.asignado_id || null,
        estado: eq.estado || 'active',
        valor: eq.valor || 0,
        fechaCompra: eq.fecha_compra || null,
        descripcion: eq.descripcion || ''
    }));
}

async function fetchEmployees() {
    console.log('👥 Cargando empleados completos...');
    // Usar la función global window.fetchEmployees solo si NO estamos dentro de inventory.js
    if (window.fetchEmployees && window.fetchEmployees !== fetchEmployees) {
        return await window.fetchEmployees();
    } else {
        // Fallback: usar el fetch directo si la función global no está disponible
        const response = await fetch('http://localhost:3000/api/employees-v2');
        if (!response.ok) throw new Error(`Error HTTP ${response.status}: ${response.statusText}`);
        return await response.json();
    }
}

async function fetchCategories() {
    console.log('📂 Cargando categorías...');
    try {
        const response = await fetch('http://localhost:3000/api/mastercode/inventario-categorias');
        if (!response.ok) throw new Error(`Error HTTP ${response.status}`);
        const data = await response.json();
        return data.map(cat => cat.name || cat.nombre || cat).filter(Boolean);
    } catch (error) {
        console.warn('⚠️ No se pudieron cargar categorías del servidor, usando por defecto');
        return ['Computo', 'Mobiliario', 'Electronico', 'Herramientas', 'Vehiculos'];
    }
}

// Estados de la interfaz
function showLoadingState() {
    const loading = document.getElementById('equipment-grid-loading');
    const table = document.getElementById('equipment-table');
    const empty = document.getElementById('equipment-grid-empty');
    const error = document.getElementById('equipment-grid-error');
    
    if (loading) loading.style.display = 'block';
    if (table) table.style.display = 'none';
    if (empty) empty.style.display = 'none';
    if (error) error.style.display = 'none';
}

function showErrorState(message) {
    const loading = document.getElementById('equipment-grid-loading');
    const table = document.getElementById('equipment-table');
    const empty = document.getElementById('equipment-grid-empty');
    const error = document.getElementById('equipment-grid-error');
    const errorMsg = document.getElementById('equipment-error-message');
    
    if (loading) loading.style.display = 'none';
    if (table) table.style.display = 'none';
    if (empty) empty.style.display = 'none';
    if (error) error.style.display = 'block';
    if (errorMsg) errorMsg.textContent = message;
}

function showTableState() {
    const loading = document.getElementById('equipment-grid-loading');
    const table = document.getElementById('equipment-table');
    const empty = document.getElementById('equipment-grid-empty');
    const error = document.getElementById('equipment-grid-error');
    
    if (loading) loading.style.display = 'none';
    if (table) table.style.display = 'table';
    if (empty) empty.style.display = 'none';
    if (error) error.style.display = 'none';
}

function showEmptyState() {
    const loading = document.getElementById('equipment-grid-loading');
    const table = document.getElementById('equipment-table');
    const empty = document.getElementById('equipment-grid-empty');
    const error = document.getElementById('equipment-grid-error');
    
    if (loading) loading.style.display = 'none';
    if (table) table.style.display = 'none';
    if (empty) empty.style.display = 'block';
    if (error) error.style.display = 'none';
}

// Renderizar tabla
function renderEquipmentTable() {
    console.log('📊 Renderizando tabla de equipos...');
    const tableBody = document.getElementById('equipment-table-body');
    if (!tableBody) {
        console.error('❌ No se encontró el elemento de la tabla');
        return;
    }
    
    if (InventoryState.equipmentData.length === 0) {
        showEmptyState();
        return;
    }
    
    tableBody.innerHTML = '';
    
    InventoryState.equipmentData.forEach(equipment => {
        const employee = getEmployeeById(equipment.empleadoId);
        const row = document.createElement('tr');
        
        row.innerHTML = `
            <td>${equipment.codigo}</td>
            <td>${equipment.nombre}</td>
            <td>${equipment.marca}</td>
            <td>${equipment.modelo}</td>
            <td>${equipment.serie}</td>
            <td>${equipment.categoria}</td>
            <td>${equipment.ubicacion}</td>
            <td>${employee ? employee.fullName : 'Sin asignar'}</td>
            <td>
                <span class="status-badge status-${equipment.estado}">
                    ${formatStatus(equipment.estado)}
                </span>
            </td>
            <td>${formatCurrency(equipment.valor)}</td>
            <td>${formatDate(equipment.fechaCompra)}</td>
            <td>
                <button onclick="editEquipment(${equipment.id})" class="btn-edit">✏️</button>
                <button onclick="deleteEquipment(${equipment.id})" class="btn-delete">🗑️</button>
            </td>
        `;
        
        tableBody.appendChild(row);
    });
    
    showTableState();
    console.log(`📋 Tabla renderizada con ${InventoryState.equipmentData.length} equipos`);
}

// Llenar selects
function populateSelects() {
    populateEmployeeSelects();
    populateCategorySelects();
}

function populateEmployeeSelects() {
    const selects = document.querySelectorAll('#filter-equipment-assigned');
    
    selects.forEach(select => {
        if (!select) return;
        
        // Limpiar opciones (excepto la primera)
        while (select.children.length > 1) {
            select.removeChild(select.lastChild);
        }
        
        // Agregar empleados
        InventoryState.employeesData.forEach(employee => {
            const option = document.createElement('option');
            option.value = employee.id;
            option.textContent = employee.fullName;
            select.appendChild(option);
        });
    });
    
    console.log('👥 Selects de empleados actualizados');
}

function populateCategorySelects() {
    const selects = document.querySelectorAll('#filter-equipment-category');
    
    selects.forEach(select => {
        if (!select) return;
        
        // Limpiar opciones (excepto la primera)  
        while (select.children.length > 1) {
            select.removeChild(select.lastChild);
        }
        
        // Agregar categorías
        InventoryState.categoriesData.forEach(category => {
            const option = document.createElement('option');
            option.value = category;
            option.textContent = category;
            select.appendChild(option);
        });
    });
    
    console.log('📂 Selects de categorías actualizados');
}

// Funciones auxiliares
function getEmployeeById(id) {
    return InventoryState.employeesData.find(emp => emp.id == id);
}

function formatStatus(status) {
    const statusMap = {
        'active': 'Activo',
        'inactive': 'Inactivo',
        'maintenance': 'Mantenimiento',
        'retired': 'Baja'
    };
    return statusMap[status?.toLowerCase()] || status || 'Sin estado';
}

function formatCurrency(value) {
    if (!value) return '$0.00';
    return new Intl.NumberFormat('es-MX', {
        style: 'currency',
        currency: 'MXN'
    }).format(value);
}

function formatDate(date) {
    if (!date) return 'No especificada';
    return new Date(date).toLocaleDateString('es-ES');
}

// Funciones requeridas por el HTML
function applyEquipmentFilters() {
    console.log('🔍 Aplicando filtros...');
    renderEquipmentTable();
}

function clearEquipmentFilters() {
    const filterElements = document.querySelectorAll('.filter-input');
    filterElements.forEach(el => {
        if (el.tagName === 'SELECT') {
            el.selectedIndex = 0;
        } else {
            el.value = '';
        }
    });
    renderEquipmentTable();
}

function editEquipment(id) {
    console.log(`✏️ Editando equipo ID: ${id}`);
    if (window.openEquipmentModal) {
        window.openEquipmentModal(id);
    }
}

function deleteEquipment(id) {
    console.log(`🗑️ Eliminando equipo ID: ${id}`);
    if (confirm('¿Estás seguro de eliminar este equipo?')) {
        // Implementar eliminación aquí
    }
}

function reloadEquipment() {
    console.log('🔄 Recargando inventario...');
    loadInventoryFromDatabase();
}

// =====================================================
// INICIALIZACIÓN SIMPLIFICADA
// =====================================================

// Funciones globales para compatibilidad con HTML
window.loadInventoryFromExcel = loadInventoryFromDatabase;
window.applyEquipmentFilters = applyEquipmentFilters;
window.clearEquipmentFilters = clearEquipmentFilters;
window.reloadEquipment = reloadEquipment;

// Inicialización automática
document.addEventListener('DOMContentLoaded', () => {
    console.log('📄 DOM cargado - Verificando vista de inventario...');
    console.log('📄 Elementos encontrados:', {
        inventorySection: !!document.getElementById('inventario-equipos'),
        tableBody: !!document.getElementById('equipment-table-body'),
        loadingDiv: !!document.getElementById('equipment-grid-loading')
    });
    
    // Verificar si estamos en la vista de inventario
    const inventorySection = document.getElementById('inventario-equipos');
    if (inventorySection) {
        console.log('📦 Vista de inventario detectada - Inicializando...');
        
        // Limpiar tabla
        const tableBody = document.getElementById('equipment-table-body');
        if (tableBody) {
            tableBody.innerHTML = '';
        }
        
        // Inicializar automáticamente
        setTimeout(() => {
            console.log('📦 Ejecutando loadInventoryFromDatabase...');
            loadInventoryFromDatabase();
        }, 1000);
    }
});

// También inicializar si se cambia la vista
document.addEventListener('viewChanged', (event) => {
    console.log('📦 Evento viewChanged recibido:', event.detail);
    if (event.detail === 'inventario-equipos') {
        console.log('📦 Vista cambiada a inventario - Inicializando...');
        setTimeout(() => {
            console.log('📦 Ejecutando loadInventoryFromDatabase tras cambio de vista...');
            loadInventoryFromDatabase();
        }, 500);
    }
});

// =====================================================
// FUNCIONES PARA BOTONES DE EDITAR Y ELIMINAR
// =====================================================

// Función para editar un equipo
function editEquipment(equipmentId) {
    console.log('✏️ Editando equipo ID:', equipmentId);
    
    // Buscar el equipo en los datos cargados
    const equipment = InventoryState.equipmentData.find(eq => eq.id === equipmentId);
    
    if (!equipment) {
        console.error('❌ Equipo no encontrado:', equipmentId);
        alert('Error: Equipo no encontrado');
        return;
    }
    
    console.log('📝 Datos del equipo a editar:', equipment);
    
    // Mostrar información del equipo
    const editData = {
        'ID': equipment.id,
        'Nombre': equipment.nombre,
        'Serie': equipment.serie,
        'Marca': equipment.marca,
        'Modelo': equipment.modelo,
        'Categoría': equipment.categoria,
        'Estado': equipment.estado,
        'Ubicación': equipment.ubicacion,
        'Usuario': equipment.usuario_nombre || 'Sin asignar',
        'Fecha Adquisición': equipment.fecha_adquisicion
    };
    
    const editText = Object.entries(editData)
        .map(([key, value]) => `${key}: ${value || 'N/A'}`)
        .join('\n');
        
    alert(`EDITAR EQUIPO\n\n${editText}\n\n(Funcionalidad de edición en desarrollo)`);
}

// Función para eliminar un equipo
async function deleteEquipment(equipmentId) {
    console.log('🗑️ Eliminando equipo ID:', equipmentId);
    
    try {
        // Buscar el equipo en los datos cargados
        const equipment = InventoryState.equipmentData.find(eq => eq.id === equipmentId);
        
        if (!equipment) {
            console.error('❌ Equipo no encontrado:', equipmentId);
            alert('Error: Equipo no encontrado');
            return;
        }
        
        // Confirmar eliminación
        const confirmMessage = `¿Estás seguro de que quieres eliminar este equipo?\n\n` +
            `Nombre: ${equipment.nombre}\n` +
            `Serie: ${equipment.serie}\n` +
            `Marca: ${equipment.marca} ${equipment.modelo}`;
            
        if (!confirm(confirmMessage)) {
            console.log('❌ Eliminación cancelada por el usuario');
            return;
        }
        
        console.log('🗑️ Procediendo con la eliminación...');
        
        // Hacer la petición DELETE al API
        const response = await fetch(`${INVENTORY_CONFIG.API_BASE}/inventory/${equipmentId}`, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        
        if (!response.ok) {
            throw new Error(`Error HTTP: ${response.status}`);
        }
        
        const result = await response.json();
        console.log('✅ Equipo eliminado exitosamente:', result);
        
        alert('Equipo eliminado correctamente');
        
        // Recargar la tabla
        await loadInventoryFromDatabase();
        
    } catch (error) {
        console.error('❌ Error al eliminar equipo:', error);
        alert(`Error al eliminar equipo: ${error.message}`);
    }
}

// Exponer funciones globalmente para los botones
window.editEquipment = editEquipment;
window.deleteEquipment = deleteEquipment;

console.log('📦 Sistema de inventario simplificado listo');