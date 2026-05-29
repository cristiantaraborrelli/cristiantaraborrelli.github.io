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

  // === Stage Spotlight: cursor as theatrical light on hero ===
  // CSS reads --spot-x / --spot-y from .proj-hero; we update those on mousemove.
  const hero = document.querySelector('.proj-hero');
  if (hero && window.matchMedia('(hover: hover)').matches &&
      !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    let raf = null;
    hero.addEventListener('mousemove', (e) => {
      if (raf) return;
      raf = requestAnimationFrame(() => {
        const r = hero.getBoundingClientRect();
        const x = ((e.clientX - r.left) / r.width) * 100;
        const y = ((e.clientY - r.top) / r.height) * 100;
        hero.style.setProperty('--spot-x', x + '%');
        hero.style.setProperty('--spot-y', y + '%');
        raf = null;
      });
    });
  }

  // === Sticky side TOC: "il libretto della pagina" ===
  // Mounted only on production pages with >= 5 .proj-sec sections.
  // Reads each section's .s-label as the entry title; smooth-scrolls; highlights active via IntersectionObserver.
  const tocSections = document.querySelectorAll('.proj-sec');
  if (tocSections.length >= 5 && window.matchMedia('(min-width: 1281px)').matches) {
    const labels = [];
    tocSections.forEach((sec, i) => {
      const lab = sec.querySelector('.s-label');
      if (!lab) return;
      // Assign id if missing — used by anchor links and observer
      if (!sec.id) sec.id = 'sec-' + (i + 1);
      labels.push({ id: sec.id, text: (lab.textContent || '').trim(), el: sec });
    });
    if (labels.length >= 5) {
      const toc = document.createElement('aside');
      toc.className = 'toc-side';
      toc.setAttribute('aria-label', 'Indice della pagina');
      toc.innerHTML = '<p class="toc-side-title">Index</p><ol></ol>';
      const ol = toc.querySelector('ol');
      labels.forEach(l => {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.href = '#' + l.id;
        // Title text: cut at first em-dash for compactness ("Note di Regia — Cristian..." -> "Note di Regia")
        const title = l.text.split(/\s+[—–-]\s+/)[0];
        a.textContent = title.length > 40 ? title.slice(0, 38) + '…' : title;
        a.dataset.target = l.id;
        a.addEventListener('click', (e) => {
          e.preventDefault();
          const t = document.getElementById(l.id);
          if (t) t.scrollIntoView({ behavior: 'smooth', block: 'start' });
        });
        li.appendChild(a);
        ol.appendChild(li);
      });
      document.body.appendChild(toc);

      // Show TOC after scrolling past hero (same trigger as frame counter)
      const showTrigger = window.innerHeight * 0.55;
      let tocVisible = false;
      const updateTocVis = () => {
        if (window.scrollY > showTrigger && !tocVisible) { toc.classList.add('show'); tocVisible = true; }
        else if (window.scrollY <= showTrigger * 0.7 && tocVisible) { toc.classList.remove('show'); tocVisible = false; }
      };
      window.addEventListener('scroll', updateTocVis, { passive: true });
      updateTocVis();

      // Highlight active section
      const tocLinks = toc.querySelectorAll('a');
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            tocLinks.forEach(a => a.classList.toggle('active', a.dataset.target === entry.target.id));
          }
        });
      }, { rootMargin: '-30% 0px -60% 0px', threshold: 0 });
      labels.forEach(l => observer.observe(l.el));
    }
  }

  // === Frame Counter: cinematic scroll-position indicator ===
  // Only on production/long pages: any page with >= 5 .proj-sec sections.
  const sections = document.querySelectorAll('.proj-sec');
  if (sections.length >= 5) {
    const counter = document.createElement('div');
    counter.className = 'frame-counter';
    counter.setAttribute('aria-hidden', 'true');
    counter.innerHTML =
      '<span class="frame-label">Frame</span>' +
      '<span class="frame-current">01</span>' +
      '<span class="frame-divider">/</span>' +
      '<span class="frame-total">' + String(sections.length).padStart(2, '0') + '</span>';
    document.body.appendChild(counter);

    const currentEl = counter.querySelector('.frame-current');
    let visible = false;
    let lastFrame = -1;

    const updateCounter = () => {
      const scrollY = window.scrollY;
      const winH = window.innerHeight;
      // Hide near the very top (hero is its own frame) — show from after first 60vh of scroll.
      if (scrollY > winH * 0.6 && !visible) {
        counter.classList.add('show');
        visible = true;
      } else if (scrollY <= winH * 0.4 && visible) {
        counter.classList.remove('show');
        visible = false;
      }
      // Find which section is most visible (closest to viewport centre).
      const centre = scrollY + winH / 2;
      let bestIdx = 0;
      let bestDist = Infinity;
      sections.forEach((sec, i) => {
        const top = sec.offsetTop;
        const mid = top + sec.offsetHeight / 2;
        const d = Math.abs(mid - centre);
        if (d < bestDist) { bestDist = d; bestIdx = i; }
      });
      const frameNum = bestIdx + 1;
      if (frameNum !== lastFrame) {
        currentEl.textContent = String(frameNum).padStart(2, '0');
        lastFrame = frameNum;
      }
    };

    let scrollRaf = null;
    window.addEventListener('scroll', () => {
      if (scrollRaf) return;
      scrollRaf = requestAnimationFrame(() => {
        updateCounter();
        scrollRaf = null;
      });
    }, { passive: true });
    updateCounter();
  }

});
