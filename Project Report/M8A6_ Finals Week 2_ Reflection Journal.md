**Week of: September 22, 2026**

**1. My goal this week**

Set up the foundational structure of my Flutter project before building out individual screens — shared theme, models, and reusable widgets — then start on the Login and Order Board screens.

**2. What I did**

I created the shared foundation files first: app_theme.dart for consistent styling across the app, an order model to represent order data, and a set of reusable widgets I knew I'd need across multiple screens. I set this up before touching individual screens so I wouldn't have to keep circling back to update shared code later. Once that was in place, I started building the Login screen and the Order Board screen.

While setting up fonts, I initially used the google_fonts package, which pulls font files from Google's server at runtime. When I noticed this was slowing down my app's load time, I switched to bundling the fonts locally instead — I downloaded the font files, added them to my project assets, declared them in pubspec.yaml, and updated app_theme.dart to reference the local files rather than fetching them remotely.

**3. What blocked me**

main.dart still had Flutter's default boilerplate code (the demo counter app) instead of pointing to my actual app. Every time I ran flutter run -d chrome, it showed the default template instead of my project, and I had to work out that the entry point hadn't been wired up yet.
The google_fonts server-fetch approach caused noticeably slow load times during development, which pushed me to figure out the local-asset alternative.

**4. What I learned**

I learned how Flutter's entry point (main.dart) actually connects to the rest of the app, and that flutter create's boilerplate needs to be deliberately replaced, not just built around. I also learned the practical difference between runtime-fetched fonts (google_fonts package) and locally bundled fonts — including how to declare custom fonts in pubspec.yaml and reference them correctly in a theme file. More generally, I got a clearer sense of why setting up shared/reusable code early pays off: it's already showing me where I'd otherwise be duplicating work across screens. I'm also slowly getting the hang of Flutter overall. I can more easily tell which part of my code is causing an issue and what needs to change to fix it.
