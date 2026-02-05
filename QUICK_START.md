# 🚀 GUÍA RÁPIDA DE INICIO

**Tiempo estimado:** 5 minutos

---

## 📌 En Este Momento

✅ **Aplicación está corriendo en:**
- Frontend: http://localhost:8082
- API: http://localhost:3000

✅ **Base de datos:** Completamente normalizada con 9 tablas

✅ **Datos de prueba:** 5 empleados incluidos

---

## 🎯 Qué Puedes Hacer Ahora

### 1️⃣ Acceder a la Aplicación
```
Abre en tu navegador: http://localhost:8082
```

### 2️⃣ Explorar Módulos
- **Inicio** - Dashboard principal
- **Empleados** - Lista y gestión
- **Reclutamiento** - Candidatos

### 3️⃣ Importar Datos desde Excel
```
1. Haz clic en "📄 Importar Excel"
2. Selecciona: employees_sample.xlsx
3. El sistema carga automáticamente
```

### 4️⃣ Probar API (Postman/Insomnia)
```
GET http://localhost:3000/api/employees-v2
GET http://localhost:3000/api/departments
GET http://localhost:3000/api/positions
```

### 5️⃣ Ver Base de Datos
```sql
-- Conectar a PostgreSQL
psql -U postgres -d BD_afirma

-- Ver empleados
SELECT * FROM employees_v2;

-- Ver salarios
SELECT * FROM salary_history;
```

---

## 📁 Archivos Importantes

### 📖 Documentación (LEE ESTO PRIMERO)
- **README.md** - Visión general
- **IMPLEMENTATION_SUMMARY.md** - Qué se hizo
- **SETUP_GUIDE.md** - Cómo usar la API
- **DATABASE_SCHEMA.md** - Esquema detallado
- **FINAL_CHECKLIST.md** - Validación completa

### 🔧 Configuración
- **.env** - Variables de entorno
- **package.json** - Dependencias

### 📊 Datos
- **employees_sample.xlsx** - Ejemplo para importar
- **server/seeds/seed_employees.sql** - Datos de prueba SQL

### 💻 Código
- **server/api.js** - API endpoints (20+)
- **src/index.html** - Interfaz principal
- **server/migrations/** - Scripts de BD

---

## 🎮 Acciones Comunes

### Crear Empleado (Vía UI)
```
1. Haz clic en "Empleados"
2. Haz clic en "+ Agregar Empleado"
3. Completa el formulario modal
4. Guarda
```

### Importar Empleados (Vía UI)
```
1. Haz clic en "Empleados"
2. Haz clic en "📄 Importar Excel"
3. Arrastra employees_sample.xlsx
4. El sistema valida y carga
```

### Consultar Vía API
```bash
# Listar todos
curl http://localhost:3000/api/employees-v2

# Obtener detalles
curl http://localhost:3000/api/employees-v2/1

# Crear
curl -X POST http://localhost:3000/api/employees-v2 \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "Juan",
    "last_name": "García",
    "email": "juan@test.com",
    "position_id": 1
  }'
```

---

## 🛠️ Comandos Útiles

### Reiniciar Aplicación
```bash
cd c:\Desarrollo\employee-management-app
npm run start:all
```

### Solo API
```bash
npm run api
```

### Solo Frontend
```bash
npm run frontend
```

### Ejecutar Migraciones
```bash
npm run migrate
```

### Generar Nuevos Ejemplos Excel
```bash
node generate_excel_sample.js
```

---

## 🔍 Verificar Estado

### ¿Está todo corriendo?
```bash
# Test API
curl http://localhost:3000/health

# Debería retornar: {"status":"ok"}
```

### Ver Base de Datos
```bash
# Conectar a PostgreSQL
psql -U postgres -d BD_afirma

# Ver empleados
\c BD_afirma
SELECT COUNT(*) FROM employees_v2;

# Listar departamentos
SELECT * FROM departments;
```

---

## 📞 Soporte Rápido

### Si la API no responde:
1. Verifica que Node esté corriendo: `node -v`
2. Verifica que PostgreSQL esté activo
3. Reinicia con: `npm run start:all`

### Si la BD no conecta:
1. Verifica PostgreSQL: `psql -U postgres`
2. Verifica BD existe: `\l | grep BD_afirma`
3. Ejecuta migraciones: `npm run migrate`

### Si falta algo:
1. Lee: **README.md**
2. Lee: **SETUP_GUIDE.md**
3. Lee: **DATABASE_SCHEMA.md**

---

## 📈 Próximas Acciones Recomendadas

### Inmediato (Hoy)
- [ ] Accede a http://localhost:8082
- [ ] Explora la interfaz
- [ ] Importa employees_sample.xlsx
- [ ] Consulta la API con Postman

### Corto Plazo (Esta Semana)
- [ ] Lee toda la documentación
- [ ] Familiarízate con la API
- [ ] Crea empleados vía UI
- [ ] Verifica datos en BD

### Mediano Plazo (Este Mes)
- [ ] Integra con tu aplicación
- [ ] Crea dashboards personalizados
- [ ] Implementa reportes
- [ ] Agrega autenticación

---

## 📚 Documentación por Nivel

### Principiante
- README.md
- SETUP_GUIDE.md

### Intermedio
- DATABASE_SCHEMA.md
- IMPLEMENTATION_SUMMARY.md

### Avanzado
- DATABASE_SCHEMA.md (secciones técnicas)
- server/api.js (código fuente)
- server/migrations/ (scripts BD)

---

## 🎯 Objetivo del Proyecto

**Crear un ERP de AFIRMA completo para:**
- ✅ Gestionar empleados (CRUD)
- ✅ Importar datos desde Excel
- ✅ Mantener historial de cambios
- ✅ Auditoría completa
- ✅ Validaciones en múltiples niveles
- ✅ Escalable y performante

**ESTADO: ✅ COMPLETADO**

---

## 💡 Tips

💡 **Drag & drop** funciona para Excel - no necesitas botón "Examinar"

💡 Los **emails deben ser únicos** - el sistema valida automáticamente

💡 Eliminar empleado los marca como **"Inactivo"** - no se pierden datos

💡 Puedes **agregar salarios** y **contactos** por empleado

💡 **Todos los cambios se auditan** automáticamente

---

## 🚀 ¡Estás Listo!

**Lo que necesitas saber:**
- Aplicación corre en puerto 8082
- API en puerto 3000
- Base de datos: BD_afirma en PostgreSQL
- Archivo de ejemplo: employees_sample.xlsx
- Documentación en: README.md y otros .md

**Siguiente paso:** Abre http://localhost:8082 y ¡empieza!

---

**Versión:** 2.0.0  
**Última Actualización:** 2024-11-13  
**Estado:** ✅ Listo para usar
