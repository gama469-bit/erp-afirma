# Estructura Normalizada de Base de Datos - Empleados

## Descripción General

La base de datos ha sido normalizada siguiendo los principios de diseño relacional (hasta 3FN - Tercera Forma Normal) para garantizar integridad referencial, evitar redundancia de datos y mejorar el rendimiento.

---

## Tablas Principales

### 1. **employees_v2** (Tabla Principal de Empleados)

Almacena toda la información de empleados con relaciones a otras tablas.

#### Campos:
- `id` (PK): Identificador único
- `first_name`: Nombre del empleado (requerido)
- `last_name`: Apellido del empleado (requerido)
- `email`: Correo electrónico único (requerido)
- `phone`: Teléfono de empresa
- `personal_phone`: Teléfono personal
- `employee_code`: Código único del empleado
- `position_id` (FK): Referencia a tabla `positions`
- `department_id` (FK): Referencia a tabla `departments`
- `hire_date`: Fecha de contratación
- `start_date`: Fecha de inicio laboral
- `birth_date`: Fecha de nacimiento
- `address`, `city`, `state`, `postal_code`, `country`: Datos de dirección
- `employment_type`: Permanente, Temporal, Contratista
- `contract_end_date`: Fecha de finalización de contrato (si aplica)
- `status`: Activo, Inactivo, En licencia, Suspendido
- `created_at`, `updated_at`: Timestamps de auditoría
- `created_by`, `updated_by`: Usuario que crea/actualiza

#### Validaciones:
- Email: Formato válido de correo electrónico
- Phone: Números y caracteres válidos
- hire_date: No puede ser fecha futura
- employment_type: Valores enumerados
- status: Valores enumerados

#### Índices:
- `email`, `employee_code`, `position_id`, `department_id`, `status`
- Búsqueda de nombre completo mediante índice BTREE

---

### 2. **departments** (Departamentos)

Almacena los departamentos de la empresa.

#### Campos:
- `id` (PK): Identificador único
- `name`: Nombre del departamento (único)
- `description`: Descripción del departamento
- `manager_id` (FK): ID del empleado que gestiona (opcional)
- `created_at`, `updated_at`: Timestamps

#### Índices:
- `name`: Para búsquedas rápidas

#### Datos Preinsertados:
- Desarrollo
- Diseño
- Gestión
- Recursos Humanos
- Finanzas
- Ventas
- Soporte

---

### 3. **positions** (Puestos/Posiciones)

Define los puestos disponibles en la empresa.

#### Campos:
- `id` (PK): Identificador único
- `name`: Nombre del puesto (único)
- `description`: Descripción del puesto
- `department_id` (FK): Departamento al que pertenece
- `salary_min`: Salario mínimo del rango
- `salary_max`: Salario máximo del rango
- `created_at`, `updated_at`: Timestamps

#### Índices:
- `name`, `department_id`: Para búsquedas rápidas

#### Datos Preinsertados:
- Desarrollador Senior, Junior, DevOps Engineer
- Diseñador UX/UI, Diseñador Gráfico
- Project Manager, Director Ejecutivo
- Especialista RRHH
- Contabilista
- Ejecutivo de Ventas
- Técnico de Soporte

---

### 4. **salary_history** (Historial de Salarios)

Registra todos los cambios de salario de un empleado.

#### Campos:
- `id` (PK): Identificador único
- `employee_id` (FK): Referencia a `employees_v2`
- `salary_amount`: Monto del salario
- `currency`: Moneda (default: COP)
- `effective_date`: Fecha de vigencia
- `reason`: Motivo del cambio (Aumento, Ajuste anual, etc.)
- `notes`: Notas adicionales
- `created_by`: Usuario que registra
- `created_at`: Timestamp

#### Índices:
- `employee_id`, `effective_date`: Para consultas rápidas

---

### 5. **emergency_contacts** (Contactos de Emergencia)

Almacena contactos de emergencia para cada empleado.

#### Campos:
- `id` (PK): Identificador único
- `employee_id` (FK): Referencia a `employees_v2`
- `contact_name`: Nombre del contacto
- `relationship`: Relación (Familiar, Amigo, etc.)
- `phone`: Teléfono del contacto
- `email`: Email del contacto (opcional)
- `address`: Dirección del contacto (opcional)
- `priority`: Orden de contacto (1 = principal)
- `created_at`, `updated_at`: Timestamps

#### Índices:
- `employee_id`, `priority`: Para consultas rápidas

---

### 6. **employee_documents** (Documentos del Empleado)

Registro de documentos (cédula, pasaporte, licencias, etc.).

