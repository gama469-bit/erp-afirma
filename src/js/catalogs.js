// Sistema de Gestión de Catálogos - RECONSTRUIDO DESDE CERO
console.log('📋 Sistema de catálogos iniciado');

// Variables globales
let currentCatalogType = '';
let currentCatalogItems = [];

// Configuración de catálogos
const catalogConfig = {
    'Entidad': {
        title: '🏢 Gestión de Entidades',
        description: 'Administra las entidades u organizaciones del sistema',
        color: '#3b82f6'
    },
    'Puestos roles': {
        title: '👔 Gestión de Puestos / Roles',
        description: 'Gestiona los puestos de trabajo y roles organizacionales',
        color: '#10b981'
    },
    'Areas': {
        title: '🏗️ Gestión de Áreas',
        description: 'Define las áreas operativas y departamentos',
        color: '#f59e0b'
    },
    'Proyecto': {
        title: '🚀 Gestión de Proyectos',
        description: 'Administra los proyectos y iniciativas activas',
        color: '#8b5cf6'
    },
    'Celulas': {
        title: '🔬 Gestión de Células',
        description: 'Gestiona las células operativas y equipos especializados',
        color: '#ec4899'
    },
    'inventario de categoria de equipos': {
        title: '📦 Gestión de Categorías de Equipos',
        description: 'Define las categorías para clasificación del inventario',
        color: '#ef4444'
    }
};

// Función principal para abrir el gestor de catálogos
function openCatalogManager(catalogType) {
    console.log('🔓 Abriendo gestor para:', catalogType);
    
    const config = catalogConfig[catalogType];
    if (!config) {
        Swal.fire({
            icon: 'error',
            title: 'Catálogo no encontrado',
            text: 'Tipo de catálogo no encontrado: ' + catalogType
        });
        return;
    }
    
    currentCatalogType = catalogType;
    
    // Configurar modal
    const modal = document.getElementById('catalog-manager-modal');
    const title = document.getElementById('catalog-manager-title');
    const subtitle = document.getElementById('catalog-manager-subtitle');
    const header = modal.querySelector('.modal-header');
    
    title.textContent = config.title;
    subtitle.textContent = config.description;
    header.style.background = `linear-gradient(135deg, ${config.color}, ${adjustColor(config.color, -20)})`;
    
    // Mostrar modal
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
    
    // Cargar elementos
    loadCatalogItems(catalogType);
    
    // Limpiar input
    document.getElementById('catalog-input').value = '';
}

// Función para cerrar el gestor
function closeCatalogManager() {
    console.log('🔒 Cerrando gestor de catálogos');
    
    const modal = document.getElementById('catalog-manager-modal');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
    
    // Limpiar estado
    currentCatalogType = '';
    currentCatalogItems = [];
    document.getElementById('catalog-input').value = '';
}

// Función para cargar elementos del catálogo
async function loadCatalogItems(catalogType) {
    console.log('📊 Cargando elementos para:', catalogType);
    
    const listContainer = document.getElementById('catalog-elements-list');
    const countElement = document.getElementById('catalog-count');
    
    // Mostrar loading
    listContainer.innerHTML = `
        <div style="text-align: center; padding: 40px; color: #9ca3af;">
            <div style="font-size: 24px; margin-bottom: 8px;">⏳</div>
            <div>Cargando elementos...</div>
        </div>
    `;
    
    try {
        const response = await fetch(`http://127.0.0.1:3000/api/mastercode/${encodeURIComponent(catalogType)}`);
        
        if (response.ok) {
            const items = await response.json();
            currentCatalogItems = items;
            renderCatalogItems(items);
            countElement.textContent = `Total: ${items.length} elemento${items.length !== 1 ? 's' : ''}`;
            console.log(`✅ Cargados ${items.length} elementos`);
        } else {
            throw new Error(`Error HTTP: ${response.status}`);
        }
    } catch (error) {
        console.error('❌ Error cargando elementos:', error);
        listContainer.innerHTML = `
            <div style="text-align: center; padding: 40px; color: #dc2626;">
                <div style="font-size: 24px; margin-bottom: 8px;">⚠️</div>
                <div style="margin-bottom: 8px;">Error al cargar elementos</div>
                <div style="font-size: 12px; margin-bottom: 16px;">${error.message}</div>
                <button onclick="loadCatalogItems('${catalogType}')" style="background: #dc2626; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer;">
                    🔄 Reintentar
                </button>
            </div>
        `;
        countElement.textContent = 'Total: Error al cargar';
    }
}

// Función para renderizar la lista de elementos
function renderCatalogItems(items) {
    const listContainer = document.getElementById('catalog-elements-list');
    
    if (items.length === 0) {
        listContainer.innerHTML = `
            <div style="text-align: center; padding: 40px; color: #9ca3af;">
                <div style="font-size: 24px; margin-bottom: 8px;">📂</div>
                <div style="margin-bottom: 4px;">No hay elementos registrados</div>
                <div style="font-size: 12px;">Agrega el primer elemento usando el formulario de arriba</div>
            </div>
        `;
        return;
    }
    
    let html = '';
    items.forEach((item, index) => {
        const itemName = item.item || item.name || 'Sin nombre';
        const isEven = index % 2 === 0;
        
        html += `
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 16px; border-radius: 8px; margin-bottom: 8px; ${isEven ? 'background: #f8fafc;' : 'background: #fff;'} border: 1px solid #e5e7eb; transition: all 0.2s;" onmouseover="this.style.borderColor='#d1d5db'" onmouseout="this.style.borderColor='#e5e7eb'">
                <div style="flex: 1;">
                    <div style="font-weight: 500; color: #1f2937; font-size: 14px;">${itemName}</div>
                    <div style="font-size: 12px; color: #6b7280; margin-top: 2px;">ID: ${item.id}</div>
                </div>
                <button 
                    onclick="deleteCatalogItem(${item.id}, '${itemName.replace(/'/g, '\\\'')}')" 
                    style="background: #fee2e2; color: #dc2626; border: 1px solid #fecaca; padding: 8px 12px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 500; transition: all 0.2s;"
                    onmouseover="this.style.background='#fecaca'; this.style.transform='scale(1.05)'"
                    onmouseout="this.style.background='#fee2e2'; this.style.transform='scale(1)'"
                >
                    🗑️ Eliminar
                </button>
            </div>
        `;
    });
    
    listContainer.innerHTML = html;
}

