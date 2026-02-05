require('dotenv').config();
const XLSX = require('xlsx');
const db = require('./db');
const path = require('path');

async function loadExcelToEquipmentImproved() {
    const excelPath = path.join(__dirname, '../Docs Variados/Inventario de Activos.xlsx');
    
    try {
        console.log('📄 Leyendo archivo Excel:', excelPath);
        
        // Leer archivo Excel
        const workbook = XLSX.readFile(excelPath);
        const worksheet = workbook.Sheets['Activos'];
        const data = XLSX.utils.sheet_to_json(worksheet);
        
        console.log(`📊 Registros encontrados: ${data.length}`);
        
        let inserted = 0;
        let updated = 0;
        let errors = [];
        
        // Procesar cada fila con mapeo mejorado
        for (let i = 0; i < data.length; i++) {
            const row = data[i];
            
            try {
                // Mapear columnas del Excel específicamente
                const equipment = {
                    codigo: (row['ID'] ? `AF${row['ID'].toString().padStart(3, '0')}` : `EQ${(i + 1).toString().padStart(3, '0')}`),
                    nombre: (row['MODELO / DESCRIPCION'] || row['TIPO DE PRODUCTO'] || 'Sin descripción').toString().trim(),
                    marca: (row['MARCA'] || '').toString().trim() || null,
                    modelo: (row['MODELO / DESCRIPCION'] || '').toString().trim() || null,
                    serie: (row['NUMERO SERIE'] || '').toString().trim() || null,
                    categoria: (row['TIPO DE PRODUCTO'] || 'General').toString().trim(),
                    ubicacion: null, // No hay columna específica
                    estado: mapearEstado(row['ESTATUS']),
                    valor: null, // No hay precio en el Excel
                    fecha_compra: parseFecha(row['FECHA DE COMPRA']),
                    observaciones: construirObservaciones(row)
                };
                
                // Buscar empleado asignado
                let asignado_id = null;
                const nombreResponsable = row['NOMBRE DEL RESPONSABLE DEL ACTIVO'];
                if (nombreResponsable && nombreResponsable.toString().trim() !== '') {
                    const nombreCompleto = nombreResponsable.toString().trim();
                    
                    // Buscar empleado exacto o parcial
                    const empResult = await db.query(
                        `SELECT id, first_name, last_name FROM employees_v2 
                         WHERE CONCAT(UPPER(first_name), ' ', UPPER(last_name)) = UPPER($1) 
                         OR UPPER(CONCAT(first_name, ' ', last_name)) LIKE '%' || UPPER($1) || '%'
                         OR UPPER($1) LIKE '%' || UPPER(first_name) || '%'
                         LIMIT 1`,
                        [nombreCompleto]
                    );
                    
                    if (empResult.rows.length > 0) {
                        asignado_id = empResult.rows[0].id;
                        console.log(`👤 Empleado asignado: ${nombreCompleto} -> ${empResult.rows[0].first_name} ${empResult.rows[0].last_name} (ID: ${asignado_id})`);
                    } else {
                        console.log(`⚠️  Empleado no encontrado: ${nombreCompleto}`);
                    }
                }
                
                // Verificar si ya existe el equipo
                const existing = await db.query('SELECT id FROM equipment WHERE codigo = $1', [equipment.codigo]);
                
                if (existing.rows.length > 0) {
                    // Actualizar equipo existente
                    await db.query(
                        `UPDATE equipment SET 
                         nombre = $1, marca = $2, modelo = $3, serie = $4, 
                         categoria = $5, ubicacion = $6, asignado_id = $7, 
                         estado = $8, valor = $9, fecha_compra = $10, 
                         observaciones = $11, updated_at = CURRENT_TIMESTAMP
                         WHERE codigo = $12`,
                        [
                            equipment.nombre, equipment.marca, equipment.modelo, 
                            equipment.serie, equipment.categoria, equipment.ubicacion, 
                            asignado_id, equipment.estado, equipment.valor, 
                            equipment.fecha_compra, equipment.observaciones, equipment.codigo
                        ]
                    );
                    updated++;
                    console.log(`🔄 ${updated + inserted}/${data.length}: Actualizado ${equipment.codigo} - ${equipment.nombre}`);
                } else {
                    // Insertar nuevo equipo
                    const result = await db.query(
                        `INSERT INTO equipment (
                            codigo, nombre, marca, modelo, serie, categoria,
                            ubicacion, asignado_id, estado, valor, fecha_compra, observaciones
                        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
                        RETURNING id`,
                        [
                            equipment.codigo, equipment.nombre, equipment.marca, 
                            equipment.modelo, equipment.serie, equipment.categoria,
                            equipment.ubicacion, asignado_id, equipment.estado, 
                            equipment.valor, equipment.fecha_compra, equipment.observaciones
                        ]
                    );
                    inserted++;
                    console.log(`✅ ${updated + inserted}/${data.length}: Insertado ${equipment.codigo} - ${equipment.nombre}`);
                }
                
            } catch (error) {
                const errorMsg = `Error en fila ${i + 1} (ID: ${row['ID']}): ${error.message}`;
                console.error(`❌ ${errorMsg}`);
                errors.push(errorMsg);
                continue;
            }
        }
        
        console.log('\n📊 RESUMEN DE IMPORTACIÓN MEJORADA:');
        console.log(`✅ Registros insertados: ${inserted}`);
        console.log(`🔄 Registros actualizados: ${updated}`);
        console.log(`📈 Total procesados: ${inserted + updated}/${data.length}`);
        console.log(`❌ Errores: ${errors.length}`);
        
        if (errors.length > 0) {
            console.log('\n🚨 ERRORES ENCONTRADOS:');
            errors.forEach((error, i) => {
                console.log(`${i + 1}. ${error}`);
            });
        }
        
        console.log('\n🎉 Importación mejorada completada!');
        
    } catch (error) {
        console.error('❌ Error general:', error.message);
        throw error;
    } finally {
        await db.pool.end();
    }
}

