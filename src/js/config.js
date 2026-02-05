// Configuration for different environments
(function() {
    // Determine the API base URL based on the current environment
    let apiBaseUrl;
    
    if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
        // Local development
        apiBaseUrl = 'http://localhost:3000';
    } else {
        // Production (Cloud Run) - use current origin
        apiBaseUrl = window.location.origin;
    }
    
    // Make configuration globally available
    window.APP_CONFIG = {
        API_BASE_URL: apiBaseUrl,
        API_ENDPOINTS: {
            health: '/api/health',
            employees: '/api/employees-v2',
            candidates: '/api/candidates',
            mastercode: '/api/mastercode',
            contractTypes: '/api/contract-types',
            contractSchemes: '/api/contract-schemes'
        }
    };
    
    // Helper function to build full API URLs
    window.getApiUrl = function(endpoint) {
        return window.APP_CONFIG.API_BASE_URL + endpoint;
    };
    
    console.log('🔧 App configurada con API Base URL:', apiBaseUrl);
})();