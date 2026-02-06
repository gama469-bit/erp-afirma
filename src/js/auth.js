// auth.js - Authentication utilities for ERP Afirma

/**
 * Get API base URL based on environment
 */
window.getApiUrl = function() {
    if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        return 'http://127.0.0.1:3000';
    }
    return '';
};

/**
 * Get authentication token from localStorage
 */
function getAuthToken() {
    return localStorage.getItem('auth_token');
}

/**
 * Get current user from localStorage
 */
function getCurrentUser() {
    const userStr = localStorage.getItem('user');
    return userStr ? JSON.parse(userStr) : null;
}

/**
 * Set authentication token and user
 */
function setAuth(token, user) {
    localStorage.setItem('auth_token', token);
    localStorage.setItem('user', JSON.stringify(user));
}

/**
 * Clear authentication
 */
function clearAuth() {
    localStorage.removeItem('auth_token');
    localStorage.removeItem('user');
    localStorage.removeItem('remember_me');
}

/**
 * Check if user is authenticated
 */
function isAuthenticated() {
    return !!getAuthToken();
}

/**
 * Check if user has specific role
 */
function hasRole(roleName) {
    const user = getCurrentUser();
    return user && user.role_name === roleName;
}

/**
 * Check if user has any of the specified roles
 */
function hasAnyRole(...roleNames) {
    const user = getCurrentUser();
    return user && roleNames.includes(user.role_name);
}

/**
 * Logout user
 */
async function logout() {
    const token = getAuthToken();
    
    if (token) {
        try {
            // Notify backend of logout
            await fetch(window.getApiUrl() + '/api/auth/logout', {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${token}`,
                    'Content-Type': 'application/json'
                }
            });
        } catch (error) {
            console.error('Error al notificar logout al servidor:', error);
        }
    }
    
    clearAuth();
    window.location.href = 'login.html';
}

/**
 * Make authenticated API request
 */
async function authFetch(url, options = {}) {
    const token = getAuthToken();
    
    if (!token) {
        throw new Error('No authentication token found');
    }
    
    // Add authorization header
    const headers = {
        ...options.headers,
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
    };
    
    const response = await fetch(url, {
        ...options,
        headers
    });
    
    // If unauthorized, redirect to login
    if (response.status === 401 || response.status === 403) {
        console.warn('Token inválido o expirado, redirigiendo a login');
        clearAuth();
        window.location.href = 'login.html';
        throw new Error('Sesión expirada');
    }
    
    return response;
}

/**
 * Guard: Require authentication
 * Call this at the start of protected pages
 */
function requireAuth() {
    if (!isAuthenticated()) {
        console.warn('Usuario no autenticado, redirigiendo a login');
        window.location.href = 'login.html';
        return false;
    }
    return true;
}

/**
 * Guard: Require specific role
 */
function requireRole(...allowedRoles) {
    if (!requireAuth()) {
        return false;
    }
    
    const user = getCurrentUser();
    if (!allowedRoles.includes(user.role_name)) {
        alert(`Acceso denegado. Se requiere uno de los siguientes roles: ${allowedRoles.join(', ')}`);
        return false;
    }
    
    return true;
}

/**
 * Initialize authentication UI in main app
 */
function initAuthUI() {
    const user = getCurrentUser();
    
    if (!user) {
        return;
    }
    
    // Display user info in header
    const userInfoElement = document.getElementById('user-info');
    if (userInfoElement) {
        userInfoElement.innerHTML = `
            <div class="user-menu">
                <span class="user-name">${user.first_name} ${user.last_name}</span>
                <span class="user-role">${user.role_name}</span>
                <button onclick="logout()" class="btn-logout">Cerrar Sesión</button>
            </div>
        `;
    }
    
    // Show/hide menu items based on role
    applyRoleBasedVisibility();
}

/**
 * Apply role-based visibility to UI elements
 */
function applyRoleBasedVisibility() {
    const user = getCurrentUser();
    if (!user) return;
    
    const role = user.role_name;
    
    // Define role permissions for menu items
    const menuPermissions = {
        'empleados': ['Administrador', 'RH', 'PMO', 'Consulta'],
        'proyectos': ['Administrador', 'PMO', 'RH', 'Consulta'],
        'asignaciones': ['Administrador', 'PMO', 'RH', 'Consulta'],
        'reportes': ['Administrador', 'PMO', 'RH', 'Consulta'],
        'equipos': ['Administrador', 'RH'],
        'vacaciones': ['Administrador', 'RH'],
        'catalogos': ['Administrador', 'RH'],
        'usuarios': ['Administrador']
    };
    
    // Show/hide menu items
    Object.keys(menuPermissions).forEach(menuId => {
        const menuItem = document.querySelector(`[data-view="${menuId}"]`);
        if (menuItem) {
            if (menuPermissions[menuId].includes(role)) {
                menuItem.style.display = '';
            } else {
                menuItem.style.display = 'none';
            }
        }
    });
    
    // Hide/show specific buttons based on role
    if (role === 'Consulta') {
        // Hide all create/edit/delete buttons for view-only role
        const actionButtons = document.querySelectorAll('.btn-create, .btn-edit, .btn-delete, .btn-save');
        actionButtons.forEach(btn => {
            btn.style.display = 'none';
        });
    }
}

/**
 * Verify token is still valid
 */
async function verifyToken() {
    const token = getAuthToken();
    
    if (!token) {
        return false;
    }
    
    try {
        const response = await fetch(window.getApiUrl() + '/api/auth/me', {
            headers: {
                'Authorization': `Bearer ${token}`
            }
        });
        
        if (response.ok) {
            const user = await response.json();
            localStorage.setItem('user', JSON.stringify(user));
            return true;
        } else {
            clearAuth();
            return false;
        }
    } catch (error) {
        console.error('Error al verificar token:', error);
        return false;
    }
}

// Expose functions globally
window.getAuthToken = getAuthToken;
window.getCurrentUser = getCurrentUser;
window.setAuth = setAuth;
window.clearAuth = clearAuth;
window.isAuthenticated = isAuthenticated;
window.hasRole = hasRole;
window.hasAnyRole = hasAnyRole;
window.logout = logout;
window.authFetch = authFetch;
window.requireAuth = requireAuth;
window.requireRole = requireRole;
window.initAuthUI = initAuthUI;
window.applyRoleBasedVisibility = applyRoleBasedVisibility;
window.verifyToken = verifyToken;

console.log('🔐 Auth utilities loaded');
