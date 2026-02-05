// ========== GEOGRAPHIC DATA ==========

// Estados de México
const MEXICAN_STATES = [
    'Aguascalientes',
    'Baja California',
    'Baja California Sur',
    'Campeche',
    'Chiapas',
    'Chihuahua',
    'Coahuila',
    'Colima',
    'Ciudad de México',
    'Durango',
    'Estado de México',
    'Guanajuato',
    'Guerrero',
    'Hidalgo',
    'Jalisco',
    'Michoacán',
    'Morelos',
    'Nayarit',
    'Nuevo León',
    'Oaxaca',
    'Puebla',
    'Querétaro',
    'Quintana Roo',
    'San Luis Potosí',
    'Sinaloa',
    'Sonora',
    'Tabasco',
    'Tamaulipas',
    'Tlaxcala',
    'Veracruz',
    'Yucatán',
    'Zacatecas'
];

// Países del mundo (ordenados con México y España primero)
const WORLD_COUNTRIES = [
    'México',
    'España',
    '---', // Separador visual
    'Afganistán',
    'Albania',
    'Alemania',
    'Andorra',
    'Angola',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaiyán',
    'Bahamas',
    'Bahréin',
    'Bangladesh',
    'Barbados',
    'Bielorrusia',
    'Bélgica',
    'Belice',
    'Benín',
    'Bután',
    'Bolivia',
    'Bosnia y Herzegovina',
    'Botsuana',
    'Brasil',
    'Brunéi',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Camboya',
    'Camerún',
    'Canadá',
    'Catar',
    'Chad',
    'Chile',
    'China',
    'Chipre',
    'Colombia',
    'Comoras',
    'Corea del Norte',
    'Corea del Sur',
    'Costa Rica',
    'Costa de Marfil',
    'Croacia',
    'Cuba',
    'Dinamarca',
    'Dominica',
    'Ecuador',
    'Egipto',
    'El Salvador',
    'Emiratos Árabes Unidos',
    'Eritrea',
    'Eslovaquia',
    'Eslovenia',
    'Estados Unidos',
    'Estonia',
    'Esuatini',
    'Etiopía',
    'Filipinas',
    'Finlandia',
    'Fiyi',
    'Francia',
    'Gabón',
    'Gambia',
    'Georgia',
    'Ghana',
    'Granada',
    'Grecia',
    'Guatemala',
    'Guinea',
    'Guinea-Bisáu',
    'Guinea Ecuatorial',
    'Guyana',
    'Haití',
    'Honduras',
    'Hungría',
    'India',
    'Indonesia',
    'Irak',
    'Irán',
    'Irlanda',
    'Islandia',
    'Islas Marshall',
    'Islas Salomón',
    'Israel',
    'Italia',
    'Jamaica',
    'Japón',
    'Jordania',
    'Kazajistán',
    'Kenia',
    'Kirguistán',
    'Kiribati',
    'Kuwait',
    'Laos',
    'Lesoto',
    'Letonia',
    'Líbano',
    'Liberia',
    'Libia',
    'Liechtenstein',
    'Lituania',
    'Luxemburgo',
    'Macedonia del Norte',
    'Madagascar',
    'Malasia',
    'Malaui',
    'Maldivas',
    'Malí',
    'Malta',
    'Marruecos',
    'Mauricio',
    'Mauritania',
    'Micronesia',
    'Moldavia',
    'Mónaco',
    'Mongolia',
    'Montenegro',
    'Mozambique',
    'Birmania',
    'Namibia',
    'Nauru',
    'Nepal',
    'Nicaragua',
    'Níger',
    'Nigeria',
    'Noruega',
    'Nueva Zelanda',
    'Omán',
    'Países Bajos',
    'Pakistán',
    'Palaos',
    'Panamá',
    'Papúa Nueva Guinea',
    'Paraguay',
    'Perú',
    'Polonia',
    'Portugal',
    'Reino Unido',
    'República Centroafricana',
    'República Checa',
    'República del Congo',
    'República Democrática del Congo',
    'República Dominicana',
    'Ruanda',
    'Rumania',
    'Rusia',
    'Samoa',
    'San Cristóbal y Nieves',
    'San Marino',
    'San Vicente y las Granadinas',
    'Santa Lucía',
    'Santo Tomé y Príncipe',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leona',
    'Singapur',
    'Siria',
    'Somalia',
    'Sri Lanka',
    'Sudáfrica',
    'Sudán',
    'Sudán del Sur',
    'Suecia',
    'Suiza',
    'Surinam',
    'Tailandia',
    'Tanzania',
    'Tayikistán',
    'Timor Oriental',
    'Togo',
    'Tonga',
    'Trinidad y Tobago',
    'Túnez',
    'Turkmenistán',
    'Turquía',
    'Tuvalu',
    'Ucrania',
    'Uganda',
    'Uruguay',
    'Uzbekistán',
    'Vanuatu',
    'Vaticano',
    'Venezuela',
    'Vietnam',
    'Yemen',
    'Yibuti',
    'Zambia',
    'Zimbabue'
];

