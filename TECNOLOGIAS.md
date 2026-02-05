# Tecnologías ERP-Afirma - Documento Descriptivo

## 📋 Resumen Ejecutivo

ERP-Afirma es una aplicación web moderna de gestión integral de recursos humanos construida con una arquitectura full-stack basada en Node.js, Express y PostgreSQL. La aplicación proporciona funcionalidades completas de gestión de empleados, nómina, equipos y auditoría.

---

## 🏗️ Arquitectura General

La aplicación sigue una arquitectura de **tres capas**:

```
┌─────────────────────────────────────────┐
│         Frontend (HTML/CSS/JS)          │ Puerto 8082
│  - SPA Modal-Based CRUD Interface       │
│  - Responsive Design                    │
└────────────────┬────────────────────────┘
                 │ HTTP/REST
┌────────────────▼────────────────────────┐
│      Backend API (Express.js)           │ Puerto 3000
│  - RESTful API con 40+ endpoints        │
│  - Request logging y validación         │
│  - CORS habilitado                      │
└────────────────┬────────────────────────┘
                 │ SQL
┌────────────────▼────────────────────────┐
│    PostgreSQL Database                  │ Puerto 5432
│  - Schema normalizado (7+ tablas, 3NF)  │
│  - Connection pooling                   │
│  - Migration management                 │
└─────────────────────────────────────────┘
```

---

## 🖥️ Stack Tecnológico

### **Backend - Node.js & Express**

| Tecnología | Versión | Propósito |
|-----------|---------|----------|
| **Node.js** | 18 (Alpine) | Runtime JavaScript para servidor |
| **Express.js** | ^4.18.2 | Framework web minimalista y flexible |
| **pg (node-postgres)** | ^8.11.0 | Driver PostgreSQL para Node.js con pool de conexiones |

**Características principales:**
- Servidor API RESTful en puerto 3000
- Manejo de middleware (CORS, body parsing)
- Validación de requests y manejo de errores centralizado
- Logging de requests (excepto /health endpoints)
- Soporte para transacciones de base de datos

---

### **Frontend - HTML5/CSS3/JavaScript Vanilla**

| Tecnología | Propósito |
|-----------|----------|
| **HTML5** | Estructura semántica de la aplicación |
| **CSS3** | Estilos responsivos y diseño moderno |
| **JavaScript ES6+** | Lógica del lado cliente sin frameworks pesados |
| **Fetch API** | Comunicación con backend sin dependencias |

**Características principales:**
- Single Page Application (SPA) basada en modales
- Interfaz de pestañas (tab navigation)
- Modal-based editing para CRUD operations
- Carga dinámica de catálogos (mastercode)
- Comunicación asíncrona con API
- Compatible con navegadores modernos

---

### **Base de Datos - PostgreSQL**

| Componente | Descripción |
|-----------|------------|
| **PostgreSQL** | Sistema de gestión de base de datos relacional |
| **Pool de Conexiones** | Configurado en `server/db.js` con retry logic |
| **Migrations** | Control de versiones del schema en `server/migrations/` |

**Schema Principal:**

```
mastercode
├── lista (Entidad, Puestos roles, Areas, Proyecto, Celulas, etc.)
└── item (Valores específicos de cada categoría)

employees_v2
├── Información personal (name, email, phone)
├── Información laboral (position, department, salary)
├── Relaciones a mastercode (entity, area, project)
└── Auditoría (created_at, updated_at)

salary_history
└── Tracking histórico de cambios salariales

emergency_contacts
└── Contactos de emergencia asociados a empleados

employee_audit_log
└── Log completo de cambios para compliance
```

**Patrón Mastercode:**
- Sistema centralizado de catálogos y lookups
- Todas las dropdowns obtienen datos de una tabla maestra
- Auto-creación de entidades durante importación

---

## 📦 Dependencias Principales

### Producción

```json
{
  "express": "^4.18.2",           // Framework web
  "pg": "^8.11.0",                // PostgreSQL driver
  "multer": "^1.4.5-lts.1",       // Manejo de file uploads
  "xlsx": "^0.18.5",              // Procesamiento Excel/CSV
  "axios": "^1.13.2",             // Cliente HTTP
  "dotenv": "^16.3.1",            // Gestión de variables de entorno
  "google-auth-library": "^10.5.0",// Autenticación Google Cloud
  "node-fetch": "^2.7.0",         // Fetch API para Node.js
  "live-server": "^1.2.1"         // Servidor de desarrollo Frontend
}
```

