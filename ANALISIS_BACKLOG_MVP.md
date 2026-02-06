# 📊 Análisis de Cumplimiento: Backlog MVP vs Sistema ERP Afirma

**Fecha de Análisis:** Febrero 5, 2026  
**Sistema:** ERP Afirma (MVP)  
**Estado General:** 50% cumplido - Funcionalidades críticas implementadas, reportes y control de acceso pendientes

---

## 📋 RESUMEN EJECUTIVO

| Épica | Requisitos | Cumplidos | % Cumplimiento | Estado |
|-------|-----------|-----------|-----------------|--------|
| 1. Administración de Recursos | 2 | 2 | ✅ 100% | Completo |
| 2. Administración de Proyectos | 2 | 1.5 | ⚠️ 75% | Parcial |
| 3. Asignación de Recursos | 2 | 0.5 | ❌ 25% | Crítico |
| 4. Recursos en Banca | 1 | 0 | ❌ 0% | **Falta** |
| 5. Reportes Básicos | 2 | 0 | ❌ 0% | **Falta** |
| 6. Control de Acceso | 1 | 0 | ❌ 0% | **Falta** |
| **TOTALES MVP** | **10** | **4** | **⚠️ 40%** | ⚠️ |

---

## 🟢 ✅ ÉPICA 1: ADMINISTRACIÓN DE RECURSOS (100% Cumplida)

### **US-01: Alta de Recurso** ✅ COMPLETO

**Requisito:**  
Como área de RH, quiero registrar un recurso en el sistema para centralizar su información laboral.

**Campos Mínimos Requeridos:**
- ✅ Nombre  
- ✅ Rol  
- ✅ Área  
- ✅ Tipo (Interno/Externo)  
- ✅ Estatus (Activo/Baja/BANCA)  
- ✅ Skills/habilidades  

**Implementación:**
- **UI:** Vista "Empleados" - Modal de agregar empleado con 3 pestañas
- **Campos:** 15+ campos incluyendo información personal, expediente y RH
- **Validación:** Nombre y puesto requeridos
- **Duplicados:** Sistema permite búsqueda por nombre para evitar duplicados
- **Base de datos:** Tabla `employees_v2` con 25+ columnas
- **Endpoints API:**
  - `POST /api/employees-v2` - Crear empleado
  - `PUT /api/employees-v2/:id` - Actualizar empleado
  - `GET /api/employees-v2` - Listar empleados

**Criterios de Aceptación:**
- ✅ El recurso se guarda correctamente
- ✅ El sistema permite búsqueda por nombre (filtros en UI)
- ✅ La información es visible para consulta

**Nota:** Sistema guarda información ampliada como:
- Información bancaria (CLABE, cuenta)
- Información de contratación (tarifa, esquema)
- Expediente (CURP, RFC, NSS)
- Dirección completa

---

### **US-02: Consulta de Recurso** ✅ COMPLETO

**Requisito:**  
Como PMO, quiero buscar y consultar un recurso para visualizar su información general y historial.

**Búsqueda Implementada:**
- ✅ Por nombre (filtro de texto)
- ✅ Por puesto/rol
- ✅ Por entidad
- ✅ Por estado
- ✅ Búsqueda combinada

**Visualización:**
- ✅ Datos generales en tabla principal
- ✅ Modal de detalle completo
- ✅ Historial de:
  - ✅ Contratos
  - ✅ Información bancaria
  - ✅ Salario
  - ✅ Contactos de emergencia

**Endpoints usados:**
- `GET /api/employees-v2` - Listar con búsqueda
- `GET /api/employees-v2/:id` - Detalle
- `GET /api/employees-v2/:id/contracts` - Historial de contratos
- `GET /api/employees-v2/:id/salary-history` - Historial salarial

---

## 🟡 ⚠️ ÉPICA 2: ADMINISTRACIÓN DE PROYECTOS (75% Cumplida)

