// CRISTIANTARABORRELLISTUDIO — lang.js
// Trilingual switcher IT | EN | FR

(function () {
  'use strict';

  const SUPPORTED = ['en', 'it', 'fr'];
  const DEFAULT   = 'en';
  const STORAGE_KEY = 'cts-lang';

  // Detect initial language: saved > browser > default
  function detectLang() {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved && SUPPORTED.includes(saved)) return saved;
    const nav = (navigator.language || '').slice(0, 2).toLowerCase();
    if (SUPPORTED.includes(nav)) return nav;
    return DEFAULT;
  }

  // Apply language to all [data-i18n] elements
  function applyLang(lang) {
    document.documentElement.lang = lang;
    localStorage.setItem(STORAGE_KEY, lang);

    // Update text content
    document.querySelectorAll('[data-i18n]').forEach(el => {
      const key = el.getAttribute('data-i18n');
      const text = el.getAttribute('data-' + lang);
      if (text) {
        // Support HTML content (for <br>, <em>, etc.)
        if (text.includes('<')) {
          el.innerHTML = text;
        } else {
          el.textContent = text;
        }
      }
    });

    // Update switcher buttons
    document.querySelectorAll('.lang-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.lang === lang);
    });

    // Show/hide language-specific blocks
    SUPPORTED.forEach(l => {
      document.querySelectorAll('[data-lang-block="' + l + '"]').forEach(el => {
        el.style.display = (l === lang) ? '' : 'none';
      });
    });
  }

  // Create switcher UI
  function createSwitcher() {
    const switcher = document.createElement('div');
    switcher.className = 'lang-switcher';
    switcher.innerHTML = SUPPORTED.map(l =>
      '<button class="lang-btn" data-lang="' + l + '">' + l.toUpperCase() + '</button>'
    ).join('<span class="lang-sep">|</span>');

    // Insert into nav, before the toggle button
    const nav = document.querySelector('.nav');
    const toggle = document.querySelector('.nav-toggle');
    if (nav && toggle) {
      nav.insertBefore(switcher, toggle);
    } else if (nav) {
      nav.appendChild(switcher);
    }

    // Event listeners
    switcher.querySelectorAll('.lang-btn').forEach(btn => {
      btn.addEventListener('click', () => applyLang(btn.dataset.lang));
    });
  }

  // Initialize
  document.addEventListener('DOMContentLoaded', () => {
    createSwitcher();
    applyLang(detectLang());
  });

})();
