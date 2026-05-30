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

  // === Reading Progress Bar + Estimated Reading Time ===
  if (sections.length === undefined) var sections = document.querySelectorAll('.proj-sec');
  if (document.querySelectorAll('.proj-sec').length >= 3) {
    const pageText = (document.querySelector('.proj-body') || document.body).innerText || '';
    const words = pageText.trim().split(/\s+/).length;
    const wpm = 220;
    const minutes = Math.max(1, Math.round(words / wpm));

    // Progress bar
    const bar = document.createElement('div');
    bar.className = 'reading-progress';
    bar.innerHTML = '<div class="reading-progress-bar"></div>';
    document.body.appendChild(bar);
    const barFill = bar.querySelector('.reading-progress-bar');

    // Reading time pill (bottom-left)
    const rt = document.createElement('div');
    rt.className = 'reading-time';
    rt.innerHTML = '<span class="read-label">Read</span><span class="read-min">' + minutes + ' min</span>';
    document.body.appendChild(rt);

    let rtVisible = false;
    let rafScroll = null;
    const updateRead = () => {
      const docH = document.documentElement.scrollHeight - window.innerHeight;
      const pct = docH > 0 ? Math.min(100, (window.scrollY / docH) * 100) : 0;
      barFill.style.width = pct + '%';
      const winH = window.innerHeight;
      if (window.scrollY > winH * 0.5 && !rtVisible) { rt.classList.add('show'); rtVisible = true; }
      else if (window.scrollY <= winH * 0.3 && rtVisible) { rt.classList.remove('show'); rtVisible = false; }
    };
    window.addEventListener('scroll', () => {
      if (rafScroll) return;
      rafScroll = requestAnimationFrame(() => { updateRead(); rafScroll = null; });
    }, { passive: true });
    updateRead();
  }

  // === Lazy-load YouTube embed: thumbnail + click-to-play ===
  document.querySelectorAll('iframe[src*="youtube-nocookie.com/embed/"], iframe[src*="youtube.com/embed/"]').forEach(iframe => {
    const src = iframe.getAttribute('src') || '';
    const m = src.match(/\/embed\/([a-zA-Z0-9_\-]+)/);
    if (!m) return;
    const videoId = m[1];
    const title = iframe.getAttribute('title') || 'Video';
    const wrap = document.createElement('div');
    wrap.className = 'yt-lite';
    wrap.setAttribute('role', 'button');
    wrap.setAttribute('aria-label', 'Play: ' + title);
    wrap.tabIndex = 0;
    wrap.innerHTML = '<img src="https://i.ytimg.com/vi/' + videoId + '/hqdefault.jpg" alt="' + title.replace(/"/g, '&quot;') + '" loading="lazy">';
    iframe.parentNode.replaceChild(wrap, iframe);
    const activate = () => {
      const real = document.createElement('iframe');
      real.src = src.includes('autoplay=') ? src : (src + (src.includes('?') ? '&' : '?') + 'autoplay=1');
      real.title = title;
      real.setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture');
      real.allowFullscreen = true;
      wrap.appendChild(real);
    };
    wrap.addEventListener('click', activate, { once: true });
    wrap.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); activate(); } }, { once: true });
  });

  // === Atmospheric audio toggle (opt-in via data-atmo-audio on .proj-hero) ===
  const hero2 = document.querySelector('.proj-hero[data-atmo-audio]');
  if (hero2) {
    const audioUrl = hero2.dataset.atmoAudio;
    const audio = new Audio(audioUrl);
    audio.loop = true;
    audio.volume = 0.45;
    const btn = document.createElement('button');
    btn.className = 'audio-toggle';
    btn.setAttribute('aria-label', 'Toggle ambient audio');
    btn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><path d="M15.54 8.46a5 5 0 0 1 0 7.07"></path><path d="M19.07 4.93a10 10 0 0 1 0 14.14"></path></svg><span class="playing-pulse"></span>';
    document.body.appendChild(btn);
    setTimeout(() => btn.classList.add('show'), 800);
    btn.addEventListener('click', () => {
      if (audio.paused) { audio.play().then(() => btn.classList.add('playing')).catch(() => {}); }
      else { audio.pause(); btn.classList.remove('playing'); }
    });
  }

  // === Cinema-mode hero video (opt-in via data-cinema-hero on .proj-hero) ===
  const cinemaHero = document.querySelector('.proj-hero[data-cinema-hero]');
  if (cinemaHero && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    const videoUrl = cinemaHero.dataset.cinemaHero;
    const video = document.createElement('video');
    video.className = 'cinema-hero';
    video.src = videoUrl;
    video.muted = true;
    video.loop = true;
    video.playsInline = true;
    video.preload = 'metadata';
    const img = cinemaHero.querySelector('img');
    if (img) cinemaHero.insertBefore(video, img.nextSibling);
    else cinemaHero.appendChild(video);
    video.addEventListener('canplay', () => {
      video.play().then(() => video.classList.add('playing')).catch(() => {});
    });
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