### **US-03: Alta de Proyecto** ✅ COMPLETO

**Requisito:**  
Como PMO, quiero registrar un proyecto para gestionar recursos y periodos de asignación.

**Campos Implementados:**
- ✅ Nombre del proyecto
- ✅ Descripción
- ✅ Fecha de inicio
- ✅ Fecha de fin estimada
- ✅ Estatus (Planificación/En Progreso/Completado/En Espera)
- ✅ Responsable del proyecto (manager_id)
- ⚠️ Cliente (NO implementado en formulario)
- ⚠️ Modalidad (Consultoría/Proyecto Cerrado/Terceros) - NO está

**Base de datos:**
- Tabla `projects` con estructura básica
- Tabla `project_assignments` para registrar asignaciones

**Endpoints:**
- `POST /api/projects` - Crear proyecto
- `PUT /api/projects/:id` - Actualizar proyecto
- `GET /api/projects/:id` - Obtener detalle

**UI:**
- Modal con formulario en sección "Proyectos"
- Validación de campos obligatorios

---

### **US-04: Consulta de Proyecto** ⚠️ PARCIAL

**Requisito:**  
Como PMO, quiero consultar un proyecto para visualizar los recursos asignados e información general.

**Implementado:**
- ✅ Lista de proyectos con tabla
- ✅ Visualización de datos básicos (nombre, descripción, fechas, estado)
- ✅ Modal de detalle
- ⚠️ Visualización de recursos asignados - UI NO COMPLETA

**Falta:**
- ❌ Vista clara de recursos asignados por proyecto
- ❌ Información de tarifa aplicada por recurso
- ❌ Periodo de asignación visible

**Endpoints existentes:**
- `GET /api/projects` - Listar proyectos
- `GET /api/projects/:id` - Obtener proyecto
- `GET /api/projects/:id/assignments` - Obtener asignaciones del proyecto (backend existe pero front no lo consume)

---

## 🔴 ❌ ÉPICA 3: ASIGNACIÓN DE RECURSOS (25% Implementada - CRÍTICO)

### **US-05: Asignar Recurso a Proyecto** ❌ INCOMPLETO

**Requisito:**  
Como PMO, quiero asignar un recurso a un proyecto para registrar su participación, periodo y tarifa.

**Campos Clave Requeridos:**
- ✅ Recurso (employee_id)
- ✅ Proyecto (project_id)
- ✅ Fecha de inicio (start_date)
- ✅ Fecha de fin (end_date)
- ✅ Tarifa aplicada (DB NO tiene columna específica)
- ⚠️ Horas asignadas (hours_allocated - existe en DB)

**Estado del Backend:**
- ✅ Endpoints API creados:
  - `POST /api/projects/:id/assignments` - Crear asignación
  - `DELETE /api/projects/:projectId/assignments/:assignmentId` - Eliminar asignación
  - `GET /api/projects/:id/assignments` - Listar asignaciones del proyecto
- ✅ Tabla `project_assignments` con estructura correcta

**Estado del Frontend:**
- ❌ **NO HAY UI para crear/editar asignaciones**
- ❌ NO hay modal para asignar recursos
- ❌ NO hay lista visual de asignaciones por proyecto
- ⚠️ Solo existe en dropdown de empleado pero no es para asignación

**Falta Crítica:**
- ❌ Validación: "Un recurso no puede estar asignado a varios proyectos"
- ❌ Interfaz visual para gestionar asignaciones

**Base de datos:**
```sql
project_assignments (
  id, project_id, employee_id, role, start_date, end_date, hours_allocated
)
```

---

### **US-06: Historial de Asignaciones por Recurso** ❌ NO IMPLEMENTADO

**Requisito:**  
Como PMO, quiero visualizar el historial de proyectos de un recurso para conocer en qué proyectos ha participado.

