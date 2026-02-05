// Test para verificar funciones de modal
console.log('🧪 === TEST DE FUNCIONES DE MODAL ===');

// Verificar que las funciones existen
const functions = [
  'openMastercodeModal',
  'closeMastercodeModal', 
  'loadMastercodeList',
  'addMastercodeItem',
  'deleteMastercodeItem',
  'refreshMastercodeList'
];

functions.forEach(funcName => {
  const func = window[funcName];
  const exists = typeof func === 'function';
  console.log(`${exists ? '✅' : '❌'} ${funcName}:`, typeof func);
  
  if (!exists) {
    console.error(`❌ Función ${funcName} no encontrada en window`);
  }
});

// Test específico para el botón de cerrar
console.log('\n🧪 === TEST ESPECÍFICO DE closeMastercodeModal ===');
if (typeof window.closeMastercodeModal === 'function') {
  console.log('✅ Function exists, testing...');
  
  // Verificar que el modal existe
  const modal = document.getElementById('mastercode-modal');
  console.log('✅ Modal exists:', !!modal);
  
  if (modal) {
    // Hacer visible el modal primero para probar cerrarlo
    modal.style.display = 'block';
    console.log('✅ Modal made visible');
    
    // Esperar 1 segundo y cerrarlo
    setTimeout(() => {
      console.log('🧪 Calling closeMastercodeModal...');
      window.closeMastercodeModal();
    }, 1000);
  }
} else {
  console.error('❌ closeMastercodeModal function not found!');
}