#### Campos:
- `id` (PK): Identificador único
- `employee_id` (FK): Referencia a `employees_v2`
- `document_type`: Tipo (Cédula, Pasaporte, Licencia, etc.)
- `document_number`: Número del documento
- `issue_date`: Fecha de emisión
- `expiry_date`: Fecha de vencimiento
- `document_file_path`: Ruta al archivo almacenado
- `notes`: Notas adicionales
- `created_at`, `updated_at`: Timestamps

#### Índices:
- `employee_id`, `document_type`: Para búsquedas rápidas

---

### 7. **employee_audit_log** (Auditoría de Cambios)

Registro de todas las modificaciones realizadas en la tabla `employees_v2`.

#### Campos:
- `id` (PK): Identificador único
- `employee_id` (FK): Referencia a `employees_v2`
- `action`: INSERT, UPDATE, DELETE
- `field_name`: Campo modificado
- `old_value`: Valor anterior
- `new_value`: Valor nuevo
- `changed_by`: Usuario que realizó el cambio
- `changed_at`: Timestamp del cambio

#### Índices:
- `employee_id`, `changed_at`, `action`: Para auditoría

---

## Relaciones (ER Diagram)

```
employees_v2
├── position_id → positions.id
├── department_id → departments.id
│
├── 1:N → salary_history (historial salarial)
├── 1:N → emergency_contacts (contactos emergencia)
├── 1:N → employee_documents (documentos)
└── 1:N → employee_audit_log (auditoría)

positions
├── department_id → departments.id
└── 1:N → employees_v2

departments
├── manager_id → employees_v2.id (opcional)
└── 1:N → positions
└── 1:N → employees_v2
```

---

## Reglas de Integridad

### Restricciones de Clave Externa (FK):
- `employee_id` en tablas relacionadas deleta en cascada si se elimina el empleado
- `position_id`, `department_id` se ponen en NULL si se elimina la posición o departamento
- `manager_id` en departments se pone en NULL si se elimina el empleado

### Restricciones CHECK:
- Email debe ser válido: `email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'`
- Teléfono válido: `phone ~ '^[0-9\-\+\(\)]{7,}$'`
- hire_date no puede ser futura: `hire_date <= CURRENT_DATE`
- employment_type en lista permitida
- status en lista permitida

---

## Migraciones

Las migraciones se ejecutan en orden:
1. `001_create_employees.sql` - Tabla original (soporte legacy)
2. `002_create_candidates.sql` - Tabla de candidatos
3. `003_create_departments.sql` - Departamentos
4. `004_create_positions.sql` - Puestos
5. `005_create_employees_v2.sql` - Empleados normalizados
6. `006_create_employee_relations.sql` - Tablas relacionadas

Ejecutar: `npm run migrate`

---

## Endpoints de API

### Departamentos:
- `GET /api/departments` - Listar todos
- `POST /api/departments` - Crear

### Posiciones:
- `GET /api/positions` - Listar todos
- `POST /api/positions` - Crear

### Empleados (v2):
- `GET /api/employees-v2` - Listar todos con detalles
- `GET /api/employees-v2/:id` - Obtener uno
- `POST /api/employees-v2` - Crear
- `PUT /api/employees-v2/:id` - Actualizar
- `DELETE /api/employees-v2/:id` - Cambiar estado a Inactivo

### Salarios:
- `GET /api/employees-v2/:id/salary-history` - Historial
- `POST /api/employees-v2/:id/salary` - Agregar registro

### Contactos de Emergencia:
- `GET /api/employees-v2/:id/emergency-contacts` - Listar
- `POST /api/employees-v2/:id/emergency-contacts` - Crear

---

## Rendimiento

### Índices Optimizados:
- Búsquedas por email: O(log n)
- Búsquedas por código: O(log n)
- Búsquedas por departamento: O(log n)
- Búsquedas por estado: O(log n)
- Búsquedas históricas por fecha: O(log n)

### Consultas Eficientes:
- Uso de JOINs optimizados
- Prepared statements para prevenir SQL injection
- Índices en columnas de filtrado frecuente

---

## Consideraciones Especiales

1. **Soft Delete**: Los empleados se marcan como "Inactivo" en lugar de eliminarse físicamente
2. **Auditoría**: Todos los cambios se registran en `employee_audit_log`
3. **Escalabilidad**: Estructura preparada para crecer a miles de registros
4. **Validación**: Tanto en BD como en API
5. **Relaciones Opcionales**: Se usan FK ON DELETE SET NULL para mayor flexibilidad

---

## Mejoras Futuras

- Triggers para auditoría automática
- Vistas para reportes comunes
- Particionamiento por fecha para tablas grandes
- Replicación para alta disponibilidad
- Backup incremental