**Información que Debería Mostrar:**
- ❌ Proyecto
- ❌ Periodo de asignación
- ❌ Tarifa aplicada
- ❌ Observaciones

**Estado Actual:**
- ❌ NO existe endpoint para obtener asignaciones de un empleado específico
- ❌ NO existe vista en frontend
- ❌ NO está integrado al modal de empleado

**Necesario:**
```sql
GET /api/employees/:id/assignments
-- Debería devolver todas las asignaciones de un empleado con detalles del proyecto
```

---

## 🔴 ❌ ÉPICA 4: RECURSOS EN BANCA (0% - CRÍTICO)

### **US-07: Identificación de Recursos en Banca** ❌ NO IMPLEMENTADO

**Requisito:**  
Como PMO, quiero identificar recursos sin asignación activa para facilitar la toma de decisiones de colocación.

**¿Qué Está Faltando?**

1. **Backend:**
   - ❌ Campo/estado "BANCA" o "Sin asignación"
   - ❌ Endpoint `/api/employees/unassigned` o similar
   - ❌ Query que identifique empleados sin proyecto activo

2. **Frontend:**
   - ❌ Vista específica para "Recursos en Banca"
   - ❌ Filtro de estado "BANCA"
   - ❌ Reporte visual

3. **Base de datos:**
   - ⚠️ Campo `status` en `employees_v2` existe pero no registra "BANCA"
   - ❌ NO hay relación temporal (validar fecha inicio/fin)

**Lógica Necesaria:**
```sql
SELECT e.* FROM employees_v2 e
LEFT JOIN project_assignments pa ON e.id = pa.employee_id 
  AND pa.end_date >= CURRENT_DATE
WHERE pa.id IS NULL AND e.status = 'Activo'
-- Empleados activos sin asignación vigente
```

**Nota:** El sistema NO valida que un recurso NO esté presupuestado en múltiples proyectos simultáneamente.

---

## 🔴 ❌ ÉPICA 5: REPORTES BÁSICOS (0% - CRÍTICO)

### **US-08: Reporte de Recursos por Proyecto** ❌ NO IMPLEMENTADO

**Requisito:**  
Como PMO, quiero visualizar los recursos asignados a un proyecto para tener visibilidad operativa.

**Falta:**
- ❌ Endpoint `/api/reports/resources-by-project/:projectId`
- ❌ Vista/tabla de reporte
- ❌ Visualización de:
  - ❌ Lista de recursos del proyecto
  - ❌ Roles asignados
  - ❌ Periodo de asignación
  - ❌ Tarifa/costo
  - ❌ Horas asignadas

**Debería Retornar:**
```json
{
  "project_id": 1,
  "project_name": "ADO",
  "assignments": [
    {
      "employee_id": 1,
      "employee_name": "Juan Garcia",
      "role": "Desarrollador",
      "start_date": "2024-01-01",
      "end_date": "2024-12-31",
      "hours_allocated": 40.00,
      "hourly_rate": 250.00
    }
  ]
}
```

---

### **US-09: Reporte de Proyectos por Recurso** ❌ NO IMPLEMENTADO

**Requisito:**  
Como PMO, quiero visualizar los proyectos en los que ha participado un recurso para análisis de carga y experiencia.

**Falta:**
- ❌ Endpoint `/api/reports/projects-by-employee/:employeeId`
- ❌ Vista/tabla de reporte
- ❌ Análisis de carga (horas totales asignadas)
- ❌ Historial de experiencia

**Debería Mostrar:**
```
Empleado: Juan Garcia
Total de Proyectos: 3
Carga Promedio: 35 horas/semana

Proyecto                Periodo          Rol              Horas  Costo Total
-----                   -------          ---              -----  -----------
ADO                     01/01-31/12/24   Desarrollador    40     $80,000
DATA LAKE               15/03-30/06/24   Arquitecto       30     $30,000
RPA                     01/09-ongoing    Scrum Master     20     $20,000
```

