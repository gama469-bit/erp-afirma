require('dotenv').config();
const db = require('./db');

async function seedEquipment() {
    try {
        // Insertar datos de ejemplo
        const equipments = [
            {
                codigo: 'EQ001',
                nombre: 'Laptop Dell Latitude',
                marca: 'Dell', 
                modelo: 'Latitude 7420',
                serie: 'DL7420001',
                categoria: 'Computo',
                ubicacion: 'Oficina 201',
                estado: 'Activo',
                valor: 25000.00,
                fecha_compra: '2023-01-15'
            },
            {
                codigo: 'EQ002',
                nombre: 'Monitor Samsung 24"',
                marca: 'Samsung',
                modelo: 'S24F350F', 
                serie: 'SM24001',
                categoria: 'Electronico',
                ubicacion: 'Oficina 201',
                estado: 'Activo',
                valor: 5500.00,
                fecha_compra: '2023-01-15'
            },
            {
                codigo: 'EQ003',
                nombre: 'Escritorio Ejecutivo',
                marca: 'Officeline',
                modelo: 'EJE-2020',
                serie: 'OF2020001', 
                categoria: 'Mobiliario',
                ubicacion: 'Oficina 202',
                estado: 'Activo',
                valor: 8000.00,
                fecha_compra: '2022-12-10'
            }
        ];

        for (const equipment of equipments) {
            await db.query(`
                INSERT INTO equipment (
                    codigo, nombre, marca, modelo, serie, categoria,
                    ubicacion, estado, valor, fecha_compra
                ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
                ON CONFLICT (codigo) DO NOTHING
            `, [
                equipment.codigo, equipment.nombre, equipment.marca,
                equipment.modelo, equipment.serie, equipment.categoria,
                equipment.ubicacion, equipment.estado, equipment.valor,
                equipment.fecha_compra
            ]);
            
            console.log(`✅ Equipment ${equipment.codigo} inserted/updated`);
        }

        console.log('🎉 Equipment seed data completed');
        process.exit(0);
    } catch (error) {
        console.error('❌ Error seeding equipment:', error);
        process.exit(1);
    }
}

seedEquipment();