### Desarrollo

```json
{
  "nodemon": "^2.0.22",           // Hot reload durante desarrollo
  "concurrently": "^9.2.1",       // Ejecutar múltiples procesos simultáneamente
  "http-proxy-middleware": "^3.0.5" // Proxy para desarrollo local
}
```

---

## 🚀 Tecnologías de Despliegue

### **Docker & Containerización**

```dockerfile
FROM node:18-alpine
```

**Características:**
- Imagen Node.js 18 optimizada (Alpine Linux)
- Tamaño reducido (~150MB vs 900MB+ con imágenes completas)
- Instalación de dependencias en build time
- Exposición de puerto 3000

**Docker Compose:**
- PostgreSQL local con volumen persistente
- Adminer para gestión visual de BD
- Network configurada para comunicación entre servicios

---

### **PM2 - Gestor de Procesos**

```javascript
exec_mode: 'cluster'         // Modo cluster para múltiples instancias
instances: 'max'             // Una instancia por core CPU
max_memory_restart: '1G'      // Reinicio automático si excede 1GB
node_args: '--max-old-space-size=1024'  // Memoria heap optimizada
```

**Características:**
- Monitoreo de procesos en producción
- Auto-restart en caso de fallos
- Logging centralizado con timestamps
- Clustering automático para paralelismo

---

### **Cloud Deployment Options**

#### **Google Cloud Platform**

- **Cloud Run:** Despliegue sin servidor (serverless)
- **Dockerfile.cloudrun:** Versión optimizada para Cloud Run
- **Service Account IAM:** Autenticación segura
- **Archivo:** `GOOGLE-CLOUD-DEPLOY.md` (documentación completa)

#### **Windows VPS**

- **deploy-windows.bat:** Script de despliegue automatizado
- **start-production.bat:** Comando de inicio
- Integración con PM2 para gestión de procesos

#### **Linux/Heroku**

- **Procfile:** Configuración para Heroku
- **deploy-heroku:** Script git-based deployment

---

## 🔧 Tecnologías de Utilidad

### **Procesamiento de Archivos**

| Librería | Propósito |
|---------|----------|
| **XLSX** | Lectura/escritura de archivos Excel |
| **Multer** | Gestión de uploads HTTP multipart |

**Flujo de Importación:**
1. Multer recibe el archivo
2. XLSX.readFile() parsea la hoja
3. findOrCreateEntity() resuelve/crea entradas mastercode
4. Inserción batch con rollback transaccional

---

### **Autenticación & Seguridad**

- **Google Auth Library:** Autenticación con Google Cloud
- **CORS:** Habilitado para desarrollo (localhost:8082 → localhost:3000)
- **dotenv:** Gestión segura de credenciales sensibles

**Variables de Entorno:**
```env
DB_HOST          # Host PostgreSQL
DB_PORT          # Puerto PostgreSQL (5432)
DB_NAME          # Nombre de la base de datos
DB_USER          # Usuario PostgreSQL
DB_PASSWORD      # Contraseña PostgreSQL
API_PORT         # Puerto Express (3000)
NODE_ENV         # development | production
```

---

## 📊 Gestión de Base de Datos

### **Migraciones**

**Herramienta:** Script Node.js en `server/migrate.js`

**Características:**
- Versionado de schema (archivos SQL en `server/migrations/`)
- Ejecución de migraciones pendientes
- Rollback seguro en caso de errores

**Comando:**
```bash
npm run migrate
```

---

### **Seeding (Datos Iniciales)**

**Archivos:**
- `server/seeds/seed_catalogs.js` - Catálogos maestros
- `setup-basic-categories.js` - Categorías básicas
- Otros scripts especializados para inventario y equipos

**Comando:**
```bash
npm run seed:catalogs
```

---

## 🎯 Patrones & Convenciones de Código

### **API REST**

**Patrón de respuesta estándar:**
```javascript
// Éxito
res.status(200).json({ data: {...} })

// Error
res.status(500).json({ error: 'Mensaje descriptivo' })
```

**Endpoints principales:**
- `GET /api/employees` - Listar empleados
- `POST /api/employees` - Crear empleado
- `PUT /api/employees/:id` - Actualizar empleado
- `DELETE /api/employees/:id` - Eliminar empleado
- `GET /api/mastercode/:lista` - Obtener catálogo
- `POST /api/import` - Importar datos Excel

---

### **Frontend Patterns**

