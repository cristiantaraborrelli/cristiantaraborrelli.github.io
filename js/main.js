// CRISTIANTARABORRELLISTUDIO — main.js

document.addEventListener('DOMContentLoaded', () => {

  // Scroll reveal
  const observer = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible'); });
  }, { threshold: 0.07 });
  document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

  // Mobile nav
  const toggle = document.querySelector('.nav-toggle');
  const menu   = document.querySelector('.nav-links');
  if (toggle && menu) {
    toggle.addEventListener('click', () => {
      menu.classList.toggle('open');
      document.body.style.overflow = menu.classList.contains('open') ? 'hidden' : '';
    });
  }

  // Mobile: toggle dropdowns on click (instead of hover)
  document.querySelectorAll('.nav-item > a').forEach(a => {
    a.addEventListener('click', (e) => {
      if (window.innerWidth <= 640) {
        e.preventDefault();
        const li = a.parentElement;
        // Close other open items
        document.querySelectorAll('.nav-item.open').forEach(item => {
          if (item !== li) item.classList.remove('open');
        });
        li.classList.toggle('open');
      }
    });
  });

  // Close mobile menu on link click (only actual page links)
  document.querySelectorAll('.nav-dropdown a, .nav-links > li:not(.nav-item) > a').forEach(a => {
    a.addEventListener('click', () => {
      if (menu) menu.classList.remove('open');
      document.querySelectorAll('.nav-item.open').forEach(item => item.classList.remove('open'));
      document.body.style.overflow = '';
    });
  });

});
