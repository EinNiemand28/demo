export function showToast(options = {}) {
  const {
    message,
    type = 'success',
    delay = 2000,
    redirect = null,
    errors = null,
  } = options;

  const toast = document.getElementById('toast');
  toast.className = `toast align-items-center text-white bg-${type} border-0`;

  if (errors) {
    toast.querySelector('.toast-body').innerHTML = `
      <h6 class="mb-0">${message}</h6>
      <ul class="mb-0 small">
        ${errors.map(error => `<li>${error}</li>`).join('')}
      </ul>
    `;
  } else {
    toast.querySelector('.toast-body').textContent = message;
  }

  const bsToast = new bootstrap.Toast(toast, {
    animation: true,
    autohide: true,
    delay: delay
  });
  bsToast.show();

  if (redirect) {
    setTimeout(() => {
      window.location.href = redirect;
    }, delay);
  }
}