**Carga de catálogos:**
```javascript
async loadCatalogDropdowns() {
  // Llamadas a GET /api/mastercode/:lista
  // Pobla dropdowns dinámicamente
}
```

**CRUD Modal-based:**
- Click → Modal abierto
- Edición inline
- Submit → API call
- Cierre automático o con confirmación

**URL dinámica del API:**
```javascript
window.getApiUrl() // Abstracción para flexibilidad ambiental
```

---

## 📈 Estructura de Archivos Clave

```
erp-afirma/
├── server/
│   ├── api.js                      # API Express (1600+ líneas)
│   ├── db.js                       # Pool PostgreSQL con retry
│   ├── frontend.js                 # Servidor estático frontend
│   ├── migrate.js                  # Runner de migraciones
│   ├── migrations/                 # SQL versioned
│   └── seeds/                      # Datos iniciales
├── src/
│   ├── index.html                  # SPA principal
│   ├── js/app.js                   # Lógica frontend
│   ├── css/                        # Estilos
│   └── assets/                     # Recursos estáticos
├── package.json                    # Dependencias Node
├── docker-compose.yml              # Orquestación local
├── Dockerfile                      # Imagen producción
└── ecosystem.config.js             # Configuración PM2
```

---

## 🔄 Flujos de Desarrollo

### **Desarrollo Local**

```powershell
# Full stack con live reload
npm run dev:all

# Por separado
npm run api      # Express en puerto 3000
npm run frontend # Live server en puerto 8082
```

### **Testing**

- **Archivos:** `test-*.js` en raíz
- **Patrón:** Scripts Node.js ejecutables
- **Framework:** Sin framework formal (testing manual)

Ejemplo:
```bash
node test-complete-app.js  # Tests full CRUD
```

---

## 🌍 Ciclo de Despliegue Completo

### **1. Desarrollo Local**
```bash
npm run dev:all
```

### **2. Migraciones & Datos**
```bash
npm run migrate
npm run seed:catalogs
```

### **3. Build & Packaging**
```bash
npm run docker:build
```

### **4. Despliegue**

**Opción A - Producción Local (Windows)**
```bash
npm run pm2:start
```

**Opción B - Cloud Run (GCP)**
```

```

**Opción C - Docker Compose**
```bash
docker-compose up -d
```

---

## 📋 Requisitos del Sistema

### **Producción**

| Componente | Requisito |
|-----------|-----------|
| **Node.js** | v18.x o superior |
| **PostgreSQL** | 12.x o superior |
| **Memoria RAM** | Mínimo 1GB (recomendado 2GB) |
| **Almacenamiento** | 500MB mínimo |
| **Puerto 3000** | Disponible para API |
| **Puerto 5432** | Disponible para BD (o remota) |

### **Desarrollo**

- Todos los anteriores, más:
- **Live Server** para frontend
- **Nodemon** para hot reload
- **PostgreSQL local** (Docker recomendado)

---

## 🔐 Consideraciones de Seguridad

1. **Autenticación Google:** Integración con Google Cloud para SSO
2. **Variables de Entorno:** Credenciales nunca en código fuente
3. **CORS:** Configurado por ambiente (desarrollo vs producción)
4. **SQL Injection:** Uso de prepared statements con pg
5. **Validación:** Validación input en servidor
6. **Auditoría:** Log completo de cambios (employee_audit_log)
7. **Error Handling:** Manejo centralizado sin exposición de stack traces sensibles

---

## 📚 Documentación Relacionada

- **SETUP_GUIDE.md** - Instalación inicial
- **DATABASE_SCHEMA.md** - Esquema detallado
- **GOOGLE-CLOUD-DEPLOY.md** - Despliegue GCP
- **DEPLOYMENT.md** - Opciones de despliegue
- **QUICK_START.md** - Inicio rápido

---

## 🎓 Conclusión

ERP-Afirma utiliza un stack moderno y bien establecido que proporciona:

✅ **Escalabilidad** - Node.js cluster mode, BD relacional normalizada  
✅ **Mantenibilidad** - Código limpio, migrations versionadas, logging  
✅ **Flexibilidad** - Despliegue en local, VPS, Cloud (GCP, Heroku)  
✅ **Seguridad** - Autenticación, validación, auditoría  
✅ **Desarrollo Ágil** - Hot reload, testing scripts, CORS para desarrollo  

La arquitectura está optimizada para un equipo pequeño de desarrolladores con posibilidad de escalado a medida que crezca la organización.

---

**Última actualización:** Febrero 2026  
**Versión:** 1.0.0  
**Licencia:** MIT
