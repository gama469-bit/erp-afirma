# 🚀 PLAN DE DIVISIÓN DE TRABAJO - 2 DESARROLLADORES

**Fecha:** 5 de Febrero 2026  
**Objetivo:** Completar MVP del ERP Afirma (52% → 100%)  
**Equipo:** 2 Desarrolladores Full-Stack  
**Tiempo Estimado:** 3-4 Sprints (6-8 semanas)

---

## 📋 RESUMEN DEL TRABAJO PENDIENTE

| Item | Componente | Esfuerzo | Prioridad |
|------|-----------|----------|-----------|
| UI de Asignaciones | Frontend | 16-20h | 🔴 CRÍTICA |
| Endpoint Asignaciones/Recurso | Backend | 8-10h | 🔴 CRÍTICA |
| Validación Exclusividad | Backend | 4-6h | 🔴 CRÍTICA |
| Recursos en Banca | Full-Stack | 10-12h | 🔴 CRÍTICA |
| Reportes (4 endpoints) | Full-Stack | 20-24h | 🟡 ALTA |
| Autenticación y Roles | Full-Stack | 25-30h | 🟡 MEDIA |
| Campos Proyecto (Cliente, Modalidad) | Full-Stack | 4-6h | 🟢 BAJA |
| **TOTAL** | — | **87-108h** | — |

**Tiempo por Dev:** 43-54 horas cada uno (5-7 semanas a 8h/semana)

---

## 🎯 ESTRATEGIA DE DIVISIÓN

### Opción Recomendada: **División por Especialidad (Front/Back)**

#### 👨‍💻 DEV 1 - "Backend Lead"
**Foco:** Endpoints, lógica de negocio, reportes

#### 👩‍💻 DEV 2 - "Frontend Lead"  
**Foco:** UI/UX, integración, validaciones de cliente

**Ventajas:**
- ✅ Menos conflictos de merge
- ✅ Cada dev se especializa
- ✅ Trabajo paralelo sin bloqueos
- ✅ Code review más efectivo

---

## 📅 SPRINT 2 - ASIGNACIONES CORE (Semanas 1-2)

**Objetivo:** Hacer funcional el módulo de asignaciones para PMO

### 👨‍💻 DEV 1 - Backend Lead

#### Tarea 1: Endpoint de Asignaciones por Recurso (8-10h)
```javascript
// GET /api/employees/:id/assignments
// Retornar historial de proyectos de un empleado
```

**Subtareas:**
- [ ] Crear query JOIN entre `employees_v2`, `project_assignments`, `projects`
- [ ] Ordenar por fecha descendente
- [ ] Incluir: proyecto, rol, periodo, tarifa estimada
- [ ] Testing con Postman/curl
- [ ] Documentar en README

**Entregable:** Endpoint funcional + documentation  
**Tiempo:** 8-10 horas  
**Archivos:** `server/api.js` (línea ~1900)

---

#### Tarea 2: Validación de Exclusividad (4-6h)
```javascript
// POST /api/projects/:id/assignments
// Validar que recurso NO tenga asignación vigente
```

**Subtareas:**
- [ ] Query para detectar asignaciones activas:
```sql
SELECT COUNT(*) FROM project_assignments
WHERE employee_id = $1 
AND (end_date IS NULL OR end_date >= CURRENT_DATE)
```
- [ ] Retornar error 409 si hay conflicto
- [ ] Mensaje claro: "Empleado ya tiene asignación activa en proyecto X"
- [ ] Testing de edge cases (misma fecha inicio/fin)

**Entregable:** Validación implementada  
**Tiempo:** 4-6 horas  
**Archivos:** `server/api.js` (línea ~1862)

---

#### Tarea 3: Endpoint de Recursos en Banca (6-8h)
```javascript
// GET /api/employees/unassigned
// GET /api/reports/bench-resources
```

