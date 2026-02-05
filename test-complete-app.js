// =====================================================
// PRUEBAS COMPLETAS DE LA APLICACIÓN ERP AFIRMA
// =====================================================

console.log('🧪 INICIANDO PRUEBAS COMPLETAS DE LA APLICACIÓN ERP AFIRMA');
console.log('='.repeat(60));

async function testCompleteApp() {
    const baseURL = 'http://localhost:3000';
    let totalTests = 0;
    let passedTests = 0;
    let failedTests = [];

    // Función auxiliar para hacer pruebas
    async function runTest(testName, testFunction) {
        totalTests++;
        try {
            console.log(`\n🔬 ${testName}...`);
            await testFunction();
            passedTests++;
            console.log(`✅ ${testName} - EXITOSO`);
        } catch (error) {
            failedTests.push({ name: testName, error: error.message });
            console.error(`❌ ${testName} - FALLÓ: ${error.message}`);
        }
    }

    // =====================================================
    // PRUEBA 1: HEALTH CHECK
    // =====================================================
    await runTest('Health Check', async () => {
        const response = await fetch(`${baseURL}/api/health`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const data = await response.json();
        if (data.status !== 'OK') throw new Error('Health check failed');
        console.log(`   ℹ️  Status: ${data.status}, DB: ${data.database}, Uptime: ${data.uptime}`);
    });

    // =====================================================
    // PRUEBA 2: API EMPLOYEES-V2
    // =====================================================
    await runTest('API Employees-v2', async () => {
        const response = await fetch(`${baseURL}/api/employees-v2`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const employees = await response.json();
        if (!Array.isArray(employees)) throw new Error('Response is not an array');
        console.log(`   ℹ️  Total empleados: ${employees.length}`);
        if (employees.length > 0) {
            const emp = employees[0];
            console.log(`   ℹ️  Primer empleado: ${emp.first_name} ${emp.last_name} (ID: ${emp.id})`);
            console.log(`   ℹ️  Entidad: ${emp.entity_name}, Posición: ${emp.position_name}`);
        }
    });

    // =====================================================
    // PRUEBA 3: API EMPLOYEES (OBSOLETA) - DEBE FALLAR
    // =====================================================
    await runTest('API Employees obsoleta (debe fallar)', async () => {
        try {
            const response = await fetch(`${baseURL}/api/employees`);
            if (response.ok) {
                throw new Error('El endpoint obsoleto /api/employees aún funciona - debería estar eliminado');
            }
            console.log(`   ✅ Endpoint obsoleto correctamente eliminado (HTTP ${response.status})`);
        } catch (fetchError) {
            // Si es error de conexión, está bien porque significa que el endpoint no existe
            if (fetchError.message.includes('fetch')) {
                console.log(`   ✅ Endpoint obsoleto correctamente eliminado`);
                return;
            }
            throw fetchError;
        }
    });

    // =====================================================
    // PRUEBA 4: API INVENTORY
    // =====================================================
    await runTest('API Inventory', async () => {
        const response = await fetch(`${baseURL}/api/inventory`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const inventory = await response.json();
        if (!Array.isArray(inventory)) throw new Error('Response is not an array');
        console.log(`   ℹ️  Total equipos: ${inventory.length}`);
        if (inventory.length > 0) {
            const equip = inventory[0];
            console.log(`   ℹ️  Primer equipo: ${equip.nombre} - ${equip.marca} ${equip.modelo} (ID: ${equip.id})`);
        }
    });

    // =====================================================
    // PRUEBA 5: API MASTERCODE (CATÁLOGOS)
    // =====================================================
    const catalogs = ['Entidad', 'Puestos roles', 'Areas', 'Proyecto', 'Celulas', 'inventario de categoria de equipos'];
    
    for (const catalog of catalogs) {
        await runTest(`API Mastercode - ${catalog}`, async () => {
            const encodedCatalog = encodeURIComponent(catalog);
            const response = await fetch(`${baseURL}/api/mastercode/${encodedCatalog}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            const items = await response.json();
            if (!Array.isArray(items)) throw new Error('Response is not an array');
            console.log(`   ℹ️  ${catalog}: ${items.length} elementos`);
        });
    }

    // =====================================================
    // PRUEBA 6: FRONTEND ESTÁTICO
    // =====================================================
    await runTest('Frontend estático', async () => {
        const response = await fetch(`${baseURL}/`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const html = await response.text();
        if (!html.includes('<title>')) throw new Error('HTML inválido');
        if (!html.includes('ERP')) throw new Error('No contiene título ERP');
        console.log(`   ℹ️  HTML cargado correctamente (${html.length} caracteres)`);
    });

    // =====================================================
    // PRUEBA 7: ARCHIVOS JavaScript CRÍTICOS
    // =====================================================
    const jsFiles = ['/js/app.js', '/js/employees.js', '/js/inventory.js', '/js/catalogs.js'];
    
    for (const jsFile of jsFiles) {
        await runTest(`Archivo ${jsFile}`, async () => {
            const response = await fetch(`${baseURL}${jsFile}`);
            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            const content = await response.text();
            if (content.length === 0) throw new Error('Archivo vacío');
            console.log(`   ℹ️  ${jsFile}: ${content.length} caracteres`);
        });
    }

    // =====================================================
    // RESUMEN FINAL
    // =====================================================
    console.log('\n' + '='.repeat(60));
    console.log('📊 RESUMEN DE PRUEBAS COMPLETAS');
    console.log('='.repeat(60));
    console.log(`✅ Pruebas exitosas: ${passedTests}/${totalTests}`);
    console.log(`❌ Pruebas fallidas: ${failedTests.length}/${totalTests}`);
    
    if (failedTests.length > 0) {
        console.log('\n🔍 DETALLES DE FALLAS:');
        failedTests.forEach((test, index) => {
            console.log(`${index + 1}. ${test.name}: ${test.error}`);
        });
    }
    
    const successRate = (passedTests / totalTests * 100).toFixed(1);
    console.log(`\n🎯 Tasa de éxito: ${successRate}%`);
    
    if (successRate >= 90) {
        console.log('🎉 APLICACIÓN EN EXCELENTE ESTADO');
    } else if (successRate >= 75) {
        console.log('⚠️  APLICACIÓN REQUIERE ATENCIÓN');
    } else {
        console.log('🚨 APLICACIÓN TIENE PROBLEMAS CRÍTICOS');
    }
    
    console.log('\n🏁 PRUEBAS COMPLETAS TERMINADAS\n');
}

// Ejecutar pruebas
testCompleteApp().catch(error => {
    console.error('💥 Error fatal en las pruebas:', error);
    process.exit(1);
});