---

## 🔴 ❌ ÉPICA 6: CONTROL DE ACCESO (0%)

### **US-10: Control de Acceso Básico** ❌ NO IMPLEMENTADO

**Requisito:**  
Como administrador, quiero definir permisos de acceso para proteger la información del sistema.

**Roles Iniciales Planeados:**
- ❌ Administrador
- ❌ RH
- ❌ PMO
- ❌ Consulta (lectura)

**¿Qué Falta?**

1. **Autenticación:**
   - ❌ Sistema de login
   - ❌ Gestión de usuarios
   - ❌ Sesiones/tokens

2. **Autorización:**
   - ❌ Control de roles en API
   - ❌ Restricciones por módulo
   - ❌ Permisos granulares

3. **Frontend:**
   - ❌ Pantalla de login
   - ❌ Visualización condicional (menú según rol)
   - ❌ Protección de rutas

**Nota:** Sistema actual es COMPLETAMENTE ABIERTO - cualquier usuario puede acceder a todo sin restricción.

---

## 🟢 ✅ FUNCIONALIDADES EXTRAS (NO en backlog pero implementadas)

| Funcionalidad | Estado | Cobertura |
|---------------|--------|-----------|
| Gestión de Equipos/Inventario | ✅ | 90% |
| Solicitud de Vacaciones | ✅ | 85% |
| Gestión de Catálogos/Mastercode | ✅ | 95% |
| Información Bancaria de Empleados | ✅ | 80% |
| Gestión de Contratos | ✅ | 75% |
| Contactos de Emergencia | ✅ | 70% |
| Reclutamiento de Candidatos | ✅ | 60% |

**Impacto:** Estas funcionalidades adicionales NO están contempladas en el backlog MVP pero agregan valor operativo.

---

## 📊 ANÁLISIS DETALLADO POR COMPONENTE

### Base de Datos
**Estado: ✅ Estructura Excelente**
- 22 migraciones ejecutadas correctamente
- 20+ tablas normalizadas (3NF)
- Tablas críticas presentes: `employees_v2`, `projects`, `project_assignments`, `salary_history`
- ⚠️ Falta: Campo para identificar "recursos en banca"
- ⚠️ Falta: Tabla para control de acceso/roles

### API Backend
**Estado: ⚠️ 60% de cobertura**
- ✅ Endpoints para empleados (CREATE, READ, UPDATE, DELETE)
- ✅ Endpoints para proyectos (CRUD)
- ✅ Endpoints para asignaciones (POST, GET, DELETE)
- ✅ Endpoints para información ampliada (bancaria, contratos, vacaciones)
- ❌ Falta: Reportes (endpoints específicos)
- ❌ Falta: Autenticación/autorización
- ❌ Falta: Endpoint de recursos en banca

### Frontend
**Estado: ⚠️ 45% de cobertura**
- ✅ Vistas completas: Empleados, Proyectos, Equipos, Vacaciones, Catálogos
- ⚠️ Funcionalidad incompleta: Gestión de asignaciones (backend OK, front NO)
- ❌ Falta: Vistas de reportes
- ❌ Falta: Sistema de login
- ❌ Falta: Visualización de recursos en banca
- ❌ Falta: Historial de asignaciones por empleado

---

## 🎯 PRIORIZACIÓN DE TRABAJO FALTANTE

### CRÍTICO - Phase 2 (Semana 1-2)

1. **[CRÍTICO] Asignación de Recursos - UI Completa**
   - Crear modal de asignación de recursos a proyectos
   - Listar asignaciones por proyecto
   - Implementar validación: "Un recurso no puede estar en múltiples proyectos simultáneamente"
   - Estimado: 16-20 horas

2. **[CRÍTICO] Historial de Asignaciones por Empleado**
   - Crear endpoint `/api/employees/:id/assignments`
   - UI: Pestaña "Mis Proyectos" en empleado
   - Mostrar: proyecto, periodo, tarifa, rol
   - Estimado: 8-10 horas