**Subtareas:**
- [ ] Query complejo:
```sql
SELECT e.*, 
  COUNT(pa.id) as active_assignments,
  MAX(pa.end_date) as last_assignment_end
FROM employees_v2 e
LEFT JOIN project_assignments pa ON e.id = pa.employee_id 
  AND (pa.end_date IS NULL OR pa.end_date >= CURRENT_DATE)
WHERE e.status = 'Activo'
GROUP BY e.id
HAVING COUNT(pa.id) = 0
```
- [ ] Agregar filtro opcional por área, rol
- [ ] Testing

**Entregable:** Endpoint funcional  
**Tiempo:** 6-8 horas  
**Archivos:** `server/api.js`

---

#### Tarea 4: Mejorar Endpoint de Asignaciones por Proyecto (2h)
```javascript
// GET /api/projects/:id/assignments
// Agregar información completa del empleado
```

**Subtareas:**
- [ ] Modificar query para incluir nombre, email, puesto
- [ ] Formatear fechas correctamente

**Entregable:** Endpoint mejorado  
**Tiempo:** 2 horas  
**Archivos:** `server/api.js` (línea ~1842)

---

**Total DEV 1 Sprint 2:** 20-26 horas

---

### 👩‍💻 DEV 2 - Frontend Lead

#### Tarea 1: Modal de Asignación de Recursos (12-16h)

**UI Overview:**
```
[Modal: Asignar Recurso a Proyecto]
  - Proyecto: [Dropdown] (pre-seleccionado si viene de vista proyecto)
  - Recurso: [Dropdown searchable con empleados activos]
  - Rol en proyecto: [Input text - ej: "Desarrollador Senior"]
  - Fecha Inicio: [Date picker]
  - Fecha Fin: [Date picker]
  - Horas asignadas/semana: [Number input]
  - [Botón: Guardar] [Botón: Cancelar]
```

**Subtareas:**
- [ ] Crear HTML del modal en `src/index.html` (líneas ~1100+)
- [ ] CSS styling (extender `src/css/styles.css`)
- [ ] JavaScript handlers en `src/js/app.js`:
  - [ ] `openAssignmentModal(projectId = null)`
  - [ ] `closeAssignmentModal()`
  - [ ] `submitAssignmentForm()`
- [ ] Cargar dropdown de empleados: `loadEmployeesForAssignment()`
- [ ] Cargar dropdown de proyectos: reusar función existente
- [ ] Validación cliente:
  - [x] Fechas requeridas
  - [x] Fecha fin > fecha inicio
  - [x] Horas > 0
- [ ] Integración con API:
  - POST `/api/projects/:id/assignments`
  - Manejo de error 409 (ya asignado)
- [ ] Mostrar mensaje de éxito/error

**Entregable:** Modal funcional  
**Tiempo:** 12-16 horas  
**Archivos:**
- `src/index.html`
- `src/js/app.js`
- `src/css/styles.css`

---

#### Tarea 2: Tabla de Asignaciones en Vista de Proyecto (4-6h)

**UI en Modal de Proyecto:**
```
[Proyecto: ADO]
  [Tab: Información General]
  [Tab: Recursos Asignados] <-- NUEVA
  
  [Tabla de Recursos Asignados]
  | Empleado | Rol | Inicio | Fin | Horas/sem | Acciones |
  |----------|-----|--------|-----|-----------|----------|
  | Juan G.  | Dev | 01/01  | -   | 40        | [X]     |
  
  [+ Asignar Recurso]
```

**Subtareas:**
- [ ] Agregar tab "Recursos Asignados" en modal de proyecto
- [ ] Función `loadProjectAssignments(projectId)` 
  - GET `/api/projects/:id/assignments`
- [ ] Renderizar tabla con datos
- [ ] Botón "Asignar Recurso" que abra modal
- [ ] Botón "X" para cancelar asignación (DELETE endpoint)
- [ ] Refresh automático después de crear/eliminar

**Entregable:** Vista de asignaciones funcionando  
**Tiempo:** 4-6 horas  
**Archivos:** `src/js/app.js`, `src/index.html`

---

#### Tarea 3: Pestaña de Historial de Proyectos en Empleado (4-6h)