// Función para agregar elemento
async function addCatalogElement(event) {
    event.preventDefault();
    
    const input = document.getElementById('catalog-input');
    const itemName = input.value.trim();
    
    if (!itemName) {
        Swal.fire({
            icon: 'warning',
            title: 'Campo requerido',
            text: 'Por favor ingresa un nombre para el elemento'
        });
        return;
    }
    
    // Verificar duplicados
    if (currentCatalogItems.some(item => (item.item || item.name || '').toLowerCase() === itemName.toLowerCase())) {
        Swal.fire({
            icon: 'warning',
            title: 'Elemento duplicado',
            text: 'Este elemento ya existe en la lista'
        });
        return;
    }
    
    console.log('➕ Agregando elemento:', itemName);
    
    try {
        const response = await fetch(`http://127.0.0.1:3000/api/mastercode/${encodeURIComponent(currentCatalogType)}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ name: itemName })
        });
        
        if (response.ok) {
            const newItem = await response.json();
            console.log('✅ Elemento agregado:', newItem);
            
            // Limpiar input
            input.value = '';
            
            // Recargar lista
            await loadCatalogItems(currentCatalogType);
            
            // Mostrar mensaje de éxito
            showSuccessMessage(`✅ "${itemName}" agregado exitosamente`);
        } else {
            const error = await response.json();
            throw new Error(error.message || 'Error del servidor');
        }
    } catch (error) {
        console.error('❌ Error agregando elemento:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error al agregar elemento',
            text: error.message
        });
    }
}

// Función para eliminar elemento
async function deleteCatalogItem(itemId, itemName) {
    const result = await Swal.fire({
        title: '¿Eliminar elemento?',
        text: `¿Estás seguro de eliminar "${itemName}"?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Sí, eliminar',
        cancelButtonText: 'Cancelar',
        confirmButtonColor: '#d33',
        cancelButtonColor: '#3085d6'
    });
    
    if (!result.isConfirmed) return;
    
    console.log('🗑️ Eliminando elemento:', itemId, itemName);
    
    try {
        const response = await fetch(`http://127.0.0.1:3000/api/mastercode/${encodeURIComponent(currentCatalogType)}/${itemId}`, {
            method: 'DELETE'
        });
        
        if (response.ok) {
            console.log('✅ Elemento eliminado');
            
            // Recargar lista
            await loadCatalogItems(currentCatalogType);
            
            // Mostrar mensaje de éxito
            showSuccessMessage(`✅ "${itemName}" eliminado exitosamente`);
        } else {
            const error = await response.json();
            throw new Error(error.message || 'Error del servidor');
        }
    } catch (error) {
        console.error('❌ Error eliminando elemento:', error);
        Swal.fire({
            icon: 'error',
            title: 'Error al eliminar elemento',
            text: error.message
        });
    }
}

// Función para refrescar la lista
function refreshCatalogList() {
    if (currentCatalogType) {
        console.log('🔄 Refrescando lista de:', currentCatalogType);
        loadCatalogItems(currentCatalogType);
    }
}

// Función para mostrar mensajes de éxito
function showSuccessMessage(message) {
    // Crear elemento de notificación
    const notification = document.createElement('div');
    notification.innerHTML = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #10b981;
        color: white;
        padding: 12px 20px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 99999;
        animation: slideIn 0.3s ease-out;
    `;
    
    document.body.appendChild(notification);
    
    // Remover después de 3 segundos
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Función auxiliar para ajustar color
function adjustColor(color, percent) {
    const num = parseInt(color.replace("#", ""), 16);
    const amt = Math.round(2.55 * percent);
    const R = (num >> 16) + amt;
    const G = (num >> 8 & 0x00FF) + amt;
    const B = (num & 0x0000FF) + amt;
    return "#" + (0x1000000 + (R < 255 ? R < 1 ? 0 : R : 255) * 0x10000 +
        (G < 255 ? G < 1 ? 0 : G : 255) * 0x100 +
        (B < 255 ? B < 1 ? 0 : B : 255)).toString(16).slice(1);
}

// Agregar efectos hover a las tarjetas del catálogo
document.addEventListener('DOMContentLoaded', function() {
    console.log('🎨 Configurando efectos visuales');
    
    // Agregar efectos hover a las tarjetas
    const cards = document.querySelectorAll('.catalog-card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
            this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.1)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = 'none';
        });
    });
});

// Exponer funciones globalmente
window.openCatalogManager = openCatalogManager;
window.closeCatalogManager = closeCatalogManager;
window.addCatalogElement = addCatalogElement;
window.deleteCatalogItem = deleteCatalogItem;
window.refreshCatalogList = refreshCatalogList;

console.log('✅ Sistema de catálogos listo');