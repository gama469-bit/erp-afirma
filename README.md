# 🏢 ERP Afirma - Sistema de Gestión de Empleados

Sistema profesional de gestión de empleados con base de datos normalizada, importación de Excel y auditoría completa.

## ✨ Características Principales

- **Base de Datos Normalizada** (3FN) con 7 tablas relacionales
- **CRUD Completo** de empleados, candidatos, departamentos y puestos
- **Importación de Excel/CSV** con validación automática
- **Auditoría de Cambios** completa y trazable
- **Gestión de Salarios** con historial
- **Contactos de Emergencia** por empleado
- **Validaciones** en BD y API
- **Índices Optimizados** para rendimiento
- **Soft Delete** preservando históricos
- **API RESTful** moderna

## 📋 Proyecto

```
erp-afirma
├── src/
│   ├── index.html              # Interfaz principal
│   ├── css/
│   │   └── styles.css          # Estilos modernos (diseño Afirma)
│   ├── js/
│   │   ├── app.js              # Lógica principal y navegación
│   │   ├── employees.js        # Cliente API de empleados
│   │   ├── candidates.js       # Cliente API de candidatos
│   │   ├── ui.js               # Renderizado de listas
│   │   └── import.js           # Importación de Excel
│   ├── data/
│   │   └── employees.json      # Datos iniciales
│   └── assets/
│       └── logo.svg            # Logo Afirma
├── server/
│   ├── api.js                  # API REST (puerto 3000)
│   ├── frontend.js             # Servidor frontend (puerto 8082)
│   ├── db.js                   # Conexión PostgreSQL
│   ├── migrate.js              # Ejecutor de migraciones
│   └── migrations/
│       ├── 001_create_employees.sql
│       ├── 002_create_candidates.sql
│       ├── 003_create_departments.sql
│       ├── 004_create_positions.sql
│       ├── 005_create_employees_v2.sql
│       └── 006_create_employee_relations.sql
├── DATABASE_SCHEMA.md          # Documentación de esquema
├── SETUP_GUIDE.md              # Guía de uso
├── NORMALIZATION_REPORT.md     # Reporte de normalización
├── generate_excel_sample.js    # Generador de ejemplos
└── employees_sample.xlsx       # Archivo de ejemplo
```

## 🚀 Instalación Rápida

### 1. Requisitos Previos
- Node.js v14+
- PostgreSQL v12+
- npm

### 2. Configuración
```bash
# Clonar repo (si aplica)
cd erp-afirma

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env
# Editar .env con credenciales PostgreSQL
```

### 3. Base de Datos
```bash
# Ejecutar migraciones
npm run migrate
```

### 4. Iniciar Aplicación
```bash
# Iniciar API + Frontend (en paralelo)
npm run start:all

# O por separado:
npm run api      # Puerto 3000
npm run frontend # Puerto 8082
```

Accede a: **http://localhost:8082**

## 📊 Estructura de Base de Datos

### Tablas Principales

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| `departments` | Departamentos de la empresa | 7 |
| `positions` | Catálogo de puestos | 11 |
| `employees_v2` | Empleados normalizados | Principal |
| `salary_history` | Historial de salarios | 1:N |
| `emergency_contacts` | Contactos de emergencia | N:M |
| `employee_documents` | Documentos personales | N:M |
| `employee_audit_log` | Auditoría de cambios | Completa |

### Validaciones
- ✅ Email único y válido
- ✅ Teléfonos con formato
- ✅ Fechas coherentes
- ✅ Estados enumerados
- ✅ Integridad referencial

## 🔌 API Endpoints

### Empleados
```bash
GET    /api/employees-v2           # Listar todos
GET    /api/employees-v2/:id       # Obtener uno
POST   /api/employees-v2           # Crear
PUT    /api/employees-v2/:id       # Actualizar
DELETE /api/employees-v2/:id       # Marcar como inactivo
```

### Departamentos y Puestos
```bash
GET    /api/departments            # Listar departamentos
POST   /api/departments            # Crear departamento
GET    /api/positions              # Listar puestos
POST   /api/positions              # Crear puesto
```

### Información Relacionada
```bash
GET    /api/employees-v2/:id/salary-history          # Historial de salarios
POST   /api/employees-v2/:id/salary                  # Agregar salario
GET    /api/employees-v2/:id/emergency-contacts      # Contactos emergencia
POST   /api/employees-v2/:id/emergency-contacts      # Agregar contacto
```