**UI en Modal de Empleado:**
```
[Empleado: Juan Garcia]
  [Tab: Información General]
  [Tab: Expediente]
  [Tab: Recursos Humanos]
  [Tab: Mis Proyectos] <-- NUEVA
  
  [Historial de Proyectos]
  | Proyecto | Rol | Periodo | Horas | Estado |
  |----------|-----|---------|-------|--------|
  | ADO      | Dev | 01/01/24 - Actual | 40 | Activo |
  | RPA      | QA  | 01/09/23 - 31/12/23 | 20 | Completado |
```

**Subtareas:**
- [ ] Agregar tab "Mis Proyectos" en modal empleado
- [ ] Función `loadEmployeeAssignments(employeeId)`
  - GET `/api/employees/:id/assignments` (esperar a que DEV1 lo cree)
- [ ] Renderizar tabla
- [ ] Indicador visual de asignaciones activas vs históricas

**Entregable:** Historial visible  
**Tiempo:** 4-6 horas  
**Archivos:** `src/js/app.js`, `src/index.html`

---

**Total DEV 2 Sprint 2:** 20-28 horas

---

## 📅 SPRINT 3 - VISIBILIDAD OPERATIVA (Semanas 3-4)

**Objetivo:** Reportes y recursos en banca

### 👨‍💻 DEV 1 - Backend Lead

#### Tarea 1: Endpoint de Reporte Recursos por Proyecto (6-8h)
```javascript
// GET /api/reports/resources-by-project/:projectId
```

**Respuesta Esperada:**
```json
{
  "project": {
    "id": 1,
    "name": "ADO",
    "start_date": "2024-01-01",
    "status": "En Progreso"
  },
  "assignments": [
    {
      "employee_id": 1,
      "employee_name": "Juan Garcia Lopez",
      "employee_email": "juan.garcia@afirma.com",
      "position": "Desarrollador",
      "role_in_project": "Backend Developer",
      "start_date": "2024-01-15",
      "end_date": null,
      "hours_allocated": 40,
      "estimated_cost": 120000
    }
  ],
  "summary": {
    "total_resources": 5,
    "active_resources": 4,
    "total_hours": 180,
    "estimated_monthly_cost": 450000
  }
}
```

**Subtareas:**
- [ ] Query complejo con JOINs
- [ ] Cálculo de costos (salario o tarifa)
- [ ] Agregaciones (summary)
- [ ] Testing

**Entregable:** Endpoint con JSON estructurado  
**Tiempo:** 6-8 horas

---

#### Tarea 2: Endpoint de Reporte Proyectos por Recurso (6-8h)
```javascript
// GET /api/reports/projects-by-employee/:employeeId
```

**Respuesta Esperada:**
```json
{
  "employee": {
    "id": 1,
    "name": "Juan Garcia Lopez",
    "position": "Desarrollador",
    "status": "Activo"
  },
  "projects": [
    {
      "project_id": 1,
      "project_name": "ADO",
      "role": "Backend Dev",
      "start_date": "2024-01-01",
      "end_date": null,
      "hours_allocated": 40,
      "is_active": true
    }
  ],
  "summary": {
    "total_projects": 3,
    "active_projects": 1,
    "completed_projects": 2,
    "total_hours_worked": 1200,
    "average_hours_per_week": 35
  }
}
```

**Subtareas:**
- [ ] Query con agregaciones
- [ ] Calcular promedio de horas
- [ ] Diferenciar activos vs históricos
- [ ] Testing

**Entregable:** Endpoint funcional  
**Tiempo:** 6-8 horas

---

#### Tarea 3: Endpoint de Carga de Trabajo (Workload) (4-6h)
```javascript
// GET /api/reports/workload-summary
// Retorna resumen de carga de todos los recursos
```

**Subtareas:**
- [ ] Query agregado por empleado
- [ ] Calcular horas totales asignadas
- [ ] Identificar sobre-asignación (>40h)
- [ ] Testing

**Entregable:** Endpoint de análisis  
**Tiempo:** 4-6 horas

---

#### Tarea 4: Mejorar Endpoint de Candidatos (Duplicados) (3-4h)
```javascript
// GET /api/candidates/duplicates
// Identificar candidatos potencialmente duplicados
```

