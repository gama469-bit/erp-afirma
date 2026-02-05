// Script de debug para probar las pestañas
console.log('🔍 DIAGNÓSTICO DE PESTAÑAS');
console.log('========================');

// Verificar si switchTab está disponible
console.log('1. ¿switchTab está disponible globalmente?', typeof window.switchTab);

// Verificar elementos del DOM
const tabButtons = document.querySelectorAll('.tab-button');
const tabContents = document.querySelectorAll('.tab-content');

console.log('2. Botones de pestañas encontrados:', tabButtons.length);
console.log('3. Contenidos de pestañas encontrados:', tabContents.length);

// Mostrar información de cada botón
tabButtons.forEach((btn, index) => {
    console.log(`   Botón ${index + 1}: data-tab="${btn.dataset.tab}", text="${btn.textContent.trim()}"`);
});

// Mostrar información de cada contenido
tabContents.forEach((content, index) => {
    console.log(`   Contenido ${index + 1}: id="${content.id}", visible="${content.classList.contains('active')}"`);
});

// Probar cambio de pestaña manualmente
console.log('4. Probando cambio a pestaña "expediente"...');
if (typeof window.switchTab === 'function') {
    window.switchTab('expediente');
    console.log('   ✅ Función ejecutada');
} else {
    console.log('   ❌ Función no disponible');
}

// Verificar event listeners
console.log('5. Event listeners en botones:');
tabButtons.forEach((btn, index) => {
    const hasClickListener = btn.onclick !== null || btn.addEventListener;
    console.log(`   Botón ${index + 1}: ${hasClickListener ? '✅ Con listeners' : '❌ Sin listeners'}`);
});