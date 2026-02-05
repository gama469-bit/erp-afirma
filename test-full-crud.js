// Test directo del endpoint de categorías
const fetch = require('node-fetch');

async function testCategoriesEndpoint() {
    try {
        console.log('🧪 Probando endpoint /api/mastercode/inventario-categorias...');
        
        const response = await fetch('http://localhost:3000/api/mastercode/inventario-categorias');
        
        if (response.ok) {
            const categories = await response.json();
            console.log(`✅ Respuesta exitosa. Categorías encontradas: ${categories.length}`);
            
            categories.forEach(cat => {
                console.log(`  - ${cat.item} (ID: ${cat.id})`);
            });
            
            // Test agregar nueva categoría
            console.log('\n🆕 Probando agregar nueva categoría...');
            const testCategory = 'Categoria Test ' + Date.now();
            
            const addResponse = await fetch('http://localhost:3000/api/mastercode/inventario-categorias', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ name: testCategory })
            });
            
            if (addResponse.ok) {
                const newCat = await addResponse.json();
                console.log(`✅ Categoría agregada: ${newCat.item} (ID: ${newCat.id})`);
                
                // Test eliminar categoría
                console.log('\n🗑️ Probando eliminar categoría...');
                const deleteResponse = await fetch(`http://localhost:3000/api/mastercode/inventario-categorias/${newCat.id}`, {
                    method: 'DELETE'
                });
                
                if (deleteResponse.ok) {
                    console.log('✅ Categoría eliminada exitosamente');
                } else {
                    console.log('❌ Error eliminando categoría:', deleteResponse.status);
                }
            } else {
                console.log('❌ Error agregando categoría:', addResponse.status);
            }
            
        } else {
            console.log(`❌ Error en la respuesta: ${response.status} ${response.statusText}`);
        }
        
    } catch (error) {
        console.error('❌ Error:', error.message);
    }
    
    process.exit(0);
}

testCategoriesEndpoint();