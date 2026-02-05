# Guía de Uso - Estructura Normalizada de Empleados

## Resumen de Cambios

Se ha actualizado completamente la estructura de base de datos para empleados, normalizando la información según los siguientes principios:

### ✅ Mejoras Implementadas:

1. **Normalización en 3FN** (Tercera Forma Normal)
   - Eliminación de redundancias
   - Separación de responsabilidades
   - Integridad referencial garantizada

2. **Nuevas Tablas Relacionales:**
   - `departments`: Gestión de departamentos
   - `positions`: Catálogo de puestos
   - `employees_v2`: Empleados normalizados
   - `salary_history`: Historial salarial
   - `emergency_contacts`: Contactos de emergencia
   - `employee_documents`: Gestión de documentos
   - `employee_audit_log`: Auditoría de cambios

3. **Validaciones en Base de Datos:**
   - Formato de email
   - Teléfonos válidos
   - Fechas coherentes
   - Enumeraciones controladas (status, employment_type)

4. **Índices Optimizados:**
   - Búsquedas rápidas por email, código, departamento
   - Consultas eficientes en historial y auditoría

5. **Control de Cambios:**
   - Auditoría completa de modificaciones
   - Timestamps de creación/actualización
   - Usuario responsable registrado

---

## API Endpoints

### Crear Empleado (Estructura Normalizada)

```bash
POST /api/employees-v2

{
  "first_name": "Juan",
  "last_name": "García López",
  "email": "juan.garcia@afirma.com",
  "phone": "+57-1-1234567",
  "personal_phone": "3001234567",
  "employee_code": "EMP-001",
  "position_id": 1,
  "department_id": 1,
  "hire_date": "2024-01-15",
  "start_date": "2024-02-01",
  "birth_date": "1990-03-20",
  "address": "Cra 15 # 100-50",
  "city": "Bogotá",
  "state": "Cundinamarca",
  "postal_code": "110111",
  "country": "Colombia",
  "employment_type": "Permanente",
  "status": "Activo",
  "created_by": "admin"
}
```

### Listar Empleados

```bash
GET /api/employees-v2

Respuesta:
[
  {
    "id": 1,
    "first_name": "Juan",
    "last_name": "García López",
    "email": "juan.garcia@afirma.com",
    "position_name": "Desarrollador Senior",
    "department_name": "Desarrollo",
    "status": "Activo",
    ...
  }
]
```

### Obtener Detalles de Empleado

```bash
GET /api/employees-v2/1
```

### Actualizar Empleado

```bash
PUT /api/employees-v2/1

{
  "position_id": 2,
  "status": "En licencia",
  "updated_by": "admin"
}
```

### Cambiar Estado (Soft Delete)

```bash
DELETE /api/employees-v2/1

Respuesta: Marca el empleado como "Inactivo" sin eliminarlo
```

### Gestionar Departamentos

```bash
GET /api/departments
POST /api/departments

{
  "name": "Marketing",
  "description": "Equipo de marketing y comunicaciones"
}
```

### Gestionar Puestos

```bash
GET /api/positions
POST /api/positions

{
  "name": "Especialista Marketing Digital",
  "description": "Especialista en marketing digital",
  "department_id": 8,
  "salary_min": 3000000,
  "salary_max": 5000000
}
```

### Historial de Salarios

```bash
GET /api/employees-v2/1/salary-history

POST /api/employees-v2/1/salary

{
  "salary_amount": 4800000,
  "currency": "COP",
  "effective_date": "2024-06-01",
  "reason": "Aumento por desempeño",
  "created_by": "admin"
}
```

### Contactos de Emergencia

```bash
GET /api/employees-v2/1/emergency-contacts

POST /api/employees-v2/1/emergency-contacts

{
  "contact_name": "Ana García",
  "relationship": "Esposa",
  "phone": "3007654321",
  "email": "ana.garcia@email.com",
  "priority": 1
}
```

---

## Importar desde Excel

### Formato Recomendado:

**Para Empleados:**
```
Nombre | Apellido | Email | Teléfono | Posición | Departamento
Juan   | García   | j.garcia@afirma.com | 3001234567 | Desarrollador Senior | Desarrollo
```

**Para Candidatos:**
```
Nombre | Apellido | Email | Teléfono | Posición | Estado | Notas
```

El sistema automáticamente mapea las columnas a los campos de la base de datos.

---

## Datos de Ejemplo

Se ha incluido un script con datos de prueba:

```sql
-- Ejecutar (opcional):
psql -U postgres -d BD_afirma -f server/seeds/seed_employees.sql
```

Esto crea 5 empleados con:
- Datos personales completos
- Historial salarial
- Contactos de emergencia

---

## Consideraciones Importantes

### ✔️ Soft Delete
Los empleados **no se eliminan** sino que se marcan como "Inactivo". Esto preserva:
- Históricos de salario
- Datos de auditoría
- Contactos de emergencia

### ✔️ Validaciones
Las validaciones ocurren en **dos niveles**:
1. **Base de datos**: Constraints CHECK y FK
2. **API**: Validación en endpoints

### ✔️ Auditoría
Todos los cambios se registran en `employee_audit_log`:
- Quién realizó el cambio
- Cuándo lo realizó
- Qué cambió (valor anterior y nuevo)

### ✔️ Escalabilidad
La estructura soporta:
- Millones de registros
- Múltiples departamentos y puestos
- Historial temporal completo
- Consultas analíticas complejas

---

## Migraciones Ejecutadas

```
001_create_employees.sql        ✓ Tabla original (legacy)
002_create_candidates.sql       ✓ Candidatos
003_create_departments.sql      ✓ Departamentos
004_create_positions.sql        ✓ Puestos
005_create_employees_v2.sql     ✓ Empleados normalizados
006_create_employee_relations.sql ✓ Tablas relacionadas
```

---

## Consultas Útiles (SQL)

### Empleados activos por departamento
```sql
SELECT 
  d.name as departamento,
  COUNT(e.id) as cantidad,
  SUM(sh.salary_amount) as total_nómina
FROM employees_v2 e
LEFT JOIN departments d ON e.department_id = d.id
LEFT JOIN salary_history sh ON e.id = sh.employee_id
WHERE e.status = 'Activo'
GROUP BY d.name;
```

### Empleados próximos a cumpleaños (este mes)
```sql
SELECT 
  CONCAT(first_name, ' ', last_name) as nombre,
  birth_date,
  EXTRACT(DAY FROM birth_date) as día
FROM employees_v2
WHERE EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM CURRENT_DATE)
ORDER BY EXTRACT(DAY FROM birth_date);
```

### Contratos próximos a vencer
```sql
SELECT 
  CONCAT(first_name, ' ', last_name) as nombre,
  contract_end_date,
  (contract_end_date - CURRENT_DATE) as días_restantes
FROM employees_v2
WHERE contract_end_date IS NOT NULL
  AND contract_end_date <= CURRENT_DATE + INTERVAL '30 days'
ORDER BY contract_end_date;
```

---

## Próximas Mejoras

- [ ] Triggers para auditoría automática
- [ ] Vistas para reportes comunes
- [ ] Dashboard de métricas
- [ ] Notificaciones de eventos
- [ ] Exportación a diferentes formatos
- [ ] Integración con nómina
- [ ] Sistema de evaluación de desempeño
