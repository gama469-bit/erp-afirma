document.addEventListener('DOMContentLoaded', async () => {
        // --- Vacaciones ---
        const addVacationBtn = document.getElementById('add-vacation-btn');
        const vacationTableBody = document.getElementById('vacation-table-body');
        const vacationGridLoading = document.getElementById('vacation-grid-loading');
        const vacationGridEmpty = document.getElementById('vacation-grid-empty');
        const vacationTable = document.getElementById('vacation-table');
        let allVacations = [];

        async function fetchVacations() {
            try {
                vacationGridLoading.style.display = 'block';
                vacationTable.style.display = 'none';
                vacationGridEmpty.style.display = 'none';
                const url = window.getApiUrl ? window.getApiUrl('/api/vacations') : '/api/vacations';
                const res = await fetch(url);
                if (!res.ok) throw new Error('Error al cargar vacaciones');
                const data = await res.json();
                allVacations = data;
                populateYearFilter();
                renderVacations(data);
            } catch (e) {
                vacationGridLoading.style.display = 'none';
                vacationTable.style.display = 'none';
                vacationGridEmpty.style.display = 'block';
                vacationGridEmpty.innerHTML = '<div style="color:#e53e3e">Error al cargar vacaciones</div>';
            }
        }

        function renderVacations(vacations) {
            vacationTableBody.innerHTML = '';
            if (!vacations || vacations.length === 0) {
                vacationGridLoading.style.display = 'none';
                vacationTable.style.display = 'none';
                vacationGridEmpty.style.display = 'block';
                return;
            }
            vacationGridLoading.style.display = 'none';
            vacationGridEmpty.style.display = 'none';
            vacationTable.style.display = 'table';
            vacations.forEach(vac => {
                const tr = document.createElement('tr');
                // Buscar nombre real del empleado si existe el ID
                let empName = vac.employee_name || '';
                if (vac.employee_id && allEmployeesList.length) {
                    const emp = allEmployeesList.find(e => String(e.id) === String(vac.employee_id));
                    if (emp) empName = `${emp.first_name || ''} ${emp.last_name || ''}`.trim();
                }
                tr.innerHTML = `
                    <td>${vac.id}</td>
                    <td>${empName}</td>
                    <td>${vac.start_date || ''}</td>
                    <td>${vac.end_date || ''}</td>
                    <td>${vac.status || ''}</td>
                    <td>
                        <button class="btn-action-edit" data-id="${vac.id}">✏️</button>
                        <button class="btn-action-delete" data-id="${vac.id}" style="margin-left:4px">🗑️</button>
                    </td>
                `;
                vacationTableBody.appendChild(tr);
            });
        }
    // Delegar clicks para editar/eliminar vacaciones
    vacationTableBody?.addEventListener('click', async (e) => {
        const editBtn = e.target.closest('.btn-action-edit');
        const delBtn = e.target.closest('.btn-action-delete');
        if (editBtn) {
            const id = editBtn.dataset.id;
            const vac = allVacations.find(v => String(v.id) === String(id));
            if (!vac) return alert('No encontrada');
            openVacationModal(true, vac);
        }
        if (delBtn) {
            const id = delBtn.dataset.id;
            const result = await Swal.fire({
                title: '¿Eliminar esta solicitud?',
                text: 'Esta acción no se puede deshacer',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            });
            if (!result.isConfirmed) return;
            await fetch((window.getApiUrl ? window.getApiUrl(`/api/vacations/${id}`) : `/api/vacations/${id}`), {
                method: 'DELETE'
            });
            Swal.fire({
                icon: 'success',
                title: 'Solicitud eliminada',
                timer: 2000,
                showConfirmButton: false
            });
            fetchVacations();
        }
    });

    function filterVacations() {
        const employeeId = document.getElementById('filter-vacation-employee')?.value;
        const status = (document.getElementById('filter-vacation-status')?.value || '').trim();
        const year = (document.getElementById('filter-vacation-year')?.value || '').trim();
        const month = (document.getElementById('filter-vacation-month')?.value || '').trim();
        
        let filtered = allVacations;
        
        if (employeeId) {
            filtered = filtered.filter(v => String(v.employee_id) === String(employeeId));
        }
        if (status) {
            filtered = filtered.filter(v => v.status === status);
        }
        if (year) {
            filtered = filtered.filter(v => {
                const startDate = v.start_date?.split('T')[0] || '';
                return startDate.startsWith(year);
            });
        }
        if (month) {
            filtered = filtered.filter(v => {
                const startDate = v.start_date?.split('T')[0] || '';
                return startDate.includes('-' + month + '-');
            });
        }
        
        renderVacations(filtered);
    }
    
    function populateYearFilter() {
        const years = new Set();
        allVacations.forEach(v => {
            const startDate = v.start_date?.split('T')[0] || '';
            if (startDate) {
                const year = startDate.substring(0, 4);
                if (year) years.add(year);
            }
        });
        
        const yearSelect = document.getElementById('filter-vacation-year');
        if (yearSelect) {
            const selectedYear = yearSelect.value;
            yearSelect.innerHTML = '<option value="">📆 Todos los años</option>';
            
            Array.from(years).sort().reverse().forEach(year => {
                const opt = document.createElement('option');
                opt.value = year;
                opt.textContent = year;
                yearSelect.appendChild(opt);
            });
            
            yearSelect.value = selectedYear;
        }
    }    // Cargar lista de empleados para vacaciones
    let allEmployeesList = [];
    async function loadVacationEmployeeDropdown() {
        const select = document.getElementById('filter-vacation-employee');
        if (!select) return;
        allEmployeesList = await (window.fetchEmployees ? window.fetchEmployees() : []);
        select.innerHTML = '<option value="">👤 Todos los empleados</option>';
        allEmployeesList.forEach(emp => {
            const opt = document.createElement('option');
            opt.value = emp.id;
            opt.textContent = `${emp.first_name || ''} ${emp.last_name || ''}`.trim();
            select.appendChild(opt);
        });
    }

    document.getElementById('filter-vacation-employee')?.addEventListener('change', filterVacations);
    document.getElementById('filter-vacation-status')?.addEventListener('change', filterVacations);
    document.getElementById('filter-vacation-year')?.addEventListener('change', filterVacations);
    document.getElementById('filter-vacation-month')?.addEventListener('change', filterVacations);
    document.getElementById('filter-vacation-search-btn')?.addEventListener('click', filterVacations);
    document.getElementById('filter-vacation-clear-btn')?.addEventListener('click', () => {
        document.getElementById('filter-vacation-employee').value = '';
        document.getElementById('filter-vacation-status').value = '';
        document.getElementById('filter-vacation-year').value = '';
        document.getElementById('filter-vacation-month').value = '';
        renderVacations(allVacations);
    });

    // Funciones para el modal de vacaciones
    const vacationModal = document.getElementById('vacation-modal');
    const vacationForm = document.getElementById('vacation-form');
    const vacationModalClose = document.getElementById('vacation-modal-close');
    const vacationCancel = document.getElementById('vacation-cancel');
    const vacationSubmit = document.getElementById('vacation-submit');

    async function openVacationModal(isEdit = false, vacation = null) {
        document.getElementById('vacation-modal-title').textContent = isEdit ? 'Editar Solicitud de Vacaciones' : 'Nueva Solicitud de Vacaciones';
        
        // Primero, cargar el dropdown de empleados
        await loadVacationEmployeeDropdownForModal();

        // Luego, llenar los valores
        if (!isEdit) {
            vacationForm.reset();
            document.getElementById('vacation-id').value = '';
        } else if (vacation) {
            console.log('📝 Loading vacation data for edit:', vacation);
            document.getElementById('vacation-id').value = vacation.id || '';
            document.getElementById('vacation-employee').value = vacation.employee_id || '';
            
            // Formatear fechas correctamente (YYYY-MM-DD)
            const formatDate = (dateStr) => {
                if (!dateStr) return '';
                // Si es un objeto Date, convertir a string ISO
                if (dateStr instanceof Date) {
                    return dateStr.toISOString().split('T')[0];
                }
                // Si es string, extraer solo la parte YYYY-MM-DD
                if (typeof dateStr === 'string') {
                    return dateStr.split('T')[0];
                }
                return '';
            };
            
            document.getElementById('vacation-start-date').value = formatDate(vacation.start_date);
            document.getElementById('vacation-end-date').value = formatDate(vacation.end_date);
            document.getElementById('vacation-status').value = vacation.status || 'Pendiente';
            console.log('✅ Vacation data loaded', {
                startDate: formatDate(vacation.start_date),
                endDate: formatDate(vacation.end_date)
            });
        }

        vacationModal.style.display = 'flex';
    }

    async function closeVacationModal(skipConfirmation = false) {
        if (!skipConfirmation) {
            const result = await Swal.fire({
                title: '¿Cancelar solicitud?',
                text: 'Los cambios no guardados se perderán',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, cancelar',
                cancelButtonText: 'Continuar editando',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            });
            if (!result.isConfirmed) return;
        }
        vacationModal.style.display = 'none';
        vacationForm.reset();
    }

    async function loadVacationEmployeeDropdownForModal() {
        const select = document.getElementById('vacation-employee');
        allEmployeesList = await (window.fetchEmployees ? window.fetchEmployees() : []);
        select.innerHTML = '<option value="">Seleccionar empleado...</option>';
        allEmployeesList.forEach(emp => {
            const opt = document.createElement('option');
            opt.value = emp.id;
            opt.textContent = `${emp.first_name || ''} ${emp.last_name || ''}`.trim();
            select.appendChild(opt);
        });
    }

    addVacationBtn?.addEventListener('click', () => openVacationModal(false));
    vacationModalClose?.addEventListener('click', async () => await closeVacationModal());
    vacationCancel?.addEventListener('click', async () => await closeVacationModal());
    vacationModal?.addEventListener('click', async (e) => {
        if (e.target === vacationModal) await closeVacationModal();
    });

    vacationForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        console.log('🔔 Submit event fired for vacation form');
        const vacationId = document.getElementById('vacation-id').value;
        const employeeId = document.getElementById('vacation-employee').value;
        const startDate = document.getElementById('vacation-start-date').value;
        const endDate = document.getElementById('vacation-end-date').value;
        const status = document.getElementById('vacation-status').value;

        console.log('📝 Vacation form data:', { vacationId, employeeId, startDate, endDate, status });

        if (!employeeId || !startDate || !endDate) {
            alert('Todos los campos son obligatorios');
            return;
        }

        const emp = allEmployeesList.find(e => String(e.id) === String(employeeId));
        const payload = {
            employee_id: employeeId,
            employee_name: emp ? `${emp.first_name} ${emp.last_name}`.trim() : '',
            start_date: startDate,
            end_date: endDate,
            status: status || 'Pendiente'
        };

        console.log('📤 Sending payload:', payload);

        try {
            const url = vacationId 
                ? (window.getApiUrl ? window.getApiUrl(`/api/vacations/${vacationId}`) : `/api/vacations/${vacationId}`)
                : (window.getApiUrl ? window.getApiUrl('/api/vacations') : '/api/vacations');
            
            const method = vacationId ? 'PUT' : 'POST';
            console.log(`📡 ${method} request to:`, url);
            
            const response = await fetch(url, {
                method: method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            console.log('✅ Response status:', response.status);

            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const result = await response.json();
            console.log('✅ Success response:', result);
            closeVacationModal(true); // true = skip confirmation
            fetchVacations();
        } catch (err) {
            console.error('❌ Error:', err);
            alert('Error al guardar: ' + err.message);
        }
    });

    const employeeForm = document.getElementById('employee-form');
    const candidateForm = document.getElementById('candidate-form');
    const navLinks = document.querySelectorAll('.nav a');
    const views = document.querySelectorAll('.view');
    const modal = document.getElementById('employee-modal');
    const candidateModal = document.getElementById('candidate-modal');
    const addBtn = document.getElementById('add-employee-btn');
    const addCandidateBtn = document.getElementById('add-candidate-btn');
    const modalClose = document.getElementById('modal-close');
    const candidateModalClose = document.getElementById('candidate-modal-close');
    const cancelBtn = document.getElementById('employee-cancel');

    // Load catalog dropdowns for employee form
    async function loadCatalogDropdowns() {
        console.log('🔄 Loading catalog dropdowns...');
        try {
            const [entities, positions, areas, projects, cells, contractTypes, contractSchemes] = await Promise.all([
                fetch(window.getApiUrl ? window.getApiUrl('/api/mastercode/Entidad') : '/api/mastercode/Entidad').then(r => r.json()).catch(() => []),
                fetch(window.getApiUrl ? window.getApiUrl('/api/mastercode/Puestos%20roles') : '/api/mastercode/Puestos%20roles').then(r => r.json()).catch(() => []),
                fetch(window.getApiUrl ? window.getApiUrl('/api/mastercode/Areas') : '/api/mastercode/Areas').then(r => r.json()).catch(() => []),
                fetch(window.getApiUrl ? window.getApiUrl('/api/mastercode/Proyecto') : '/api/mastercode/Proyecto').then(r => r.json()).catch(() => []),
                fetch(window.getApiUrl ? window.getApiUrl('/api/mastercode/Celulas') : '/api/mastercode/Celulas').then(r => r.json()).catch(() => []),
                fetch(window.getApiUrl ? window.getApiUrl('/api/contract-types') : '/api/contract-types').then(r => r.json()).catch(() => []),
                fetch(window.getApiUrl ? window.getApiUrl('/api/contract-schemes') : '/api/contract-schemes').then(r => r.json()).catch(() => [])
            ]);

            console.log(`✅ Loaded catalogs: ${entities.length} entities, ${positions.length} positions, ${areas.length} areas, ${projects.length} projects, ${cells.length} cells`);

            const entitySelect = document.getElementById('employee-entity');
            const positionSelect = document.getElementById('employee-position');
            const areaSelect = document.getElementById('employee-area');
            const projectSelect = document.getElementById('employee-project');
            const cellSelect = document.getElementById('employee-cell');
            const contractTypeSelect = document.getElementById('employee-contract-type');
            const contractSchemeSelect = document.getElementById('employee-contract-scheme');

            // Populate entities
            if (entitySelect) {
                entitySelect.innerHTML = '<option value="">Seleccionar entidad...</option>';
                entities.forEach(e => {
                    const opt = document.createElement('option');
                    opt.value = e.id;
                    opt.textContent = e.name;
                    entitySelect.appendChild(opt);
                });
            }

            // Populate positions
            if (positionSelect) {
                positionSelect.innerHTML = '<option value="">Seleccionar posición...</option>';
                positions.forEach(p => {
                    const opt = document.createElement('option');
                    opt.value = p.id;
                    opt.textContent = p.name;
                    positionSelect.appendChild(opt);
                });
            }

            // Populate areas
            if (areaSelect) {
                areaSelect.innerHTML = '<option value="">Seleccionar área...</option>';
                areas.forEach(a => {
                    const opt = document.createElement('option');
                    opt.value = a.id;
                    opt.textContent = a.name;
                    areaSelect.appendChild(opt);
                });
            }

            // Populate projects
            if (projectSelect) {
                projectSelect.innerHTML = '<option value="">Seleccionar proyecto...</option>';
                projects.forEach(p => {
                    const opt = document.createElement('option');
                    opt.value = p.id;
                    opt.textContent = p.name;
                    projectSelect.appendChild(opt);
                });
            }

            // Populate cells
            if (cellSelect) {
                cellSelect.innerHTML = '<option value="">Seleccionar célula...</option>';
                cells.forEach(c => {
                    const opt = document.createElement('option');
                    opt.value = c.id;
                    opt.textContent = c.name;
                    cellSelect.appendChild(opt);
                });
            }

            // Populate contract types
            if (contractTypeSelect) {
                contractTypeSelect.innerHTML = '<option value="">Seleccionar tipo...</option>';
                contractTypes.forEach(ct => {
                    const opt = document.createElement('option');
                    opt.value = ct.id;
                    opt.textContent = ct.name;
                    contractTypeSelect.appendChild(opt);
                });
            }

            // Populate contract schemes
            if (contractSchemeSelect) {
                contractSchemeSelect.innerHTML = '<option value="">Seleccionar esquema...</option>';
                contractSchemes.forEach(cs => {
                    const opt = document.createElement('option');
                    opt.value = cs.id;
                    opt.textContent = cs.name;
                    contractSchemeSelect.appendChild(opt);
                });
            }

            console.log('✅ All dropdowns populated successfully');
        } catch (e) {
            console.error('❌ Error loading catalog dropdowns:', e);
        }
    }

    function showView(id){
        views.forEach(v=> v.id === id ? v.style.display = '' : v.style.display = 'none');
        navLinks.forEach(a=> a.dataset.view === id ? a.classList.add('active') : a.classList.remove('active'));
        
        // Recargar datos cuando se accede a la vista de empleados
        if (id === 'alta') {
            loadAndRender();
        }
    }

    async function openModal(isEdit = false){
        console.log('🔓 Abriendo modal, isEdit:', isEdit);
        document.getElementById('modal-title').textContent = isEdit ? 'Actualizar Empleado' : 'Agregar Empleado';
        modal.style.display = 'flex';
        if (!isEdit) {
            window.clearInputFields();
        }
        
        // Always reload catalogs to ensure they're up to date
        await loadCatalogDropdowns();
        
        // Activar primera pestaña automáticamente con más tiempo para el modo editar
        const delay = isEdit ? 300 : 100;
        setTimeout(() => {
            console.log('⏰ Activando pestaña general después de', delay, 'ms');
            switchTab('general');
        }, delay);
    }

    async function closeModal(skipConfirmation = false){
        if (!skipConfirmation) {
            const result = await Swal.fire({
                title: '¿Cancelar edición?',
                text: 'Los cambios no guardados se perderán',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, cancelar',
                cancelButtonText: 'Continuar editando',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            });
            if (!result.isConfirmed) return;
        }
        modal.style.display = 'none';
        window.clearInputFields();
    }

    // Simplified direct tab switching function
    function switchTabDirect(tabName) {
        console.log('🎯 Direct tab switch to:', tabName);
        
        try {
            // Remove active from all buttons
            const allButtons = document.querySelectorAll('.tab-button');
            console.log('Found buttons:', allButtons.length);
            allButtons.forEach(btn => {
                btn.classList.remove('active');
                console.log('Removed active from button:', btn.textContent.trim());
            });
            
            // Remove active from all contents
            const allContents = document.querySelectorAll('.tab-content');
            console.log('Found contents:', allContents.length);
            allContents.forEach(content => {
                content.classList.remove('active');
                console.log('Removed active from content:', content.id);
            });
            
            // Add active to selected content
            const selectedContent = document.getElementById(`tab-${tabName}`);
            if (selectedContent) {
                selectedContent.classList.add('active');
                console.log('✅ Activated content:', `tab-${tabName}`);
            } else {
                console.error('❌ Content not found:', `tab-${tabName}`);
                return false;
            }
            
            // Add active to correct button - find by onclick text content
            let buttonActivated = false;
            allButtons.forEach(btn => {
                if (btn.onclick && btn.onclick.toString().includes(`'${tabName}'`)) {
                    btn.classList.add('active');
                    console.log('✅ Activated button:', btn.textContent.trim());
                    buttonActivated = true;
                }
            });
            
            if (!buttonActivated) {
                console.error('❌ No button activated for:', tabName);
            }
            
            console.log('✅ Tab switch completed successfully');
            
            // Load HR data if needed
            if (tabName === 'hr') {
                const employeeId = document.getElementById('employee-id')?.value;
                if (employeeId) {
                    console.log('📊 Loading HR data for employee:', employeeId);
                    loadEmployeeContracts(employeeId);
                    loadEmployeeBanking(employeeId);
                }
            }
            
            return true;
        } catch (error) {
            console.error('❌ Error in switchTabDirect:', error);
            return false;
        }
    }

    // Make it globally available
    window.switchTabDirect = switchTabDirect;

    // Make switchTab available globally for backwards compatibility
    window.switchTab = switchTabDirect;
    
    // Global test function
    window.testTabs = function() {
        console.log('=== TESTING ALL TABS ===');
        ['general', 'expediente', 'hr'].forEach(tab => {
            console.log(`\n--- Testing ${tab} ---`);
            const result = switchTabDirect(tab);
            console.log(`Result: ${result ? 'SUCCESS' : 'FAILED'}`);
        });
    };
    
    // Global debug function
    window.debugTabState = function() {
        console.log('=== TAB STATE DEBUG ===');
        
        const buttons = document.querySelectorAll('.tab-button');
        console.log(`\nButtons (${buttons.length}):`);
        buttons.forEach((btn, i) => {
            console.log(`  ${i+1}. "${btn.textContent.trim()}" - active: ${btn.classList.contains('active')} - onclick: ${!!btn.onclick}`);
        });
        
        const contents = document.querySelectorAll('.tab-content');
        console.log(`\nContents (${contents.length}):`);
        contents.forEach((content, i) => {
            console.log(`  ${i+1}. ${content.id} - active: ${content.classList.contains('active')} - display: ${getComputedStyle(content).display}`);
        });
        
        console.log('\nFunctions available:');
        console.log('  window.switchTabDirect:', typeof window.switchTabDirect);
        console.log('  window.testTabs:', typeof window.testTabs);
    };

    // Load employee contracts for HR tab
    async function loadEmployeeContracts(employeeId) {
        if (!employeeId) {
            document.getElementById('contracts-list').innerHTML = '<p><em>Selecciona un empleado para ver su historial de contratos</em></p>';
            return;
        }

        try {
            const url = window.getApiUrl ? window.getApiUrl(`/api/employees-v2/${employeeId}/contracts`) : `/api/employees-v2/${employeeId}/contracts`;
            const contracts = await fetch(url).then(r => r.json());
            const contractsList = document.getElementById('contracts-list');
            
            if (contracts.length === 0) {
                contractsList.innerHTML = '<p><em>No hay contratos registrados</em></p>';
                return;
            }

            contractsList.innerHTML = contracts.map(contract => {
                const isActive = contract.is_active;
                const startDate = contract.start_date ? new Date(contract.start_date).toLocaleDateString() : 'N/A';
                const endDate = contract.end_date ? new Date(contract.end_date).toLocaleDateString() : 'Vigente';
                
                return `
                    <div class="contract-item ${isActive ? 'contract-active' : ''}">
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:10px;">
                            <strong>${contract.contract_type_name || 'Tipo no especificado'}</strong>
                            ${isActive ? '<span style="color:#007bff;font-weight:bold;">ACTIVO</span>' : ''}
                        </div>
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;font-size:14px;">
                            <div><strong>Esquema:</strong> ${contract.contract_scheme_name || 'N/A'}</div>
                            <div><strong>Período:</strong> ${startDate} - ${endDate}</div>
                            <div><strong>Salario bruto:</strong> ${contract.gross_monthly_salary ? '$' + parseFloat(contract.gross_monthly_salary).toLocaleString() : 'N/A'}</div>
                            <div><strong>Salario neto:</strong> ${contract.net_monthly_salary ? '$' + parseFloat(contract.net_monthly_salary).toLocaleString() : 'N/A'}</div>
                        </div>
                    </div>
                `;
            }).join('');
        } catch (error) {
            console.error('Error loading contracts:', error);
            document.getElementById('contracts-list').innerHTML = '<p><em>Error cargando historial de contratos</em></p>';
        }
    }

    // Load employee banking info for HR tab
    async function loadEmployeeBanking(employeeId) {
        if (!employeeId) return;

        try {
            const url = window.getApiUrl ? window.getApiUrl(`/api/employees-v2/${employeeId}/banking`) : `/api/employees-v2/${employeeId}/banking`;
            const banking = await fetch(url).then(r => r.json());
            if (banking) {
                document.getElementById('employee-bank-name').value = banking.bank_name || '';
                document.getElementById('employee-account-holder').value = banking.account_holder_name || '';
                document.getElementById('employee-account-number').value = banking.account_number || '';
                document.getElementById('employee-clabe').value = banking.clabe_interbancaria || '';
            }
        } catch (error) {
            console.error('Error loading banking info:', error);
        }
    }

    function openCandidateModal(isEdit = false){
        document.getElementById('candidate-modal-title').textContent = isEdit ? 'Actualizar Candidato' : 'Agregar Candidato';
        candidateModal.style.display = 'flex';
        if (!isEdit) window.clearCandidateForm();
    }

    function closeCandidateModal(){
        candidateModal.style.display = 'none';
        window.clearCandidateForm();
    }

    // navigation
    navLinks.forEach(a => {
        a.addEventListener('click', (e) => {
            e.preventDefault();
            const view = a.dataset.view;
            showView(view);
        });
    });

    // Cargar vacaciones al mostrar la vista
    navLinks.forEach(a => {
        a.addEventListener('click', (e) => {
            const view = a.dataset.view;
            if (view === 'vacaciones') {
                loadVacationEmployeeDropdown();
                fetchVacations();
            }
            if (view === 'proyectos') {
                fetchProjects();
            }
            if (view === 'asignaciones') {
                if (typeof window.loadAssignments === 'function') {
                    window.loadAssignments();
                }
                if (typeof window.loadAssignmentFilters === 'function') {
                    window.loadAssignmentFilters();
                }
            }
            if (view === 'reportes') {
                if (typeof window.loadAllReports === 'function') {
                    window.loadAllReports();
                }
            }
        });
    });

    // modal controls
    addBtn.addEventListener('click', async () => await openModal(false));
    modalClose.addEventListener('click', async () => await closeModal());
    cancelBtn.addEventListener('click', async () => await closeModal());
    modal.addEventListener('click', async (e) => {
        if (e.target === modal) await closeModal();
    });
    
    // Prevent modal from closing when clicking inside modal content
    // BUT allow buttons to work normally
    document.querySelector('#employee-modal .modal-content').addEventListener('click', (e) => {
        // No bloquear clicks en botones de control
        if (e.target.tagName === 'BUTTON' || e.target.closest('button')) {
            return; // Permitir que el evento se propague
        }
        e.stopPropagation();
    });

    // Tab controls - now using inline onclick handlers (working solution)
    // Tabs functionality is embedded directly in HTML onclick attributes

    // candidate modal controls
    addCandidateBtn.addEventListener('click', () => openCandidateModal(false));
    candidateModalClose.addEventListener('click', () => {
        closeCandidateModal();
    });
    
    candidateModal.addEventListener('click', (e) => {
        if (e.target === candidateModal) closeCandidateModal();
    });

    async function loadAndRender() {
        try {
            if (typeof window.showGridLoading === 'function') {
                window.showGridLoading();
            }
            
            const employees = await window.fetchEmployees();
            
            if (employees && employees.length > 0) {
                window.renderEmployees(employees);
            } else {
                window.renderEmployees([]);
            }
        } catch (error) {
            console.error('Error cargando empleados:', error);
            if (typeof window.showGridError === 'function') {
                window.showGridError('Error de conexión con la API');
            } else {
                window.renderEmployees([]);
            }
        }
    }

    async function loadAndRenderCandidates() {
        const candidates = await window.fetchCandidates();
        window.renderCandidates(candidates);
    }

    // Inicialización simple
    await loadAndRender();
    await loadAndRenderCandidates();
    await loadCatalogDropdowns();
    // show default view
    showView('alta');

    // handle submit for create/update employees
    employeeForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        // Eliminar todas las validaciones y alertas, solo tomar los valores y guardar
        const id = document.getElementById('employee-id').value;
        const first = document.getElementById('employee-first').value;
        const last = document.getElementById('employee-last').value;
        const email = document.getElementById('employee-email').value;
        const birth = document.getElementById('employee-birth').value;
        const code = document.getElementById('employee-code').value;
        const phone = document.getElementById('employee-phone').value;
        const personalPhone = document.getElementById('employee-personal-phone').value;
        const positionId = document.getElementById('employee-position').value || null;
        const entityId = document.getElementById('employee-entity').value || null;
        const areaId = document.getElementById('employee-area').value || null;
        const projectId = document.getElementById('employee-project').value || null;
        const cellId = document.getElementById('employee-cell').value || null;
        const status = document.getElementById('employee-status').value;
        const addressStreet = document.getElementById('employee-address-street').value;
        const addressExterior = document.getElementById('employee-address-exterior').value;
        const addressInterior = document.getElementById('employee-address-interior').value;
        const addressColonia = document.getElementById('employee-address-colonia').value;
        const addressCity = document.getElementById('employee-address-city').value;
        const addressState = document.getElementById('employee-address-state').value;
        const addressPostal = document.getElementById('employee-address-postal-code').value;
        const addressCountry = document.getElementById('employee-address-country').value;
        const curp = document.getElementById('employee-curp').value;
        const rfc = document.getElementById('employee-rfc').value;
        const nss = document.getElementById('employee-nss').value;
        const passport = document.getElementById('employee-passport').value;
        const gender = document.getElementById('employee-gender').value;
        const maritalStatus = document.getElementById('employee-marital-status').value;
        const nationality = document.getElementById('employee-nationality').value;
        const bloodType = document.getElementById('employee-blood-type').value;
        const bankName = document.getElementById('employee-bank-name').value;
        const accountHolder = document.getElementById('employee-account-holder').value;
        const accountNumber = document.getElementById('employee-account-number').value;
        const clabe = document.getElementById('employee-clabe').value;
        const contractTypeId = document.getElementById('employee-contract-type').value || null;
        const obra = document.getElementById('employee-obra').value;
        const contractSchemeId = document.getElementById('employee-contract-scheme').value || null;
        const initialRate = document.getElementById('employee-initial-rate').value;
        const grossSalary = document.getElementById('employee-gross-salary').value;
        const netSalary = document.getElementById('employee-net-salary').value;
        const companyCost = document.getElementById('employee-company-cost').value;
        const hireDate = document.getElementById('employee-hire-date').value;
        const endDate = document.getElementById('employee-end-date').value;
        const terminationReason = document.getElementById('employee-termination-reason').value;
        const rehireable = document.getElementById('employee-rehireable').checked;

        const payload = {
            first_name: first,
            last_name: last,
            email: email || null,
            birth_date: birth || null,
            employee_code: code || null,
            phone: phone || null,
            personal_phone: personalPhone || null,
            position_id: positionId ? parseInt(positionId) : null,
            entity_id: entityId ? parseInt(entityId) : null,
            area_id: areaId ? parseInt(areaId) : null,
            project_id: projectId ? parseInt(projectId) : null,
            cell_id: cellId ? parseInt(cellId) : null,
            status: status || null,
            address: addressStreet || null,
            exterior_number: addressExterior || null,
            interior_number: addressInterior || null,
            colonia: addressColonia || null,
            city: addressCity || null,
            state: addressState || null,
            postal_code: addressPostal || null,
            country: addressCountry || 'México',
            curp: curp || null,
            rfc: rfc || null,
            nss: nss || null,
            passport: passport || null,
            gender: gender || null,
            marital_status: maritalStatus || null,
            nationality: nationality || null,
            blood_type: bloodType || null,
            created_by: 'web'
        };

        console.log('📤 Payload a enviar:', payload);

        try {
            let employeeId;
            let result;
            if (id) {
                result = await window.updateEmployee(id, payload);
                employeeId = id;
                Swal.fire({
                    icon: 'success',
                    title: 'Empleado actualizado',
                    text: 'Los datos del empleado se actualizaron correctamente',
                    timer: 2000,
                    showConfirmButton: false
                });
                console.log('✅ Empleado actualizado:', result);
            } else {
                result = await window.createEmployee(payload);
                employeeId = result.id;
                Swal.fire({
                    icon: 'success',
                    title: 'Empleado creado',
                    text: 'El empleado se creó correctamente',
                    timer: 2000,
                    showConfirmButton: false
                });
                console.log('✅ Empleado creado:', result);
            }

            // Save banking info if provided
            if (bankName || accountHolder || accountNumber || clabe) {
                const bankingData = {
                    bank_name: bankName,
                    account_holder_name: accountHolder,
                    account_number: accountNumber,
                    clabe_interbancaria: clabe
                };
                try {
                    const url = window.getApiUrl ? window.getApiUrl(`/api/employees-v2/${employeeId}/banking`) : `/api/employees-v2/${employeeId}/banking`;
                    const bankingRes = await fetch(url, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(bankingData)
                    });
                    if (!bankingRes.ok) throw new Error('Error guardando datos bancarios');
                    Swal.fire({
                        icon: 'success',
                        title: 'Datos bancarios guardados',
                        timer: 1500,
                        showConfirmButton: false
                    });
                } catch (bankingError) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error guardando datos bancarios',
                        text: bankingError.message || bankingError
                    });
                    console.error('Error saving banking info:', bankingError);
                }
            }

            // Save contract info if provided
            if (contractTypeId || grossSalary || hireDate) {
                const contractData = {
                    contract_type_id: contractTypeId || null,
                    obra: obra || null,
                    contract_scheme_id: contractSchemeId || null,
                    initial_rate: initialRate ? parseFloat(initialRate) : null,
                    gross_monthly_salary: grossSalary ? parseFloat(grossSalary) : null,
                    net_monthly_salary: netSalary ? parseFloat(netSalary) : null,
                    company_cost: companyCost ? parseFloat(companyCost) : null,
                    start_date: hireDate || null,
                    end_date: endDate || null,
                    termination_reason: terminationReason || null,
                    is_rehireable: rehireable,
                    is_active: true // New contracts are active by default
                };
                try {
                    const url = window.getApiUrl ? window.getApiUrl(`/api/employees-v2/${employeeId}/contracts`) : `/api/employees-v2/${employeeId}/contracts`;
                    const contractRes = await fetch(url, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(contractData)
                    });
                    if (!contractRes.ok) throw new Error('Error guardando contrato');
                    Swal.fire({
                        icon: 'success',
                        title: 'Contrato guardado',
                        timer: 1500,
                        showConfirmButton: false
                    });
                } catch (contractError) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error guardando contrato',
                        text: contractError.message || contractError
                    });
                    console.error('Error saving contract info:', contractError);
                }
            }

        } catch (err) {
            Swal.fire({
                icon: 'error',
                title: 'Error guardando empleado',
                text: err.message || err
            });
            console.error('❌ Error guardando empleado:', err);
            return;
        }

        closeModal(true); // true = skip confirmation
        await loadAndRender();
    });

    // handle submit for create/update candidates
    candidateForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const id = document.getElementById('candidate-id').value;
        const first = document.getElementById('candidate-first').value.trim();
        const last = document.getElementById('candidate-last').value.trim();
        const email = document.getElementById('candidate-email').value.trim();
        const phone = document.getElementById('candidate-phone').value.trim();
        const position = document.getElementById('candidate-position').value.trim();
        const status = document.getElementById('candidate-status').value.trim();
        const notes = document.getElementById('candidate-notes').value.trim();
        
        if (!first || !last || !position) return;

        // client-side email validation (if provided)
        if (email) {
            const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRe.test(String(email))) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Email inválido',
                    text: 'Por favor ingresa un formato de email válido'
                });
                return;
            }
        }

        const payload = { first_name: first, last_name: last, email: email || null, phone: phone || null, position_applied: position, status, notes: notes || null };
        try {
            if (id) {
                await window.updateCandidate(id, payload);
                Swal.fire({
                    icon: 'success',
                    title: 'Candidato actualizado',
                    timer: 2000,
                    showConfirmButton: false
                });
            } else {
                await window.createCandidate(payload);
                Swal.fire({
                    icon: 'success',
                    title: 'Candidato creado',
                    timer: 2000,
                    showConfirmButton: false
                });
            }
        } catch (err) {
            // Error ya manejado en las funciones
            return;
        }
        closeCandidateModal();
        await loadAndRenderCandidates();
    });

    // ========== TAB SWITCHING FUNCTION ==========
    function switchTab(tabName) {
        console.log('🔄 switchTab llamada con:', tabName);
        
        // Get the currently open modal to work within its context
        const openModal = document.querySelector('.modal[style*="display: flex"], .modal[style*="display: block"]');
        if (!openModal) {
            console.warn('⚠️ No hay modal abierto');
            return;
        }
        
        console.log('📋 Modal encontrado:', openModal.id);
        
        // Remove active class from all tab buttons in this modal
        const tabButtons = openModal.querySelectorAll('.tab-button');
        console.log('🔘 Botones encontrados:', tabButtons.length);
        tabButtons.forEach((button, index) => {
            button.classList.remove('active');
            console.log(`  Botón ${index + 1}: ${button.textContent.trim()} - data-tab: ${button.dataset.tab}`);
        });
        
        // Hide all tab content in this modal
        const tabContents = openModal.querySelectorAll('.tab-content');
        console.log('📄 Contenidos encontrados:', tabContents.length);
        tabContents.forEach((content, index) => {
            content.classList.remove('active');
            content.style.display = 'none';
            console.log(`  Contenido ${index + 1}: ${content.id}`);
        });
        
        // Activate selected tab button
        const activeButton = openModal.querySelector(`[data-tab="${tabName}"]`);
        if (activeButton) {
            activeButton.classList.add('active');
            console.log('✅ Botón activado:', activeButton.textContent.trim());
        } else {
            console.error('❌ No se encontró botón para pestaña:', tabName);
        }
        
        // Show selected tab content
        const activeContent = openModal.querySelector(`#tab-${tabName}`);
        if (activeContent) {
            activeContent.classList.add('active');
            activeContent.style.display = 'block';
            console.log('✅ Contenido mostrado:', activeContent.id);
            console.log('📋 Display después del cambio:', getComputedStyle(activeContent).display);
        } else {
            console.error('❌ No se encontró contenido para pestaña:', `#tab-${tabName}`);
        }
        
        // Cargar datos específicos según el tab
        if (tabName === 'asignaciones') {
            const employeeId = document.getElementById('employee-id')?.value;
            if (employeeId && window.loadEmployeeAssignments) {
                console.log('📊 Cargando asignaciones del empleado:', employeeId);
                window.loadEmployeeAssignments(employeeId);
            }
        } else if (tabName === 'project-assignments') {
            const projectId = document.getElementById('project-id')?.value;
            if (projectId && window.loadProjectAssignments) {
                console.log('📊 Cargando asignaciones del proyecto:', projectId);
                window.loadProjectAssignments(projectId);
            }
        }
        
        console.log('✅ switchTab completado para:', tabName);
    }
    
    // ========== EMPLOYEE DATA LOADING FUNCTIONS ==========
    async function loadEmployeeContracts(employeeId) {
        console.log('💼 Cargando contratos para empleado:', employeeId);
        try {
            const url = window.getApiUrl ? window.getApiUrl(`/api/employees-v2/${employeeId}/contracts`) : `/api/employees-v2/${employeeId}/contracts`;
            const response = await fetch(url);
            if (!response.ok) {
                console.warn('⚠️ No se pudieron cargar los contratos');
                return;
            }
            const contracts = await response.json();
            
            // Update contracts list in the UI
            const contractsList = document.getElementById('contracts-list');
            if (contractsList && contracts.length > 0) {
                contractsList.innerHTML = contracts.map(contract => `
                    <div class="contract-item ${contract.is_current ? 'contract-active' : ''}">
                        <h5>${contract.position_name || 'Sin posición'}</h5>
                        <p><strong>Periodo:</strong> ${contract.start_date} - ${contract.end_date || 'Actual'}</p>
                        <p><strong>Salario:</strong> $${contract.gross_salary || 'No especificado'}</p>
                        <p><strong>Estado:</strong> ${contract.is_current ? 'Activo' : 'Inactivo'}</p>
                    </div>
                `).join('');
            } else if (contractsList) {
                contractsList.innerHTML = '<p><em>No hay contratos registrados</em></p>';
            }
        } catch (error) {
            console.error('❌ Error cargando contratos:', error);
        }
    }
    
    async function loadEmployeeBanking(employeeId) {
        console.log('🏦 Cargando información bancaria para empleado:', employeeId);
        try {
            const url = window.getApiUrl ? window.getApiUrl(`/api/employees-v2/${employeeId}/banking`) : `/api/employees-v2/${employeeId}/banking`;
            const response = await fetch(url);
            if (!response.ok) {
                console.warn('⚠️ No se pudo cargar la información bancaria');
                return;
            }
            const banking = await response.json();
            
            // Update banking fields if they exist
            if (banking) {
                const bankNameField = document.getElementById('employee-bank-name');
                const accountHolderField = document.getElementById('employee-account-holder');
                const accountNumberField = document.getElementById('employee-account-number');
                const clabeField = document.getElementById('employee-clabe');
                
                if (bankNameField) bankNameField.value = banking.bank_name || '';
                if (accountHolderField) accountHolderField.value = banking.account_holder || '';
                if (accountNumberField) accountNumberField.value = banking.account_number || '';
                if (clabeField) clabeField.value = banking.clabe || '';
            }
        } catch (error) {
            console.error('❌ Error cargando información bancaria:', error);
        }
    }

    // delegate edit/delete clicks for employees (supports table or legacy list)
    const employeeClicksHost = document.getElementById('employee-table-body') || document.getElementById('employee-list');
    if (employeeClicksHost) {
        employeeClicksHost.addEventListener('click', async (e)=>{
            const edit = e.target.closest('.edit-employee');
            const del = e.target.closest('.delete-employee');
            if (edit) {
                const id = edit.dataset.id;
                const employees = await window.fetchEmployees();
                const emp = employees.find(x=> String(x.id) === String(id));
                if (emp) {
                    if (!confirm('¿Estás seguro de que deseas editar este empleado?')) return;
                    await openModal(true); // Abre el modal y espera catálogos
                    // Espera a que los catálogos estén listos antes de poblar el formulario
                    setTimeout(() => {
                        window.populateForm(emp);
                        // Re-verificar que los event listeners funcionen después de populate
                        const modal = document.getElementById('employee-modal');
                        const buttons = modal.querySelectorAll('.tab-button');
                        buttons.forEach((btn, index) => {
                            console.log(`  Botón ${index + 1}: ${btn.textContent.trim()} - data-tab: ${btn.getAttribute('data-tab')}`);
                        });
                    }, 200);
                }
                return;
            }
            if (del) {
                const id = del.dataset.id;
                const result = await Swal.fire({
                    title: '¿Eliminar empleado?',
                    text: 'Esta acción no se puede deshacer',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Sí, eliminar',
                    cancelButtonText: 'Cancelar',
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6'
                });
                if (!result.isConfirmed) return;
                await window.deleteEmployee(id);
                await loadAndRender();
            }
        });
    }

    // delegate edit/delete clicks for candidates
    document.getElementById('candidate-list').addEventListener('click', async (e)=>{
        const edit = e.target.closest('.edit-candidate');
        const del = e.target.closest('.delete-candidate');
        if (edit) {
            const id = edit.dataset.id;
            const candidates = await window.fetchCandidates();
            const cand = candidates.find(x=> String(x.id) === String(id));
            if (cand) {
                window.populateCandidateForm(cand);
                openCandidateModal(true);
            }
            return;
        }
        if (del) {
            const id = del.dataset.id;
            const result = await Swal.fire({
                title: '¿Eliminar candidato?',
                text: 'Esta acción no se puede deshacer',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            });
            if (!result.isConfirmed) return;
            await window.deleteCandidate(id);
            await loadAndRenderCandidates();
        }
    });

    // ========== TAB EVENT LISTENERS ==========
    // Add event listeners to tab buttons with event delegation
    document.addEventListener('click', (e) => {
        // Only handle clicks on tab buttons
        if (e.target.matches('.tab-button[data-tab]')) {
            e.preventDefault();
            e.stopPropagation();
            
            const tabName = e.target.getAttribute('data-tab');
            const modal = e.target.closest('.modal');
            
            console.log('🎯 Click en tab-button detectado:', tabName);
            
            // Only proceed if we're inside a modal
            if (tabName && modal && modal.style.display !== 'none') {
                console.log('🖱️ Procesando click en pestaña:', tabName);
                switchTab(tabName);
            } else {
                console.warn('⚠️ Click ignorado - modal no visible o sin tabName');
            }
        } else {
            // Debug para otros clics
            if (e.target.classList.contains('tab-button')) {
                console.log('🔍 Click en tab-button pero sin data-tab:', e.target);
            }
        }
    }, true); // Usar capture phase para interceptar antes que otros handlers

    // Expose functions for global access
    window.switchTab = switchTab;
    window.loadEmployeeContracts = loadEmployeeContracts;
    window.loadEmployeeBanking = loadEmployeeBanking;
    window.openModal = openModal;
    window.closeCandidateModal = closeCandidateModal;
    
    // --- PROYECTOS ---
    const addProjectBtn = document.getElementById('add-project-btn');
    const projectTableBody = document.getElementById('project-table-body');
    const projectGridLoading = document.getElementById('project-grid-loading');
    const projectGridEmpty = document.getElementById('project-grid-empty');
    const projectTable = document.getElementById('project-table');
    let allProjects = [];

    async function fetchProjects() {
        try {
            projectGridLoading.style.display = 'block';
            projectTable.style.display = 'none';
            projectGridEmpty.style.display = 'none';
            const url = window.getApiUrl ? window.getApiUrl('/api/projects') : '/api/projects';
            const res = await fetch(url);
            if (!res.ok) throw new Error('Error al cargar proyectos');
            const data = await res.json();
            allProjects = data;
            renderProjects(data);
        } catch (e) {
            projectGridLoading.style.display = 'none';
            projectTable.style.display = 'none';
            projectGridEmpty.style.display = 'block';
            projectGridEmpty.innerHTML = '<div style="color:#e53e3e">Error al cargar proyectos</div>';
        }
    }

    function renderProjects(projects) {
        projectTableBody.innerHTML = '';
        if (!projects || projects.length === 0) {
            projectGridLoading.style.display = 'none';
            projectTable.style.display = 'none';
            projectGridEmpty.style.display = 'block';
            return;
        }
        projectGridLoading.style.display = 'none';
        projectGridEmpty.style.display = 'none';
        projectTable.style.display = 'table';
        projects.forEach(proj => {
            const tr = document.createElement('tr');
            tr.innerHTML = `
                <td>${proj.id}</td>
                <td>${proj.name || ''}</td>
                <td>${(proj.description || '').substring(0, 50)}${(proj.description || '').length > 50 ? '...' : ''}</td>
                <td>${proj.start_date ? proj.start_date.split('T')[0] : ''}</td>
                <td>${proj.end_date ? proj.end_date.split('T')[0] : ''}</td>
                <td><span style="background:${proj.status === 'Completado' ? '#10b981' : proj.status === 'En Progreso' ? '#3b82f6' : proj.status === 'Planificación' ? '#f59e0b' : '#6b7280'};color:white;padding:4px 8px;border-radius:4px;font-size:12px">${proj.status || ''}</span></td>
                <td>
                    <button class="btn-action-edit" data-id="${proj.id}">✏️</button>
                    <button class="btn-action-delete" data-id="${proj.id}" style="margin-left:4px">🗑️</button>
                </td>
            `;
            projectTableBody.appendChild(tr);
        });
    }

    projectTableBody?.addEventListener('click', async (e) => {
        const editBtn = e.target.closest('.btn-action-edit');
        const delBtn = e.target.closest('.btn-action-delete');
        if (editBtn) {
            const id = editBtn.dataset.id;
            const proj = allProjects.find(p => String(p.id) === String(id));
            if (!proj) {
                Swal.fire({
                    icon: 'error',
                    title: 'Proyecto no encontrado',
                    text: 'No se encontró el proyecto seleccionado'
                });
                return;
            }
            openProjectModal(true, proj);
        }
        if (delBtn) {
            const id = delBtn.dataset.id;
            const result = await Swal.fire({
                title: '¿Eliminar proyecto?',
                text: 'Esta acción no se puede deshacer. Se eliminarán todas las asignaciones relacionadas.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            });
            if (!result.isConfirmed) return;
            try {
                const response = await fetch((window.getApiUrl ? window.getApiUrl(`/api/projects/${id}`) : `/api/projects/${id}`), {
                    method: 'DELETE'
                });
                if (!response.ok) throw new Error('Error al eliminar proyecto');
                Swal.fire({
                    icon: 'success',
                    title: 'Proyecto eliminado',
                    timer: 2000,
                    showConfirmButton: false
                });
                fetchProjects();
            } catch (err) {
                Swal.fire({
                    icon: 'error',
                    title: 'Error al eliminar proyecto',
                    text: err.message || err
                });
            }
        }
    });

    function filterProjects() {
        const status = (document.getElementById('filter-project-status')?.value || '').trim();
        let filtered = allProjects;
        if (status) filtered = filtered.filter(p => p.status === status);
        renderProjects(filtered);
    }

    document.getElementById('filter-project-status')?.addEventListener('change', filterProjects);
    document.getElementById('filter-project-search-btn')?.addEventListener('click', filterProjects);
    document.getElementById('filter-project-clear-btn')?.addEventListener('click', () => {
        document.getElementById('filter-project-status').value = '';
        renderProjects(allProjects);
    });

    // Modal de proyectos
    const projectModal = document.getElementById('project-modal');
    const projectForm = document.getElementById('project-form');
    const projectModalClose = document.getElementById('project-modal-close');
    const projectCancel = document.getElementById('project-cancel');

    async function openProjectModal(isEdit = false, project = null) {
        document.getElementById('project-modal-title').textContent = isEdit ? 'Editar Proyecto' : 'Nuevo Proyecto';
        
        // Cargar responsables disponibles
        await loadProjectManagers();

        if (!isEdit) {
            projectForm.reset();
            document.getElementById('project-id').value = '';
        } else if (project) {
            console.log('📝 Loading project data for edit:', project);
            document.getElementById('project-id').value = project.id || '';
            document.getElementById('project-name').value = project.name || '';
            document.getElementById('project-description').value = project.description || '';
            
            const formatDate = (dateStr) => {
                if (!dateStr) return '';
                if (dateStr instanceof Date) {
                    return dateStr.toISOString().split('T')[0];
                }
                if (typeof dateStr === 'string') {
                    return dateStr.split('T')[0];
                }
                return '';
            };
            
            document.getElementById('project-start-date').value = formatDate(project.start_date);
            document.getElementById('project-end-date').value = formatDate(project.end_date);
            document.getElementById('project-status').value = project.status || 'Planificación';
            document.getElementById('project-manager').value = project.manager_id || '';
            console.log('✅ Project data loaded');
        }

        projectModal.style.display = 'flex';
    }

    async function closeProjectModal(skipConfirmation = false) {
        if (!skipConfirmation) {
            const result = await Swal.fire({
                title: '¿Cancelar proyecto?',
                text: 'Los cambios no guardados se perderán',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, cancelar',
                cancelButtonText: 'Continuar editando',
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6'
            });
            if (!result.isConfirmed) return;
        }
        projectModal.style.display = 'none';
        projectForm.reset();
    }

    async function loadProjectManagers() {
        const select = document.getElementById('project-manager');
        const employees = await (window.fetchEmployees ? window.fetchEmployees() : []);
        select.innerHTML = '<option value="">Seleccionar responsable...</option>';
        employees.forEach(emp => {
            const opt = document.createElement('option');
            opt.value = emp.id;
            opt.textContent = `${emp.first_name || ''} ${emp.last_name || ''}`.trim();
            select.appendChild(opt);
        });
    }

    addProjectBtn?.addEventListener('click', () => openProjectModal(false));
    projectModalClose?.addEventListener('click', async () => await closeProjectModal());
    projectCancel?.addEventListener('click', async () => await closeProjectModal());
    projectModal?.addEventListener('click', async (e) => {
        if (e.target === projectModal) await closeProjectModal();
    });

    projectForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        console.log('🔔 Submit event fired for project form');
        const projectId = document.getElementById('project-id').value;
        const name = document.getElementById('project-name').value;
        const description = document.getElementById('project-description').value;
        const startDate = document.getElementById('project-start-date').value;
        const endDate = document.getElementById('project-end-date').value;
        const status = document.getElementById('project-status').value;
        const managerId = document.getElementById('project-manager').value;

        console.log('📝 Project form data:', { projectId, name, startDate, endDate, status });

        if (!name || !startDate || !endDate) {
            Swal.fire({
                icon: 'warning',
                title: 'Campos requeridos',
                text: 'Los campos nombre, fecha inicio y fecha fin son obligatorios'
            });
            return;
        }

        try {
            const payload = {
                name,
                description,
                start_date: startDate,
                end_date: endDate,
                status,
                manager_id: managerId ? parseInt(managerId) : null
            };

            const url = projectId 
                ? (window.getApiUrl ? window.getApiUrl(`/api/projects/${projectId}`) : `/api/projects/${projectId}`)
                : (window.getApiUrl ? window.getApiUrl('/api/projects') : '/api/projects');
            
            const method = projectId ? 'PUT' : 'POST';
            
            const response = await fetch(url, {
                method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            if (!response.ok) throw new Error(`HTTP ${response.status}`);
            
            const result = await response.json();
            console.log('✅ Success response:', result);
            
            if (projectId) {
                Swal.fire({
                    icon: 'success',
                    title: 'Proyecto actualizado',
                    text: 'Los datos del proyecto se actualizaron correctamente',
                    timer: 2000,
                    showConfirmButton: false
                });
            } else {
                Swal.fire({
                    icon: 'success',
                    title: 'Proyecto creado',
                    text: 'El proyecto se creó correctamente',
                    timer: 2000,
                    showConfirmButton: false
                });
            }
            
            closeProjectModal(true); // true = skip confirmation
            fetchProjects();
        } catch (err) {
            console.error('❌ Error:', err);
            Swal.fire({
                icon: 'error',
                title: 'Error al guardar proyecto',
                text: err.message
            });
        }
    });

    // Additional protection: Prevent modal closing when clicking on form elements
    document.addEventListener('click', (e) => {
        // Check if the click is on a form element inside any modal
        const isInsideModal = e.target.closest('.modal-content');
        const isFormElement = e.target.matches('input, textarea, select, label, button[type="submit"], button[type="button"]:not(.modal-close)');
        
        if (isInsideModal && isFormElement) {
            e.stopPropagation();
        }
    }, true); // Use capture phase
});