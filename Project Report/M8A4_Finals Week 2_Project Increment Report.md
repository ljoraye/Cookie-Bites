**Weekly Increment Report**

**Week of: September 27, 2026**

**1. What changed this week (each real change: a feature added, a bug fixed, a screen or endpoint built)**

Finished the remaining MVP screens, Order Entry Form, Expenses Log, Add Expense dialog, and Financial Summary Dashboard. I also wired real navigation between all four so the bottom nav bar and order editing actually work. Created the Supabase project and set up the orders and expenses tables with Row Level Security.

**2. Why (what these changes were for)**

All six MVP screens needed to be built and connected before moving to the backend, since the proposal scoped the app around them working together. Visual polish matters because I compare it to my Design System. Starting Supabase now leaves real debugging time before the deadline instead of rushing it at the end.

**3. What broke or what I got stuck on (the honest part: errors, things that did not work, where you are stuck)**

git push got rejected from diverged branches, then the merge failed again because two of my own filenames had colons, which Windows doesn't allow, had to use core.sparseCheckout and core.protectNTFS false to get past it. Supabase isn't connected to the app yet, so nothing persists between sessions.

**4. What is left (what still has to be done before the final)**

Remaining screens: Profile view screen and hamburger menu/settings. I am also starting to set up my Supabase, I already have the tables, I just have to connect it to Flutter.