**Subtareas:**
- [ ] Query por email duplicado
- [ ] Query por nombre similar (LIKE o Levenshtein)
- [ ] Testing

**Entregable:** Endpoint de duplicados  
**Tiempo:** 3-4 horas

---

**Total DEV 1 Sprint 3:** 19-26 horas

---

### 👩‍💻 DEV 2 - Frontend Lead

#### Tarea 1: Vista de Recursos en Banca (6-8h)

**Nueva Vista en Sidebar:**
```
Sidebar:
  - Inicio
  - Empleados
  - Reclutamiento
  - Inventario de Equipos
  - Vacaciones
  - Proyectos
  > [NUEVO] Recursos en Banca  <--
  - Catálogos
```

**Subtareas:**
- [ ] Agregar link en sidebar
- [ ] Crear sección HTML `<section id="recursos-banca">`
- [ ] Función `fetchBenchResources()`
  - GET `/api/employees/unassigned`
- [ ] Tabla con:
  - Nombre, Puesto, Área, Última Asignación, Días sin proyecto
- [ ] Filtros: Por área, por rol
- [ ] Botón "Asignar a Proyecto" (abre modal de asignación)
- [ ] Badge visual con contador: "🏖️ 5 recursos disponibles"

**Entregable:** Vista funcional  
**Tiempo:** 6-8 horas  
**Archivos:** `src/index.html`, `src/js/app.js`, `src/css/styles.css`

---

#### Tarea 2: Vista de Reporte: Recursos por Proyecto (6-8h)

**Nueva Vista dentro de Proyectos:**
```
[Vista de Proyecto: ADO]
  [Tab: Información]
  [Tab: Recursos Asignados]
  [Tab: Reporte de Recursos] <-- NUEVO

  [Reporte Detallado]
  Proyecto: ADO
  Estado: En Progreso
  Periodo: 01/01/2024 - Actual
  
  [Tabla Detallada]
  | Empleado | Puesto | Rol | Horas/sem | Inicio | Fin | Costo Mensual |
  |----------|--------|-----|-----------|--------|-----|---------------|
  | Juan G.  | Dev    | BE  | 40        | 01/01  | -   | $80,000      |
  
  Resumen:
  - Total Recursos: 5
  - Recursos Activos: 4
  - Horas Totales: 180/sem
  - Costo Mensual Estimado: $450,000
  
  [Exportar a Excel]
```

**Subtareas:**
- [ ] Agregar tab "Reporte" en modal proyecto
- [ ] Función `loadProjectResourceReport(projectId)`
  - GET `/api/reports/resources-by-project/:id`
- [ ] Renderizar tabla + resumen
- [ ] Botón "Exportar a Excel" (opcional - puede ser CSV simple)
- [ ] Estilos visuales para resumen (cards con iconos)

**Entregable:** Vista de reporte  
**Tiempo:** 6-8 horas

---

#### Tarea 3: Vista de Reporte: Proyectos por Recurso (6-8h)

**Nueva Pestaña en Modal Empleado:**
```
[Empleado: Juan Garcia]
  [Tab: Información General]
  [Tab: Mis Proyectos]
  [Tab: Análisis de Carga] <-- NUEVO
  
  [Análisis de Carga de Trabajo]
  Empleado: Juan Garcia Lopez
  Puesto: Desarrollador
  
  [Tabla de Proyectos]
  | Proyecto | Rol | Periodo | Horas | Estado |
  |----------|-----|---------|-------|--------|
  | ADO      | BE  | 01/01/24 - Actual | 40 | Activo |
  | RPA      | QA  | 01/09/23 - 31/12/23 | 20 | Completado |
  
  Resumen:
  - Total Proyectos: 3
  - Proyectos Activos: 1
  - Promedio Horas/Semana: 38
  - Carga Actual: 40h (100%)
  
  [Exportar]
```

**Subtareas:**
- [ ] Agregar tab "Análisis de Carga"
- [ ] Función `loadEmployeeWorkloadReport(employeeId)`
  - GET `/api/reports/projects-by-employee/:id`
- [ ] Renderizar tabla + resumen
- [ ] Visualización gráfica de carga (opcional - barra de progreso)
- [ ] Estilos CSS

