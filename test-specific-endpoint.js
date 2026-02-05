// Test específico del endpoint con logs detallados
const fetch = require('node-fetch');

async function testSpecificEndpoint() {
    try {
        console.log('🧪 Test específico del endpoint de categorías...');
        console.log('URL:', 'http://localhost:3000/api/mastercode/inventario-categorias');
        
        const response = await fetch('http://localhost:3000/api/mastercode/inventario-categorias');
        
        console.log('Status:', response.status);
        console.log('Status Text:', response.statusText);
        console.log('Headers:', Object.fromEntries(response.headers));
        
        const text = await response.text();
        console.log('Raw Response:', text);
        
        if (response.ok) {
            try {
                const data = JSON.parse(text);
                console.log('Parsed Data:', data);
                console.log('Data Length:', data.length);
            } catch (parseError) {
                console.error('JSON Parse Error:', parseError.message);
            }
        }
        
    } catch (error) {
        console.error('❌ Fetch Error:', error.message);
    }
    
    process.exit(0);
}

testSpecificEndpoint();