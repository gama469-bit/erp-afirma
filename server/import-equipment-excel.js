require('dotenv').config();
const XLSX = require('xlsx');
const db = require('./db');
const path = require('path');

async function loadExcelToEquipment() {
    const excelPath = path.join(__dirname, '../Docs Variados/Inventario de Activos.xlsx');
    
    try {
        console.log('📄 Leyendo archivo Excel:', excelPath);
        
        // Leer archivo Excel
        const workbook = XLSX.readFile(excelPath);
        console.log('📋 Hojas disponibles:', workbook.SheetNames);
        
        // Leer hoja 'Activos'
        const sheetName = 'Activos';
        if (!workbook.SheetNames.includes(sheetName)) {
            throw new Error(`Hoja '${sheetName}' no encontrada. Hojas disponibles: ${workbook.SheetNames.join(', ')}`);
        }
        
        const worksheet = workbook.Sheets[sheetName];
        const data = XLSX.utils.sheet_to_json(worksheet);
        
        console.log(`📊 Registros encontrados: ${data.length}`);
        if (data.length === 0) {
            throw new Error('No se encontraron datos en la hoja especificada');
        }
        
        // Mostrar primeras 3 filas para análisis
        console.log('\n📝 Primeras 3 filas de datos:');
        data.slice(0, 3).forEach((row, i) => {
            console.log(`Fila ${i + 1}:`, Object.keys(row));
            console.log(`Contenido:`, row);
        });
        
        let inserted = 0;
        let errors = [];
        
        // Limpiar tabla equipment antes de insertar (opcional)
        console.log('\n🗑️ Limpiando tabla equipment...');
        await db.query('DELETE FROM equipment');
        console.log('✅ Tabla equipment limpiada');
        
        // Procesar cada fila
        for (let i = 0; i < data.length; i++) {
            const row = data[i];
            
            try {
                // Mapear columnas del Excel a campos de la BD
                // Ajustar según las columnas reales del Excel
                const equipment = {
                    codigo: (row['Código'] || row['codigo'] || row['CODIGO'] || row['Code'] || `EQ${(i + 1).toString().padStart(3, '0')}`).toString().trim(),
                    nombre: (row['Nombre'] || row['nombre'] || row['NOMBRE'] || row['Descripción'] || row['descripcion'] || row['DESCRIPCION'] || row['Name'] || row['Description'] || 'Sin nombre').toString().trim(),
                    marca: (row['Marca'] || row['marca'] || row['MARCA'] || row['Brand'] || '').toString().trim() || null,
                    modelo: (row['Modelo'] || row['modelo'] || row['MODELO'] || row['Model'] || '').toString().trim() || null,
                    serie: (row['Serie'] || row['serie'] || row['SERIE'] || row['Serial'] || row['Número de serie'] || '').toString().trim() || null,
                    categoria: (row['Categoría'] || row['categoria'] || row['CATEGORIA'] || row['Category'] || row['Tipo'] || row['tipo'] || row['TIPO'] || 'General').toString().trim(),
                    ubicacion: (row['Ubicación'] || row['ubicacion'] || row['UBICACION'] || row['Location'] || row['Área'] || row['area'] || '').toString().trim() || null,
                    estado: (row['Estado'] || row['estado'] || row['ESTADO'] || row['Status'] || row['Estatus'] || 'Activo').toString().trim(),
                    valor: null, // Procesaremos valores numéricos
                    fecha_compra: null, // Procesaremos fechas
                    observaciones: (row['Observaciones'] || row['observaciones'] || row['OBSERVACIONES'] || row['Notes'] || row['Notas'] || '').toString().trim() || null
                };
                
                // Procesar valor/precio
                const valorFields = ['Valor', 'valor', 'VALOR', 'Price', 'Precio', 'precio', 'PRECIO', 'Costo', 'costo', 'COSTO'];
                for (const field of valorFields) {
                    if (row[field] !== undefined && row[field] !== null && row[field] !== '') {
                        const valorStr = row[field].toString().replace(/[^0-9\.-]/g, '');
                        const valorNum = parseFloat(valorStr);
                        if (!isNaN(valorNum) && valorNum > 0) {
                            equipment.valor = valorNum;
                            break;
                        }
                    }
                }
                
                // Procesar fecha de compra
                const fechaFields = ['Fecha compra', 'fecha_compra', 'FECHA_COMPRA', 'Purchase Date', 'Fecha', 'fecha', 'FECHA'];
                for (const field of fechaFields) {
                    if (row[field] !== undefined && row[field] !== null && row[field] !== '') {
                        try {
                            const fecha = new Date(row[field]);
                            if (!isNaN(fecha.getTime())) {
                                equipment.fecha_compra = fecha.toISOString().split('T')[0];
                                break;
                            }
                        } catch (e) {
                            // Ignorar errores de fecha
                        }
                    }
                }
                
                // Buscar empleado asignado por nombre
                let asignado_id = null;
                const asignadoFields = ['Asignado', 'asignado', 'ASIGNADO', 'Assigned', 'Usuario', 'usuario', 'USUARIO', 'Empleado', 'empleado'];
                for (const field of asignadoFields) {
                    if (row[field] && row[field].toString().trim() !== '') {
                        const nombreAsignado = row[field].toString().trim();
                        
                        // Buscar empleado en employees_v2
                        try {
                            const empResult = await db.query(
                                `SELECT id FROM employees_v2 
                                 WHERE CONCAT(first_name, ' ', last_name) ILIKE $1 
                                 OR first_name ILIKE $1 
                                 OR last_name ILIKE $1 
                                 LIMIT 1`,
                                [nombreAsignado]
                            );
                            
                            if (empResult.rows.length > 0) {
                                asignado_id = empResult.rows[0].id;
                                console.log(`👤 Empleado encontrado: ${nombreAsignado} -> ID ${asignado_id}`);
                                break;
                            }
                        } catch (empError) {
                            console.warn(`⚠️ Error buscando empleado ${nombreAsignado}:`, empError.message);
                        }
                        break;
                    }
                }
                
                // Validar campos obligatorios
                if (!equipment.codigo || equipment.codigo === '') {
                    equipment.codigo = `EQ${(i + 1).toString().padStart(3, '0')}`;
                }
                
                if (!equipment.nombre || equipment.nombre === '' || equipment.nombre === 'Sin nombre') {
                    equipment.nombre = `Equipo ${equipment.codigo}`;
                }
                
                // Insertar en la base de datos
                const result = await db.query(
                    `INSERT INTO equipment (
                        codigo, nombre, marca, modelo, serie, categoria,
                        ubicacion, asignado_id, estado, valor, fecha_compra, observaciones
                    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
                    RETURNING id, codigo, nombre`,
                    [
                        equipment.codigo,
                        equipment.nombre,
                        equipment.marca,
                        equipment.modelo,
                        equipment.serie,
                        equipment.categoria,
                        equipment.ubicacion,
                        asignado_id,
                        equipment.estado,
                        equipment.valor,
                        equipment.fecha_compra,
                        equipment.observaciones
                    ]
                );
                
                inserted++;
                console.log(`✅ ${inserted}/${data.length}: ${result.rows[0].codigo} - ${result.rows[0].nombre}`);
                
            } catch (error) {
                const errorMsg = `Error en fila ${i + 1}: ${error.message}`;
                console.error(`❌ ${errorMsg}`);
                errors.push(errorMsg);
                
                // Continuar con el siguiente registro en caso de error
                continue;
            }
        }
        
        console.log('\n📊 RESUMEN DE IMPORTACIÓN:');
        console.log(`✅ Registros insertados: ${inserted}/${data.length}`);
        console.log(`❌ Errores: ${errors.length}`);
        
        if (errors.length > 0) {
            console.log('\n🚨 ERRORES ENCONTRADOS:');
            errors.forEach((error, i) => {
                console.log(`${i + 1}. ${error}`);
            });
        }
        
        console.log('\n🎉 Importación completada!');
        
    } catch (error) {
        console.error('❌ Error general:', error.message);
        throw error;
    } finally {
        // Cerrar conexión
        await db.pool.end();
    }
}

// Ejecutar importación
console.log('🚀 Iniciando importación de equipos desde Excel...\n');
loadExcelToEquipment()
    .then(() => {
        console.log('✨ Proceso completado exitosamente');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Error en el proceso:', error.message);
        process.exit(1);
    });