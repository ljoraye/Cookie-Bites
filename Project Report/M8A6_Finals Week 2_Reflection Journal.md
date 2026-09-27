**Week of: September 27, 2026**

**1. My goal this week**
To finish my MVP and set up Supabase. My main focus was getting the database tables created and connected so that the app could move beyond stubbed/mock data. 

**2. What I did**
I completed the MVP and set up Supabase, including creating the database tables. While setting this up, I decided to drop the "Continue with Google" and "Continue with Apple" login options for now, since implementing them would require setting up OAuth API credentials with each provider — which is more scope than I need for the MVP right now.

**3. What blocked me**
After git pull fetched successfully, the merge failed because four files from the remote had colons in their filenames (e.g. M8A1: Finals Week 1: Project Increment Report.md and M8A3: Finals Week 1: Reflection Journal.md). Colons are valid in filenames on GitHub's web interface, but Windows forbids them in file paths entirely, so Git couldn't create those files locally.

**4. What I learned**
Setting up the Supabase tables refreshed my memory on writing SQL from my Information Management class last semester — things like defining columns, data types, and constraints came back to me as I worked through creating the actual schema. It was a good reminder that the concepts I learned in that course directly apply to real project work, not just theoretical exercises.
