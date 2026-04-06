<!-- Authentication (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Ideole — Sign In</title>
<!-- Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<!-- Material Symbols -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<!-- Tailwind CSS -->
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "surface": "#faf5ee",
              "background": "#faf5ee",
              "surface-container-lowest": "#ffffff",
              "secondary-fixed-dim": "#cec6be",
              "inverse-on-surface": "#faf5ee",
              "tertiary-fixed": "#fce0e0",
              "on-surface-variant": "#605850",
              "primary-container": "#e08850",
              "on-secondary-fixed": "#2a2420",
              "tertiary-fixed-dim": "#e8a0a0",
              "on-tertiary-fixed-variant": "#6e3030",
              "surface-container": "#f2ece4",
              "surface-bright": "#faf5ee",
              "primary-fixed-dim": "#f0a878",
              "on-tertiary-container": "#3a2020",
              "primary-fixed": "#fbe8d8",
              "on-secondary-fixed-variant": "#504840",
              "on-primary-fixed-variant": "#8a4518",
              "error": "#c0392b",
              "on-tertiary": "#ffffff",
              "inverse-surface": "#3a302a",
              "surface-container-low": "#f6f0e8",
              "on-background": "#3a302a",
              "secondary": "#78706a",
              "on-error": "#ffffff",
              "tertiary": "#8c3c3c",
              "outline": "#9a9088",
              "surface-tint": "#c2652a",
              "on-primary": "#ffffff",
              "secondary-container": "#eae2da",
              "on-primary-fixed": "#401a08",
              "on-primary-container": "#fbe8d8",
              "on-tertiary-fixed": "#2e1515",
              "primary": "#c2652a",
              "outline-variant": "#d8d0c8",
              "surface-container-high": "#ece6dc",
              "on-surface": "#3a302a",
              "inverse-primary": "#f0a878",
              "secondary-fixed": "#eae2da",
              "surface-variant": "#ece6dc",
              "surface-container-highest": "#e6e0d6",
              "on-secondary-container": "#605850",
              "surface-dim": "#dcd6cc",
              "error-container": "#fce4e0",
              "on-secondary": "#ffffff",
              "tertiary-container": "#d47070",
              "on-error-container": "#7a1a10"
            },
            fontFamily: {
              "headline": ["Eb Garamond", "serif"],
              "body": ["Manrope", "sans-serif"],
              "label": ["Manrope", "sans-serif"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
            font-size: 20px;
        }
        body {
            font-family: 'Manrope', sans-serif;
            background-color: #faf5ee;
        }
        .serif-italic {
            font-family: 'Eb Garamond', serif;
            font-style: italic;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-surface text-on-surface min-h-screen flex flex-col">
<!-- Top Navigation Suppression (Transactional Page Rule) -->
<main class="flex-grow flex flex-col md:flex-row items-stretch overflow-hidden">
<!-- Left Side: Visual Anchor -->
<div class="hidden md:flex md:w-1/2 lg:w-3/5 bg-surface-container relative overflow-hidden items-center justify-center p-12">
<div class="absolute inset-0 opacity-40 mix-blend-multiply">
<img class="w-full h-full object-cover" data-alt="Dreamy abstract sunrise over a minimalist architectural structure with soft golden and warm linen tones, elegant atmosphere" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCXbEbHvhFCGR4hB7YTy0iPa100fp62gwDn7jXxZR3c0RdlHnI_Xg8qwwBUG5ngceHhDKkNmgzGLNIttZjx6Xfg9CJ4MLTKhDFVgAGuSvWaFHk4G3y5Q_KED_T2Ke74XzCiyHYSCJ-WbNF3WceQ8W3hQ3ZMKFqtyW8cIyPtSzPxAVe2xZYGrc2cpL50Xe1U5dLxmiN5ZktbOA_sr-dm3h2_9049Egr46vv7wL8nl0JvJXb6gHKyMEZAojrZ4BzIVM7nY8LmxSZ9mCs3"/>
</div>
<div class="relative z-10 max-w-lg text-center">
<h1 class="font-headline italic text-6xl lg:text-8xl text-primary mb-6 tracking-tight">Ideole</h1>
<p class="font-body text-on-surface-variant text-xl lg:text-2xl tracking-wide uppercase font-light">For the Visionaries.</p>
</div>
<!-- Decorative Border -->
<div class="absolute inset-12 border border-outline-variant/30 pointer-events-none"></div>
</div>
<!-- Right Side: Interaction Canvas -->
<div class="flex-grow md:w-1/2 lg:w-2/5 flex flex-col justify-center px-8 py-16 lg:px-24 bg-surface z-20">
<!-- Mobile Header (Visible only on small screens) -->
<div class="md:hidden text-center mb-12">
<h1 class="font-headline italic text-5xl text-primary mb-2">Ideole</h1>
<p class="font-body text-on-surface-variant text-sm tracking-widest uppercase">For the Visionaries.</p>
</div>
<div class="max-w-md mx-auto w-full">
<div class="mb-10">
<h2 class="font-headline text-3xl text-on-surface mb-2">Welcome Back</h2>
<p class="font-body text-on-surface-variant text-sm">Please enter your credentials to access your vision.</p>
</div>
<!-- Form Section -->
<form class="space-y-6">
<div class="space-y-1">
<label class="block text-xs font-bold tracking-widest uppercase text-on-surface-variant ml-1" for="email">Email Address</label>
<input class="w-full px-4 py-3 bg-surface-container-lowest border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary transition-all rounded-none outline-none text-on-surface font-body" id="email" name="email" placeholder="visionary@ideole.com" type="email"/>
</div>
<div class="space-y-1">
<div class="flex justify-between items-center">
<label class="block text-xs font-bold tracking-widest uppercase text-on-surface-variant ml-1" for="password">Password</label>
<a class="text-[10px] font-bold tracking-tighter uppercase text-primary hover:underline transition-all" href="#">Forgot?</a>
</div>
<input class="w-full px-4 py-3 bg-surface-container-lowest border-outline-variant focus:border-primary focus:ring-1 focus:ring-primary transition-all rounded-none outline-none text-on-surface font-body" id="password" name="password" placeholder="••••••••" type="password"/>
</div>
<button class="w-full bg-primary text-on-primary py-4 font-body font-bold tracking-widest uppercase hover:bg-on-primary-fixed-variant transition-colors shadow-sm active:scale-[0.98] duration-150" type="submit">
                        Sign In
                    </button>
</form>
<!-- Divider -->
<div class="relative my-10">
<div aria-hidden="true" class="absolute inset-0 flex items-center">
<div class="w-full border-t border-outline-variant/60"></div>
</div>
<div class="relative flex justify-center text-xs uppercase tracking-widest">
<span class="bg-surface px-4 text-on-surface-variant font-medium">Or continue with</span>
</div>
</div>
<!-- Social Logins -->
<div class="grid grid-cols-2 gap-4 mb-10">
<button class="flex items-center justify-center gap-3 px-4 py-3 border border-outline-variant bg-surface-container-low hover:bg-surface-container-high transition-colors group">
<svg class="w-5 h-5" fill="currentColor" viewbox="0 0 24 24">
<path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path>
<path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path>
<path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"></path>
<path d="M12 5.38c1.62 0 3.06.56 4.21 1.66l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path>
</svg>
<span class="font-body text-xs font-bold tracking-widest uppercase">Google</span>
</button>
<button class="flex items-center justify-center gap-3 px-4 py-3 border border-outline-variant bg-surface-container-low hover:bg-surface-container-high transition-colors group">
<svg class="w-5 h-5" fill="currentColor" viewbox="0 0 24 24">
<path d="M17.05 20.28c-.98.95-2.05 1.72-3.11 1.72-1.04 0-1.4-.64-2.62-.64-1.25 0-1.65.62-2.61.64-1.03.02-2.14-.8-3.15-1.78C3.51 18.2 2 14.94 2 12.18c0-4.38 2.85-6.7 5.62-6.7 1.45 0 2.62.9 3.48.9.83 0 2.25-.97 3.88-.97 1.7 0 4.1.84 5.38 3.03-2.9 1.43-2.43 5.4.52 6.64-.67 1.83-1.85 3.9-3.83 5.3zm-3.66-15.6c-.02 3.1 2.58 5.62 5.61 5.45.1-.12.2-.25.3-.38 2.33-3.1-1.05-6.17-3.68-6.17-.1 0-.19.01-.28.02.01.37.04.73.05 1.08z"></path>
</svg>
<span class="font-body text-xs font-bold tracking-widest uppercase">Apple</span>
</button>
</div>
<!-- Footer Links -->
<div class="text-center space-y-4">
<p class="font-body text-sm text-on-surface-variant">
                        New to the circle? 
                        <a class="text-primary font-bold hover:underline ml-1" href="#">Create Account</a>
</p>
<div class="flex justify-center gap-6 pt-4 border-t border-outline-variant/30">
<a class="text-[10px] text-on-surface-variant uppercase tracking-widest hover:text-primary transition-colors" href="#">Privacy Policy</a>
<a class="text-[10px] text-on-surface-variant uppercase tracking-widest hover:text-primary transition-colors" href="#">Terms of Service</a>
</div>
</div>
</div>
</div>
</main>
<!-- Contextual FAB Suppression (Transactional Rule Applied) -->
<!-- BottomNavBar Suppression (Transactional Rule Applied) -->
</body></html>

<!-- Idea Detail (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Ideole — Idea Detail</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400;0,600;0,700;1,400&amp;family=Manrope:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "primary-fixed-dim": "#f0a878",
              "inverse-on-surface": "#faf5ee",
              "surface-container-lowest": "#ffffff",
              "primary-container": "#e08850",
              "on-tertiary-fixed": "#2e1515",
              "on-tertiary": "#ffffff",
              "primary-fixed": "#fbe8d8",
              "on-secondary-fixed-variant": "#504840",
              "on-surface": "#3a302a",
              "secondary-container": "#eae2da",
              "on-error": "#ffffff",
              "primary": "#c2652a",
              "error-container": "#fce4e0",
              "tertiary": "#8c3c3c",
              "surface-tint": "#c2652a",
              "tertiary-fixed": "#fce0e0",
              "surface-container-high": "#ece6dc",
              "on-secondary-container": "#605850",
              "on-primary-fixed-variant": "#8a4518",
              "on-error-container": "#7a1a10",
              "on-primary-fixed": "#401a08",
              "on-tertiary-fixed-variant": "#6e3030",
              "surface-dim": "#dcd6cc",
              "surface": "#faf5ee",
              "outline": "#9a9088",
              "surface-container": "#f2ece4",
              "on-primary-container": "#fbe8d8",
              "secondary-fixed-dim": "#cec6be",
              "outline-variant": "#d8d0c8",
              "on-background": "#3a302a",
              "tertiary-fixed-dim": "#e8a0a0",
              "on-secondary": "#ffffff",
              "surface-container-highest": "#e6e0d6",
              "on-tertiary-container": "#3a2020",
              "surface-container-low": "#f6f0e8",
              "on-secondary-fixed": "#2a2420",
              "inverse-primary": "#f0a878",
              "on-surface-variant": "#605850",
              "background": "#faf5ee",
              "secondary": "#78706a",
              "secondary-fixed": "#eae2da",
              "inverse-surface": "#3a302a",
              "surface-variant": "#ece6dc",
              "surface-bright": "#faf5ee",
              "on-primary": "#ffffff",
              "error": "#c0392b",
              "tertiary-container": "#d47070"
            },
            fontFamily: {
              "headline": ["Eb Garamond", "serif"],
              "body": ["Manrope", "sans-serif"],
              "label": ["Manrope", "sans-serif"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body { font-family: 'Manrope', sans-serif; }
        h1, h2, h3 { font-family: 'Eb Garamond', serif; }
        .tap-highlight-transparent { -webkit-tap-highlight-color: transparent; }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-surface min-h-screen pb-32">
<!-- TopAppBar -->
<header class="bg-[#faf5ee] dark:bg-stone-950 docked full-width top-0 border-b border-stone-200/60 dark:border-stone-800/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)] sticky z-40">
<div class="flex justify-between items-center w-full px-6 py-4">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-[#c2652a] dark:text-orange-500" data-icon="lightbulb">lightbulb</span>
<span class="font-serif italic text-2xl tracking-tight text-[#c2652a] dark:text-orange-400">Ideole</span>
</div>
<div class="flex items-center gap-4">
<span class="material-symbols-outlined text-stone-500" data-icon="search">search</span>
<img alt="User Profile" class="w-8 h-8 rounded-full border border-outline-variant" data-alt="Close up portrait of a smiling professional person with warm lighting and soft background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDzdRfPvclqeVDZPSYC2ZFLAdzOynw2bS3NQxgXvZDBKWzOnJOZ84JrX2OJ2NhM1I64AVO8daqZuCoKLVR6PQAQRKyue5Yf9boZF5VpwcH9CkzA4hRG6kF2biLHovTwasAvuKhVV2xXxfjajlxFx96R0MMI69_FIRwi-M2TmW50Fp3IesCDdaAh7OpSNjSWa0kJQRvv6k4xKhNy7HgHsYiH0YdzuUjInQGMzMkSexg0KOzsOciwmljBR-XLwH_q24MC0JU_Q2Znk8sC"/>
</div>
</div>
</header>
<main class="max-w-4xl mx-auto px-6 pt-8">
<!-- Hero Section -->
<section class="mb-12">
<div class="flex items-center gap-2 mb-4">
<span class="bg-primary/10 text-primary text-[10px] font-bold tracking-widest uppercase px-2 py-1 rounded">Sustainability</span>
<span class="text-on-surface-variant text-sm">• 12m ago</span>
</div>
<h1 class="text-5xl md:text-6xl font-bold leading-[1.1] mb-6 tracking-tight">Regenerative Urban Oasis: The Vertical Canopy</h1>
<div class="flex items-center gap-3 mb-8">
<img class="w-10 h-10 rounded-full" data-alt="Portrait of an architect in a sunlit studio, warm tones" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA2i8bNnQMy4Q-4OmxA0jo-7gQieQPpl7Qc72nM_p3HvRkGxVXKmQq3u8nMrvab28_foQyIV3NxHTZ1xkk6MZwzK-O_i00-I0LvfFAqLibaxeUvdFvZHWAp4-_WkhU_xh9VLxUg9IK_LM2e63_-T33Ecftc0UG0qHJV2QrTwJpydVQzo0p0jp0dbJDgHTF8yoiaIit2J2w-D7u24l41SuQ9g3S7179Bh36I9kqygT6d9rp4u8r_PLcCzPnSG8EYDy1D9HMwjFnbF0AI"/>
<div>
<p class="font-semibold text-sm">Elena Voss</p>
<p class="text-xs text-on-surface-variant">Lead Visionary • Berlin</p>
</div>
</div>
<div class="aspect-[16/9] w-full rounded-2xl overflow-hidden mb-12 shadow-sm">
<img class="w-full h-full object-cover" data-alt="Modern architectural structure with lush vertical gardens and warm golden hour lighting reflecting off glass surfaces" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBkRyRpE8FGHAnUICXS23EW7xSVTQpkdOn0GQrdV3z6iJ5ZaOPsqETFpO5hFS6EiSYGyqQs5pPxCHO7rvPX5Cf_ZGwg_dZyfN0nMxtafsyD9cQSHGPyENY6UUSkQvFy1LSv9edsdfYJHEZgWRpdD7I3IVJiRqc2luzoBStR8cEQJYMKX3yaAGGZA0rAc34KP2AizR9RbqQuH0-FCmomtcPHhUCZ2aAugoqokoN5qExyaBgPfB9NwKPvT7OjiWZygCQ-fiIu5k6ophDZ"/>
</div>
</section>
<!-- Metrics Bento Grid -->
<section class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-16">
<div class="bg-surface-container-low p-6 rounded-2xl border border-outline-variant/30 flex flex-col justify-between">
<span class="text-xs font-bold tracking-widest uppercase text-on-surface-variant mb-4">Feasibility</span>
<div class="flex items-baseline gap-1">
<span class="text-3xl font-serif font-bold text-primary">8.4</span>
<span class="text-xs text-on-surface-variant">/10</span>
</div>
<div class="w-full bg-outline-variant/30 h-1 rounded-full mt-4 overflow-hidden">
<div class="bg-primary h-full w-[84%]"></div>
</div>
</div>
<div class="bg-surface-container-low p-6 rounded-2xl border border-outline-variant/30 flex flex-col justify-between">
<span class="text-xs font-bold tracking-widest uppercase text-on-surface-variant mb-4">Impact</span>
<div class="flex items-baseline gap-1">
<span class="text-3xl font-serif font-bold text-tertiary">9.2</span>
<span class="text-xs text-on-surface-variant">/10</span>
</div>
<div class="w-full bg-outline-variant/30 h-1 rounded-full mt-4 overflow-hidden">
<div class="bg-tertiary h-full w-[92%]"></div>
</div>
</div>
<div class="bg-surface-container-low p-6 rounded-2xl border border-outline-variant/30 flex flex-col justify-between">
<span class="text-xs font-bold tracking-widest uppercase text-on-surface-variant mb-4">Novelty</span>
<div class="flex items-baseline gap-1">
<span class="text-3xl font-serif font-bold text-on-surface">7.8</span>
<span class="text-xs text-on-surface-variant">/10</span>
</div>
<div class="w-full bg-outline-variant/30 h-1 rounded-full mt-4 overflow-hidden">
<div class="bg-on-surface h-full w-[78%]"></div>
</div>
</div>
<div class="bg-surface-container-low p-6 rounded-2xl border border-outline-variant/30 flex flex-col justify-between">
<span class="text-xs font-bold tracking-widest uppercase text-on-surface-variant mb-4">Sentiment</span>
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-primary" data-icon="trending_up">trending_up</span>
<span class="text-xl font-serif font-bold text-on-surface">Positive</span>
</div>
<p class="text-[10px] mt-4 text-on-surface-variant">Based on 142 reviews</p>
</div>
</section>
<!-- Problem & Solution Section -->
<section class="space-y-16 mb-20">
<div class="grid md:grid-cols-12 gap-8">
<div class="md:col-span-4">
<h2 class="text-3xl font-bold italic tracking-tight sticky top-24">The Tension</h2>
</div>
<div class="md:col-span-8">
<p class="text-xl leading-relaxed text-on-surface-variant font-light">
                        Modern urban environments suffer from "concrete heat sinks," where soaring temperatures and lack of biodiversity create hostile living conditions. Existing green roofs are often heavy, high-maintenance, and isolated. We lack a connected biological infrastructure that breathes with the city.
                    </p>
</div>
</div>
<div class="grid md:grid-cols-12 gap-8">
<div class="md:col-span-4">
<h2 class="text-3xl font-bold italic tracking-tight sticky top-24 text-primary">The Synthesis</h2>
</div>
<div class="md:col-span-8 space-y-6">
<p class="text-xl leading-relaxed text-on-surface font-medium">
                        A modular, bio-ceramic "canopy" system that attaches to existing facades. It utilizes passive condensation to self-irrigate and provides a vertical corridor for local pollinators.
                    </p>
<div class="p-8 bg-surface-container-high rounded-3xl space-y-4">
<div class="flex gap-4">
<span class="material-symbols-outlined text-primary" data-icon="check_circle" style="font-variation-settings: 'FILL' 1;">check_circle</span>
<div>
<h4 class="font-bold text-lg mb-1">Modular Integration</h4>
<p class="text-on-surface-variant text-sm">Lightweight ceramic frames that click into standard building scaffolds.</p>
</div>
</div>
<div class="flex gap-4">
<span class="material-symbols-outlined text-primary" data-icon="check_circle" style="font-variation-settings: 'FILL' 1;">check_circle</span>
<div>
<h4 class="font-bold text-lg mb-1">Atmospheric Harvesting</h4>
<p class="text-on-surface-variant text-sm">Harvests up to 15 liters of water per day from morning humidity.</p>
</div>
</div>
</div>
</div>
</div>
</section>
<!-- Discussion Section -->
<section class="border-t border-outline-variant/40 pt-16">
<div class="flex justify-between items-end mb-10">
<h2 class="text-4xl font-bold tracking-tight">Refinements</h2>
<button class="text-primary font-bold text-sm underline decoration-2 underline-offset-4">View All Discussions</button>
</div>
<div class="space-y-8">
<!-- Comment 1 -->
<div class="flex gap-6 group">
<img class="w-12 h-12 rounded-full ring-2 ring-background ring-offset-2 ring-offset-outline-variant/20" data-alt="Close up portrait of an engineer, warm natural lighting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuB971XqVQ9DbzDSITSXJfzApxqLtCRORTRzf9Uz3W2VSeoqTP0QExVWK5c0zx0M-7VAyZ3r_qFayMGYsmjQhepELgjBCxhGqkBgXoonaWJW1o7Qu_Sj7-1hWWK7dDzn47ya-a9B70fqdT3kst97lY_3rC5HEJtDCkmjTix53DnSRuW90pQK2xfakz3Px5HS1NnJNyjhE5VZI2w8LteH6XtSSPdTZlBnIvIOXs7M6Zrm1yTe2mb5oxDKC_wYCUsEEq0PPtFZMSLvPzev"/>
<div class="flex-1">
<div class="flex items-center gap-3 mb-2">
<span class="font-bold text-sm">Marcus Chen</span>
<span class="text-xs text-on-surface-variant">2h ago</span>
</div>
<p class="text-on-surface-variant leading-relaxed mb-4">
                            The ceramic modularity is brilliant, but how do we address the structural load during high wind events? Perhaps adding a wind-tuned dampening system within the frames could mitigate the risk while generating small amounts of kinetic energy.
                        </p>
<div class="flex gap-6 items-center">
<button class="flex items-center gap-1.5 text-xs font-bold text-on-surface-variant hover:text-primary transition-colors">
<span class="material-symbols-outlined text-lg" data-icon="thumb_up">thumb_up</span>
                                24
                            </button>
<button class="flex items-center gap-1.5 text-xs font-bold text-on-surface-variant hover:text-primary transition-colors">
<span class="material-symbols-outlined text-lg" data-icon="chat_bubble_outline">chat_bubble_outline</span>
                                Reply
                            </button>
</div>
</div>
</div>
<!-- Comment 2 -->
<div class="flex gap-6 group pl-16 border-l-2 border-outline-variant/20">
<img class="w-10 h-10 rounded-full" data-alt="Portrait of a female urban planner with warm studio light" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDEkA52fL3llwLCoTnNjsyRwzKpQ7wfeGpKH_ei9NixQ-nNZC6HMw3xIXRS2Hvxl_I7xOMgrgq8HdNZLRM2UAjdRuj5SPQPknL7TmlMrYktQ9-2MjJjAl7aSPhIRwiz_cvjhf2Ahdd8WtZrMIEcYO6ELEoUf6eBoJgAo2utTNYAa5zFue30QOGSpnY3bn-txQ5tuvcxcAVrvRUi9cv8JVclSmtHzfhkz_3rY8irEtmF3YzRJcVZVtXdbVH3gAS9jtL0vlxbcbTqP920"/>
<div class="flex-1">
<div class="flex items-center gap-3 mb-2">
<span class="font-bold text-sm">Sasha Grey</span>
<span class="text-xs text-on-surface-variant">Just now</span>
</div>
<p class="text-on-surface-variant leading-relaxed mb-4">
                            Marcus, love that idea. Energy harvesting could power the internal sensors that track soil nutrient levels. Elena, what's the estimated manufacturing cost per module?
                        </p>
</div>
</div>
</div>
<!-- Input Box -->
<div class="mt-12 bg-white rounded-2xl p-4 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant flex items-center gap-4">
<img class="w-10 h-10 rounded-full" data-alt="User profile picture, warm light" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAt0gY9mUHPmspeIaljHbcA6OjzvmE0DSEjV5wongG996-MXYenSzRrIETljNI4MIfTCVWd8yBENHf0AgqRw5o3araL95fhVKGTeunpdnYE57KWMFdCESxqnLUa8GXyaoyqZXvQqSCk1wd0QLfbKDWUXELWf9uVBmbdjSoMf2FLQVwvbevg15kEM8SBZ7vvmgBFg5E99rXIfYS-8Yd0Vfh_XwW_y0NWkQeitT7_-fzJPjQt70gJ_OZMZEZkeQrAs44N103UZZCrcQDA"/>
<input class="flex-1 border-none focus:ring-0 bg-transparent text-sm placeholder:text-stone-400" placeholder="Add your refinement..." type="text"/>
<button class="bg-primary text-white p-2 rounded-xl">
<span class="material-symbols-outlined" data-icon="send">send</span>
</button>
</div>
</section>
</main>
<!-- FAB for Collaboration -->
<button class="fixed bottom-24 right-6 w-16 h-16 bg-primary text-white rounded-full shadow-xl flex items-center justify-center tap-highlight-transparent active:scale-90 transition-transform z-50">
<span class="material-symbols-outlined text-3xl" data-icon="group_add">group_add</span>
</button>
<!-- BottomNavBar -->
<nav class="bg-[#faf5ee]/90 dark:bg-stone-950/90 backdrop-blur-md fixed bottom-0 w-full z-50 border-t border-stone-200/60 dark:border-stone-800/60 fixed bottom-0 left-0 w-full flex justify-around items-center px-4 pb-safe pt-2 md:hidden">
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:bg-[#c2652a]/5 dark:hover:bg-orange-900/10 rounded-xl px-4 py-2 transition-all" href="#">
<span class="material-symbols-outlined" data-icon="home">home</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase mt-1">Feed</span>
</a>
<a class="flex flex-col items-center justify-center text-[#c2652a] dark:text-orange-400 font-bold hover:bg-[#c2652a]/5 dark:hover:bg-orange-900/10 rounded-xl px-4 py-2 transition-all" href="#">
<span class="material-symbols-outlined" data-icon="explore" style="font-variation-settings: 'FILL' 1;">explore</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase mt-1">Explore</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:bg-[#c2652a]/5 dark:hover:bg-orange-900/10 rounded-xl px-4 py-2 transition-all" href="#">
<span class="material-symbols-outlined" data-icon="insights">insights</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase mt-1">Insights</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:bg-[#c2652a]/5 dark:hover:bg-orange-900/10 rounded-xl px-4 py-2 transition-all" href="#">
<span class="material-symbols-outlined" data-icon="person">person</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase mt-1">Profile</span>
</a>
</nav>
</body></html>

<!-- Discover Communities (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=EB+Garamond:wght@400;500;600;700;800&amp;family=Manrope:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "primary-fixed": "#fbe8d8",
              "surface": "#faf5ee",
              "on-tertiary-fixed": "#2e1515",
              "outline": "#9a9088",
              "surface-container-highest": "#e6e0d6",
              "on-secondary-fixed": "#2a2420",
              "on-primary-container": "#fbe8d8",
              "outline-variant": "#d8d0c8",
              "surface-container-lowest": "#ffffff",
              "on-primary-fixed": "#401a08",
              "on-surface-variant": "#605850",
              "error-container": "#fce4e0",
              "surface-tint": "#c2652a",
              "on-primary": "#ffffff",
              "surface-container-high": "#ece6dc",
              "primary": "#c2652a",
              "surface-container-low": "#f6f0e8",
              "on-secondary-fixed-variant": "#504840",
              "error": "#c0392b",
              "on-secondary-container": "#605850",
              "secondary-container": "#eae2da",
              "tertiary-fixed": "#fce0e0",
              "secondary": "#78706a",
              "on-surface": "#3a302a",
              "surface-bright": "#faf5ee",
              "on-error": "#ffffff",
              "surface-dim": "#dcd6cc",
              "on-error-container": "#7a1a10",
              "surface-container": "#f2ece4",
              "on-tertiary": "#ffffff",
              "background": "#faf5ee",
              "on-tertiary-container": "#3a2020",
              "inverse-on-surface": "#faf5ee",
              "on-tertiary-fixed-variant": "#6e3030",
              "on-background": "#3a302a",
              "on-primary-fixed-variant": "#8a4518",
              "tertiary": "#8c3c3c",
              "tertiary-container": "#d47070",
              "primary-container": "#e08850",
              "secondary-fixed": "#eae2da",
              "secondary-fixed-dim": "#cec6be",
              "on-secondary": "#ffffff",
              "tertiary-fixed-dim": "#e8a0a0",
              "surface-variant": "#ece6dc",
              "primary-fixed-dim": "#f0a878",
              "inverse-surface": "#3a302a",
              "inverse-primary": "#f0a878"
            },
            fontFamily: {
              "headline": ["Eb Garamond"],
              "body": ["Manrope"],
              "label": ["Manrope"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
</head>
<body class="bg-surface font-body text-on-background min-h-screen pb-32">
<!-- TopAppBar -->
<header class="bg-[#faf5ee] dark:bg-stone-950 border-b border-stone-200/60 dark:border-stone-800/60 docked full-width top-0 sticky z-40">
<div class="flex justify-between items-center w-full px-6 py-4 max-w-7xl mx-auto">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-[#c2652a] dark:text-[#d4824d]" data-icon="search">search</span>
<h1 class="font-['EB_Garamond'] text-3xl tracking-tight text-stone-900 dark:text-stone-100">Discover Communities</h1>
</div>
<div class="w-10 h-10 rounded-full overflow-hidden border-2 border-primary-container">
<img alt="User profile avatar" class="w-full h-full object-cover" data-alt="Close up portrait of a young woman with a warm, sunlit glow and soft natural background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA9f6ohaV1K8EeaLTRQtiT1GWvLauBYa1no7WZTpQWQ1aZbifduoBoGMN8dnmyFt-hAyzqpZ8SdmblcbUSkTyIy586fnteBZbCwICQaglwZqA0JAJtqZAcQ1eAhBn5TKA0s6fNXzk3ysF5LE4NCxMk5BSyFoGfLTEzp6FuJy1fVXmMrBdw5XK_Wsz5EAK0qziYHR_ekA55dp71HU22xgjAf_CP4NEaYuQBQ6zM6zRkXs6q1lDKWVnsBAoNYmv6Ax-IG18QCivHAzLRt"/>
</div>
</div>
</header>
<main class="max-w-7xl mx-auto px-6 mt-6 space-y-8">
<!-- Search Field -->
<section class="w-full">
<div class="relative group">
<span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline" data-icon="search">search</span>
<input class="w-full bg-surface-container-lowest border border-outline-variant rounded-xl py-4 pl-12 pr-4 focus:ring-1 focus:ring-primary focus:border-primary transition-all duration-300 placeholder:text-outline/70" placeholder="Find niche innovation circles..." type="text"/>
</div>
</section>
<!-- Categories Horizontal Scroll -->
<section class="space-y-4">
<div class="flex items-center justify-between">
<h2 class="font-headline text-xl text-on-surface">Browse by Intent</h2>
<button class="text-primary font-label text-sm font-semibold">View All</button>
</div>
<div class="flex gap-3 overflow-x-auto hide-scrollbar -mx-6 px-6">
<div class="flex-none px-6 py-2.5 rounded-full bg-primary text-on-primary font-label text-sm font-medium shadow-sm cursor-pointer">Sustainability</div>
<div class="flex-none px-6 py-2.5 rounded-full bg-surface-container-high text-on-surface-variant font-label text-sm font-medium hover:bg-surface-container-highest transition-colors cursor-pointer">AI</div>
<div class="flex-none px-6 py-2.5 rounded-full bg-surface-container-high text-on-surface-variant font-label text-sm font-medium hover:bg-surface-container-highest transition-colors cursor-pointer">Social Impact</div>
<div class="flex-none px-6 py-2.5 rounded-full bg-surface-container-high text-on-surface-variant font-label text-sm font-medium hover:bg-surface-container-highest transition-colors cursor-pointer">Urban Planning</div>
<div class="flex-none px-6 py-2.5 rounded-full bg-surface-container-high text-on-surface-variant font-label text-sm font-medium hover:bg-surface-container-highest transition-colors cursor-pointer">Bio-Tech</div>
<div class="flex-none px-6 py-2.5 rounded-full bg-surface-container-high text-on-surface-variant font-label text-sm font-medium hover:bg-surface-container-highest transition-colors cursor-pointer">Architecture</div>
</div>
</section>
<!-- Group List: High Fidelity Cards -->
<section class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
<!-- Card 1 -->
<article class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex flex-col hover:translate-y-[-4px] transition-transform duration-300">
<div class="h-56 w-full relative">
<img alt="Regenerative Cities" class="w-full h-full object-cover" data-alt="Sun-baked architectural structure with warm wooden textures and lush green roof gardens in soft evening light" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDBt1REPZ4wKgNyxkPbHd48Fh0QRcBPZUsKtayFOmeQtKUFIPUBTQcV9qBesxvxkZ0Fkg0UcPFdJ3qbXqc2hC5Mv0TiU2Qgw7554Y520RekutRFnltZKJN_MP4lDbDbgVKicWA2kqk-gOjPqJLSeFSAXyJuCfoTeD-765aBiykflRKz0qLFvu1-oaryKA5exEX3YFz7otlA23ixg8yk2b2NgBCDtqcE9Kk7zObEybGXcz_E45KLJo-Snvt6ESgRVlJU-eARed7Ag8no"/>
<div class="absolute top-4 right-4 bg-surface/90 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase text-on-surface-variant">Urban Planning</div>
</div>
<div class="p-7 flex-grow space-y-4">
<div class="space-y-2">
<h3 class="font-headline text-2xl font-semibold text-on-surface leading-tight">Regenerative Cities</h3>
<p class="text-on-surface-variant text-sm leading-relaxed line-clamp-2">Exploring circular economy frameworks and sustainable architecture for the next century of urban living.</p>
</div>
<div class="flex items-center gap-2 text-primary font-label text-xs font-bold tracking-wider uppercase">
<span class="material-symbols-outlined text-lg" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
                        2.4k Visionaries
                    </div>
<button class="w-full bg-primary text-on-primary py-3.5 rounded-lg font-label font-bold text-sm tracking-wide hover:opacity-90 transition-opacity active:scale-95 duration-150">Join Community</button>
</div>
</article>
<!-- Card 2 -->
<article class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex flex-col hover:translate-y-[-4px] transition-transform duration-300">
<div class="h-56 w-full relative">
<img alt="Neural Arts Collective" class="w-full h-full object-cover" data-alt="Abstract neural network visualization with warm golden hues and soft organic shapes on a linen-textured background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAtIOmf-mSaFZK-_qdClJExpjb-AlqNc91_nZ2V4Zf8hl4hmuXdswxfTOIXLyrIKk2VcvoLOK8MuIJ-A8AVWlP7mrmZP9XcWpSLK6RFqv2DWPyKIGqmtsboFGSKCLTv8nAjJugoK8CMnczgkU15WOWzyxsbOZtNj32rDocF_p00579dt1q10wPyVbbb7W1GWDqjkgjZbwAUX5AErZGD9NEiBLO8ql9wSBWPZTZzKyCKosVFDl0owN_AoWsvWlUviB0RJ62wM6Ga62xb"/>
<div class="absolute top-4 right-4 bg-surface/90 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase text-on-surface-variant">AI &amp; Art</div>
</div>
<div class="p-7 flex-grow space-y-4">
<div class="space-y-2">
<h3 class="font-headline text-2xl font-semibold text-on-surface leading-tight">Neural Arts Collective</h3>
<p class="text-on-surface-variant text-sm leading-relaxed line-clamp-2">A collaborative space for artists and data scientists redefining creative expression through generative models.</p>
</div>
<div class="flex items-center gap-2 text-primary font-label text-xs font-bold tracking-wider uppercase">
<span class="material-symbols-outlined text-lg" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
                        850 Active Members
                    </div>
<button class="w-full bg-primary text-on-primary py-3.5 rounded-lg font-label font-bold text-sm tracking-wide hover:opacity-90 transition-opacity active:scale-95 duration-150">Join Community</button>
</div>
</article>
<!-- Card 3 -->
<article class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex flex-col hover:translate-y-[-4px] transition-transform duration-300">
<div class="h-56 w-full relative">
<img alt="Bio-Mimicry Studio" class="w-full h-full object-cover" data-alt="Close up of vibrant green plant leaves with crystal clear water droplets and soft morning sunlight" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAluyQdKIE23TkT20dvYvmu_wUzEnDf4lOQh-G0AhUTljwiMH0D5EombaMHw9_gArHrghIAwo-BEhSV2frwis7exklXXRCl8_yC4TQKmTTW3lAEoCIOcXXtsOI789GxUTAna-VqAiPPHwUi8cYk51bJ2QZAznUP4hNEEQMAMmg2nUziikrUTUO1HMV8vd4z4NSWiQLxkATJsm661YJjKwKWyfFwlGO-Vk8HAvc8v3JCrYqSz-htMjHXZT_EX3tQAgTvN7A8P8OuGWnk"/>
<div class="absolute top-4 right-4 bg-surface/90 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase text-on-surface-variant">Bio-Tech</div>
</div>
<div class="p-7 flex-grow space-y-4">
<div class="space-y-2">
<h3 class="font-headline text-2xl font-semibold text-on-surface leading-tight">Bio-Mimicry Studio</h3>
<p class="text-on-surface-variant text-sm leading-relaxed line-clamp-2">Harnessing nature's design patterns to create efficient industrial solutions and regenerative products.</p>
</div>
<div class="flex items-center gap-2 text-primary font-label text-xs font-bold tracking-wider uppercase">
<span class="material-symbols-outlined text-lg" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
                        1.2k Visionaries
                    </div>
<button class="w-full bg-primary text-on-primary py-3.5 rounded-lg font-label font-bold text-sm tracking-wide hover:opacity-90 transition-opacity active:scale-95 duration-150">Join Community</button>
</div>
</article>
<!-- Card 4 (Asymmetric Layout Hint) -->
<article class="bg-surface-container-lowest rounded-xl overflow-hidden shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex flex-col md:col-span-2 lg:col-span-1 hover:translate-y-[-4px] transition-transform duration-300">
<div class="h-56 w-full relative">
<img alt="Social Impact Lab" class="w-full h-full object-cover" data-alt="Modern collaborative workspace with warm lighting, wooden tables, and young people engaged in thoughtful conversation" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBy6iDl2WdRcTkuvkjsRBW6DYUfrfVBGE4pm5ZxLTQl-sPqgvS5rZfr7n-bBB3xSCjGGp13tS9C6g-GGxwhAtnRWe1_opH1Q9_ThxIgnaST5R-xF5Nqt7PJHO0mAF-q6PcpUsehvg_mN7i2CgaEdvw8h8dcpTMy3KnJnNH_uFhqES8wn6PFtgH38ji5A6_H7wSeetOXoZ3Cp7g0DsKUkNXgfr_tyK2ouRiYmi4DqAyQRmkHm-95Dqvp2jShjVNOjFKomQF-m8R5t4OS"/>
<div class="absolute top-4 right-4 bg-surface/90 backdrop-blur-md px-3 py-1 rounded-full text-[10px] font-bold tracking-widest uppercase text-on-surface-variant">Social Impact</div>
</div>
<div class="p-7 flex-grow space-y-4">
<div class="space-y-2">
<h3 class="font-headline text-2xl font-semibold text-on-surface leading-tight">Social Impact Lab</h3>
<p class="text-on-surface-variant text-sm leading-relaxed line-clamp-2">Incubating ideas that solve systemic community challenges through localized innovation and empathy.</p>
</div>
<div class="flex items-center gap-2 text-primary font-label text-xs font-bold tracking-wider uppercase">
<span class="material-symbols-outlined text-lg" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
                        3.1k Visionaries
                    </div>
<button class="w-full bg-primary text-on-primary py-3.5 rounded-lg font-label font-bold text-sm tracking-wide hover:opacity-90 transition-opacity active:scale-95 duration-150">Join Community</button>
</div>
</article>
</section>
</main>
<!-- BottomNavBar -->
<nav class="fixed bottom-0 left-0 w-full z-50 flex justify-around items-center px-4 pb-safe h-20 bg-[#faf5ee]/90 dark:bg-stone-950/90 backdrop-blur-md border-t border-stone-200/60 dark:border-stone-800/60 shadow-[0_-2px_16px_rgba(58,48,42,0.04)]">
<button class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#c2652a] transition-colors">
<span class="material-symbols-outlined" data-icon="explore">explore</span>
<span class="font-['Manrope'] text-[11px] font-medium tracking-wide uppercase mt-1">Explore</span>
</button>
<button class="flex flex-col items-center justify-center text-[#c2652a] dark:text-[#d4824d] scale-105">
<span class="material-symbols-outlined" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
<span class="font-['Manrope'] text-[11px] font-medium tracking-wide uppercase mt-1">Communities</span>
</button>
<button class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#c2652a] transition-colors">
<span class="material-symbols-outlined" data-icon="event">event</span>
<span class="font-['Manrope'] text-[11px] font-medium tracking-wide uppercase mt-1">Events</span>
</button>
<button class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#c2652a] transition-colors">
<span class="material-symbols-outlined" data-icon="person">person</span>
<span class="font-['Manrope'] text-[11px] font-medium tracking-wide uppercase mt-1">Profile</span>
</button>
</nav>
<!-- FAB Suppression: On discovery/listing screens, it's often better to avoid FAB to prioritize grid navigation, but if needed, we'd add 'Create Group' here -->
</body></html>

<!-- Holistic Idea Creation (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Ideole — Create New Vision</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface": "#faf5ee",
                        "background": "#faf5ee",
                        "surface-container-lowest": "#ffffff",
                        "secondary-fixed-dim": "#cec6be",
                        "inverse-on-surface": "#faf5ee",
                        "tertiary-fixed": "#fce0e0",
                        "on-surface-variant": "#605850",
                        "primary-container": "#e08850",
                        "on-secondary-fixed": "#2a2420",
                        "tertiary-fixed-dim": "#e8a0a0",
                        "on-tertiary-fixed-variant": "#6e3030",
                        "surface-container": "#f2ece4",
                        "surface-bright": "#faf5ee",
                        "primary-fixed-dim": "#f0a878",
                        "on-tertiary-container": "#3a2020",
                        "primary-fixed": "#fbe8d8",
                        "on-secondary-fixed-variant": "#504840",
                        "on-primary-fixed-variant": "#8a4518",
                        "error": "#c0392b",
                        "on-error": "#ffffff",
                        "tertiary": "#8c3c3c",
                        "outline": "#9a9088",
                        "surface-tint": "#c2652a",
                        "on-primary": "#ffffff",
                        "secondary-container": "#eae2da",
                        "on-primary-fixed": "#401a08",
                        "on-primary-container": "#fbe8d8",
                        "on-tertiary-fixed": "#2e1515",
                        "primary": "#c2652a",
                        "outline-variant": "#d8d0c8",
                        "surface-container-high": "#ece6dc",
                        "on-surface": "#3a302a",
                        "inverse-primary": "#f0a878",
                        "secondary-fixed": "#eae2da",
                        "surface-variant": "#ece6dc",
                        "surface-container-highest": "#e6e0d6",
                        "on-secondary-container": "#605850",
                        "surface-dim": "#dcd6cc",
                        "error-container": "#fce4e0",
                        "on-secondary": "#ffffff",
                        "tertiary-container": "#d47070",
                        "on-error-container": "#7a1a10"
                    },
                    fontFamily: {
                        "headline": ["Eb Garamond"],
                        "body": ["Manrope"],
                        "label": ["Manrope"]
                    },
                    borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
                },
            },
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            background-color: #faf5ee;
            color: #3a302a;
            font-family: 'Manrope', sans-serif;
            -webkit-font-smoothing: antialiased;
        }
        .serif-heading {
            font-family: 'Eb Garamond', serif;
        }
        .custom-dashed {
            background-image: url("data:image/svg+xml,%3csvg width='100%25' height='100%25' xmlns='http://www.w3.org/2000/svg'%3e%3crect width='100%25' height='100%25' fill='none' stroke='%23d8d0c8' stroke-width='1' stroke-dasharray='8%2c 12' stroke-dashoffset='0' stroke-linecap='square'/%3e%3c/svg%3e");
        }
        .pb-safe {
            padding-bottom: env(safe-area-inset-bottom);
        }
        input::placeholder, textarea::placeholder {
            color: #bcaea3;
        }
    </style>
</head>
<body class="bg-surface selection:bg-primary-fixed">
<!-- TopAppBar -->
<header class="fixed top-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-[#faf5ee]/95 backdrop-blur-sm border-b border-[#d8d0c8]/60">
<div class="flex items-center gap-4">
<button class="material-symbols-outlined text-[#c2652a] hover:bg-stone-100 transition-colors p-2 rounded-full">
                arrow_back
            </button>
<span class="font-serif italic text-2xl text-[#c2652a]">Ideole</span>
</div>
<div class="flex items-center gap-4">
<div class="hidden sm:flex items-center gap-2 text-outline text-[10px] uppercase tracking-widest font-semibold">
<span class="w-1.5 h-1.5 rounded-full bg-green-500/60"></span>
                Draft Saved
            </div>
<div class="w-8 h-8 rounded-full bg-surface-container overflow-hidden border border-outline-variant">
<img alt="User profile" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBej2aBL3Zo8xYW_dsky2-B1FWHY1BPhYUm3g0TksJqR8IXyQLxlVkyAhZY6OjX7P0dC-3JpQQ2WeFTj40Aon7l76uQ6XLHUNIQudBLwkaOcNGJyn9u9Z5ccRi9XE-1_MAYBNoJhwhA73jPKPCTIMLUXN1gisMDyVHiCE9htgGu--tgM4VZln4paFQKZ5Vu2tfzE28ZzzRQZcmqvMrWQiSG4uM56ufeg9Z-Y47hZ0PfxK0wyPVn1cVJv-3RP8QmrBC9L7KpbGHml2lW"/>
</div>
</div>
</header>
<main class="pt-24 pb-40 px-6 max-w-2xl mx-auto">
<!-- Journal Header -->
<header class="mb-12 text-center">
<span class="font-body text-[10px] uppercase tracking-[0.4em] text-outline mb-3 block">Innovation Lab</span>
<h1 class="serif-heading italic text-5xl text-on-surface leading-tight">Create New Vision</h1>
<div class="flex justify-center items-center gap-2 mt-4 sm:hidden">
<span class="w-1.5 h-1.5 rounded-full bg-green-500/60"></span>
<span class="text-outline text-[10px] uppercase tracking-widest">Draft Saved</span>
</div>
</header>
<form class="space-y-16">
<!-- Theme Selection -->
<div class="space-y-4">
<label class="font-body text-[10px] uppercase tracking-widest text-outline font-bold">Select Theme</label>
<div class="flex overflow-x-auto pb-2 gap-3 no-scrollbar">
<button class="whitespace-nowrap px-5 py-2 rounded-full border border-primary bg-primary text-on-primary font-body text-sm transition-all shadow-sm" type="button">Sustainability</button>
<button class="whitespace-nowrap px-5 py-2 rounded-full border border-outline-variant bg-surface-container-low text-on-surface-variant font-body text-sm hover:border-primary/50 transition-all" type="button">Artificial Intelligence</button>
<button class="whitespace-nowrap px-5 py-2 rounded-full border border-outline-variant bg-surface-container-low text-on-surface-variant font-body text-sm hover:border-primary/50 transition-all" type="button">Social Impact</button>
<button class="whitespace-nowrap px-5 py-2 rounded-full border border-outline-variant bg-surface-container-low text-on-surface-variant font-body text-sm hover:border-primary/50 transition-all" type="button">Education</button>
<button class="whitespace-nowrap px-5 py-2 rounded-full border border-outline-variant bg-surface-container-low text-on-surface-variant font-body text-sm hover:border-primary/50 transition-all" type="button">Urban Design</button>
</div>
</div>
<!-- Core Concept -->
<div class="space-y-10">
<div class="group">
<label class="font-body text-[10px] uppercase tracking-widest text-outline mb-3 block group-focus-within:text-primary transition-colors font-bold" for="idea-title">Idea Title</label>
<input class="w-full bg-transparent border-0 border-b border-outline-variant focus:ring-0 focus:border-primary serif-heading italic text-4xl pb-4 transition-all placeholder:text-stone-300" id="idea-title" placeholder="A name for your future..." type="text"/>
</div>
<div class="group">
<label class="font-body text-[10px] uppercase tracking-widest text-outline mb-3 block group-focus-within:text-primary transition-colors font-bold" for="elevator-pitch">Elevator Pitch</label>
<textarea class="w-full bg-surface-container-low border border-transparent focus:border-primary/20 rounded-xl p-5 focus:ring-0 font-body text-lg leading-relaxed italic" id="elevator-pitch" maxlength="200" placeholder="A short, high-impact summary (max 200 chars)..." rows="2"></textarea>
<div class="flex justify-end mt-1">
<span class="text-[10px] text-outline uppercase tracking-tighter">0 / 200</span>
</div>
</div>
<div class="group">
<label class="font-body text-[10px] uppercase tracking-widest text-outline mb-3 block group-focus-within:text-primary transition-colors font-bold" for="problem">Problem Statement</label>
<textarea class="w-full bg-surface-container-low border border-transparent focus:border-primary/20 rounded-xl p-5 focus:ring-0 font-body text-base leading-relaxed" id="problem" placeholder="What dissonance are you observing in the world today?" rows="4"></textarea>
</div>
<div class="group">
<label class="font-body text-[10px] uppercase tracking-widest text-outline mb-3 block group-focus-within:text-primary transition-colors font-bold" for="solution">Proposed Solution</label>
<textarea class="w-full bg-surface-container-low border border-transparent focus:border-primary/20 rounded-xl p-5 focus:ring-0 font-body text-base leading-relaxed" id="solution" placeholder="Describe the deep mechanism of your impact..." rows="8"></textarea>
</div>
</div>
<!-- Visual Anchor -->
<div class="space-y-4">
<label class="font-body text-[10px] uppercase tracking-widest text-outline font-bold">Visual Anchor</label>
<div class="custom-dashed aspect-video rounded-2xl flex flex-col items-center justify-center p-8 text-center group cursor-pointer hover:bg-surface-container-high transition-colors bg-surface-container/30">
<div class="w-16 h-16 rounded-full bg-surface-container-highest flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
<span class="material-symbols-outlined text-3xl text-primary/60 group-hover:text-primary transition-colors">add_photo_alternate</span>
</div>
<p class="serif-heading italic text-xl text-on-surface mb-2">Mood Image or Prototype Sketch</p>
<p class="font-body text-xs text-on-surface-variant max-w-[240px] leading-relaxed">Drop a visual that represents the soul of your idea or browse files</p>
</div>
</div>
<!-- Holistic Details -->
<div class="space-y-10 pt-8 border-t border-outline-variant/30">
<div class="space-y-6">
<label class="font-body text-[10px] uppercase tracking-widest text-outline font-bold">Impact Metrics</label>
<div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
<div class="space-y-2">
<span class="font-body text-[11px] text-on-surface-variant">Target Reach</span>
<div class="relative">
<input class="w-full bg-surface-container-low border-0 rounded-lg py-3 px-4 font-body text-sm focus:ring-1 focus:ring-primary" placeholder="e.g. 1M+" type="text"/>
</div>
</div>
<div class="space-y-2">
<span class="font-body text-[11px] text-on-surface-variant">Time to Impact</span>
<div class="relative">
<input class="w-full bg-surface-container-low border-0 rounded-lg py-3 px-4 font-body text-sm focus:ring-1 focus:ring-primary" placeholder="e.g. 2 years" type="text"/>
</div>
</div>
<div class="space-y-2">
<span class="font-body text-[11px] text-on-surface-variant">Sustainability Score</span>
<div class="relative">
<input class="w-full bg-surface-container-low border-0 rounded-lg py-3 px-4 font-body text-sm focus:ring-1 focus:ring-primary" placeholder="0-100" type="number"/>
</div>
</div>
</div>
</div>
<div class="space-y-4">
<label class="font-body text-[10px] uppercase tracking-widest text-outline font-bold">Resource Needs</label>
<div class="flex flex-wrap gap-2">
<button class="px-4 py-2 rounded-lg border border-outline-variant bg-surface hover:border-primary text-xs font-medium transition-all" type="button">Technical Expertise</button>
<button class="px-4 py-2 rounded-lg border border-primary bg-primary/5 text-primary text-xs font-bold transition-all flex items-center gap-2" type="button">
                            Seed Funding <span class="material-symbols-outlined text-xs">close</span>
</button>
<button class="px-4 py-2 rounded-lg border border-outline-variant bg-surface hover:border-primary text-xs font-medium transition-all" type="button">Legal Guidance</button>
<button class="px-4 py-2 rounded-lg border border-outline-variant bg-surface hover:border-primary text-xs font-medium transition-all" type="button">Product Design</button>
<button class="px-4 py-2 rounded-lg border border-outline-variant bg-surface border-dashed text-outline text-xs font-medium hover:text-primary transition-all" type="button">
                            + Add Resource
                        </button>
</div>
</div>
<!-- Collaboration Settings -->
<div class="grid grid-cols-1 sm:grid-cols-2 gap-8 p-6 bg-surface-container rounded-2xl">
<div class="flex items-center justify-between gap-4">
<div class="space-y-0.5">
<h4 class="font-body font-bold text-sm">Open for Forking</h4>
<p class="text-[11px] text-on-surface-variant leading-tight">Allow others to evolve this vision</p>
</div>
<button class="w-12 h-6 bg-primary rounded-full relative transition-colors" type="button">
<span class="absolute right-1 top-1 w-4 h-4 bg-white rounded-full shadow-sm"></span>
</button>
</div>
<div class="space-y-2">
<h4 class="font-body font-bold text-sm">Privacy</h4>
<div class="relative">
<select class="w-full bg-surface border-outline-variant rounded-lg py-2 px-3 text-sm font-body focus:ring-primary focus:border-primary appearance-none">
<option>Public (Visible to Universe)</option>
<option>Private (Draft Only)</option>
<option>Shared with Collaborators</option>
</select>
<span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-outline pointer-events-none text-sm">expand_more</span>
</div>
</div>
</div>
</div>
</form>
</main>
<!-- Action Bar (Mobile & Desktop Unified) -->
<div class="fixed bottom-0 w-full z-50 bg-[#faf5ee]/95 backdrop-blur-md border-t border-[#d8d0c8]/60 px-6 py-6 pb-safe flex items-center justify-center">
<div class="max-w-2xl w-full flex items-center gap-4">
<button class="flex-1 px-6 py-4 border border-primary/40 text-primary rounded-full font-body text-xs font-bold uppercase tracking-[0.15em] hover:bg-white transition-all">
                Save Draft
            </button>
<button class="flex-[1.5] px-6 py-4 bg-primary text-on-primary rounded-full font-body text-xs font-bold uppercase tracking-[0.15em] shadow-xl shadow-primary/25 active:scale-95 transition-all">
                Publish to Universe
            </button>
</div>
</div>
</body></html>

<!-- Idea Feed (Refined Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Ideole - Idea Feed</title>
<!-- Fonts -->
<link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<!-- Icons -->
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "surface-tint": "#c2652a",
              "on-secondary-container": "#605850",
              "primary": "#c2652a",
              "tertiary": "#8c3c3c",
              "surface-container-low": "#f6f0e8",
              "on-background": "#3a302a",
              "tertiary-container": "#d47070",
              "outline-variant": "#d8d0c8",
              "background": "#faf5ee",
              "error-container": "#fce4e0",
              "on-secondary-fixed": "#2a2420",
              "on-primary-container": "#fbe8d8",
              "on-tertiary-container": "#3a2020",
              "secondary-fixed": "#eae2da",
              "on-primary-fixed": "#401a08",
              "on-error-container": "#7a1a10",
              "on-tertiary-fixed": "#2e1515",
              "on-surface": "#3a302a",
              "on-secondary": "#ffffff",
              "surface": "#faf5ee",
              "secondary": "#78706a",
              "on-surface-variant": "#605850",
              "surface-container-highest": "#e6e0d6",
              "on-secondary-fixed-variant": "#504840",
              "on-primary": "#ffffff",
              "outline": "#9a9088",
              "surface-container": "#f2ece4",
              "secondary-container": "#eae2da",
              "inverse-primary": "#f0a878",
              "tertiary-fixed": "#fce0e0",
              "surface-bright": "#faf5ee",
              "primary-fixed": "#fbe8d8",
              "inverse-on-surface": "#faf5ee",
              "on-primary-fixed-variant": "#8a4518",
              "tertiary-fixed-dim": "#e8a0a0",
              "inverse-surface": "#3a302a",
              "surface-dim": "#dcd6cc",
              "surface-container-high": "#ece6dc",
              "primary-container": "#e08850",
              "surface-variant": "#ece6dc",
              "primary-fixed-dim": "#f0a878",
              "on-tertiary": "#ffffff",
              "error": "#c0392b",
              "on-error": "#ffffff",
              "secondary-fixed-dim": "#cec6be",
              "on-tertiary-fixed-variant": "#6e3030",
              "surface-container-lowest": "#ffffff"
            },
            fontFamily: {
              "headline": ["EB Garamond"],
              "body": ["Manrope"],
              "label": ["Manrope"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-background font-body antialiased">
<!-- TopAppBar -->
<header class="fixed top-0 left-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-[#faf5ee] dark:bg-stone-950 border-b border-[#d8d0c8]/60 dark:border-stone-800 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
<div class="flex items-center gap-4">
<span class="material-symbols-outlined text-[#c2652a] dark:text-[#d4824d]" data-icon="search">search</span>
</div>
<h1 class="text-2xl font-serif italic text-[#c2652a] dark:text-[#d4824d] tracking-tight">Ideole</h1>
<div class="flex items-center">
<img alt="User profile photo" class="w-8 h-8 rounded-full border border-outline-variant/30 object-cover" data-alt="close-up portrait of a woman with warm skin tones and natural lighting against a soft terracotta background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCqsP4Ea1-FJE92G8MHimc-XHwxqaC3FWYPOQQaCNyQP6vqHcdd_ByexMOTvdzzgO7FznCW9ru5WwoR74y5fqiSVeCzDouMEuLZDs09uwCW9C7TJ69Des4R6y3cM1xUUDJwOBq1FPnS51SJP_vpDQ1B6nQoGUg9i8ezTQv0OJWYF68BKO-ToNzyiTV3nS0jHMWc4MK8UF-1QPVD0NkrDEDVilGl46JAsGJyzrBel1TxcKWtHGxb45gOwN7PAp6bvtG0AwrP3et2DKUr"/>
</div>
</header>
<!-- Main Content Canvas -->
<main class="pt-20 pb-24 px-3 max-w-lg mx-auto min-h-screen">
<!-- Sticky Search Bar -->
<div class="sticky top-16 z-40 py-4 bg-background/80 backdrop-blur-md">
<div class="relative group">
<input class="w-full bg-surface-container-lowest border-outline-variant/60 rounded-xl py-3 pl-11 pr-4 focus:ring-primary focus:border-primary text-sm font-label transition-all shadow-sm" placeholder="Search your creative spark..." type="text"/>
<span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-secondary scale-90" data-icon="search">search</span>
</div>
</div>
<!-- Idea Card Stack -->
<div class="space-y-4">
<!-- Card 1 -->
<article class="bg-surface-container-lowest rounded-xl p-7 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/20 hover:border-primary/20 transition-all active:scale-[0.98]">
<div class="flex justify-between items-start mb-4">
<span class="px-2.5 py-0.5 rounded-full bg-surface-container-highest text-[10px] font-label font-bold uppercase tracking-widest text-secondary">Public</span>
<span class="material-symbols-outlined text-secondary/40 text-sm" data-icon="more_vert">more_vert</span>
</div>
<h2 class="text-[24px] font-headline font-bold leading-tight mb-3 text-on-surface">The Vertical Veranda Garden</h2>
<p class="text-[14px] text-on-surface-variant line-clamp-2 leading-relaxed mb-6 font-medium">Urban dwellers lack space for meaningful agriculture. This modular hydroponic system fits any balcony railing without drilling.</p>
<!-- Circular Progress Indicators -->
<div class="flex items-center gap-6 mb-8">
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#10B981" stroke-dasharray="113" stroke-dashoffset="20" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">82</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Original</span>
</div>
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#F59E0B" stroke-dasharray="113" stroke-dashoffset="40" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">64</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Feasible</span>
</div>
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#3B82F6" stroke-dasharray="113" stroke-dashoffset="15" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">91</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Impact</span>
</div>
</div>
<div class="flex items-center justify-between pt-4 border-t border-outline-variant/20">
<div class="flex items-center gap-2">
<img alt="Reviewer" class="w-6 h-6 rounded-full border border-outline-variant/40" data-alt="headshot of a man with spectacles in a professional but warm studio lighting setting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCxCqJefDjBDzyWDBrmPf_D5rhkXvxkvqcSP-IDJ3j0v2cU67SyYVBKkf-Ub2HmJbIQIqFKSMaVP1NN0duCM1ia_gaku6srEM3LSjPXwshQWo6ZiGhmp32fs-qRMdDC4gNiCZJbL5vtsod62oYXPcXX_PCQiLgcd-LzDOfuAazCavuNRE2-aiNcFhPBoxxX8nNgGBhyFxFlY75DJ7ZZLlsYsf0YZ5zhJ7Tp9Ji_BquWoZtyTVB18z1alwM_BsLzSg-MFPa0i4tFuX50"/>
<span class="text-[12px] font-label font-medium text-on-surface-variant">12 Reviewers</span>
</div>
<div class="flex items-center gap-1 text-on-surface-variant">
<span class="material-symbols-outlined text-[16px]" data-icon="chat_bubble_outline">chat_bubble_outline</span>
<span class="text-[12px] font-label font-medium">8 Comments</span>
</div>
</div>
</article>
<!-- Card 2 -->
<article class="bg-surface-container-lowest rounded-xl p-7 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/20 active:scale-[0.98]">
<div class="flex justify-between items-start mb-4">
<span class="px-2.5 py-0.5 rounded-full bg-primary/10 text-[10px] font-label font-bold uppercase tracking-widest text-primary">Private</span>
<span class="material-symbols-outlined text-secondary/40 text-sm" data-icon="lock">lock</span>
</div>
<h2 class="text-[24px] font-headline font-bold leading-tight mb-3 text-on-surface">Local Artisan Ledger</h2>
<p class="text-[14px] text-on-surface-variant line-clamp-2 leading-relaxed mb-6 font-medium">A blockchain-backed verification system for authentic handmade goods to fight mass-produced imitators.</p>
<div class="flex items-center gap-6 mb-8">
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#10B981" stroke-dasharray="113" stroke-dashoffset="50" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">55</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Original</span>
</div>
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#F59E0B" stroke-dasharray="113" stroke-dashoffset="25" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">78</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Feasible</span>
</div>
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#3B82F6" stroke-dasharray="113" stroke-dashoffset="60" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">47</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Impact</span>
</div>
</div>
<div class="flex items-center justify-between pt-4 border-t border-outline-variant/20">
<div class="flex items-center gap-2">
<div class="w-6 h-6 rounded-full bg-secondary-container flex items-center justify-center">
<span class="text-[10px] font-bold text-on-secondary-container">Y</span>
</div>
<span class="text-[12px] font-label font-medium text-on-surface-variant">3 Reviewers</span>
</div>
<div class="flex items-center gap-1 text-on-surface-variant">
<span class="material-symbols-outlined text-[16px]" data-icon="chat_bubble_outline">chat_bubble_outline</span>
<span class="text-[12px] font-label font-medium">2 Comments</span>
</div>
</div>
</article>
<!-- Card 3 -->
<article class="bg-surface-container-lowest rounded-xl p-7 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/20 active:scale-[0.98]">
<div class="flex justify-between items-start mb-4">
<span class="px-2.5 py-0.5 rounded-full bg-surface-container-highest text-[10px] font-label font-bold uppercase tracking-widest text-secondary">Public</span>
<span class="material-symbols-outlined text-secondary/40 text-sm" data-icon="more_vert">more_vert</span>
</div>
<h2 class="text-[24px] font-headline font-bold leading-tight mb-3 text-on-surface">The Restorative Nap-Pod</h2>
<p class="text-[14px] text-on-surface-variant line-clamp-2 leading-relaxed mb-6 font-medium">Micro-rentable sensory pods in transport hubs featuring white noise, air filtration, and 20-minute cycle lighting.</p>
<div class="flex items-center gap-6 mb-8">
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#10B981" stroke-dasharray="113" stroke-dashoffset="10" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">92</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Original</span>
</div>
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#F59E0B" stroke-dasharray="113" stroke-dashoffset="70" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">38</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Feasible</span>
</div>
<div class="flex flex-col items-center gap-1.5">
<div class="relative w-11 h-11 flex items-center justify-center">
<svg class="w-full h-full -rotate-90">
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#f2ece4" stroke-width="3"></circle>
<circle cx="22" cy="22" fill="transparent" r="18" stroke="#3B82F6" stroke-dasharray="113" stroke-dashoffset="30" stroke-linecap="round" stroke-width="3"></circle>
</svg>
<span class="absolute text-[10px] font-bold text-on-surface">74</span>
</div>
<span class="text-[9px] font-label font-semibold text-secondary uppercase tracking-tighter">Impact</span>
</div>
</div>
<div class="flex items-center justify-between pt-4 border-t border-outline-variant/20">
<div class="flex items-center gap-2">
<img alt="Reviewer" class="w-6 h-6 rounded-full border border-outline-variant/40" data-alt="warm portrait of a creative professional woman in a bright, airy designer studio setting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAxSxA8Sd3Qel0EhbfeFtk2qtmpgeP1GwBzndFaxixxPTKpavVDE6APrhFCsT9SQGBGsemzkjhTndPbyrn71Chw_n30Fg8uk8KNxo2BVXjxfKG0GlefeHFprDwtAVtqGI0Z8Cyd9iETC7GEkfOnfWDYgkGKqAo0_ToFzsCjcLFoDx2U5nG9sgujgF8TrZ5LBOlZ-0vmx7u28oYGnG4ko4Ly77zLj76z40119L9Be4xu0e_-AVGBzVYsF7PqwVgjLMYYBA8GdHyE3hkP"/>
<span class="text-[12px] font-label font-medium text-on-surface-variant">42 Reviewers</span>
</div>
<div class="flex items-center gap-1 text-on-surface-variant">
<span class="material-symbols-outlined text-[16px]" data-icon="chat_bubble_outline">chat_bubble_outline</span>
<span class="text-[12px] font-label font-medium">31 Comments</span>
</div>
</div>
</article>
</div>
</main>
<!-- FAB for New Idea -->
<button class="fixed right-6 bottom-24 w-14 h-14 bg-primary text-on-primary rounded-full shadow-lg flex items-center justify-center active:scale-90 transition-transform z-50">
<span class="material-symbols-outlined" data-icon="add">add</span>
</button>
<!-- BottomNavBar -->
<nav class="fixed bottom-0 left-0 w-full z-50 flex justify-around items-center px-4 pb-safe h-20 bg-[#faf5ee]/95 dark:bg-stone-950/95 backdrop-blur-md border-t border-[#d8d0c8]/60 dark:border-stone-800 shadow-[0_-2px_16px_rgba(58,48,42,0.04)]">
<a class="flex flex-col items-center justify-center text-[#c2652a] dark:text-[#d4824d] scale-110 transition-transform tap-highlight-transparent" href="#">
<span class="material-symbols-outlined" data-icon="dynamic_feed" style="font-variation-settings: 'FILL' 1;">dynamic_feed</span>
<span class="text-[11px] font-sans font-medium Manrope uppercase tracking-wider mt-1">Feed</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#c2652a] dark:hover:text-[#d4824d] transition-all tap-highlight-transparent" href="#">
<span class="material-symbols-outlined" data-icon="explore">explore</span>
<span class="text-[11px] font-sans font-medium Manrope uppercase tracking-wider mt-1">Explore</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#c2652a] dark:hover:text-[#d4824d] transition-all tap-highlight-transparent" href="#">
<span class="material-symbols-outlined" data-icon="lightbulb">lightbulb</span>
<span class="text-[11px] font-sans font-medium Manrope uppercase tracking-wider mt-1">Insights</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#c2652a] dark:hover:text-[#d4824d] transition-all tap-highlight-transparent" href="#">
<span class="material-symbols-outlined" data-icon="person">person</span>
<span class="text-[11px] font-sans font-medium Manrope uppercase tracking-wider mt-1">Profile</span>
</a>
</nav>
</body></html>

<!-- Invite Modal (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "primary-fixed-dim": "#f0a878",
              "inverse-on-surface": "#faf5ee",
              "surface-container-lowest": "#ffffff",
              "primary-container": "#e08850",
              "on-tertiary-fixed": "#2e1515",
              "on-tertiary": "#ffffff",
              "primary-fixed": "#fbe8d8",
              "on-secondary-fixed-variant": "#504840",
              "on-surface": "#3a302a",
              "secondary-container": "#eae2da",
              "on-error": "#ffffff",
              "primary": "#c2652a",
              "error-container": "#fce4e0",
              "tertiary": "#8c3c3c",
              "surface-tint": "#c2652a",
              "tertiary-fixed": "#fce0e0",
              "surface-container-high": "#ece6dc",
              "on-secondary-container": "#605850",
              "on-primary-fixed-variant": "#8a4518",
              "on-error-container": "#7a1a10",
              "on-primary-fixed": "#401a08",
              "on-tertiary-fixed-variant": "#6e3030",
              "surface-dim": "#dcd6cc",
              "surface": "#faf5ee",
              "outline": "#9a9088",
              "surface-container": "#f2ece4",
              "on-primary-container": "#fbe8d8",
              "secondary-fixed-dim": "#cec6be",
              "outline-variant": "#d8d0c8",
              "on-background": "#3a302a",
              "tertiary-fixed-dim": "#e8a0a0",
              "on-secondary": "#ffffff",
              "surface-container-highest": "#e6e0d6",
              "on-tertiary-container": "#3a2020",
              "surface-container-low": "#f6f0e8",
              "on-secondary-fixed": "#2a2420",
              "inverse-primary": "#f0a878",
              "on-surface-variant": "#605850",
              "background": "#faf5ee",
              "secondary": "#78706a",
              "secondary-fixed": "#eae2da",
              "inverse-surface": "#3a302a",
              "surface-variant": "#ece6dc",
              "surface-bright": "#faf5ee",
              "on-primary": "#ffffff",
              "error": "#c0392b",
              "tertiary-container": "#d47070"
            },
            fontFamily: {
              "headline": ["Eb Garamond"],
              "body": ["Manrope"],
              "label": ["Manrope"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body { font-family: 'Manrope', sans-serif; }
        h1, h2, h3 { font-family: 'Eb Garamond', serif; }
        .bottom-sheet-shadow {
            box-shadow: 0 -8px 24px rgba(58, 48, 42, 0.08);
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-surface antialiased overflow-hidden">
<!-- Background Content (Simulated Feed) -->
<header class="bg-[#faf5ee] dark:bg-stone-950 border-b border-stone-200/60 dark:border-stone-800/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)] fixed top-0 w-full z-10 flex justify-between items-center px-6 py-4">
<div class="flex items-center gap-2">
<span class="material-symbols-outlined text-[#c2652a] dark:text-orange-500" data-icon="lightbulb">lightbulb</span>
<span class="font-serif italic text-2xl tracking-tight text-[#c2652a] dark:text-orange-400">Ideole</span>
</div>
<div class="h-8 w-8 rounded-full bg-surface-container-highest overflow-hidden border border-outline-variant">
<img class="h-full w-full object-cover" data-alt="Portrait of a creative professional woman in warm studio lighting with a soft linen background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBu50JB3XLRy9B9pBbU2LHgj9mVQQP61omM4UyMfKs_VZs20sp_jQz5rXBfNXe8bBqayoKxsAOBiTLrrUt3SfRm-LtAZvMYLQEXOYvplh4ZQvHJwdH9DdSdi_HEzs_j9zBHwltDgDnddFrQFP3FDtB3UHRu2OIqdn-uIZMmoezpmRKKnuvBzL5BDkvE61OabV9Txo7fDSSE4rm0EMh4aV6e7qhyyfkL-NAon2g6ypcyHeU6ZMOJ0rz_OVUeSskWu2JtPsKXnUWnGdUB"/>
</div>
</header>
<main class="pt-20 px-6 space-y-8 opacity-40 select-none">
<section class="space-y-4">
<div class="h-48 w-full bg-surface-container-low rounded-xl overflow-hidden">
<img class="w-full h-full object-cover" data-alt="Minimalist workspace with a ceramic cup, notebook, and dried flowers in warm morning sunlight" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCBU4oAFLS_Lc39im1wzZElt1jOYRfHC9BBj0kYdG3Qw8Cm3OmkCW_CX_xo3wtiGHq6Hmxt41d5MCvi6YuUQci5qO05y5QG1EhLjItPX3fAWytFlx4cG76L0aopkCUoyTGQc5-1W1YZY72hd6tNmYX6PSM9pu3Cy6GEJ3h8n6UMYRGUGL7uP2ZUcMIUTJfKq6JaSdSc_ncDOACHDL_kCBOo9kFcSmez6cH8-59PolwhddQXPk9OLkqADDQOiYGWZCt00owLLqhaW9Lj"/>
</div>
<h1 class="text-3xl font-serif">The Art of Ideation</h1>
<p class="text-on-surface-variant leading-relaxed">Gathering the right minds for a project is as much an art as the creation itself...</p>
</section>
<div class="grid grid-cols-2 gap-4">
<div class="h-32 bg-surface-container rounded-xl"></div>
<div class="h-32 bg-surface-container rounded-xl"></div>
</div>
</main>
<!-- Modal Backdrop -->
<div class="fixed inset-0 bg-on-surface/20 backdrop-blur-[2px] z-40"></div>
<!-- Bottom Sheet Content -->
<div class="fixed bottom-0 left-0 right-0 bg-surface rounded-t-[32px] bottom-sheet-shadow z-50 flex flex-col max-h-[813px] transition-transform">
<!-- Handle Bar -->
<div class="flex justify-center py-4">
<div class="w-12 h-1.5 bg-outline-variant/40 rounded-full"></div>
</div>
<!-- Header -->
<div class="px-8 pb-4">
<h2 class="text-3xl font-serif text-on-surface mb-1">Invite Collaborators</h2>
<p class="text-on-surface-variant font-body text-sm">Add thinkers and makers to your project.</p>
</div>
<!-- Search Section -->
<div class="px-8 mb-6">
<div class="relative group">
<div class="absolute inset-y-0 left-4 flex items-center pointer-events-none">
<span class="material-symbols-outlined text-outline group-focus-within:text-primary transition-colors" data-icon="search">search</span>
</div>
<input class="w-full bg-surface-container-low border-none rounded-2xl py-4 pl-12 pr-4 text-on-surface placeholder:text-outline focus:ring-2 focus:ring-primary/20 transition-all outline-none font-body" placeholder="Search by name or email..." type="text"/>
</div>
</div>
<!-- Invited List Scroll Area -->
<div class="px-8 flex-1 overflow-y-auto min-h-[300px] space-y-6 pb-24">
<div class="space-y-4">
<h3 class="text-xs font-bold font-body uppercase tracking-widest text-outline">Active Collaborators</h3>
<!-- Collaborator Item: Joined -->
<div class="flex items-center justify-between group">
<div class="flex items-center gap-4">
<div class="relative">
<img class="w-12 h-12 rounded-full object-cover border-2 border-surface" data-alt="Smiling man with beard wearing warm earth-toned sweater in a minimalist indoor setting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCytz9IXls7h5O9G-nw_b0-RUI85YSA3YBYt0bqSnJSRF1eC2eH2QjqnAGo2nBo8VX_H_XdccY_Jj22pnTEDnMNxtlxkS55d_tnCJ55IMybGFDV210s18T3SC8vaPBI9lE3W9yZOPyyDyyO0jj9jZtWnnlGw_iQHVZkZjgud5IJ3wsffph5JBADSZVILjt6bvZQ2r6HjP8DjBgp4lTjBQxL0ZM7tnjTFTdaXL40ZZ2YsemvL9Ytj9hjueH6RVZnSPyIWs8pQQd0i5n9"/>
<div class="absolute bottom-0 right-0 w-3.5 h-3.5 bg-primary rounded-full border-2 border-surface"></div>
</div>
<div>
<p class="font-body font-semibold text-on-surface">Julian Thorne</p>
<p class="text-xs text-on-surface-variant">julian@studio.ideole</p>
</div>
</div>
<span class="px-3 py-1 bg-primary/10 text-primary text-[10px] font-bold font-body uppercase tracking-wider rounded-full">Joined</span>
</div>
<!-- Collaborator Item: Pending -->
<div class="flex items-center justify-between">
<div class="flex items-center gap-4 opacity-70">
<div class="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container font-serif text-xl italic">
                            EH
                        </div>
<div>
<p class="font-body font-semibold text-on-surface">Elena Hadrick</p>
<p class="text-xs text-on-surface-variant">elena.h@design.com</p>
</div>
</div>
<span class="px-3 py-1 bg-surface-container-highest text-on-surface-variant text-[10px] font-bold font-body uppercase tracking-wider rounded-full">Pending</span>
</div>
<!-- Collaborator Item: Joined -->
<div class="flex items-center justify-between">
<div class="flex items-center gap-4">
<img class="w-12 h-12 rounded-full object-cover border-2 border-surface" data-alt="Headshot of a creative woman with glasses in soft natural lighting, earthy aesthetic" src="https://lh3.googleusercontent.com/aida-public/AB6AXuD_rap0VTX8qNDlQlpVeK5_L3W1LFgqlLB5DF6peedX4Y6Ss0yUT3sg3dp2_Bvz9N_poCkRrffx1ypT8mbdHRJHghhOGS-4v7h5yrUn7BbPKhcm-exV-GsXXW75cPFAdQngErqlyMDAnqYdqs7OVIwCT59Rm5eCHRbkaQTIWeH3p4Ejj6kJkEMcqlcu50GuvbWtq6sFlYeL-qsl81gPmF4tOQLYtArj7zevISY8Obj10IMZ52YpXSdZPbe2FCcrxA2Pnv5rARr4afwb"/>
<div>
<p class="font-body font-semibold text-on-surface">Sasha Vane</p>
<p class="text-xs text-on-surface-variant">svane@ideole.app</p>
</div>
</div>
<span class="px-3 py-1 bg-primary/10 text-primary text-[10px] font-bold font-body uppercase tracking-wider rounded-full">Joined</span>
</div>
</div>
<!-- Suggestions -->
<div class="space-y-4 pt-4 border-t border-outline-variant/30">
<h3 class="text-xs font-bold font-body uppercase tracking-widest text-outline">Suggested</h3>
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full border-2 border-dashed border-outline-variant flex items-center justify-center text-outline">
<span class="material-symbols-outlined" data-icon="add">add</span>
</div>
<div class="flex-1">
<p class="font-body font-semibold text-on-surface">Invite via link</p>
<p class="text-xs text-on-surface-variant">Anyone with the link can view</p>
</div>
<button class="text-primary p-2">
<span class="material-symbols-outlined" data-icon="content_copy">content_copy</span>
</button>
</div>
</div>
</div>
<!-- Sticky Footer Action -->
<div class="absolute bottom-0 left-0 right-0 px-8 pb-10 pt-4 bg-gradient-to-t from-surface via-surface to-transparent">
<button class="w-full bg-primary text-on-primary py-4 rounded-2xl font-body font-bold text-sm tracking-wide uppercase transition-all active:scale-[0.98] shadow-lg shadow-primary/20">
                Send Invites
            </button>
</div>
</div>
<!-- Hidden Navigation Shell (Suppressed for focused modal task) -->
<nav class="hidden md:flex fixed top-0 left-0 h-full w-20 flex-col items-center py-8 space-y-8 bg-surface border-r border-outline-variant/30 z-0">
<!-- Background Navigation elements for context -->
</nav>
<!-- Bottom NavBar - Hidden as per suppression logic for modal/linear task -->
<div class="md:hidden fixed bottom-0 left-0 w-full bg-[#faf5ee]/90 backdrop-blur-md border-t border-stone-200/60 z-30 flex justify-around items-center px-4 pb-8 pt-2 opacity-20 pointer-events-none">
<div class="flex flex-col items-center justify-center text-stone-400">
<span class="material-symbols-outlined" data-icon="home">home</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase">Feed</span>
</div>
<div class="flex flex-col items-center justify-center text-stone-400">
<span class="material-symbols-outlined" data-icon="explore">explore</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase">Explore</span>
</div>
<div class="flex flex-col items-center justify-center text-stone-400">
<span class="material-symbols-outlined" data-icon="insights">insights</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase">Insights</span>
</div>
<div class="flex flex-col items-center justify-center text-[#c2652a]">
<span class="material-symbols-outlined" data-icon="person">person</span>
<span class="font-sans text-[11px] font-medium tracking-wide uppercase">Profile</span>
</div>
</div>
</body></html>

<!-- Manage Reviewers (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Manage Reviewers - Ideole</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&amp;family=Manrope:wght@300;400;500;600;700&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "surface-variant": "#ece6dc",
              "on-primary-container": "#fbe8d8",
              "surface-container-low": "#f6f0e8",
              "error": "#c0392b",
              "surface-bright": "#faf5ee",
              "secondary-container": "#eae2da",
              "on-primary": "#ffffff",
              "surface-tint": "#c2652a",
              "on-primary-fixed": "#401a08",
              "on-tertiary-fixed": "#2e1515",
              "on-surface-variant": "#605850",
              "tertiary-fixed": "#fce0e0",
              "surface-container-lowest": "#ffffff",
              "on-primary-fixed-variant": "#8a4518",
              "primary-container": "#e08850",
              "surface-container-high": "#ece6dc",
              "secondary-fixed-dim": "#cec6be",
              "outline-variant": "#d8d0c8",
              "tertiary-fixed-dim": "#e8a0a0",
              "on-background": "#3a302a",
              "primary": "#c2652a",
              "secondary": "#78706a",
              "on-tertiary": "#ffffff",
              "surface-dim": "#dcd6cc",
              "on-error-container": "#7a1a10",
              "on-secondary-container": "#605850",
              "on-secondary": "#ffffff",
              "inverse-surface": "#3a302a",
              "primary-fixed-dim": "#f0a878",
              "surface-container-highest": "#e6e0d6",
              "inverse-primary": "#f0a878",
              "tertiary": "#8c3c3c",
              "on-error": "#ffffff",
              "on-secondary-fixed-variant": "#504840",
              "on-secondary-fixed": "#2a2420",
              "secondary-fixed": "#eae2da",
              "inverse-on-surface": "#faf5ee",
              "on-tertiary-container": "#3a2020",
              "background": "#faf5ee",
              "tertiary-container": "#d47070",
              "outline": "#9a9088",
              "surface-container": "#f2ece4",
              "primary-fixed": "#fbe8d8",
              "error-container": "#fce4e0",
              "surface": "#faf5ee",
              "on-tertiary-fixed-variant": "#6e3030",
              "on-surface": "#3a302a"
            },
            fontFamily: {
              "headline": ["Eb Garamond", "serif"],
              "body": ["Manrope", "sans-serif"],
              "label": ["Manrope", "sans-serif"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            display: inline-block;
            line-height: 1;
        }
        body {
            font-family: 'Manrope', sans-serif;
            background-color: #faf5ee;
            color: #3a302a;
        }
        .serif-text { font-family: 'Eb Garamond', serif; }
        .tap-highlight-transparent { -webkit-tap-highlight-color: transparent; }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-background min-h-screen flex flex-col">
<!-- TopAppBar -->
<header class="fixed top-0 w-full z-50 bg-[#faf5ee] dark:bg-stone-950 border-b border-[#d8d0c8]/60 dark:border-stone-800 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
<div class="flex justify-between items-center w-full px-6 h-16">
<div class="flex items-center gap-4">
<button class="text-[#c2652a] hover:bg-[#c2652a]/5 transition-colors p-2 rounded-full">
<span class="material-symbols-outlined" data-icon="arrow_back">arrow_back</span>
</button>
<h1 class="font-serif text-3xl font-medium tracking-tight text-[#3a302a]">Manage Reviewers</h1>
</div>
<button class="text-[#c2652a] hover:bg-[#c2652a]/5 transition-colors p-2 rounded-full">
<span class="material-symbols-outlined" data-icon="more_vert">more_vert</span>
</button>
</div>
</header>
<main class="flex-grow pt-24 pb-28 px-6 max-w-2xl mx-auto w-full">
<!-- Search Section -->
<section class="mb-8">
<div class="relative group">
<span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-outline">search</span>
<input class="w-full bg-surface-container-lowest border border-outline-variant rounded-xl py-4 pl-12 pr-4 focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition-all placeholder:text-outline font-body" placeholder="Search by name or expertise..." type="text"/>
</div>
</section>
<!-- Filters Section -->
<section class="mb-10 overflow-x-auto no-scrollbar">
<div class="flex gap-3 pb-2">
<button class="px-6 py-2 rounded-full bg-primary text-on-primary font-label text-sm font-semibold tracking-wide shadow-sm">All</button>
<button class="px-6 py-2 rounded-full border border-outline-variant bg-surface-container-lowest text-on-surface-variant font-label text-sm font-semibold tracking-wide hover:border-primary transition-colors">Internal</button>
<button class="px-6 py-2 rounded-full border border-outline-variant bg-surface-container-lowest text-on-surface-variant font-label text-sm font-semibold tracking-wide hover:border-primary transition-colors">External</button>
<button class="px-6 py-2 rounded-full border border-outline-variant bg-surface-container-lowest text-on-surface-variant font-label text-sm font-semibold tracking-wide hover:border-primary transition-colors">Experts</button>
</div>
</section>
<!-- Reviewers List -->
<section class="space-y-6">
<!-- Reviewer Card 1 -->
<div class="bg-surface-container-lowest rounded-xl p-6 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex items-center gap-5 group">
<div class="w-16 h-16 rounded-full overflow-hidden border-2 border-primary/10 flex-shrink-0">
<img alt="Julian Vane" class="w-full h-full object-cover" data-alt="close-up portrait of a mature man with thoughtful expression in warm afternoon sunlight, soft bokeh background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDaj8kanYcgi27196VsfPOywpIYzpZ2cCHeP_Nqx8Un_wZ-w9tcvJbWfjPuw7mUMxC0EQQQYs-MBqYoUxelEMFp0XVOwlqh2sOhRlPD_VI7Jco8uLX6ZTPfD6dznVgQfM5yNF_UXieRrCBaXcI4xNHqZANidA1l4Pn22w88nTVuaylW8aPeda33uyMFKOMnxR6nBkPLF7oUR3FUkv9hzf_OeajYX1FliuUWwDu1VrKHOcq4c9WIWSHWpmc-z0dNNvAd3cr51jfDEZUn"/>
</div>
<div class="flex-grow">
<div class="flex justify-between items-start">
<div>
<h3 class="font-serif text-xl font-semibold text-on-surface leading-tight">Julian Vane</h3>
<p class="font-body text-sm text-secondary font-medium mt-0.5">Senior Architect • Sustainable Design</p>
</div>
<button class="text-outline hover:text-primary transition-colors">
<span class="material-symbols-outlined" data-icon="more_horiz">more_horiz</span>
</button>
</div>
<div class="mt-3 flex items-center gap-3">
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-primary-container/20 text-on-primary-fixed-variant">Joined</span>
<span class="text-[11px] font-label text-outline uppercase tracking-tighter">Activity: 2 days ago</span>
</div>
</div>
</div>
<!-- Reviewer Card 2 -->
<div class="bg-surface-container-lowest rounded-xl p-6 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex items-center gap-5 group">
<div class="w-16 h-16 rounded-full overflow-hidden border-2 border-primary/10 flex-shrink-0">
<img alt="Elena Moretti" class="w-full h-full object-cover" data-alt="portrait of a woman with elegant professional style, warm studio lighting, neutral earthy background, soft minimalist aesthetic" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDRIMjq6TIzFSwds2FfmIGyqyBYhaiCkVXhxY2EjliDb1_qTlCPgLFYzUfw24FseaPEmCgHAr4cQGe16h1V7ruqKCm4QK0xrRToMgDDJGQK1u5Jc3BO6LklRUx4oDTOUONHZ6D6FV9Sxy2IAF4RTkTIcMPIgW2YZWr4d8XLZFVEbO5PYxhG37vdmh3yHUlToAKv9R9W4W-yC_YzFlubzpAF6cBM48r2QabtH8pc6Ojfqy4q2AOgecO37BDi7fo3-swn3U51AxY5E_yu"/>
</div>
<div class="flex-grow">
<div class="flex justify-between items-start">
<div>
<h3 class="font-serif text-xl font-semibold text-on-surface leading-tight">Elena Moretti</h3>
<p class="font-body text-sm text-secondary font-medium mt-0.5">Urban Planner • Policy Specialist</p>
</div>
<button class="text-outline hover:text-primary transition-colors">
<span class="material-symbols-outlined" data-icon="more_horiz">more_horiz</span>
</button>
</div>
<div class="mt-3 flex items-center gap-3">
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-tertiary-fixed text-on-tertiary-fixed-variant">Pending</span>
<span class="text-[11px] font-label text-outline uppercase tracking-tighter">Invited: Oct 12</span>
</div>
</div>
</div>
<!-- Reviewer Card 3 -->
<div class="bg-surface-container-lowest rounded-xl p-6 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex items-center gap-5 group">
<div class="w-16 h-16 rounded-full overflow-hidden border-2 border-primary/10 flex-shrink-0">
<img alt="Marcus Chen" class="w-full h-full object-cover" data-alt="headshot of a man with creative glasses, warm indoor lighting with shadows, modern minimal professional portrait" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBew9weRQpk45PPfOBNuaNEnq4z1fdZoSKilLETqUTP1-U4xGkLBFpbn4V_QZnNi6E0OAfkXwmqsy3cjeBqXIuuCqDzablIi1nf7M7QP34nHGIP1sZBMM-AX_5E5FEun0xm1Z4sZJD3hwVrWRP4FFMtXo-ZDs0FDQazY-alCNDynziych6ckK1TYd7iiBhl7HhitSJdCU_jDZ_bvj2rBXY3HyLsJn8t_6zi-6SMO7BAkuhpW_XztByg0mPFmUwg-sQlrUhokRlRiJld"/>
</div>
<div class="flex-grow">
<div class="flex justify-between items-start">
<div>
<h3 class="font-serif text-xl font-semibold text-on-surface leading-tight">Marcus Chen</h3>
<p class="font-body text-sm text-secondary font-medium mt-0.5">Lead Developer • API Governance</p>
</div>
<button class="text-outline hover:text-primary transition-colors">
<span class="material-symbols-outlined" data-icon="more_horiz">more_horiz</span>
</button>
</div>
<div class="mt-3 flex items-center gap-3">
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-primary-container/20 text-on-primary-fixed-variant">Joined</span>
<span class="text-[11px] font-label text-outline uppercase tracking-tighter">Activity: Today</span>
</div>
</div>
</div>
<!-- Reviewer Card 4 (External Expert) -->
<div class="bg-surface-container-lowest rounded-xl p-6 shadow-[0_2px_16px_rgba(58,48,42,0.04)] border border-outline-variant/30 flex items-center gap-5 group">
<div class="w-16 h-16 rounded-full overflow-hidden border-2 border-primary/10 flex-shrink-0">
<img alt="Sarah Jenkins" class="w-full h-full object-cover" data-alt="close-up of a smiling woman in a linen shirt, outdoors with warm golden hour lighting and soft blurred foliage" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDouXLWF8AbDroHLoW5bZQ54ePalPJhZfia96-T6AmpZiwl8Njnf7QeM6yVDRZ2updMHbuvCBGMkwFWerzYNBCxK-bDC5fMHmZSrBaSboBJU2C3O-ccToyP4xhd8Qrd3uo7XxmlQDkfoVreMH6n40RNpBZ0ocDBhbYE1q0EUeWGwObPIcttEVNV6-BiCOQLYxgVJ979rhkvywYk1kYQiiSHrloga8CwmTS9mxGMYZ7LdJkYwv4_ocu9uC_psoC-Hx0tWj_wAMiXTVwH"/>
</div>
<div class="flex-grow">
<div class="flex justify-between items-start">
<div>
<h3 class="font-serif text-xl font-semibold text-on-surface leading-tight">Sarah Jenkins</h3>
<p class="font-body text-sm text-secondary font-medium mt-0.5">External • UX Ethnography</p>
</div>
<button class="text-outline hover:text-primary transition-colors">
<span class="material-symbols-outlined" data-icon="more_horiz">more_horiz</span>
</button>
</div>
<div class="mt-3 flex items-center gap-3">
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-primary-container/20 text-on-primary-fixed-variant">Joined</span>
<span class="text-[11px] font-label text-outline uppercase tracking-tighter">Activity: 1 week ago</span>
</div>
</div>
</div>
</section>
</main>
<!-- FAB -->
<button class="fixed right-6 bottom-24 w-14 h-14 bg-primary text-on-primary rounded-2xl shadow-lg flex items-center justify-center transition-transform active:scale-90 z-40">
<span class="material-symbols-outlined text-3xl" data-icon="add">add</span>
</button>
<!-- BottomNavBar -->
<nav class="fixed bottom-0 w-full z-50 bg-[#faf5ee]/95 dark:bg-stone-950/95 backdrop-blur-md border-t border-[#d8d0c8]/60 dark:border-stone-800 flex justify-around items-center h-20 px-4 pb-safe tap-highlight-transparent">
<div class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#8c3c3c] transition-colors">
<span class="material-symbols-outlined" data-icon="folder">folder</span>
<span class="font-sans text-[10px] font-semibold uppercase tracking-wider mt-1">Projects</span>
</div>
<!-- Active State: Reviewers -->
<div class="flex flex-col items-center justify-center text-[#c2652a] dark:text-[#d48450] scale-110 transition-transform">
<span class="material-symbols-outlined" data-icon="group" style="font-variation-settings: 'FILL' 1;">group</span>
<span class="font-sans text-[10px] font-semibold uppercase tracking-wider mt-1">Reviewers</span>
</div>
<div class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#8c3c3c] transition-colors">
<span class="material-symbols-outlined" data-icon="analytics">analytics</span>
<span class="font-sans text-[10px] font-semibold uppercase tracking-wider mt-1">Insights</span>
</div>
<div class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#8c3c3c] transition-colors">
<span class="material-symbols-outlined" data-icon="settings">settings</span>
<span class="font-sans text-[10px] font-semibold uppercase tracking-wider mt-1">Settings</span>
</div>
</nav>
</body></html>

<!-- Group Details (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
<title>Regenerative Cities - Group Details</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=EB+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "secondary-container": "#eae2da",
              "background": "#faf5ee",
              "tertiary": "#8c3c3c",
              "inverse-surface": "#3a302a",
              "inverse-on-surface": "#faf5ee",
              "on-primary-container": "#fbe8d8",
              "surface-bright": "#faf5ee",
              "secondary-fixed-dim": "#cec6be",
              "on-background": "#3a302a",
              "on-primary-fixed-variant": "#8a4518",
              "on-primary-fixed": "#401a08",
              "outline": "#9a9088",
              "on-primary": "#ffffff",
              "primary-fixed": "#fbe8d8",
              "on-error": "#ffffff",
              "tertiary-fixed-dim": "#e8a0a0",
              "secondary": "#78706a",
              "on-tertiary": "#ffffff",
              "surface-container-lowest": "#ffffff",
              "on-tertiary-fixed": "#2e1515",
              "surface-variant": "#ece6dc",
              "outline-variant": "#d8d0c8",
              "on-error-container": "#7a1a10",
              "inverse-primary": "#f0a878",
              "error-container": "#fce4e0",
              "surface-dim": "#dcd6cc",
              "on-tertiary-fixed-variant": "#6e3030",
              "on-surface-variant": "#605850",
              "on-secondary": "#ffffff",
              "error": "#c0392b",
              "surface-container-highest": "#e6e0d6",
              "on-tertiary-container": "#3a2020",
              "on-secondary-fixed-variant": "#504840",
              "surface-container-low": "#f6f0e8",
              "primary-fixed-dim": "#f0a878",
              "tertiary-fixed": "#fce0e0",
              "secondary-fixed": "#eae2da",
              "surface": "#faf5ee",
              "on-surface": "#3a302a",
              "surface-tint": "#c2652a",
              "surface-container-high": "#ece6dc",
              "primary-container": "#e08850",
              "on-secondary-fixed": "#2a2420",
              "on-secondary-container": "#605850",
              "tertiary-container": "#d47070",
              "primary": "#c2652a",
              "surface-container": "#f2ece4"
            },
            fontFamily: {
              "headline": ["EB Garamond"],
              "body": ["Manrope"],
              "label": ["Manrope"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            -webkit-tap-highlight-color: transparent;
            scroll-behavior: smooth;
        }
        .hide-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .hide-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-background font-body selection:bg-primary-fixed selection:text-on-primary-fixed">
<!-- TopAppBar -->
<nav class="fixed top-0 w-full z-50 bg-[#faf5ee] dark:bg-stone-950 border-b border-[#d8d0c8]/60 dark:border-stone-800 shadow-[0_2px_16px_rgba(58,48,42,0.04)] flex items-center justify-between px-6 h-16 w-full">
<div class="flex items-center gap-4">
<button class="text-[#c2652a] dark:text-[#d4824d] hover:bg-[#c2652a]/5 transition-colors p-2 rounded-full active:scale-95 duration-200">
<span class="material-symbols-outlined">arrow_back</span>
</button>
<h1 class="font-['EB_Garamond'] text-2xl tracking-tight dark:text-stone-100">Innovation Hub</h1>
</div>
<div class="flex items-center">
<button class="text-[#c2652a] dark:text-[#d4824d] hover:bg-[#c2652a]/5 transition-colors p-2 rounded-full active:scale-95 duration-200">
<span class="material-symbols-outlined">more_vert</span>
</button>
</div>
</nav>
<main class="pt-16 pb-32">
<!-- Hero Section -->
<section class="relative w-full aspect-[4/5] md:aspect-[16/7] overflow-hidden">
<img alt="Regenerative Cityscape" class="w-full h-full object-cover" data-alt="futuristic sustainable city with vertical gardens, solar panels, and soft golden sunset light illuminating modern wooden architecture" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBeOe1GCnT35T3nnQ_2LFWAriEJBb_VXlJzhCaKwSOoEUu-JuF1ksXc7ZJiuv0sgRNEwQuwdJ2njfcFJwkII7jxP4SlAe_i_tjRmtho_PYFih4U3WUmirnYf4W1pItyq8z4yyOjGDo4gj8ylgOLgS2RMzKx00X7K8jKvf7eJl660uFlbUzGLKVt1s578V3Z50mTgEiClTxu2RFzdJHlK5ZC6UpScwrg7mJNi6WC29jA1DbgzMJGOjPSQE2LOn09vSiEIEF66kqk9PYX"/>
<div class="absolute inset-0 bg-gradient-to-t from-background via-background/20 to-transparent"></div>
<div class="absolute bottom-0 left-0 w-full p-6 space-y-3">
<div class="inline-flex items-center px-3 py-1 bg-primary/10 border border-primary/20 rounded-full">
<span class="text-primary font-label text-xs font-bold uppercase tracking-widest">Active Community</span>
</div>
<h2 class="font-headline text-5xl leading-tight text-on-background">Regenerative Cities</h2>
<p class="font-body text-lg text-on-surface-variant max-w-md leading-relaxed">
                    Exploring circular economy frameworks and sustainable architecture for the next generation of living.
                </p>
</div>
</section>
<!-- Stats Row -->
<section class="px-6 mt-8">
<div class="grid grid-cols-3 gap-4 py-6 border-y border-outline-variant/60">
<div class="text-center space-y-1">
<p class="text-primary font-headline text-xl font-bold">2.4k</p>
<p class="text-on-surface-variant text-[10px] uppercase tracking-wider font-semibold">Visionaries</p>
</div>
<div class="text-center space-y-1 border-x border-outline-variant/60 px-2">
<p class="text-primary font-headline text-xl font-bold">142</p>
<p class="text-on-surface-variant text-[10px] uppercase tracking-wider font-semibold">Live Topics</p>
</div>
<div class="text-center space-y-1">
<p class="text-primary font-headline text-xl font-bold">2021</p>
<p class="text-on-surface-variant text-[10px] uppercase tracking-wider font-semibold">Founded</p>
</div>
</div>
</section>
<!-- About Section -->
<section class="px-6 mt-10 space-y-4">
<h3 class="font-headline text-2xl italic text-on-surface">The Vision</h3>
<div class="space-y-4 font-body text-on-surface-variant leading-relaxed">
<p>
                    Our mission is to redesign the urban environment as a living organism. We move beyond "sustainability"—which merely seeks to maintain—to "regeneration," which seeks to heal and enhance the ecosystems they inhabit.
                </p>
<p>
                    Join a collective of architects, urban planners, and policy makers dedicated to implementing closed-loop systems, biophilic design, and community-owned infrastructure in global metropolises.
                </p>
</div>
</section>
<!-- Focus Areas -->
<section class="mt-10">
<div class="px-6 flex justify-between items-end mb-4">
<h3 class="font-headline text-2xl italic text-on-surface">Focus Areas</h3>
<button class="text-primary font-label text-xs font-bold uppercase tracking-widest">See Strategy</button>
</div>
<div class="flex overflow-x-auto gap-3 px-6 hide-scrollbar">
<div class="flex-none bg-surface-container-low border border-outline-variant/40 px-5 py-4 rounded-xl space-y-2 w-48">
<span class="material-symbols-outlined text-primary">eco</span>
<p class="font-label text-sm font-bold text-on-surface">Circular Economy</p>
<p class="text-xs text-on-surface-variant leading-snug">Zero-waste supply chains and material lifecycles.</p>
</div>
<div class="flex-none bg-surface-container-low border border-outline-variant/40 px-5 py-4 rounded-xl space-y-2 w-48">
<span class="material-symbols-outlined text-primary">potted_plant</span>
<p class="font-label text-sm font-bold text-on-surface">Green Infrastructure</p>
<p class="text-xs text-on-surface-variant leading-snug">Integrating nature directly into the built form.</p>
</div>
<div class="flex-none bg-surface-container-low border border-outline-variant/40 px-5 py-4 rounded-xl space-y-2 w-48">
<span class="material-symbols-outlined text-primary">domain</span>
<p class="font-label text-sm font-bold text-on-surface">Urban Resilience</p>
<p class="text-xs text-on-surface-variant leading-snug">Adapting cities to withstand climate challenges.</p>
</div>
</div>
</section>
<!-- Founding Members -->
<section class="px-6 mt-12 mb-10">
<h3 class="font-headline text-2xl italic text-on-surface mb-6">Founding Council</h3>
<div class="space-y-6">
<div class="flex items-center gap-4">
<img alt="Council Member" class="w-14 h-14 rounded-full object-cover border-2 border-primary/20" data-alt="portrait of a middle-aged male architect with glasses in a light linen shirt, warm natural lighting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDE5dGyoVGykPV5o6Pj-cCA_ARcTM0Nh6e1Kpo6U-F7AFCD4bnvX_nYVb_xnN_K4V7Or30pLlVlF_gC8Iv9-Wjf73l4zgOmyFGUxkJzygCeAJg9Wm0O3WfChluoWJAvDD45ZZPf6D7lkvAOu56xmvX7g0uK92a2uY5671MKhFTK2zPm-Txl0zGl2WYA5bRIlgb31toBCszGHgwwObP-DD244Bjr9OsPKAHk_J5xFzNZqryDzy-BBrZ9ho_pnLJ1G2EFgn6I3DbaKH1q"/>
<div>
<p class="font-headline text-lg text-on-surface leading-none">Dr. Julian Thorne</p>
<p class="font-body text-xs text-on-surface-variant uppercase tracking-wide mt-1">Lead Architect, Circularity Lab</p>
</div>
</div>
<div class="flex items-center gap-4">
<img alt="Council Member" class="w-14 h-14 rounded-full object-cover border-2 border-primary/20" data-alt="portrait of a professional woman with a warm smile, wearing minimalist gold jewelry and a beige sweater" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCxo6FT2W4N2YNaHscgCtedPx4HLjHrPR5XIo5i6fFvjdR65AnY42NFNJ9aLMSKGGV4RgfLcBsQMROypWozneseHthgSlu4go9P2Bf7hQ7NLG_7RWwj9_fEl-ViTW6FDVSQBbCED8Z5BhFxNULmrgHcEs0rMR9FyVIXf6QNfGkkXbLOsgpajzL-isHhybWfFn72SxpaQmuG7PCuwvd3e99GW05PrrSjpCMj_J5ft8Kc4Zf_6MLFMRAHCpRDZFy475Hsj2h-8TrqMxN6"/>
<div>
<p class="font-headline text-lg text-on-surface leading-none">Elena Vasquez</p>
<p class="font-body text-xs text-on-surface-variant uppercase tracking-wide mt-1">Urban Ecologist &amp; Advisor</p>
</div>
</div>
<div class="flex items-center gap-4">
<img alt="Council Member" class="w-14 h-14 rounded-full object-cover border-2 border-primary/20" data-alt="portrait of a creative man with a beard in a sunlit studio, warm tones and soft focus background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCQzsPN6LuBuPRz7LoZnCBg1p9JJjWB31UJYXULIg0Tppg7sT5DTMiH5yK0R2p4BpXKAVZFC6BDoupO_rD-NvitJKU9Lxpz1DbswMHKbschFrgva6lx4QhUj3P6w0-LIKUR_41hFSfsvxoTRRbZqRjLsOu_lz03wbMcwYZjXt3XJm-ZyLnlq_hmg3j7pfSZCDxHEVUZ4Ia4tle3h_utCeZ8ExhoMHQDSIWQkBdmjZQpA93HHvL505kMqtweAjF2ydiTEnsMjwuhHklv"/>
<div>
<p class="font-headline text-lg text-on-surface leading-none">Marcus Wei</p>
<p class="font-body text-xs text-on-surface-variant uppercase tracking-wide mt-1">Sustainable Materials Lead</p>
</div>
</div>
</div>
</section>
<!-- Primary Action -->
<section class="px-6 space-y-4">
<button class="w-full bg-primary text-on-primary font-label py-4 rounded-xl font-bold uppercase tracking-widest shadow-lg shadow-primary/20 active:scale-95 transition-transform">
                Request to Join
            </button>
<div class="grid grid-cols-2 gap-4">
<button class="border border-outline-variant py-3 rounded-lg font-label text-xs font-bold uppercase tracking-widest text-on-surface-variant hover:bg-surface-container transition-colors">
                    Guidelines
                </button>
<button class="border border-outline-variant py-3 rounded-lg font-label text-xs font-bold uppercase tracking-widest text-on-surface-variant hover:bg-surface-container transition-colors">
                    Projects
                </button>
</div>
</section>
</main>
<!-- BottomNavBar -->
<nav class="fixed bottom-0 left-0 w-full z-50 bg-[#faf5ee]/95 backdrop-blur-md dark:bg-stone-950/95 border-t border-[#d8d0c8]/60 dark:border-stone-800 shadow-[0_-4px_20px_rgba(58,48,42,0.03)] flex justify-around items-center h-20 px-4 pb-safe rounded-t-2xl">
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#8c3c3c] transition-all active:translate-y-0.5 duration-150" href="#">
<span class="material-symbols-outlined">explore</span>
<span class="font-['Manrope'] text-[10px] uppercase tracking-widest font-semibold mt-1">Explore</span>
</a>
<a class="flex flex-col items-center justify-center text-[#c2652a] dark:text-[#d4824d] scale-110 active:translate-y-0.5 duration-150" href="#">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">group</span>
<span class="font-['Manrope'] text-[10px] uppercase tracking-widest font-semibold mt-1">Collab</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#8c3c3c] transition-all active:translate-y-0.5 duration-150" href="#">
<span class="material-symbols-outlined">lightbulb</span>
<span class="font-['Manrope'] text-[10px] uppercase tracking-widest font-semibold mt-1">Insights</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400 dark:text-stone-600 hover:text-[#8c3c3c] transition-all active:translate-y-0.5 duration-150" href="#">
<span class="material-symbols-outlined">person</span>
<span class="font-['Manrope'] text-[10px] uppercase tracking-widest font-semibold mt-1">Profile</span>
</a>
</nav>
</body></html>

<!-- Rating Input (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport"/>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "primary-fixed-dim": "#f0a878",
              "inverse-on-surface": "#faf5ee",
              "surface-container-lowest": "#ffffff",
              "primary-container": "#e08850",
              "on-tertiary-fixed": "#2e1515",
              "on-tertiary": "#ffffff",
              "primary-fixed": "#fbe8d8",
              "on-secondary-fixed-variant": "#504840",
              "on-surface": "#3a302a",
              "secondary-container": "#eae2da",
              "on-error": "#ffffff",
              "primary": "#c2652a",
              "error-container": "#fce4e0",
              "tertiary": "#8c3c3c",
              "surface-tint": "#c2652a",
              "tertiary-fixed": "#fce0e0",
              "surface-container-high": "#ece6dc",
              "on-secondary-container": "#605850",
              "on-primary-fixed-variant": "#8a4518",
              "on-error-container": "#7a1a10",
              "on-primary-fixed": "#401a08",
              "on-tertiary-fixed-variant": "#6e3030",
              "surface-dim": "#dcd6cc",
              "surface": "#faf5ee",
              "outline": "#9a9088",
              "surface-container": "#f2ece4",
              "on-primary-container": "#fbe8d8",
              "secondary-fixed-dim": "#cec6be",
              "outline-variant": "#d8d0c8",
              "on-background": "#3a302a",
              "tertiary-fixed-dim": "#e8a0a0",
              "on-secondary": "#ffffff",
              "surface-container-highest": "#e6e0d6",
              "on-tertiary-container": "#3a2020",
              "surface-container-low": "#f6f0e8",
              "on-secondary-fixed": "#2a2420",
              "inverse-primary": "#f0a878",
              "on-surface-variant": "#605850",
              "background": "#faf5ee",
              "secondary": "#78706a",
              "secondary-fixed": "#eae2da",
              "inverse-surface": "#3a302a",
              "surface-variant": "#ece6dc",
              "surface-bright": "#faf5ee",
              "on-primary": "#ffffff",
              "error": "#c0392b",
              "tertiary-container": "#d47070"
            },
            fontFamily: {
              "headline": ["Eb Garamond"],
              "body": ["Manrope"],
              "label": ["Manrope"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        body { font-family: 'Manrope', sans-serif; -webkit-tap-highlight-color: transparent; }
        .serif-text { font-family: 'Eb Garamond', serif; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
        input[type="range"] {
            -webkit-appearance: none;
            width: 100%;
            height: 6px;
            background: #d8d0c8;
            border-radius: 5px;
            outline: none;
        }
        input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 24px;
            height: 24px;
            background: #c2652a;
            border-radius: 50%;
            cursor: pointer;
            border: 4px solid #faf5ee;
            box-shadow: 0 2px 8px rgba(58, 48, 42, 0.1);
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-surface text-on-surface min-h-screen flex flex-col">
<!-- Top Navigation Shell -->
<header class="bg-[#faf5ee] dark:bg-stone-950 border-b border-stone-200/60 dark:border-stone-800/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)] sticky top-0 z-50">
<div class="flex justify-between items-center w-full px-6 py-4">
<div class="flex items-center gap-3">
<button class="flex items-center justify-center p-2 rounded-full hover:bg-stone-100 transition-colors">
<span class="material-symbols-outlined text-on-surface-variant">close</span>
</button>
<span class="font-serif italic text-2xl tracking-tight text-[#c2652a] dark:text-orange-500">Ideole</span>
</div>
<div class="h-10 w-10 rounded-full bg-secondary-container flex items-center justify-center overflow-hidden border border-outline-variant">
<img alt="Profile" class="w-full h-full object-cover" data-alt="Close up portrait of a smiling woman with warm golden hour lighting and natural makeup" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDuGfP2KnDN_tAxX15WkT1yurIPUI15rOauFybMuGH8DW7tuGaZ1hAKUTBlytR7HQji5iJjP2TJxTCG1QbrLadts55f8Z7TUSGQtfF0YFaGMrLeNt0Cgg9B7A40JnrKmafPDAom3KHMsoNNTKlynYOQljBCIU5eP6PgqkQGjeYmK5UTWRxXIuLTzYtSzL2vuA8M6xWNhGzVxN5G5cM07xVVMjlh9F0zpnYhSp5Ik7OIRYyaC3oGg2FJieQAsilNFmbMH0dx46V2QGe7"/>
</div>
</div>
</header>
<!-- Main Content Canvas -->
<main class="flex-1 px-6 pt-8 pb-32 max-w-lg mx-auto w-full">
<!-- Header Section -->
<header class="mb-10 text-center">
<h1 class="font-headline text-4xl text-on-surface leading-tight mb-2 italic">Evaluate Concept</h1>
<p class="font-body text-on-surface-variant text-sm tracking-wide">Reviewing "Solar-Powered Urban Oasis"</p>
</header>
<!-- Rating Cards Bento -->
<div class="space-y-8">
<!-- Metric 1: Originality -->
<section class="bg-surface-container-low rounded-3xl p-8 border border-outline-variant/30 transition-all duration-300">
<div class="flex justify-between items-end mb-6">
<div>
<span class="font-body text-[10px] font-bold uppercase tracking-[0.2em] text-primary mb-1 block">Criterion 01</span>
<h2 class="font-headline text-2xl text-on-surface">Originality</h2>
</div>
<div class="text-right">
<span class="font-headline text-4xl text-primary italic">8.5</span>
<span class="text-on-surface-variant text-xs block">/ 10</span>
</div>
</div>
<div class="relative py-4">
<input class="w-full" max="10" min="1" step="0.1" type="range" value="8.5"/>
</div>
<p class="font-body text-xs text-on-surface-variant mt-2 leading-relaxed">How unique and innovative is this concept compared to existing solutions in the market?</p>
</section>
<!-- Metric 2: Feasibility -->
<section class="bg-surface-container-low rounded-3xl p-8 border border-outline-variant/30">
<div class="flex justify-between items-end mb-6">
<div>
<span class="font-body text-[10px] font-bold uppercase tracking-[0.2em] text-primary mb-1 block">Criterion 02</span>
<h2 class="font-headline text-2xl text-on-surface">Feasibility</h2>
</div>
<div class="text-right">
<span class="font-headline text-4xl text-primary italic">6.2</span>
<span class="text-on-surface-variant text-xs block">/ 10</span>
</div>
</div>
<div class="relative py-4">
<input class="w-full" max="10" min="1" step="0.1" type="range" value="6.2"/>
</div>
<p class="font-body text-xs text-on-surface-variant mt-2 leading-relaxed">The technical and economic viability of bringing this idea to life within 12 months.</p>
</section>
<!-- Metric 3: Impact -->
<section class="bg-surface-container-low rounded-3xl p-8 border border-outline-variant/30">
<div class="flex justify-between items-end mb-6">
<div>
<span class="font-body text-[10px] font-bold uppercase tracking-[0.2em] text-primary mb-1 block">Criterion 03</span>
<h2 class="font-headline text-2xl text-on-surface">Impact</h2>
</div>
<div class="text-right">
<span class="font-headline text-4xl text-primary italic">9.1</span>
<span class="text-on-surface-variant text-xs block">/ 10</span>
</div>
</div>
<div class="relative py-4">
<input class="w-full" max="10" min="1" step="0.1" type="range" value="9.1"/>
</div>
<p class="font-body text-xs text-on-surface-variant mt-2 leading-relaxed">The potential scale of positive change this concept could deliver to its target audience.</p>
</section>
<!-- Qualitative Feedback -->
<section class="mt-4">
<label class="font-body text-[10px] font-bold uppercase tracking-[0.2em] text-on-surface-variant mb-3 block">Collaborative Notes (Optional)</label>
<textarea class="w-full bg-surface-container-lowest border border-outline-variant rounded-2xl p-4 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-sm font-body text-on-surface placeholder:text-stone-400" placeholder="Share a brief thought on this evaluation..." rows="3"></textarea>
</section>
</div>
</main>
<!-- Bottom Action Bar -->
<footer class="fixed bottom-0 left-0 w-full bg-[#faf5ee]/90 backdrop-blur-xl border-t border-stone-200/60 p-6 z-50">
<div class="max-w-lg mx-auto">
<button class="w-full bg-primary text-white py-5 rounded-full font-body font-bold text-sm tracking-[0.15em] uppercase shadow-lg shadow-primary/20 flex items-center justify-center gap-3 active:scale-[0.98] transition-transform">
<span>Submit Evaluation</span>
<span class="material-symbols-outlined text-lg">arrow_forward</span>
</button>
<div class="mt-4 text-center">
<p class="text-[10px] text-on-surface-variant uppercase tracking-widest font-bold">Evaluation will be synced with the Feed</p>
</div>
</div>
</footer>
<!-- Bottom Navigation Shell Suppression: This is a task-focused sub-page (Rating Input), so the global NavBar is excluded to maintain focus on the transaction -->
</body></html>

<!-- Collaboration & Discussion (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>Ideole — Idea Discussion</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface": "#faf5ee",
                        "background": "#faf5ee",
                        "surface-container-lowest": "#ffffff",
                        "secondary-fixed-dim": "#cec6be",
                        "inverse-on-surface": "#faf5ee",
                        "tertiary-fixed": "#fce0e0",
                        "on-surface-variant": "#605850",
                        "primary-container": "#e08850",
                        "on-secondary-fixed": "#2a2420",
                        "tertiary-fixed-dim": "#e8a0a0",
                        "on-tertiary-fixed-variant": "#6e3030",
                        "surface-container": "#f2ece4",
                        "surface-bright": "#faf5ee",
                        "primary-fixed-dim": "#f0a878",
                        "on-tertiary-container": "#3a2020",
                        "primary-fixed": "#fbe8d8",
                        "on-secondary-fixed-variant": "#504840",
                        "on-primary-fixed-variant": "#8a4518",
                        "error": "#c0392b",
                        "on-tertiary": "#ffffff",
                        "inverse-surface": "#3a302a",
                        "surface-container-low": "#f6f0e8",
                        "on-background": "#3a302a",
                        "secondary": "#78706a",
                        "on-error": "#ffffff",
                        "tertiary": "#8c3c3c",
                        "outline": "#9a9088",
                        "surface-tint": "#c2652a",
                        "on-primary": "#ffffff",
                        "secondary-container": "#eae2da",
                        "on-primary-fixed": "#401a08",
                        "on-primary-container": "#fbe8d8",
                        "on-tertiary-fixed": "#2e1515",
                        "primary": "#c2652a",
                        "outline-variant": "#d8d0c8",
                        "surface-container-high": "#ece6dc",
                        "on-surface": "#3a302a",
                        "inverse-primary": "#f0a878",
                        "secondary-fixed": "#eae2da",
                        "surface-variant": "#ece6dc",
                        "surface-container-highest": "#e6e0d6",
                        "on-secondary-container": "#605850",
                        "surface-dim": "#dcd6cc",
                        "error-container": "#fce4e0",
                        "on-secondary": "#ffffff",
                        "tertiary-container": "#d47070",
                        "on-error-container": "#7a1a10"
                    },
                    fontFamily: {
                        "headline": ["Eb Garamond", "serif"],
                        "body": ["Manrope", "sans-serif"],
                        "label": ["Manrope", "sans-serif"]
                    },
                    borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
                },
            },
        }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body {
            background-color: #faf5ee;
            color: #3a302a;
            font-family: 'Manrope', sans-serif;
        }
        h1, h2, h3, .serif-heading {
            font-family: 'Eb Garamond', serif;
        }
    </style>
<style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head>
<body class="bg-background text-on-background min-h-screen pb-32">
<!-- TopAppBar -->
<header class="fixed top-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-[#faf5ee] dark:bg-stone-950 border-b border-[#d8d0c8]/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
<div class="flex items-center gap-4">
<span class="material-symbols-outlined text-[#c2652a] dark:text-[#d48452] cursor-pointer">menu</span>
<span class="font-serif italic text-2xl text-[#c2652a] dark:text-[#d48452]">Ideole</span>
</div>
<div class="flex items-center gap-6">
<nav class="hidden md:flex gap-8 items-center">
<a class="text-stone-500 dark:text-stone-400 font-sans tracking-tight hover:bg-stone-100 dark:hover:bg-stone-900 transition-colors px-2 py-1 rounded" href="#">Discover</a>
<a class="text-[#c2652a] font-semibold font-sans tracking-tight px-2 py-1 rounded" href="#">Pitch</a>
<a class="text-stone-500 dark:text-stone-400 font-sans tracking-tight hover:bg-stone-100 dark:hover:bg-stone-900 transition-colors px-2 py-1 rounded" href="#">Rooms</a>
<a class="text-stone-500 dark:text-stone-400 font-sans tracking-tight hover:bg-stone-100 dark:hover:bg-stone-900 transition-colors px-2 py-1 rounded" href="#">Social</a>
</nav>
<img alt="User profile" class="w-8 h-8 rounded-full border border-outline-variant object-cover" data-alt="Close up portrait of a professional man with a friendly expression in soft natural lighting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAJ7W0pO_xQG6ndA0fTPBQD0D-NwtqSjMXgxwJpT_IcQ0Nh4uekJwEzJsPKJVeZtw1F4Z130jz3i5ZUj7XPEkr-AQOsfp1C2wEJrUoENaLqAavtlRKc_1CNV0G-1fKBbhzYyUr4-dQAmkcoTJswtBvSkZmoB8XVOe5EpwzRBAcAVclOQtPxW2q23J1en68OBfMldyfSSetkfURXzYuWt0UoZKnnlkByDx2zyukqe5BBPjdw7gEptJ9uDPLXk-BUUU_4i70yWV7jjuIt"/>
</div>
</header>
<main class="pt-24 px-6 max-w-6xl mx-auto grid grid-cols-1 lg:grid-cols-12 gap-12">
<!-- Idea Header & Discussion (Left/Main Column) -->
<div class="lg:col-span-8 space-y-8">
<section class="space-y-2">
<nav class="flex items-center gap-2 text-xs uppercase tracking-widest text-outline font-label">
<span>Drafts</span>
<span class="material-symbols-outlined text-[14px]">chevron_right</span>
<span class="text-primary">Idea Detail</span>
</nav>
<h1 class="text-5xl md:text-6xl font-headline italic text-on-background leading-tight">The Solar Loom</h1>
<p class="text-lg text-on-surface-variant font-body leading-relaxed max-w-2xl">
                    A conceptual framework for weaving photovoltaic fibers into architectural textiles, creating energy-independent shading structures for urban plazas.
                </p>
</section>
<!-- Comments Section -->
<section class="space-y-8 pt-8 border-t border-outline-variant/30">
<h2 class="text-3xl font-headline italic">Discussion</h2>
<div class="space-y-10">
<!-- Thread 1 -->
<div class="flex gap-4">
<img alt="Avatar" class="w-10 h-10 rounded-full object-cover mt-1" data-alt="Portrait of a young woman with a creative style and warm lighting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBRxfCDeiEoZ9p_94Og-tL9LxfUKy8n2Rf3Vs_RGGVBhfnB2DR_JNqAwrJ5FZeIkxO6pLu_eYTJhFNUgV515Y8bmPYtCZnTN9PRn0zvkC-rom--1US4YdPyo0nhjg4G7j_PLk2p1p2UvowKpnqsVpPUtj845yNhiae1ews13bTcKLtGG8FEhlRtlMIAIUr-PsKoPSUHjhoh_dz2tBKpt2akkFPEH7E_Eg8L6fr9PX_BjzmXBNW9Aq5tLHlPO7i39clcLtp4VmL-0SMe"/>
<div class="flex-1 space-y-2">
<div class="flex items-baseline gap-3">
<span class="font-headline text-xl italic">Elena Vance</span>
<span class="text-[10px] uppercase tracking-tighter text-outline font-label">2 hours ago</span>
</div>
<p class="text-on-surface-variant font-body leading-relaxed font-light">
                                The structural integrity of the loom is paramount. Have we considered the tensile strength of the copper-infused threads when under high wind loads?
                            </p>
<div class="flex gap-4 pt-1">
<button class="text-xs uppercase tracking-widest text-primary font-bold hover:underline">Reply</button>
<button class="text-xs uppercase tracking-widest text-outline font-medium">Like</button>
</div>
<!-- Nested Comment -->
<div class="mt-6 flex gap-4 pl-4 border-l border-outline-variant/60">
<img alt="Avatar" class="w-8 h-8 rounded-full object-cover mt-1" data-alt="Portrait of a male architect with glasses in a sunlit studio environment" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAYMeFI2qWnHP0nrUb6-W2rDPu9wh_ssVXyPrOyHDoT17_IJyI1p9bjCkO9rIQOVTfcU63pGGtuwFLYjBE-0gToZ99bxk7UetZZt6A3K0pqhKnaTQgDz-FPyInSd5m8QrcBUghbe2k8D8gdI_uUz1n8e5CGy2mgoMwjTEFct8gSEwnt1mXjJlmrgYb8ImNi7z8PcCy3NOMXrzjoZhRLCtPTe_mKeWpousf0nvbnHbqTEu4kNQSMsop329hPHFD9Nl1dwW3DZmjofkFt"/>
<div class="flex-1 space-y-2">
<div class="flex items-baseline gap-3">
<span class="font-headline text-lg italic">Julian Sahara</span>
<span class="text-[10px] uppercase tracking-tighter text-outline font-label">1 hour ago</span>
</div>
<p class="text-on-surface-variant font-body leading-relaxed font-light">
                                        Good point, Elena. I've uploaded the latest stress tests to the 'Drafts' folder. The hybrid polymer seems to hold up well up to 45 knots.
                                    </p>
</div>
</div>
</div>
</div>
<!-- Thread 2 -->
<div class="flex gap-4">
<img alt="Avatar" class="w-10 h-10 rounded-full object-cover mt-1" data-alt="Headshot of a middle-aged man with a professional yet artistic look" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBfEPiWr_m7Ktw_u6A-kV1CxTxDOFxR3KcfJpnMTgoWPnhseycAOjrkmeF_JOze9aJaYHx94uUzK3N8ajJzW2lZX8KhO3xCWY4VDEcMJOCq6vgHRj1orZ7DJ8YLqybRjzk1OZVk11inKtmRRPbXZh13CjNxBKIWWvAM1a66jUmHdR43wANJ3Jrfb57pTMQ2rhBLPwtx4_h8lkGOFc8UxLqAFHcSlEsfM80YYATTKVVmjMj2iSVBeQp3mr6cnEfxrKSUVFw1ANovuQ80"/>
<div class="flex-1 space-y-2">
<div class="flex items-baseline gap-3">
<span class="font-headline text-xl italic">Marcus Thorne</span>
<span class="text-[10px] uppercase tracking-tighter text-outline font-label">45 mins ago</span>
</div>
<p class="text-on-surface-variant font-body leading-relaxed font-light">
                                I’m seeing some potential issues with the solar conversion efficiency on curved surfaces. We might need a gradient density in the weave.
                            </p>
<div class="flex gap-4 pt-1">
<button class="text-xs uppercase tracking-widest text-primary font-bold hover:underline">Reply</button>
<button class="text-xs uppercase tracking-widest text-outline font-medium">Like</button>
</div>
</div>
</div>
</div>
<!-- Input area -->
<div class="pt-6">
<div class="relative">
<textarea class="w-full bg-surface-container-lowest border border-outline-variant rounded-lg p-4 font-body text-sm focus:ring-1 focus:ring-primary focus:border-primary outline-none min-h-[100px] resize-none" placeholder="Share your perspective..."></textarea>
<button class="absolute bottom-4 right-4 bg-primary text-on-primary px-6 py-2 rounded-full font-label text-xs uppercase tracking-widest hover:opacity-90 transition-opacity">
                            Post
                        </button>
</div>
</div>
</section>
</div>
<!-- Sidebar (Collaborators & Actions) -->
<aside class="lg:col-span-4 space-y-8">
<div class="bg-surface-container-low p-8 rounded-xl space-y-6 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
<div class="flex justify-between items-center">
<h3 class="text-2xl font-headline italic">Collaborators</h3>
<span class="text-[10px] font-label uppercase tracking-widest text-outline">3 Active</span>
</div>
<ul class="space-y-6">
<li class="flex items-center justify-between group">
<div class="flex items-center gap-3">
<img alt="Avatar" class="w-10 h-10 rounded-full object-cover" data-alt="Portrait of a male creative director with professional studio lighting" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDu9R8JG6JrUgxl47fQ0dHzd2RbD7ZE68PTA46Pfc9hAGEnhtUrWLtz3ZmuwKmdqG5NA-6i3JSnrYSs6zojdjoG4kthLncwN_aw11kAb1xevxI58r0cVe-8vz8l8lWk2WlqD85rW00BIT9d3e5qRjLaJGHiY6E76Hhw3uQMCAETs6v5UkOK4YF061uF76oi3iBQLkbW0rAmjTyQBulDVhXC50o7z0-b0f63OWNGuYkaSgtshIuP3IM-VgNXnYvjNDTfvFKZOzh1tY81"/>
<div>
<p class="font-body text-sm font-semibold text-on-background">Julian Sahara</p>
<p class="text-[10px] font-label uppercase tracking-widest text-primary">Owner</p>
</div>
</div>
<span class="material-symbols-outlined text-outline text-lg opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">more_vert</span>
</li>
<li class="flex items-center justify-between group">
<div class="flex items-center gap-3">
<img alt="Avatar" class="w-10 h-10 rounded-full object-cover" data-alt="Portrait of a young female designer with warm skin tones and soft focus background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCrDiq0JvdVHvzqG5CTUQuf8c2hhzBWepFCf0StV3hsGILpPMlW59WCXG_6Q-lSIV38oaGszmlgWTVWFRfsqftk5iea8DN0I18pt0M_udfLVEHLuLE2h8VgebtklAbzHf8CKrbhfdsrGfIi6-Wee1aWabNvYMty14GxwO-PiHaOyz-lfL-QIDMMitEJOjkvmmV5IM4YJpgxI16MJzfUXMe3GTH_UKiXepS1WBJFcph6nHA7vZpSVC_yzWKUiDRtCeOsYBJDqafCvNZS"/>
<div>
<p class="font-body text-sm font-semibold text-on-background">Elena Vance</p>
<p class="text-[10px] font-label uppercase tracking-widest text-outline">Editor</p>
</div>
</div>
<span class="material-symbols-outlined text-outline text-lg opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">more_vert</span>
</li>
<li class="flex items-center justify-between group">
<div class="flex items-center gap-3">
<div class="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container font-headline italic text-lg">MT</div>
<div>
<p class="font-body text-sm font-semibold text-on-background">Marcus Thorne</p>
<p class="text-[10px] font-label uppercase tracking-widest text-outline">Viewer</p>
</div>
</div>
<span class="material-symbols-outlined text-outline text-lg opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer">more_vert</span>
</li>
<li class="flex items-center justify-between py-2 px-3 bg-surface border border-dashed border-outline-variant/60 rounded-lg">
<div class="flex items-center gap-3 opacity-60">
<div class="w-10 h-10 rounded-full bg-stone-200 flex items-center justify-center">
<span class="material-symbols-outlined text-stone-400">mail</span>
</div>
<div>
<p class="font-body text-xs font-medium italic">Pending invite...</p>
<p class="text-[9px] font-label uppercase tracking-widest">sarah.l@design.com</p>
</div>
</div>
</li>
</ul>
</div>
<!-- Ready to Adopt CTA -->
<div class="bg-primary p-8 rounded-xl text-on-primary space-y-4 shadow-xl">
<h3 class="text-3xl font-headline italic leading-tight">Ready to Adopt?</h3>
<p class="text-sm font-body opacity-90 leading-relaxed">
                    This idea is nearing completion. Once "Adopted," it moves from draft to production stage.
                </p>
<button class="w-full bg-on-primary text-primary py-4 rounded-lg font-label text-xs uppercase tracking-[0.2em] font-extrabold hover:bg-stone-50 transition-colors">
                    Lock Concept
                </button>
</div>
</aside>
</main>
<!-- Floating Action Button -->
<button class="fixed bottom-24 right-8 md:bottom-12 md:right-12 w-16 h-16 bg-primary text-on-primary rounded-full shadow-2xl flex items-center justify-center hover:scale-105 active:scale-95 transition-transform z-40 group">
<span class="material-symbols-outlined text-3xl">person_add</span>
<span class="absolute right-20 bg-inverse-surface text-inverse-on-surface px-4 py-2 rounded-lg font-label text-xs uppercase tracking-widest whitespace-nowrap opacity-0 group-hover:opacity-100 pointer-events-none transition-opacity">Invite Collaborator</span>
</button>
<!-- BottomNavBar (Mobile only) -->
<nav class="md:hidden fixed bottom-0 w-full z-50 flex justify-around items-center px-4 pb-safe h-20 bg-[#faf5ee]/90 backdrop-blur-md border-t border-[#d8d0c8]/60">
<div class="flex flex-col items-center justify-center text-stone-400">
<span class="material-symbols-outlined" data-icon="explore">explore</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Discover</span>
</div>
<div class="flex flex-col items-center justify-center text-[#c2652a]">
<span class="material-symbols-outlined" data-icon="add_circle" style="font-variation-settings: 'FILL' 1;">add_circle</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Pitch</span>
</div>
<div class="flex flex-col items-center justify-center text-stone-400">
<span class="material-symbols-outlined" data-icon="wb_incandescent">wb_incandescent</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Rooms</span>
</div>
<div class="flex flex-col items-center justify-center text-stone-400">
<span class="material-symbols-outlined" data-icon="group">group</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Social</span>
</div>
</nav>
</body></html>

<!-- Idea Room - Organized Chat (Sahara) -->
<!DOCTYPE html>

<html class="light" lang="en"><head>
<meta charset="utf-8"/>
<meta content="width=device-width, initial-scale=1.0" name="viewport"/>
<title>The Vertical Canopy | Idea Room</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Eb+Garamond:ital,wght@0,400..800;1,400..800&amp;family=Manrope:wght@200..800&amp;display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
<script id="tailwind-config">
      tailwind.config = {
        darkMode: "class",
        theme: {
          extend: {
            colors: {
              "surface": "#faf5ee",
              "background": "#faf5ee",
              "surface-container-lowest": "#ffffff",
              "secondary-fixed-dim": "#cec6be",
              "inverse-on-surface": "#faf5ee",
              "tertiary-fixed": "#fce0e0",
              "on-surface-variant": "#605850",
              "primary-container": "#e08850",
              "on-secondary-fixed": "#2a2420",
              "tertiary-fixed-dim": "#e8a0a0",
              "on-tertiary-fixed-variant": "#6e3030",
              "surface-container": "#f2ece4",
              "surface-bright": "#faf5ee",
              "primary-fixed-dim": "#f0a878",
              "on-tertiary-container": "#3a2020",
              "primary-fixed": "#fbe8d8",
              "on-secondary-fixed-variant": "#504840",
              "on-primary-fixed-variant": "#8a4518",
              "error": "#c0392b",
              "on-tertiary": "#ffffff",
              "inverse-surface": "#3a302a",
              "surface-container-low": "#f6f0e8",
              "on-background": "#3a302a",
              "secondary": "#78706a",
              "on-error": "#ffffff",
              "tertiary": "#8c3c3c",
              "outline": "#9a9088",
              "surface-tint": "#c2652a",
              "on-primary": "#ffffff",
              "secondary-container": "#eae2da",
              "on-primary-fixed": "#401a08",
              "on-primary-container": "#fbe8d8",
              "on-tertiary-fixed": "#2e1515",
              "primary": "#c2652a",
              "outline-variant": "#d8d0c8",
              "surface-container-high": "#ece6dc",
              "on-surface": "#3a302a",
              "inverse-primary": "#f0a878",
              "secondary-fixed": "#eae2da",
              "surface-variant": "#ece6dc",
              "surface-container-highest": "#e6e0d6",
              "on-secondary-container": "#605850",
              "surface-dim": "#dcd6cc",
              "error-container": "#fce4e0",
              "on-secondary": "#ffffff",
              "tertiary-container": "#d47070",
              "on-error-container": "#7a1a10"
            },
            fontFamily: {
              "headline": ["Eb Garamond", "serif"],
              "body": ["Manrope", "sans-serif"],
              "label": ["Manrope", "sans-serif"]
            },
            borderRadius: {"DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px"},
          },
        },
      }
    </script>
<style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 24;
        }
        .serif-italic { font-family: 'Eb Garamond', serif; font-style: italic; }
        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
<style>
        body {
            min-height: max(884px, 100dvh);
        }
    </style>
</head>
<body class="bg-surface text-on-surface font-body selection:bg-primary-fixed selection:text-on-primary-fixed">
<!-- TopAppBar -->
<header class="fixed top-0 w-full z-50 flex justify-between items-center px-6 h-16 bg-[#faf5ee] dark:bg-stone-950 border-b border-[#d8d0c8]/60 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
<div class="flex items-center gap-4">
<button class="p-2 hover:bg-stone-100 dark:hover:bg-stone-900 transition-colors rounded-full">
<span class="material-symbols-outlined text-[#c2652a] dark:text-[#d48452]">menu</span>
</button>
<span class="font-serif italic text-2xl text-[#c2652a] dark:text-[#d48452]">Ideole</span>
</div>
<div class="hidden md:flex items-center gap-8">
<a class="text-stone-500 hover:text-[#c2652a] transition-colors font-sans tracking-tight" href="#">Discover</a>
<a class="text-stone-500 hover:text-[#c2652a] transition-colors font-sans tracking-tight" href="#">Pitch</a>
<a class="text-[#c2652a] font-semibold font-sans tracking-tight" href="#">Rooms</a>
<a class="text-stone-500 hover:text-[#c2652a] transition-colors font-sans tracking-tight" href="#">Social</a>
</div>
<div class="flex items-center gap-3">
<div class="w-8 h-8 rounded-full overflow-hidden border border-outline-variant">
<img alt="Julian Sahara" src="https://lh3.googleusercontent.com/aida-public/AB6AXuC35Tvz8J8lcCxuAVf4vdEVPUQwMRbkwbPYPqgKLgkSWXlsJqXRzjLlqcBQWjGiWuftHGjQ-UOfxSXOWIctbJ7wMxEXjOcrkhXdXc8I-84rHN1UlzbDzrC2YO2zZwU0AjA70fqG_Or-kyso_PYUppBMcHRMhNh836Vd8H_e6O8PuSZCMIPcS1qTfUZ9TzoX-5dihdyhJoYQ-YQhBNiQzAj225pXeDtaDCxlJ1pdU_awHFhbXoBjq48--imisy7ue4oiAHEkNyIFUD7E"/>
</div>
</div>
</header>
<main class="pt-24 pb-32 px-4 md:px-8 max-w-7xl mx-auto">
<!-- Project Header -->
<section class="mb-12">
<div class="flex flex-col md:flex-row md:items-end justify-between gap-6">
<div>
<div class="flex items-center gap-3 mb-2">
<span class="px-3 py-1 bg-primary/10 text-primary text-[10px] font-bold tracking-[0.15em] uppercase rounded-full">Adopted &amp; Incubating</span>
<span class="text-on-surface-variant/60 text-sm">v1.0.4</span>
</div>
<h1 class="text-5xl md:text-7xl font-headline text-on-surface leading-none tracking-tight">The Vertical Canopy</h1>
<p class="mt-4 text-lg text-on-surface-variant max-w-2xl font-body leading-relaxed">
                        Redefining urban biodiversity through modular, self-sustaining architectural flora.
                    </p>
</div>
<div class="flex items-center gap-2">
<button class="px-6 py-3 bg-primary text-on-primary font-medium rounded-full shadow-sm hover:opacity-90 transition-opacity">
                        Invite Collaborators
                    </button>
<button class="p-3 border border-outline-variant rounded-full hover:bg-surface-container transition-colors">
<span class="material-symbols-outlined">more_horiz</span>
</button>
</div>
</div>
</section>
<!-- Tabbed Navigation -->
<nav class="flex border-b border-outline-variant/30 mb-8 overflow-x-auto hide-scrollbar">
<button class="px-8 py-4 border-b-2 border-primary text-primary font-bold text-sm tracking-widest uppercase">Workspace</button>
<button class="px-8 py-4 border-b-2 border-transparent text-on-surface-variant hover:text-primary transition-colors text-sm tracking-widest uppercase">Team Chat</button>
<button class="px-8 py-4 border-b-2 border-transparent text-on-surface-variant hover:text-primary transition-colors text-sm tracking-widest uppercase">Roadmap</button>
<button class="px-8 py-4 border-b-2 border-transparent text-on-surface-variant hover:text-primary transition-colors text-sm tracking-widest uppercase">Analytics</button>
</nav>
<!-- Main Content Grid -->
<div class="grid grid-cols-1 lg:grid-cols-12 gap-8">
<!-- Left Column: Workspace Core -->
<div class="lg:col-span-8 space-y-8">
<!-- Pinned Vision Message -->
<div class="bg-primary-fixed/40 border-l-4 border-primary p-6 rounded-r-xl">
<div class="flex items-start gap-4">
<span class="material-symbols-outlined text-primary" style="font-variation-settings: 'FILL' 1;">push_pin</span>
<div>
<span class="text-[10px] font-bold tracking-widest text-primary uppercase block mb-1">Pinned Vision</span>
<p class="font-headline italic text-xl text-on-primary-fixed leading-relaxed">
                                "Our goal is not just to add greenery, but to create a living, breathing respiratory system for the modern concrete jungle. Sustainability is the baseline, beauty is the requirement."
                            </p>
<span class="text-xs text-on-primary-fixed-variant mt-2 block">— Julian Sahara, Project Lead</span>
</div>
</div>
</div>
<!-- Bento Grid: Key Milestones & Assets -->
<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
<!-- Milestone Card -->
<div class="bg-surface-container-low p-8 rounded-xl border border-outline-variant/30 flex flex-col justify-between">
<div>
<div class="flex justify-between items-start mb-6">
<span class="material-symbols-outlined text-primary text-3xl">architecture</span>
<span class="text-[10px] font-bold tracking-widest text-on-surface-variant uppercase">Next Phase</span>
</div>
<h3 class="text-2xl font-headline mb-2">Structural Blueprinting</h3>
<p class="text-sm text-on-surface-variant mb-6">Finalizing the load-bearing requirements for the 20-story modular chassis.</p>
</div>
<div class="flex items-center gap-4">
<div class="flex -space-x-2">
<img alt="Avatar" class="w-8 h-8 rounded-full border-2 border-surface" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAwfxQFg0xYJPjXRWg7QIje0oMeaAjK0OFtvDze9WfBJFxD7pFVjHjT2qkVlft6wr9P8Zk5EVfg1ou4zmnGNbt4Bwp8IQB5moJ0QA3mqTQaNENnEIlmI2QJBxqKPf16jrjcpRFNn7Ceq7JgbSc6VhcJE-j3IIg1NLIQhusTj_R6T7KCWw6vY1VrwczlqPFXHldTsVrtjSc9rUZkwxnR8Xh4jmgTnvMrJSDtyWdgI17xf0vwripB7ZMk8D8Dd9rBiJ3oHmgB_n437O2o"/>
<img alt="Avatar" class="w-8 h-8 rounded-full border-2 border-surface" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDqDevPVZdk4cwkmnhVUl7IBsYCzr-hEShxusdhff7EyaxYmT63015vawzk4Ih0OyQhpfuNK0MV8axBT9M2WQS35tyYdijGJF4MBzsTuLsslzW-AA-VC1nL7h2JNrMsxbkJQpcFbo23N6tY9_nz0ountiB2xAaUTBuKF-zxtpFOtrXHzD8LYwihvuFZ4yVECrT34HDFAU0ib3cQs-YBiKgxCZYeT4IViWhbnK6FMeau9EersvabVP9DK6rp-S-P7eQnQ36viFuuw5B0"/>
</div>
<span class="text-xs font-bold text-primary">82% Complete</span>
</div>
</div>
<!-- Asset Links Card -->
<div class="bg-surface-container-low p-8 rounded-xl border border-outline-variant/30">
<div class="flex justify-between items-start mb-6">
<span class="material-symbols-outlined text-primary text-3xl">folder_open</span>
<span class="text-[10px] font-bold tracking-widest text-on-surface-variant uppercase">Shared Assets</span>
</div>
<ul class="space-y-4">
<li class="flex items-center justify-between group">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">description</span>
<span class="text-sm font-medium">Core Brand Guidelines</span>
</div>
<span class="text-[10px] text-on-surface-variant/40">PDF • 12MB</span>
</li>
<li class="flex items-center justify-between group">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">image</span>
<span class="text-sm font-medium">3D Renderings v2</span>
</div>
<span class="text-[10px] text-on-surface-variant/40">ZIP • 245MB</span>
</li>
<li class="flex items-center justify-between group">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-on-surface-variant group-hover:text-primary transition-colors">link</span>
<span class="text-sm font-medium">Material Research Wiki</span>
</div>
<span class="text-[10px] text-on-surface-variant/40">URL</span>
</li>
</ul>
</div>
<!-- Large Image Feature -->
<div class="md:col-span-2 relative h-64 rounded-xl overflow-hidden group">
<img alt="Concept Art" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCn1QWUck-ImN5TEy6zGRySSaSBhPzIASM4c9-RjB5qEKrGNLE5Fdo5UWbzn8gf4YE8opYFOwzdmTpKbbO71Au9UVoi6frD6dY2Qntgjg9EY8Tl8GlXxk3yM2a_V32qKI7s3MBXP4MZVW7FoVdonwMsXkE7wA4-kmzrfg_iN3YeFUEjdFLe8qY0o9wyil0-3HNImXSIlC3x7_4I7LThCuJg7aaVaYzVICI9k4v_y9zF8j-HoBN8tNVwwQIcVKdimfpXR90EyF1BStBY"/>
<div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent flex flex-col justify-end p-8">
<p class="text-white/80 text-xs font-bold tracking-widest uppercase mb-2">Featured Concept</p>
<h4 class="text-white text-3xl font-headline">The Lungs of New Tokyo</h4>
</div>
</div>
</div>
<!-- Latest Activity Feed -->
<div class="bg-surface-container-lowest p-8 rounded-xl border border-outline-variant/30 shadow-[0_2px_16px_rgba(58,48,42,0.04)]">
<h3 class="text-2xl font-headline mb-8">Latest Activity</h3>
<div class="space-y-8">
<div class="flex gap-4">
<div class="relative">
<div class="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center">
<span class="material-symbols-outlined text-on-secondary-container text-sm">history_edu</span>
</div>
<div class="absolute top-10 left-1/2 -translate-x-1/2 w-px h-8 bg-outline-variant/40"></div>
</div>
<div class="pt-1">
<p class="text-sm"><span class="font-bold">Aria Chen</span> updated the <span class="text-primary font-medium">Structural Integrity Report</span></p>
<p class="text-[10px] text-on-surface-variant uppercase tracking-wider mt-1">2 hours ago</p>
</div>
</div>
<div class="flex gap-4">
<div class="relative">
<div class="w-10 h-10 rounded-full bg-tertiary-fixed flex items-center justify-center">
<span class="material-symbols-outlined text-on-tertiary-fixed-variant text-sm">forum</span>
</div>
<div class="absolute top-10 left-1/2 -translate-x-1/2 w-px h-8 bg-outline-variant/40"></div>
</div>
<div class="pt-1">
<p class="text-sm"><span class="font-bold">Team Discussion:</span> 42 new messages in <span class="text-primary font-medium">#material-sourcing</span></p>
<p class="text-[10px] text-on-surface-variant uppercase tracking-wider mt-1">5 hours ago</p>
</div>
</div>
<div class="flex gap-4">
<div class="relative">
<div class="w-10 h-10 rounded-full bg-primary-fixed flex items-center justify-center">
<span class="material-symbols-outlined text-on-primary-fixed-variant text-sm">check_circle</span>
</div>
</div>
<div class="pt-1">
<p class="text-sm"><span class="font-bold">Milestone Reached:</span> Conceptual Approval Phase 1</p>
<p class="text-[10px] text-on-surface-variant uppercase tracking-wider mt-1">Yesterday</p>
</div>
</div>
</div>
</div>
</div>
<!-- Right Column: Refined Team Chat (Desktop Sidebar) -->
<div class="lg:col-span-4 space-y-8">
<div class="bg-surface-container-high rounded-xl border border-outline-variant/40 flex flex-col h-[700px]">
<!-- Chat Header -->
<div class="p-4 border-b border-outline-variant/40 flex items-center justify-between">
<div class="flex items-center gap-2">
<span class="w-2 h-2 rounded-full bg-primary"></span>
<span class="font-bold text-xs tracking-widest uppercase">Team Chat</span>
</div>
<span class="text-[10px] text-on-surface-variant/60 font-medium">12 Online</span>
</div>
<!-- Chat Messages -->
<div class="flex-1 overflow-y-auto p-4 space-y-8 hide-scrollbar">
<!-- Date Section: Monday, June 12th -->
<div class="space-y-6">
<div class="flex items-center gap-4">
<div class="h-px flex-1 bg-outline-variant/30"></div>
<span class="text-[10px] font-bold tracking-[0.2em] text-on-surface-variant/50 uppercase">Monday, June 12th</span>
<div class="h-px flex-1 bg-outline-variant/30"></div>
</div>
<!-- Session: Material Sourcing -->
<div class="space-y-4">
<div class="flex items-center gap-2 px-2">
<span class="material-symbols-outlined text-[14px] text-primary">label</span>
<span class="text-[10px] font-bold tracking-widest text-primary/70 uppercase">Topic: Material Sourcing</span>
</div>
<div class="flex flex-col items-start gap-1">
<div class="flex items-center gap-2 mb-1">
<span class="text-[10px] font-bold tracking-tight uppercase">Marcus V.</span>
<span class="text-[9px] text-on-surface-variant/40">10:42 AM</span>
</div>
<div class="bg-surface p-3 rounded-tr-xl rounded-b-xl border border-outline-variant/20 max-w-[90%] shadow-sm">
<p class="text-sm text-on-surface-variant font-body">The tensile strength of the recycled polymers we discussed might not hold the weight of the oak saplings at altitude.</p>
</div>
<button class="text-[10px] text-primary font-bold ml-1 mt-1 flex items-center gap-1">
<span class="material-symbols-outlined text-[12px]">reply</span> 3 replies
                                    </button>
</div>
<div class="flex flex-col items-end gap-1">
<div class="flex items-center gap-2 mb-1">
<span class="text-[9px] text-on-surface-variant/40">10:45 AM</span>
<span class="text-[10px] font-bold tracking-tight uppercase text-primary">Me</span>
</div>
<div class="bg-primary text-on-primary p-3 rounded-tl-xl rounded-b-xl max-w-[90%] shadow-md">
<p class="text-sm font-body">Understood. Let's pivot to the graphene-reinforced mesh. Check the research link in the assets tab.</p>
</div>
</div>
</div>
</div>
<!-- Date Section: Yesterday -->
<div class="space-y-6">
<div class="flex items-center gap-4">
<div class="h-px flex-1 bg-outline-variant/30"></div>
<span class="text-[10px] font-bold tracking-[0.2em] text-on-surface-variant/50 uppercase">Yesterday</span>
<div class="h-px flex-1 bg-outline-variant/30"></div>
</div>
<!-- Session: Structural Integrity -->
<div class="space-y-4">
<div class="flex items-center gap-2 px-2">
<span class="material-symbols-outlined text-[14px] text-primary">architecture</span>
<span class="text-[10px] font-bold tracking-widest text-primary/70 uppercase">Session: Structural Integrity</span>
</div>
<div class="flex flex-col items-start gap-1">
<div class="flex items-center gap-2 mb-1">
<span class="text-[10px] font-bold tracking-tight uppercase">Sarah Lane</span>
<span class="text-[9px] text-on-surface-variant/40">04:12 PM</span>
</div>
<div class="bg-surface p-3 rounded-tr-xl rounded-b-xl border border-outline-variant/20 max-w-[90%] shadow-sm">
<p class="text-sm text-on-surface-variant font-body">On it. Uploading the new stress-test simulations now for the 20-story chassis.</p>
</div>
</div>
</div>
</div>
</div>
<!-- Chat Input -->
<div class="p-4 bg-surface border-t border-outline-variant/40 rounded-b-xl">
<div class="relative">
<input class="w-full bg-surface-container-low border border-outline-variant/60 rounded-full pl-4 pr-12 py-3 text-sm focus:ring-1 focus:ring-primary focus:border-primary outline-none transition-all font-body" placeholder="Message team..." type="text"/>
<button class="absolute right-2 top-1/2 -translate-y-1/2 p-2 text-primary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">send</span>
</button>
</div>
<div class="flex gap-4 mt-3 px-2">
<button class="text-on-surface-variant/60 hover:text-primary"><span class="material-symbols-outlined text-sm">attach_file</span></button>
<button class="text-on-surface-variant/60 hover:text-primary"><span class="material-symbols-outlined text-sm">mood</span></button>
<button class="text-on-surface-variant/60 hover:text-primary"><span class="material-symbols-outlined text-sm">alternate_email</span></button>
</div>
</div>
</div>
<!-- Collaborative Stats -->
<div class="bg-primary/5 p-6 rounded-xl border border-primary/10">
<h4 class="text-xs font-bold tracking-widest uppercase text-primary mb-4">Project Momentum</h4>
<div class="space-y-4">
<div class="flex justify-between items-center">
<span class="text-sm text-on-surface-variant">Ideas Pledged</span>
<span class="font-headline text-lg">1.2k</span>
</div>
<div class="flex justify-between items-center">
<span class="text-sm text-on-surface-variant">Incubation Days</span>
<span class="font-headline text-lg">18</span>
</div>
<div class="w-full bg-primary/10 h-1 rounded-full overflow-hidden">
<div class="bg-primary h-full w-[64%]"></div>
</div>
<p class="text-[10px] text-center text-on-surface-variant/60 italic">Phase 1: Research &amp; Discovery</p>
</div>
</div>
</div>
</div>
</main>
<!-- BottomNavBar (Mobile) -->
<nav class="md:hidden fixed bottom-0 w-full z-50 flex justify-around items-center px-4 pb-safe h-20 bg-[#faf5ee]/90 backdrop-blur-md border-t border-[#d8d0c8]/60">
<a class="flex flex-col items-center justify-center text-stone-400" href="#">
<span class="material-symbols-outlined">explore</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Discover</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400" href="#">
<span class="material-symbols-outlined">add_circle</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Pitch</span>
</a>
<a class="flex flex-col items-center justify-center text-[#c2652a] scale-95 duration-200" href="#">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">wb_incandescent</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Rooms</span>
</a>
<a class="flex flex-col items-center justify-center text-stone-400" href="#">
<span class="material-symbols-outlined">group</span>
<span class="font-sans text-[10px] font-medium uppercase tracking-widest mt-1">Social</span>
</a>
</nav>
</body></html>