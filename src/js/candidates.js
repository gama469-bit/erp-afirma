function renderCandidates(candidates) {
    const candidateList = document.getElementById('candidate-list');
    candidateList.innerHTML = '';

    if (candidates.length === 0) {
        candidateList.innerHTML = '<li style="text-align:center;color:#72809a;padding:20px">Sin candidatos</li>';
        return;
    }

    candidates.forEach(candidate => {
        const fullName = ((candidate.first_name || '') + (candidate.last_name ? ' ' + candidate.last_name : '')).trim();
        const statusColor = {
            'En revisión': '#0066ff',
            'Entrevista': '#ff9900',
            'Oferta': '#28a745',
            'Rechazado': '#dc3545',
            'Contratado': '#20c997'
        }[candidate.status] || '#72809a';
        
        const li = document.createElement('li');
        li.innerHTML = `
            <div style="flex:1">
                <strong>${escapeHtml(fullName)}</strong>
                <div style="font-size:13px;color:#72809a">
                    ${escapeHtml(candidate.position_applied || '')} • ${escapeHtml(candidate.email || '')}
                    ${candidate.phone ? `• ${escapeHtml(candidate.phone)}` : ''}
                </div>
                <div style="margin-top:4px">
                    <span style="background:${statusColor}20;color:${statusColor};padding:2px 8px;border-radius:4px;font-size:12px;font-weight:600">${escapeHtml(candidate.status)}</span>
                </div>
            </div>
            <div>
                <button class="edit-candidate" data-id="${candidate.id}" style="margin-right:6px">Editar</button>
                <button class="delete-candidate" data-id="${candidate.id}">Eliminar</button>
            </div>
        `;
        candidateList.appendChild(li);
    });
}

function clearCandidateForm() {
    document.getElementById('candidate-id').value = '';
    document.getElementById('candidate-first').value = '';
    document.getElementById('candidate-last').value = '';
    document.getElementById('candidate-email').value = '';
    document.getElementById('candidate-phone').value = '';
    document.getElementById('candidate-position').value = '';
    document.getElementById('candidate-status').value = 'En revisión';
    document.getElementById('candidate-notes').value = '';
    document.getElementById('candidate-submit').textContent = 'Guardar';
}

function populateCandidateForm(candidate){
    document.getElementById('candidate-id').value = candidate.id || '';
    document.getElementById('candidate-first').value = candidate.first_name || '';
    document.getElementById('candidate-last').value = candidate.last_name || '';
    document.getElementById('candidate-email').value = candidate.email || '';
    document.getElementById('candidate-phone').value = candidate.phone || '';
    document.getElementById('candidate-position').value = candidate.position_applied || '';
    document.getElementById('candidate-status').value = candidate.status || 'En revisión';
    document.getElementById('candidate-notes').value = candidate.notes || '';
    document.getElementById('candidate-submit').textContent = 'Guardar cambios';
}

function escapeHtml(unsafe){
    return String(unsafe||'').replace(/[&<>"']/g, function(m){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;"}[m];});
}

window.renderCandidates = renderCandidates;
window.clearCandidateForm = clearCandidateForm;
window.populateCandidateForm = populateCandidateForm;