3. **[CRÍTICO] Recursos en Banca**
   - Crear vista específica
   - Endpoint `/api/employees/unassigned` con lógica temporal
   - Filtro en tabla principal
   - Estimado: 10-12 horas

### ALTA - Phase 2 (Semana 3-4)

4. **[ALTA] Reportes Básicos - Recursos por Proyecto**
   - Endpoint `/api/reports/resources-by-project/:id`
   - UI: Vista de reporte con tabla descargable
   - Estimado: 12-14 horas

5. **[ALTA] Reportes Básicos - Proyectos por Recurso**
   - Endpoint `/api/reports/projects-by-employee/:id`
   - UI: Vista de reporte con análisis de carga
   - Estimado: 12-14 horas

### MEDIA - Phase 3 (Semana 5+)

6. **[MEDIA] Control de Acceso - Sistema de Login**
   - Tabla de usuarios/roles en BD
   - Autenticación básica (usuario/password, JWT)
   - Endpoints protegidos
   - Estimado: 20-25 horas

7. **[MEDIA] Información de Campos Faltantes en Proyectos**
   - Agregar campo "Cliente" que sea mastercode
   - Agregar campo "Modalidad" (selector)
   - Actualizar UI del formulario
   - Estimado: 4-6 horas

---

## 📋 TABLA DE RECOMENDACIONES POR USUARIO

### Para RH (Administrador de Recursos)
| Necesidad | Status | Impacto |
|-----------|--------|---------|
| ✅ Crear recursos | Completo | Alto |
| ✅ Ver historial de empleados | Completo | Alto |
| ✅ Gestionar información bancaria | Completo | Alto |
| ⚠️ Identificar recursos en banca | NO | Crítico |

**Recomendación:** Implementar vista de "Recursos en Banca" urgentemente.

---

### Para PMO (Planificación de Proyectos)
| Necesidad | Status | Impacto |
|-----------|--------|---------|
| ✅ Crear proyectos | Completo | Alto |
| ❌ Asignar recursos | Parcial (sin UI) | **Crítico** |
| ❌ Ver carga de recursos | NO | **Crítico** |
| ❌ Reportes de proyectos | NO | Alto |
| ❌ Identificar disponibles | NO | Alto |

**Recomendación:** La funcionalidad de asignación es el bloqueador más crítico. Debe implementarse UI completa.

---

### Para Administrador
| Necesidad | Status | Impacto |
|-----------|--------|---------|
| ❌ Gestionar usuarios | NO | **Crítico** |
| ❌ Definir roles | NO | **Crítico** |
| ❌ Control de acceso | NO | **Crítico** |
| ✅ Gestionar catálogos | Completo | Medio |

**Recomendación:** El sistema carece completamente de seguridad. Debe ser Priority 1.

---

## 💡 CONSIDERACIONES TÉCNICAS

### Validaciones Faltantes
- [ ] Un recurso no puede estar en múltiples proyectos simultáneamente
- [ ] Las fechas de asignación deben estar dentro del proyecto
- [ ] Validar que empleado esté "Activo"
- [ ] Validar disponibilidad de horas/carga

### Mejoras Necesarias a BD
```sql
-- Agregar tabla de usuarios/roles (falta)
CREATE TABLE roles (id, nombre, descripcion);
CREATE TABLE usuarios (id, empleado_id, rol_id, username, password_hash, activo);

-- Considerar tabla de auditoría para asignaciones
-- Agregar campos de tarifa a project_assignments
ALTER TABLE project_assignments ADD COLUMN hourly_rate NUMERIC;
ALTER TABLE project_assignments ADD COLUMN billable BOOLEAN DEFAULT true;
```

