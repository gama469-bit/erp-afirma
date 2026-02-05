// Test manual para el botón de agregar mastercode
// Ejecutar en la consola del navegador

console.log('🧪 Iniciando test manual...');

// 1. Verificar que la función existe
console.log('✅ openMastercodeModal existe:', typeof window.openMastercodeModal);
console.log('✅ addMastercodeItem existe:', typeof window.addMastercodeItem);

// 2. Abrir modal de entidades
console.log('📂 Abriendo modal de Entidades...');
openMastercodeModal('Entidad');

// 3. Esperar 2 segundos y verificar formulario
setTimeout(() => {
    console.log('🔍 Verificando formulario...');
    const form = document.getElementById('add-mastercode-item-form');
    const input = document.getElementById('new-item-name');
    
    console.log('Form encontrado:', !!form);
    console.log('Input encontrado:', !!input);
    
    if (input) {
        console.log('✍️ Escribiendo en input...');
        input.value = 'Test Manual ' + Date.now();
        
        console.log('🚀 Llamando addMastercodeItem directamente...');
        addMastercodeItem();
    }
}, 2000);