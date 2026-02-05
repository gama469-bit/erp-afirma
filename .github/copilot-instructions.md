# ERP Afirma - AI Agent Instructions

## Architecture Overview

This is a full-stack employee management system built with:
- **Backend**: Express.js API (`server/api.js`) on port 3000
- **Frontend**: Static HTML/CSS/JS (`src/`) served on port 8082 via `server/frontend.js`
- **Database**: PostgreSQL with normalized schema (7+ tables, 3NF)
- **File Processing**: Excel/CSV import via multer + XLSX

### Key Components
- `server/api.js` - Main REST API with 40+ endpoints
- `server/db.js` - PostgreSQL connection pool with retry logic
- `server/migrate.js` - Migration runner for schema updates
- `src/js/app.js` - Frontend SPA with modal-based CRUD
- `server/migrations/` - Versioned SQL schema files

## Database Architecture

The system uses a **mastercode pattern** for lookups:
```sql
-- Core table for all catalog values
mastercode (id, lista, item) 
-- Where lista = 'Entidad', 'Puestos roles', 'Areas', etc.
```

Main entities:
- `employees_v2` - Primary employee table with FKs to mastercode
- `salary_history` - Employee salary tracking
- `emergency_contacts` - Emergency contact relations
- `employee_audit_log` - Complete change auditing

## Development Workflows

### Start Development
```powershell
# Full stack (recommended)
npm run dev:all  # API + frontend with live reload

# Or separately
npm run api      # Port 3000
npm run frontend # Port 8082
```

### Database Operations
```powershell
npm run migrate           # Run pending migrations
node server/migrate.js    # Same, direct execution
npm run seed:catalogs     # Populate mastercode tables
```

### Testing Patterns
- Use `test-*.js` files in root for API/integration testing
- No formal test framework - manual testing via Node.js scripts
- Example: `node test-complete-app.js` tests full CRUD flow

## Code Conventions

### API Patterns
- All endpoints in `server/api.js` (1600+ lines)
- Consistent error handling: `res.status(500).json({ error: 'message' })`
- CORS enabled for all origins
- Request logging except `/health` endpoints

### Frontend Patterns
- Modal-based editing (no separate pages)
- Catalog loading via `loadCatalogDropdowns()` in `app.js`
- API calls use `window.getApiUrl()` for environment flexibility
- Tab navigation system in single HTML file

### Database Helpers
```javascript
// Common pattern for mastercode resolution
async function findOrCreateEntity(name) {
  // Find existing or create new mastercode entry
}
```

## Deployment

### Local Development
- `start-app.ps1` - PowerShell script for Windows development
- `docker-compose.yml` - PostgreSQL + Adminer for local DB

### Production
- `ecosystem.config.js` - PM2 cluster configuration
- `deploy-windows.bat` - Windows VPS deployment script
- `Dockerfile` - Node.js 18 Alpine container

### Environment Variables
```env
DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD
API_PORT=3000
NODE_ENV=production
```

## Critical Integration Points

### Excel Import Flow
1. `multer` receives file upload
2. `XLSX.readFile()` parses spreadsheet
3. `findOrCreateEntity()` resolves/creates mastercode entries
4. Batch insert with transaction rollback on errors

### Mastercode System
- All dropdowns populated from single `mastercode` table
- Lists: 'Entidad', 'Puestos roles', 'Areas', 'Proyecto', 'Celulas'
- Auto-creation pattern when importing data

### Frontend-Backend Communication
- Frontend uses fetch() with dynamic base URL
- CORS configured for development (localhost:8082 → localhost:3000)
- Error handling displays user-friendly messages

## When Working on Features

### Adding New Mastercode Category
1. Update `loadCatalogDropdowns()` in `app.js`
2. Add API endpoint in `api.js` following pattern: `GET /api/mastercode/:lista`
3. Update HTML form dropdowns

### Adding Employee Fields
1. Create migration in `server/migrations/`
2. Update API validation in `server/api.js`
3. Add form fields in `src/index.html`
4. Update frontend handlers in `src/js/app.js`

### Debugging
- API logs all requests (except `/health`)
- Database connection status logged on startup
- Use browser DevTools for frontend, terminal logs for backend