### Consideraciones de Seguridad
- Sistema completamente abierto (sin auth)
- Sin logs de auditoría de cambios
- Sin protección de datos sensibles (CLABE, NSS)
- SQL Injection: Revisar queries con parámetros

---

## 📈 COBERTURA ACTUAL POR SPRINT

**Sprint 1 (Completado):**
- ✅ Gestión de Empleados (US-01, US-02)
- ✅ Gestión básica de Proyectos (US-03, US-04 parcial)
- ✅ Infraestructura (BD, API base, UI shell)
- ✅ Extras: Equipos, Vacaciones, Catálogos

**Sprint 2 (Planeado - RECOMENDADO):**
- ❌ Asignación de Recursos a Proyectos (US-05) - **CRÍTICO**
- ❌ Historial de Asignaciones (US-06) - **CRÍTICO**
- ❌ Recursos en Banca (US-07) - **CRÍTICO**

**Sprint 3 (Planeado):**
- ❌ Reportes (US-08, US-09)

**Sprint 4+ (Futuro):**
- ❌ Control de Acceso (US-10)
- [ ] Enhancements adicionales

---

## ✅ VALIDACIÓN MANUAL

### Checklist para Verificar en Sistema

```
ÉPICA 1 - Recursos
[ ] ✅ Crear empleado nuevo
[ ] ✅ Ver lista de empleados
[ ] ✅ Buscar por nombre
[ ] ✅ Filtrar por estado
[ ] ✅ Editar datos de empleado

ÉPICA 2 - Proyectos
[ ] ✅ Crear proyecto nuevo
[ ] ✅ Ver lista de proyectos
[ ] ✅ Editar proyecto
[ ] ❌ Ver recursos del proyecto

ÉPICA 3 - Asignación (SIN HACER)
[ ] ❌ Asignar recurso a proyecto
[ ] ❌ Ver asignaciones del proyecto
[ ] ❌ Ver proyectos del recurso
[ ] ❌ Cambiar tarifa de asignación

ÉPICA 4 - Banca (SIN HACER)
[ ] ❌ Filtro "Recursos en Banca"
[ ] ❌ Identificar automáticamente
[ ] ❌ Contador de disponibles

ÉPICA 5 - Reportes (SIN HACER)
[ ] ❌ Reporte: Recursos por Proyecto
[ ] ❌ Reporte: Proyectos por Recurso
[ ] ❌ Exportar a Excel

ÉPICA 6 - Acceso (SIN HACER)
[ ] ❌ Login al sistema
[ ] ❌ Roles diferenciados
[ ] ❌ Permisos por rol
```

---

## 🎓 CONCLUSIONES

### Puntos Fuertes ✅
1. **Estructura sólida:** BD bien diseñada, API endpoints correctamente organizados
2. **Funcionalidades complementarias:** Equipos, vacaciones y catálogos agregan valor
3. **UI moderna:** Interfaz limpia y responsive
4. **Datos historificados:** Contratos, salarios y contactos con auditoría

### Puntos Débiles ❌
1. **Asignación incompleta:** Backend listo pero SIN UI - impacto CRÍTICO
2. **Sin reportes:** Herramienta no da visibilidad a PMO
3. **Sin seguridad:** Sistema abierto, sin auth ni roles
4. **Recursos en banca:** Feature crítico para negocio NO existe

### Cumplimiento MVP
- **Alcance:** 40% de backlog implementado
- **Funcionalidad:** 60% de la lógica de negocio
- **Usabilidad:** 70% - UI falta en áreas críticas

### Recomendación Final
**El sistema NO está listo para producción como MVP.** Falta implementar:
1. **US-05, US-06, US-07** (asignaciones y banca) - Sin estas, PMO no puede operar
2. **US-08, US-09** (reportes) - Sin visibility, no hay toma de decisiones
3. **US-10** (acceso) - Sin seguridad, no cumple requerimientos

**Estimado para Completar MVP Completo:** 2-3 sprints adicionales (4-6 semanas)

