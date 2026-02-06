// create-admin-user.js - Create initial admin user for ERP Afirma
require('dotenv').config();
const bcrypt = require('bcrypt');
const db = require('./server/db');

async function createAdminUser() {
    try {
        console.log('🔧 Creando usuario administrador inicial...\n');

        // Check if admin user already exists
        const existingAdmin = await db.query(
            "SELECT id, email FROM users WHERE email = 'admin@afirma.com'"
        );

        if (existingAdmin.rowCount > 0) {
            console.log('⚠️  El usuario admin@afirma.com ya existe');
            console.log('📧 Email:', existingAdmin.rows[0].email);
            console.log('🆔 ID:', existingAdmin.rows[0].id);
            
            // Ask if they want to reset password
            console.log('\n💡 Si deseas cambiar la contraseña, elimina el usuario y ejecuta este script de nuevo.');
            process.exit(0);
        }

        // Get Administrador role ID
        const roleResult = await db.query(
            "SELECT id FROM roles WHERE name = 'Administrador'"
        );

        if (roleResult.rowCount === 0) {
            console.log('❌ Error: No se encontró el rol Administrador');
            console.log('💡 Ejecuta las migraciones primero: node server/migrate.js');
            process.exit(1);
        }

        const adminRoleId = roleResult.rows[0].id;

        // Create admin user
        const adminData = {
            email: 'admin@afirma.com',
            password: 'Admin@2026', // Default password - SHOULD BE CHANGED
            first_name: 'Administrador',
            last_name: 'Sistema',
            role_id: adminRoleId
        };

        console.log('👤 Creando usuario:');
        console.log('   Email:', adminData.email);
        console.log('   Nombre:', adminData.first_name, adminData.last_name);
        console.log('   Rol: Administrador');
        console.log('   Contraseña temporal:', adminData.password);
        console.log('');

        // Hash password
        const saltRounds = 10;
        const password_hash = await bcrypt.hash(adminData.password, saltRounds);

        // Insert user
        const insertQuery = `
            INSERT INTO users (email, password_hash, first_name, last_name, role_id, status)
            VALUES ($1, $2, $3, $4, $5, 'Activo')
            RETURNING id, email, first_name, last_name, role_id, created_at
        `;

        const result = await db.query(insertQuery, [
            adminData.email,
            password_hash,
            adminData.first_name,
            adminData.last_name,
            adminData.role_id
        ]);

        const createdUser = result.rows[0];

        console.log('✅ Usuario administrador creado exitosamente!\n');
        console.log('📊 Detalles del usuario:');
        console.log('   ID:', createdUser.id);
        console.log('   Email:', createdUser.email);
        console.log('   Nombre:', createdUser.first_name, createdUser.last_name);
        console.log('   Rol ID:', createdUser.role_id);
        console.log('   Fecha creación:', createdUser.created_at);
        console.log('');
        console.log('🔐 Credenciales de acceso:');
        console.log('   Email:', adminData.email);
        console.log('   Contraseña:', adminData.password);
        console.log('');
        console.log('⚠️  IMPORTANTE: Cambia la contraseña después del primer login!');
        console.log('');
        console.log('🚀 Ahora puedes:');
        console.log('   1. Iniciar el servidor: npm run api');
        console.log('   2. Abrir http://127.0.0.1:8082/login.html');
        console.log('   3. Iniciar sesión con las credenciales de arriba');
        console.log('');

        process.exit(0);

    } catch (error) {
        console.error('❌ Error al crear usuario administrador:', error.message);
        console.error(error);
        process.exit(1);
    }
}

// Run the script
createAdminUser();
