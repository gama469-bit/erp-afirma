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
        CATEGORIES: '/mastercode/inventario%20de%20categoria%20de%20equipos'
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
// CONTROLADOR PRINCIPAL
// =====================================================

const InventoryController = {
    // Inicializar módulo
    async init() {
        console.log('🚀 Inicializando sistema de inventario...');
        
        try {
            InventoryView.showLoading();
            InventoryState.currentState = INVENTORY_CONFIG.STATES.LOADING;
            
            // Cargar datos en paralelo
            await this.loadAllData();
            
            // Renderizar interfaz
            this.renderInterface();
            
            // Configurar eventos
            this.setupEvents();
            
            InventoryState.currentState = INVENTORY_CONFIG.STATES.READY;
            InventoryHelpers.showNotification('✅ Sistema de inventario listo', 'success');
            
        } catch (error) {
            console.error('❌ Error inicializando inventario:', error);
            InventoryState.currentState = INVENTORY_CONFIG.STATES.ERROR;
            InventoryView.showError('Error al cargar el sistema de inventario: ' + error.message);
        }
    },

    // Cargar todos los datos
    async loadAllData() {
        console.log('📡 Cargando datos del servidor...');
        
        try {
            // Cargar datos en paralelo
            const [employees, equipment, categories] = await Promise.all([
                InventoryAPI.loadEmployees(),
                InventoryAPI.loadEquipment(),
                InventoryAPI.loadCategories()
            ]);
            
            // Actualizar estado global
            InventoryState.employeesData = employees;
            InventoryState.equipmentData = equipment;
            InventoryState.categoriesData = categories;
            
            console.log('✅ Datos cargados:');
            console.log(`  📦 ${equipment.length} equipos`);
            console.log(`  👥 ${employees.length} empleados`);
            console.log(`  📂 ${categories.length} categorías`);
            
        } catch (error) {
            console.error('❌ Error cargando datos:', error);
            throw error;
        }
    },

    // Renderizar interfaz
    renderInterface() {
        InventoryView.populateEmployeeSelects();
        InventoryView.populateCategorySelects();
        InventoryView.renderEquipmentTable();
    },

    // Configurar eventos
    setupEvents() {
        // Eventos ya están manejados por las funciones globales existentes
        console.log('🎯 Eventos configurados');
    },

    // Recargar datos
    async reload() {
        console.log('🔄 Recargando inventario...');
        await this.init();
    },

    // Filtrar equipos
    applyFilters() {
        // Implementación de filtros aquí
        console.log('🔍 Aplicando filtros...');
        InventoryView.renderEquipmentTable();
    },

    // Limpiar filtros
    clearFilters() {
        const filterElements = document.querySelectorAll('.filter-input');
        filterElements.forEach(el => {
            if (el.tagName === 'SELECT') {
                el.selectedIndex = 0;
            } else {
                el.value = '';
            }
        });
        
        this.applyFilters();
        console.log('🧹 Filtros limpiados');
    },

    // Editar equipo
    editEquipment(id) {
        console.log(`✏️ Editando equipo ID: ${id}`);
        // La lógica de edición se mantiene en las funciones existentes
        if (window.openEquipmentModal) {
            window.openEquipmentModal(id);
        }
    },

    // Eliminar equipo
    async deleteEquipment(id) {
        if (!confirm('¿Estás seguro de eliminar este equipo?')) return;
        
        try {
            await InventoryAPI.deleteEquipment(id);
            await this.loadAllData();
            this.renderInterface();
            InventoryHelpers.showNotification('✅ Equipo eliminado correctamente', 'success');
        } catch (error) {
            InventoryHelpers.showNotification('❌ Error eliminando equipo: ' + error.message, 'error');
        }
    }
};

// =====================================================
// FUNCIONES GLOBALES PARA COMPATIBILIDAD
// =====================================================

// Funciones requeridas por el HTML existente
window.loadInventoryFromExcel = () => InventoryController.init();
window.applyEquipmentFilters = () => InventoryController.applyFilters();
window.clearEquipmentFilters = () => InventoryController.clearFilters();
window.reloadEquipment = () => InventoryController.reload();

// Exponer controlador para debug
window.InventoryController = InventoryController;
window.InventoryState = InventoryState;

// =====================================================
// INICIALIZACIÓN AUTOMÁTICA
// =====================================================

// Inicializar cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', () => {
    // Verificar si estamos en la vista de inventario
    const inventorySection = document.getElementById('inventario-equipos');
    if (inventorySection) {
        // Limpiar datos hardcodeados
        const tableBody = document.getElementById('equipment-table-body');
        if (tableBody) {
            tableBody.innerHTML = '';
        }
        
        // Inicializar sistema
        InventoryController.init();
    }
});

// Inicializar también si la vista se cambia dinámicamente
document.addEventListener('viewChanged', (event) => {
    if (event.detail === 'inventario-equipos') {
        InventoryController.init();
    }
});

console.log('📦 Módulo de inventario reconstruido y listo');