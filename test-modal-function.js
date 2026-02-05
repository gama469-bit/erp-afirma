// Test simple para verificar funcionalidad del modal
console.log('🧪 Probando función openCategoriesModal...');

// Verificar que la función existe
if (typeof window.openCategoriesModal === 'function') {
    console.log('✅ Función openCategoriesModal existe');
    
    // Verificar que el modal existe
    const modal = document.getElementById('categories-modal');
    if (modal) {
        console.log('✅ Modal categories-modal existe');
        
        // Intentar abrir el modal
        try {
            window.openCategoriesModal();
            console.log('✅ Modal abierto exitosamente');
        } catch (error) {
            console.error('❌ Error abriendo modal:', error);
        }
    } else {
        console.error('❌ Modal categories-modal no encontrado');
    }
} else {
    console.error('❌ Función openCategoriesModal no existe');
    
    // Verificar qué funciones están disponibles
    console.log('🔍 Funciones disponibles en window:');
    const functionsInWindow = Object.keys(window).filter(key => typeof window[key] === 'function' && key.includes('Categories'));
    console.log(functionsInWindow);
}