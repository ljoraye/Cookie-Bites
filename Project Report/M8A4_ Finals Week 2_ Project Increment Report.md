**Weekly Increment Report **

**Week of: September 22, 2026**

**1. What changed this week**
(each real change: a feature added, a bug fixed, a screen or endpoint built)

This is the project's first week, so there's no functional feature yet — the focus was on setup. I built the shared foundation files: app_theme, order (model), main, and a set of reusable widgets. I also started work on two screens: Login and Order Board.

**2. Why**
(what these changes were for)

I prioritized the shared foundation files first so I wouldn't have to go back and forth updating common code while building individual screens. Getting the theme, models, and reusable widgets in place early means I can focus purely on polishing each screen's UI as I build it, rather than refactoring shared logic later.

**3. What broke or what I got stuck on**
(the honest part: errors, things that did not work, where you are stuck)

main.dart default screen: Running flutter run -d chrome kept showing Flutter's default demo counter app instead of my project. This was because main.dart still had the boilerplate code from flutter create and hadn't been pointed to my actual app widget yet.
Font loading performance: I initially used google_fonts pulling fonts directly from Google's server, but this caused slow load times on each run. I switched to local font assets instead — downloaded the fonts locally, declared them in pubspec.yaml, and updated app_theme to reference the local assets.

**4. What is left**
(what still has to be done before the final)

Four remaining main screens: Add Order, Expenses, Add Expense, and Financial Summary Dashboard
Possibly: a Profile view screen and hamburger menu/settings
UI polish on Login and Order Board — I want these finalized before moving on to the remaining screens