**Entregable:** Vista de análisis  
**Tiempo:** 6-8 horas

---

#### Tarea 4: Agregar Filtro "En Banca" en Tabla Empleados (2-3h)

**Mejora en Vista Empleados:**
```
[Filtros]
  - Buscar por nombre
  - Puesto
  - Entidad
  - Estado: [Activo] [Inactivo] [NUEVO: En Banca] <--
```

**Subtareas:**
- [ ] Agregar opción "En Banca" al dropdown de estado
- [ ] Al seleccionar, llamar `/api/employees/unassigned`
- [ ] Renderizar resultados
- [ ] Badge visual en empleados sin proyecto

**Entregable:** Filtro funcional  
**Tiempo:** 2-3 horas

---

**Total DEV 2 Sprint 3:** 20-27 horas

---

## 📅 SPRINT 4 - SEGURIDAD Y PERFIL (Semanas 5-6)

**Objetivo:** Implementar autenticación y control de roles

### 👨‍💻 DEV 1 - Backend Lead

#### Tarea 1: Base de Datos para Auth (4-6h)

**Nuevas Tablas:**
```sql
CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) UNIQUE NOT NULL,
  descripcion TEXT,
  permisos JSONB
);

CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  empleado_id INTEGER REFERENCES employees_v2(id),
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  rol_id INTEGER REFERENCES roles(id),
  activo BOOLEAN DEFAULT true,
  ultimo_acceso TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Insertar roles básicos
INSERT INTO roles (nombre, descripcion, permisos) VALUES
('Administrador', 'Acceso completo', '{"all": true}'::jsonb),
('RH', 'Gestión de empleados', '{"empleados": ["read", "write"]}'::jsonb),
('PMO', 'Gestión de proyectos', '{"proyectos": ["read", "write"], "asignaciones": ["read", "write"]}'::jsonb),
('Consulta', 'Solo lectura', '{"empleados": ["read"], "proyectos": ["read"]}'::jsonb);
```

**Subtareas:**
- [ ] Crear migration `023_create_auth_tables.sql`
- [ ] Ejecutar migración
- [ ] Crear usuario admin por defecto
- [ ] Testing

**Entregable:** Tablas creadas  
**Tiempo:** 4-6 horas

---

#### Tarea 2: Endpoints de Autenticación (8-10h)

**Instalar dependencias:**
```bash
npm install bcrypt jsonwebtoken dotenv
```

**Endpoints a Crear:**
```javascript
// POST /api/auth/login
// POST /api/auth/register (solo admin)
// POST /api/auth/logout
// GET /api/auth/me (obtener usuario actual)
// POST /api/auth/change-password
```

**Subtareas:**
- [ ] Hash de passwords con bcrypt
- [ ] Generar JWT tokens
- [ ] Middleware `authenticateToken(req, res, next)`
- [ ] Middleware `authorizeRole(['Admin', 'PMO'])`
- [ ] Endpoint de login
- [ ] Endpoint de registro
- [ ] Endpoint de perfil
- [ ] Testing con Postman

**Entregable:** Sistema de auth funcionando  
**Tiempo:** 8-10 horas  
**Archivos:** `server/api.js`, `server/auth.js` (nuevo)

---

#### Tarea 3: Proteger Endpoints Existentes (6-8h)

**Aplicar Middleware:**
```javascript
// Ejemplo:
app.get('/api/employees-v2', authenticateToken, async (req, res) => {
  // ...
});

app.post('/api/employees-v2', 
  authenticateToken, 
  authorizeRole(['Admin', 'RH']), 
  async (req, res) => {
  // ...
});
```

**Subtareas:**
- [ ] Listar todos los endpoints
- [ ] Definir roles por endpoint (ver matriz abajo)
- [ ] Aplicar middleware
- [ ] Testing con diferentes roles