// ========== POPULATE DROPDOWNS FUNCTIONS ==========

function populateStatesDropdown() {
    const statesSelect = document.getElementById('employee-address-state');
    if (!statesSelect) return;

    // Limpiar opciones existentes (excepto la primera)
    statesSelect.innerHTML = '<option value="">Seleccionar estado...</option>';

    // Agregar todos los estados de México
    MEXICAN_STATES.forEach(state => {
        const option = document.createElement('option');
        option.value = state;
        option.textContent = state;
        statesSelect.appendChild(option);
    });
}

function populateCountriesDropdown() {
    const countriesSelect = document.getElementById('employee-address-country');
    if (!countriesSelect) return;

    // Limpiar opciones existentes (excepto la primera)
    countriesSelect.innerHTML = '<option value="">Seleccionar país...</option>';

    // Agregar todos los países
    WORLD_COUNTRIES.forEach(country => {
        const option = document.createElement('option');
        if (country === '---') {
            // Crear un separador visual
            option.value = '';
            option.textContent = '─────────────────';
            option.disabled = true;
            option.style.fontStyle = 'italic';
            option.style.color = '#999';
        } else {
            option.value = country;
            option.textContent = country;
        }
        countriesSelect.appendChild(option);
    });

    // Seleccionar México por defecto
    countriesSelect.value = 'México';
}

function populateNationalityDropdown() {
    const nationalitySelect = document.getElementById('employee-nationality');
    if (!nationalitySelect) return;

    // Las opciones principales ya están en el HTML, solo agregar más si es necesario
    const mainNationalities = ['Mexicana', 'Española', 'Estadounidense'];
    
    // Agregar otras nacionalidades comunes
    const additionalNationalities = [
        'Argentina',
        'Brasileña', 
        'Canadiense',
        'Chilena',
        'Colombiana',
        'Francesa',
        'Italiana',
        'Peruana',
        'Venezolana'
    ];

    // Encontrar la opción "Otra" y agregar antes de ella
    const otraOption = nationalitySelect.querySelector('option[value="Otra"]');
    
    additionalNationalities.forEach(nationality => {
        const option = document.createElement('option');
        option.value = nationality;
        option.textContent = nationality;
        nationalitySelect.insertBefore(option, otraOption);
    });
}

// ========== INITIALIZE DROPDOWNS ==========

function initializeAddressDropdowns() {
    // Poblamos las listas cuando se carga la página
    document.addEventListener('DOMContentLoaded', function() {
        populateStatesDropdown();
        populateCountriesDropdown();
        populateNationalityDropdown();
    });
    
    // También poblar si ya está cargado
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            populateStatesDropdown();
            populateCountriesDropdown();
            populateNationalityDropdown();
        });
    } else {
        populateStatesDropdown();
        populateCountriesDropdown();
        populateNationalityDropdown();
    }
}

// ========== EXPORT FUNCTIONS ==========
window.populateStatesDropdown = populateStatesDropdown;
window.populateCountriesDropdown = populateCountriesDropdown;
window.populateNationalityDropdown = populateNationalityDropdown;
window.initializeAddressDropdowns = initializeAddressDropdowns;
window.MEXICAN_STATES = MEXICAN_STATES;
window.WORLD_COUNTRIES = WORLD_COUNTRIES;

// Auto-inicializar
initializeAddressDropdowns();