function mapearEstado(estatus) {
    if (!estatus) return 'Activo';
    
    const statusMap = {
        'Asignado': 'Activo',
        'Revisar': 'Mantenimiento',
        'Disponible': 'Activo',
        'En uso': 'Activo',
        'Dañado': 'Inactivo',
        'Baja': 'Baja'
    };
    
    const statusStr = estatus.toString().trim();
    return statusMap[statusStr] || 'Activo';
}

function parseFecha(fechaExcel) {
    if (!fechaExcel || fechaExcel === 'N/A' || fechaExcel === '@') return null;
    
    try {
        // Si es un número (fecha serial de Excel)
        if (typeof fechaExcel === 'number') {
            const fecha = XLSX.SSF.parse_date_code(fechaExcel);
            return `${fecha.y}-${fecha.m.toString().padStart(2, '0')}-${fecha.d.toString().padStart(2, '0')}`;
        }
        
        // Si es texto, intentar parsearlo
        const fecha = new Date(fechaExcel);
        if (!isNaN(fecha.getTime())) {
            return fecha.toISOString().split('T')[0];
        }
    } catch (e) {
        // Ignorar errores de fecha
    }
    
    return null;
}

function construirObservaciones(row) {
    const observaciones = [];
    
    if (row['COMENTARIOS']) {
        observaciones.push(`Comentarios: ${row['COMENTARIOS']}`);
    }
    
    if (row['MEMORIA RAM']) {
        observaciones.push(`RAM: ${row['MEMORIA RAM']}`);
    }
    
    if (row['DISCO DURO']) {
        observaciones.push(`Disco: ${row['DISCO DURO']}`);
    }
    
    if (row['PROCESADOR']) {
        observaciones.push(`CPU: ${row['PROCESADOR']}`);
    }
    
    if (row['SISTEMA OPERATIVO']) {
        observaciones.push(`SO: ${row['SISTEMA OPERATIVO']}`);
    }
    
    if (row['HOST NAME'] && row['HOST NAME'] !== 'N/A') {
        observaciones.push(`Host: ${row['HOST NAME']}`);
    }
    
    return observaciones.length > 0 ? observaciones.join(' | ') : null;
}

// Ejecutar importación mejorada
console.log('🚀 Iniciando importación MEJORADA de equipos desde Excel...\n');
loadExcelToEquipmentImproved()
    .then(() => {
        console.log('✨ Proceso mejorado completado exitosamente');
        process.exit(0);
    })
    .catch((error) => {
        console.error('💥 Error en el proceso mejorado:', error.message);
        process.exit(1);
    });