**Matriz de Permisos:**
| Endpoint | Admin | RH | PMO | Consulta |
|---|---|---|---|---|
| GET /api/employees-v2 | ✅ | ✅ | ✅ | ✅ |
| POST /api/employees-v2 | ✅ | ✅ | ❌ | ❌ |
| PUT /api/employees-v2/:id | ✅ | ✅ | ❌ | ❌ |
| DELETE /api/employees-v2/:id | ✅ | ✅ | ❌ | ❌ |
| GET /api/projects | ✅ | ✅ | ✅ | ✅ |
| POST /api/projects | ✅ | ❌ | ✅ | ❌ |
| POST /api/projects/:id/assignments | ✅ | ❌ | ✅ | ❌ |
| GET /api/reports/* | ✅ | ✅ | ✅ | ✅ |

**Entregable:** API protegida  
**Tiempo:** 6-8 horas

---

**Total DEV 1 Sprint 4:** 18-24 horas

---

### 👩‍💻 DEV 2 - Frontend Lead

#### Tarea 1: Página de Login (8-10h)

**Nueva Página:**
```html
<!-- login.html -->
<!DOCTYPE html>
<html>
<head>
  <title>ERP Afirma - Login</title>
  <link rel="stylesheet" href="css/login.css">
</head>
<body>
  <div class="login-container">
    <div class="login-card">
      <img src="assets/logo.png" alt="Logo">
      <h2>Iniciar Sesión</h2>
      <form id="login-form">
        <input type="text" id="username" placeholder="Usuario" required>
        <input type="password" id="password" placeholder="Contraseña" required>
        <button type="submit">Entrar</button>
      </form>
      <div id="login-error" class="error-message"></div>
    </div>
  </div>
  <script src="js/login.js"></script>
</body>
</html>
```

**Archivo JavaScript:**
```javascript
// js/login.js
document.getElementById('login-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  const username = document.getElementById('username').value;
  const password = document.getElementById('password').value;
  
  try {
    const response = await fetch('/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    });
    
    if (response.ok) {
      const data = await response.json();
      localStorage.setItem('token', data.token);
      localStorage.setItem('user', JSON.stringify(data.user));
      window.location.href = '/index.html';
    } else {
      document.getElementById('login-error').textContent = 'Usuario o contraseña incorrectos';
    }
  } catch (error) {
    document.getElementById('login-error').textContent = 'Error de conexión';
  }
});
```

**Subtareas:**
- [ ] Crear `login.html`
- [ ] Crear `css/login.css` con diseño atractivo
- [ ] Crear `js/login.js`
- [ ] Validaciones de formulario
- [ ] Manejo de errores
- [ ] Guardar token en localStorage
- [ ] Redirección después de login

**Entregable:** Página de login funcional  
**Tiempo:** 8-10 horas

---

#### Tarea 2: Protección de Rutas en Frontend (6-8h)

**Agregar al inicio de `src/js/app.js`:**
```javascript
// Verificar token al cargar
document.addEventListener('DOMContentLoaded', () => {
  const token = localStorage.getItem('token');
  if (!token) {
    window.location.href = '/login.html';
    return;
  }
  
  // Verificar token válido
  fetch('/api/auth/me', {
    headers: { 'Authorization': `Bearer ${token}` }
  }).then(res => {
    if (!res.ok) {
      localStorage.removeItem('token');
      window.location.href = '/login.html';
    }
  });
  
  // Cargar info de usuario
  loadUserInfo();
});
```

**Modificar todas las llamadas fetch:**
```javascript
// Agregar header en todas las llamadas
function getApiUrl(endpoint) {
  const token = localStorage.getItem('token');
  return {
    url: `http://localhost:3000${endpoint}`,
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    }
  };
}
```

**Subtareas:**
- [ ] Agregar validación de token en `app.js`
- [ ] Crear función `loadUserInfo()` para mostrar usuario en topbar
- [ ] Modificar todas las llamadas fetch para incluir token
- [ ] Botón de "Cerrar Sesión"
- [ ] Redirección a login si 401

**Entregable:** Frontend protegido  
**Tiempo:** 6-8 horas

---

#### Tarea 3: Menú Dinámico por Rol (4-6h)

**Lógica de Visibilidad:**
```javascript
function renderMenuByRole(userRole) {
  const menu = {
    'Administrador': ['home', 'alta', 'reclutamiento', 'inventario', 'vacaciones', 'proyectos', 'recursos-banca', 'catalogos'],
    'RH': ['home', 'alta', 'reclutamiento', 'vacaciones'],
    'PMO': ['home', 'alta', 'proyectos', 'recursos-banca'],
    'Consulta': ['home', 'alta', 'proyectos']
  };
  
  const allowedViews = menu[userRole] || [];
  
  // Ocultar links no permitidos
  document.querySelectorAll('.nav a').forEach(link => {
    const view = link.getAttribute('data-view');
    if (!allowedViews.includes(view)) {
      link.style.display = 'none';
    }
  });
}
```

**Subtareas:**
- [ ] Función para ocultar/mostrar menú según rol
- [ ] Deshabilitar botones de acción según permisos
  - Ejemplo: RH no ve "Asignar a Proyecto"
- [ ] Mensajes cuando usuario no tiene permiso
- [ ] Testing con diferentes roles

**Entregable:** Menú dinámico  
**Tiempo:** 4-6 horas

---

#### Tarea 4: Agregar Campos Faltantes en Proyecto (3-4h)

**Campos a Agregar en Modal Proyecto:**
```html
<div>
  <label>Cliente</label>
  <select id="project-client">
    <option value="">Sin cliente</option>
    <!-- Cargar desde mastercode "Clientes" -->
  </select>
</div>

<div>
  <label>Modalidad</label>
  <select id="project-modality">
    <option value="">Seleccionar...</option>
    <option value="Consultoría">Consultoría</option>
    <option value="Proyecto Cerrado">Proyecto Cerrado</option>
    <option value="Proyecto de Terceros">Proyecto de Terceros</option>
  </select>
</div>
```

**Subtareas:**
- [ ] Agregar campos al formulario
- [ ] Actualizar envío de formulario
- [ ] Agregar columnas en tabla de proyectos
- [ ] Modificar backend si es necesario (coordinar con DEV1)

**Entregable:** Campos implementados  
**Tiempo:** 3-4 horas

---

**Total DEV 2 Sprint 4:** 21-28 horas

---

## 📊 RESUMEN DE DISTRIBUCIÓN

| Sprint | DEV 1 (Backend) | DEV 2 (Frontend) | Total |
|--------|-----------------|------------------|-------|
| **Sprint 2** | 20-26h | 20-28h | 40-54h |
| **Sprint 3** | 19-26h | 20-27h | 39-53h |
| **Sprint 4** | 18-24h | 21-28h | 39-52h |
| **TOTAL** | **57-76h** | **61-83h** | **118-159h** |

**Por desarrollador:** ~60-80 horas (7-10 semanas a 8h/semana)

---

## 🔄 COORDINACIÓN Y DEPENDENCIAS

### Puntos de Sincronización

#### Sprint 2 - Día 5
- **DEV 1** entrega: Endpoint `/api/employees/:id/assignments`
- **DEV 2** integra: Historial de proyectos en UI

#### Sprint 3 - Día 5
- **DEV 1** entrega: Endpoint `/api/employees/unassigned`
- **DEV 2** integra: Vista de recursos en banca

#### Sprint 3 - Día 10
- **DEV 1** entrega: Endpoints de reportes
- **DEV 2** integra: Vistas de reportes

#### Sprint 4 - Día 5
- **DEV 1** entrega: Endpoints de auth + middleware
- **DEV 2** integra: Login y protección de rutas

---

## ✅ DEFINICIÓN DE "DONE"

### Para cada tarea:
- [ ] Código implementado y funcional
- [ ] Testing manual realizado
- [ ] Documentación básica (comentarios en código)
- [ ] Sin errores en consola
- [ ] Merge a rama `develop`
- [ ] Code review del otro dev (opcional pero recomendado)

### Para cada Sprint:
- [ ] Demo funcional de features
- [ ] Todas las tareas marcadas como Done
- [ ] Deployment a ambiente de staging
- [ ] Validación con stakeholder (RH o PMO)

---

## 🛠️ HERRAMIENTAS DE COLABORACIÓN

### Control de Versiones
```bash
# Estrategia de Branching
main              # Producción
└── develop       # Integración
    ├── feature/backend-assignments    (DEV 1)
    ├── feature/frontend-assignments   (DEV 2)
    ├── feature/backend-reports        (DEV 1)
    └── feature/frontend-reports       (DEV 2)
```

### Convención de Commits
```
feat(asignaciones): agregar endpoint de asignaciones por recurso
fix(auth): corregir validación de token
refactor(api): optimizar query de recursos en banca
docs(readme): actualizar documentación de endpoints
```

### Daily Standups (Async)
- **Formato:**
  - ¿Qué hice ayer?
  - ¿Qué haré hoy?
  - ¿Tengo bloqueos?
- **Canal:** Slack/WhatsApp/Email
- **Frecuencia:** Diaria (5 min)

### Code Review
- Pull requests obligatorios para merge a `develop`
- Otro dev aprueba antes de merge
- Checklist:
  - [ ] Sintaxis correcta
  - [ ] Funcionalidad probada
  - [ ] Sin console.logs innecesarios
  - [ ] Nombre de variables descriptivos

---

## 📈 MÉTRICAS DE PROGRESO

### Burndown por Sprint

**Sprint 2:**
```
Día 0:  45 horas pendientes
Día 5:  30 horas (33%)
Día 10: 15 horas (67%)
Día 14: 0 horas (100%)
```

### Tracking de Tareas
- [ ] Usar Trello/Jira/GitHub Projects
- [ ] Columnas: To Do, In Progress, In Review, Done
- [ ] Actualizar diariamente

---

## 🎯 CONTINGENCIAS

### Si un Dev se retrasa:
1. **Comunicar inmediatamente** al otro dev
2. **Priorizar bloqueadores** del otro dev
3. **Re-estimar** y ajustar scope del sprint
4. **Pair programming** para desbloquear

### Si una tarea es más compleja:
1. **Dividir en subtareas** más pequeñas
2. **Documentar complejidad** encontrada
3. **Solicitar ayuda** al otro dev
4. **Re-estimar** tiempo restante

### Si hay bugs críticos:
1. **Detener nuevas features**
2. **Ambos devs** trabajan en el fix
3. **Testing exhaustivo** antes de continuar
4. **Post-mortem** para evitar recurrencia

---

## 🏆 HITOS Y CELEBRACIONES

### Sprint 2 Completo
🎉 **PMO puede asignar recursos a proyectos**
- Demo con usuario real
- Pizza party (virtual o presencial)

### Sprint 3 Completo
🎉 **Sistema tiene visibilidad completa de carga**
- Validación con stakeholders
- Retrospectiva del equipo

### Sprint 4 Completo
🎉 **MVP 100% funcional y seguro**
- Presentación a dirección
- Plan de deployment a producción

---

## 📞 CONTACTOS Y ESCALACIÓN

| Rol | Responsable | Contacto |
|-----|-------------|----------|
| **DEV 1 (Backend)** | [Nombre] | [Email/Tel] |
| **DEV 2 (Frontend)** | [Nombre] | [Email/Tel] |
| **Product Owner** | Aurora Flores | [Email] |
| **Tech Lead** | [Nombre] | [Email] |
| **QA/Testing** | [Nombre] | [Email] |

---

## 📝 NOTAS FINALES

### Recomendaciones:
1. **Comunicación constante** — No esperar a standup para reportar bloqueos
2. **Testing desde día 1** — No acumular bugs
3. **Documentar decisiones** — Especialmente arquitectura
4. **Pair programming ocasional** — Para tareas complejas o críticas
5. **Celebrar wins pequeños** — Mantener motivación

### Recursos Útiles:
- [Documentación API](./ANALISIS_CUMPLIMIENTO_MVP.md)
- [Esquema de BD](./DATABASE_SCHEMA.md)
- [Postman Collection](./docs/postman_collection.json)
- [Guía de Estilo](./docs/style_guide.md)

---

**¿Listos para comenzar? 🚀**

**Próximo paso:** Revisar este plan en reunión de kick-off y asignar DEV 1 y DEV 2.
