/**
 * UPPERCASE HANDLER
 * ====================
 * Convierte automáticamente a mayúsculas el contenido de inputs y textareas
 * NO SOLO VISUALMENTE, sino también los DATOS GUARDADOS
 * 
 * USO:
 * Incluir en index.html DESPUÉS de los otros scripts:
 * <script src="js/uppercase-handler.js"></script>
 */

(function() {
  'use strict';

  // Función para convertir valor a mayúsculas
  function convertToUppercase(element) {
    const start = element.selectionStart;
    const end = element.selectionEnd;
    element.value = element.value.toUpperCase();
    // Mantener la posición del cursor
    element.setSelectionRange(start, end);
  }

  // Función para convertir emails a minúsculas
  function convertToLowercase(element) {
    const start = element.selectionStart;
    const end = element.selectionEnd;
    element.value = element.value.toLowerCase();
    // Mantener la posición del cursor
    element.setSelectionRange(start, end);
  }

  // Aplicar conversión a mayúsculas cuando el usuario escribe
  function initializeUppercaseInputs() {
    // Seleccionar todos los inputs de texto y textareas (EXCEPTO emails)
    const textInputs = document.querySelectorAll(
      'input[type="text"], input[type="tel"], textarea'
    );

    textInputs.forEach(input => {
      // Evento 'input' se dispara cuando el usuario escribe
      input.addEventListener('input', function() {
        convertToUppercase(this);
      });

      // También convertir el valor inicial si existe
      if (input.value) {
        input.value = input.value.toUpperCase();
      }
    });

    // Seleccionar inputs de email para convertir a minúsculas
    const emailInputs = document.querySelectorAll('input[type="email"]');

    emailInputs.forEach(input => {
      input.addEventListener('input', function() {
        convertToLowercase(this);
      });

      // También convertir el valor inicial si existe
      if (input.value) {
        input.value = input.value.toLowerCase();
      }
    });
  }

  // Observar cambios en el DOM para inputs dinámicos
  function observeDynamicInputs() {
    const observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        mutation.addedNodes.forEach(function(node) {
          if (node.nodeType === 1) { // Es un elemento
            // Si el nodo añadido es un input o textarea (MAYÚSCULAS)
            if (node.matches && node.matches('input[type="text"], input[type="tel"], textarea')) {
              node.addEventListener('input', function() {
                convertToUppercase(this);
              });
            }
            
            // Si el nodo añadido es un input email (MINÚSCULAS)
            if (node.matches && node.matches('input[type="email"]')) {
              node.addEventListener('input', function() {
                convertToLowercase(this);
              });
            }
            
            // Buscar inputs dentro del nodo añadido (MAYÚSCULAS)
            const inputs = node.querySelectorAll && node.querySelectorAll(
              'input[type="text"], input[type="tel"], textarea'
            );
            if (inputs) {
              inputs.forEach(input => {
                input.addEventListener('input', function() {
                  convertToUppercase(this);
                });
              });
            }

            // Buscar inputs email dentro del nodo añadido (MINÚSCULAS)
            const emailInputs = node.querySelectorAll && node.querySelectorAll('input[type="email"]');
            if (emailInputs) {
              emailInputs.forEach(input => {
                input.addEventListener('input', function() {
                  convertToLowercase(this);
                });
              });
            }
          }
        });
      });
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true
    });
  }

  // Inicializar cuando el DOM esté listo
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      initializeUppercaseInputs();
      observeDynamicInputs();
    });
  } else {
    // DOM ya está cargado
    initializeUppercaseInputs();
    observeDynamicInputs();
  }

  // Reinicializar cuando se muestren modales de SweetAlert2
  if (window.Swal) {
    const originalFire = Swal.fire;
    Swal.fire = function() {
      const result = originalFire.apply(this, arguments);
      // Esperar a que el modal se renderice
      setTimeout(() => {
        initializeUppercaseInputs();
      }, 100);
      return result;
    };
  }

  console.log('✅ Uppercase Handler inicializado - Los datos se guardarán en MAYÚSCULAS (excepto emails en minúsculas)');
})();
