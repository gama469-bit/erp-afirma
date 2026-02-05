// Test manual de empleados
console.log('🧪 INICIANDO TEST DE EMPLEADOS...');

async function testCompleteFlow() {
    try {
        // 1. Test API
        console.log('📡 Probando API...');
        const response = await fetch('http://127.0.0.1:3000/api/employees-v2');
        const employees = await response.json();
        console.log(`✅ API OK - ${employees.length} empleados obtenidos`);
        
        // 2. Test DOM
        console.log('🔍 Probando DOM...');
        const tableBody = document.getElementById('employee-table-body');
        console.log(`✅ DOM OK - Tabla encontrada: ${!!tableBody}`);
        
        // 3. Test rendering
        console.log('🎨 Probando renderizado...');
        if (window.renderEmployees) {
            window.renderEmployees(employees);
            console.log('✅ RENDER OK - Empleados renderizados');
            
            const rows = tableBody.querySelectorAll('tr');
            console.log(`✅ GRID OK - ${rows.length} filas en tabla`);
        } else {
            console.log('❌ RENDER ERROR - función renderEmployees no encontrada');
        }
        
        // 4. Test navigation
        console.log('🧭 Probando navegación...');
        const empLink = document.querySelector('[data-view="alta"]');
        if (empLink) {
            empLink.click();
            console.log('✅ NAV OK - Vista empleados activada');
        } else {
            console.log('❌ NAV ERROR - Link empleados no encontrado');
        }
        
        console.log('🎉 TEST COMPLETO EXITOSO!');
        
    } catch (error) {
        console.error('❌ TEST ERROR:', error);
    }
}

// Ejecutar cuando todo esté listo
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => setTimeout(testCompleteFlow, 1000));
} else {
    setTimeout(testCompleteFlow, 1000);
}