### Importación
```bash
POST   /api/upload-employees       # Importar empleados (Excel/CSV)
POST   /api/upload-candidates      # Importar candidatos (Excel/CSV)
```

## 📥 Importar Datos desde Excel

### Formato Requerido:
**Empleados:**
```
Nombre | Apellido | Email | Teléfono | Posición | Departamento
```

**Candidatos:**
```
Nombre | Apellido | Email | Teléfono | Posición | Estado | Notas
```

### Pasos:
1. Haz clic en "📄 Importar Excel"
2. Selecciona el archivo Excel o arrastra
3. Sistema valida automáticamente
4. Se muestran resultados y errores

**Archivo de ejemplo:** `employees_sample.xlsx`

## 📱 Módulos de la Aplicación

### Inicio
- Dashboard principal
- Bienvenida y estado

### Empleados
- Lista de empleados activos
- Agregar empleado (modal)
- Editar empleado
- Eliminar (marcar inactivo)
- **Importar desde Excel**
- Ver salarios, contactos

### Reclutamiento
- Lista de candidatos
- Agregar candidato
- Cambiar estado (revisión → entrevista → oferta)
- Notas y comentarios
- **Importar candidatos**

## 🔐 Seguridad

- Validación de email en BD y API
- Prepared statements contra SQL injection
- Restricciones CHECK en campos
- Integridad referencial (FK)
- Auditoría completa de cambios
- Control de acceso básico

## 📈 Datos de Ejemplo

Se incluyen 5 empleados con datos completos:
- Información personal y corporativa
- Historial salarial
- Contactos de emergencia
- Documentos (estructura lista)

**Generar nuevos ejemplos:**
```bash
node generate_excel_sample.js
```

## 🛠️ Desarrollo

### Scripts Útiles
```bash
npm run start:all              # Iniciar todo
npm run api                    # Solo API
npm run frontend               # Solo Frontend
npm run migrate                # Ejecutar migraciones
npm run dev                    # Modo desarrollo con nodemon
```

### Base de Datos Queries Útiles
```sql
-- Empleados activos por departamento
SELECT d.name, COUNT(*) FROM employees_v2 e
JOIN departments d ON e.department_id = d.id
WHERE e.status = 'Activo'
GROUP BY d.name;

-- Empleados próximos a cumpleaños
SELECT * FROM employees_v2
WHERE EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM NOW());

-- Historial salarial de un empleado
SELECT * FROM salary_history WHERE employee_id = 1
ORDER BY effective_date DESC;
```

## 📚 Documentación Adicional

- **DATABASE_SCHEMA.md** - Esquema completo de BD
- **SETUP_GUIDE.md** - Guía detallada de uso
- **NORMALIZATION_REPORT.md** - Análisis de normalización

## 🔄 Variables de Entorno (.env)

```env
DATABASE_USER=postgres
DATABASE_PASSWORD=Sistemas1
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=BD_afirma

API_PORT=3000
FRONTEND_PORT=8082
NODE_ENV=development
```

## 🎯 Características de Seguridad

- ✅ Validación de entrada
- ✅ Prepared statements
- ✅ Constraints en BD
- ✅ Soft delete (preserva históricos)
- ✅ Auditoría completa
- ✅ Errores detallados (desarrollo)
- ✅ CORS habilitado

## 🚀 Mejoras Futuras

- [ ] Autenticación JWT
- [ ] Dashboard analítico
- [ ] Exportar reportes (PDF, Excel)
- [ ] Nómina integrada
- [ ] Evaluaciones de desempeño
- [ ] Capacitaciones
- [ ] Notificaciones
- [ ] Búsqueda avanzada
- [ ] Filtros y reportes

## 👥 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Haz fork del proyecto
2. Crea una rama (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT.

## 📞 Soporte

Para problemas o preguntas:
1. Revisa la documentación en `DATABASE_SCHEMA.md`
2. Verifica `SETUP_GUIDE.md` para ejemplos
3. Consulta los logs de la API: `console.log` en `server/api.js`
4. Prueba los endpoints con Postman/Insomnia

---

**Versión:** 2.0.0  
**Estado:** ✅ Producción  
**Última actualización:** 2024-11-13
