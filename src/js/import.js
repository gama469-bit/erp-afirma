// Import Excel files handler

// ============ EMPLOYEES IMPORT ============

const importEmployeesBtn = document.getElementById('import-employees-btn');
const importEmployeesArea = document.getElementById('import-employees-area');
const excelFileInput = document.getElementById('excel-file-input');
const importClickArea = document.getElementById('import-click-area');
const cancelImportBtn = document.getElementById('cancel-import-btn');

// Show import area when clicking the button
importEmployeesBtn.addEventListener('click', () => {
  importEmployeesArea.style.display = 'block';
  importEmployeesBtn.style.display = 'none';
});

// Cancel import
cancelImportBtn.addEventListener('click', () => {
  importEmployeesArea.style.display = 'none';
  importEmployeesBtn.style.display = 'block';
  excelFileInput.value = '';
});

// Click to browse files
importClickArea.addEventListener('click', () => {
  excelFileInput.click();
});

// Drag and drop
importClickArea.addEventListener('dragover', (e) => {
  e.preventDefault();
  importClickArea.style.background = '#e0ecff';
});

importClickArea.addEventListener('dragleave', () => {
  importClickArea.style.background = '';
});

importClickArea.addEventListener('drop', (e) => {
  e.preventDefault();
  importClickArea.style.background = '';
  const files = e.dataTransfer.files;
  if (files.length > 0) {
    excelFileInput.files = files;
    handleEmployeeFileUpload();
  }
});

// Handle file selection
excelFileInput.addEventListener('change', handleEmployeeFileUpload);

async function handleEmployeeFileUpload() {
  const file = excelFileInput.files[0];
  if (!file) return;

  const formData = new FormData();
  formData.append('file', file);

  try {
    const response = await fetch('http://localhost:3000/api/upload-employees', {
      method: 'POST',
      body: formData
    });

    const result = await response.json();

    if (!response.ok) {
      alert(`Error: ${result.error}`);
      return;
    }

    // Show results
    let message = `✅ Se importaron ${result.imported} empleados de ${result.total}`;
    if (result.errors && result.errors.length > 0) {
      const errorDetails = result.errors.map(e => `Fila ${e.row}: ${e.error}`).join('\n');
      message += `\n\n⚠️ Errores:\n${errorDetails}`;
    }
    alert(message);

    // Refresh list and close import area
    importEmployeesArea.style.display = 'none';
    importEmployeesBtn.style.display = 'block';
    excelFileInput.value = '';
    await window.fetchEmployees();
    renderEmployees();

  } catch (err) {
    alert('Error uploading file: ' + err.message);
  }
}

// ============ CANDIDATES IMPORT ============

const importCandidatesBtn = document.getElementById('import-candidates-btn');
const importCandidatesArea = document.getElementById('import-candidates-area');
const excelFileCandidatesInput = document.getElementById('excel-file-candidates-input');
const importCandidatesClickArea = document.getElementById('import-candidates-click-area');
const cancelImportCandidatesBtn = document.getElementById('cancel-import-candidates-btn');

// Show import area when clicking the button
importCandidatesBtn.addEventListener('click', () => {
  importCandidatesArea.style.display = 'block';
  importCandidatesBtn.style.display = 'none';
});

// Cancel import
cancelImportCandidatesBtn.addEventListener('click', () => {
  importCandidatesArea.style.display = 'none';
  importCandidatesBtn.style.display = 'block';
  excelFileCandidatesInput.value = '';
});

// Click to browse files
importCandidatesClickArea.addEventListener('click', () => {
  excelFileCandidatesInput.click();
});

// Drag and drop
importCandidatesClickArea.addEventListener('dragover', (e) => {
  e.preventDefault();
  importCandidatesClickArea.style.background = '#e0ecff';
});

importCandidatesClickArea.addEventListener('dragleave', () => {
  importCandidatesClickArea.style.background = '';
});

importCandidatesClickArea.addEventListener('drop', (e) => {
  e.preventDefault();
  importCandidatesClickArea.style.background = '';
  const files = e.dataTransfer.files;
  if (files.length > 0) {
    excelFileCandidatesInput.files = files;
    handleCandidateFileUpload();
  }
});

// Handle file selection
excelFileCandidatesInput.addEventListener('change', handleCandidateFileUpload);

async function handleCandidateFileUpload() {
  const file = excelFileCandidatesInput.files[0];
  if (!file) return;

  const formData = new FormData();
  formData.append('file', file);

  try {
    const response = await fetch('http://localhost:3000/api/upload-candidates', {
      method: 'POST',
      body: formData
    });

    const result = await response.json();

    if (!response.ok) {
      alert(`Error: ${result.error}`);
      return;
    }

    // Show results
    let message = `✅ Se importaron ${result.imported} candidatos de ${result.total}`;
    if (result.errors && result.errors.length > 0) {
      const errorDetails = result.errors.map(e => `Fila ${e.row}: ${e.error}`).join('\n');
      message += `\n\n⚠️ Errores:\n${errorDetails}`;
    }
    alert(message);

    // Refresh list and close import area
    importCandidatesArea.style.display = 'none';
    importCandidatesBtn.style.display = 'block';
    excelFileCandidatesInput.value = '';
    await window.fetchCandidates();
    renderCandidates();

  } catch (err) {
    alert('Error uploading file: ' + err.message);
  }
}
