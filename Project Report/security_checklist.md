# Security checklist

Project: Flutter app with Supabase backend, deployed to GitHub Pages via GitHub Actions.

## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/`, including comments | Yes | 	Searched all .dart files in lib/ for supabase.co, eyJ, apikey, secret, password and token. The only matches were password field names, UI labels and comments, with no real key or value. |
| 2 | Private config is gitignored with an example file committed | Yes | .env is listed in .gitignore and .env.example with placeholder values is committed. (Say Yes only after you’ve created and committed that file.) |
| 3 | No keystore or signing credential in the repo | Yes | Ran git ls-files and searched for keystore, .jks and key.properties. Nothing was found. This is a web build. |
| 4 | Git history is clean | Yes | Searched git log -p for password, secret, api key, eyJ, sb_publishable, service_role and supabase.co. I had mistakenly committed my real Supabase URL and publishable key in .env.example, so I removed that commit from history and force-pushed. The search now finds only checklist text and password-field code, with no real values. git log --all --full-history -- .env returns nothing, so .env was never committed. |
| 5 | Any committed credential has been rotated | No | I did not rotate the key. It is a publishable key meant to be public and protected by RLS, but it may exist in clones made before I removed the commit.|

## GitHub Actions

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 6 | No secret value is written literally in workflow YAML | Yes | No secret value appears in deploy.yml. Both Supabase values are read from ${{ secrets.NEXT_PUBLIC_SUPABASE_URL }} and ${{ secrets.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY }}.|
| 7 | Secrets are in repository Actions secrets and read with `${{ secrets.NAME }}` | Yes | The workflow reads both values with ${{ secrets.NAME }}. (Confirm both names are listed under Settings > Secrets and variables > Actions before writing this.) |
| 8 | No step echoes a secret; recent run log checked | Yes | Opened a recent “Deploy Flutter Web” run and expanded the “Build Flutter Web” step, including the command. The Supabase URL and publishable key show as *** in the env: block, and the --dart-define flags reference them as $NEXT_PUBLIC_SUPABASE_URL and $NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY. The rest of the log is compiler output. The workflow has no echo or debug step, and the run’s annotations were only Node.js and Ubuntu deprecation notices.|
| 9 | Signed APK keystore handled as base64 secret | N/A |The project builds a Flutter web app for GitHub Pages. No APK or keystore is built. |
| 10 | Uploaded build artifacts contain no key file or generated config | Yes | I checked pubspec.yaml: .env is not listed under assets: (that line is commented out). The workflow passes the Supabase values with --dart-define and uploads only build/web, so the artifact has no key file, keystore or .env. I opened /assets/.env on my live site and it returned 404.|
| 11 | Third-party actions pinned to a commit SHA | No | I opened .github/workflows/deploy.yml. All four third-party actions use moveable version tags, not commit SHAs: actions/checkout@v4, subosito/flutter-action@v2, actions/upload-pages-artifact@v3 and actions/deploy-pages@v4. |
| 12 | Secret scanning and push protection enabled | Yes | Turned on secret scanning and push protection in Settings > Code security on October 11, 2026. Both show as Enabled. |

## Backend and security rules

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 13 | Firestore/Storage rules not open | N/A | The backend is Supabase, not Firebase, so there are no Firestore or Firebase Storage rules.|
| 14 | Rules restrict a user to their own data | Yes | Ran select ... from pg_policies where schemaname = 'public'. expenses, orders and products each have select, insert, update and delete policies limited to the owner: auth.uid() = user_id in qual (select/update/delete) or with_check (insert). profiles has select, insert and update policies limited to the owner with auth.uid() = id. No policy is open to everyone. |
| 15 | Supabase RLS on for every table | Yes | Ran a pg_tables query on the public schema. expenses, orders, products and profiles all show rowsecurity = true. |
| 16 | Firebase/Google API keys restricted | N/A | No Firebase or Google API keys are used; only Supabase. |
| 17 | Opened app signed out and confirmed no access | Yes |I opened the live site in an incognito window while signed out. The app required login and did not show any orders, expenses or products.|
| 18 | Seed/sample data is invented | No | I used my friends name but they are not actual customers.|

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 19 | Input is validated before it is written | Yes | In order_entry_form_page.dart I check customer name, at least one item and the address in code before the insert, and the quantity can’t go below 0. In add_expense_dialog.dart the validators require name, date, description and a number greater than 0 that is finite. I also added database check constraints on orders (cogs >= 0, total_price >= 0) and expenses (amount > 0). |
| 20 | Nothing secret recoverable from the built app | No | The Supabase URL and publishable key can be recovered from the built web app. This is by design, and RLS protects the data. I confirmed service_role appears nowhere in lib/. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 21 | No student number, personal email, phone, home address in repo or commits | No | No emails or phone numbers appear in lib/ or the README, but my Git commits use my personal email. I turned on GitHub’s private email setting for future commits. (Only write the second sentence if you did it. Otherwise say the old commits still show it.)|
| 22 | No classmate's personal data in repo | Yes | My friends name are in supabase not in my repo. |
| 23 | Deps from pub.dev; `build/` and `.dart_tool/` gitignored | Yes | pubspec.yaml lists only pub.dev packages (cupertino_icons, device_preview, supabase_flutter), with no git: or path: dependencies. .gitignore lists /build/ and .dart_tool/. |
| 24 | Assets are mine, licensed or credited | Yes | I created the logo on canva, downloaded fonts online and used stock photos for google and apple logo. |
| 25 | Repository visibility is deliberate, checked after last push | Yes |After my last push (the .env.example fix) I opened Settings > General > Danger Zone, which says “This repository is currently public”. |

## Anything I found and fixed

The checklist showed that my commits carried my personal email, so I enabled GitHub’s private email setting. It also reminded me that my .env is bundled into the web build and my Supabase key is therefore public, so I confirmed RLS protects my data. I also created a .env.example file, which I had been missing. My git history had no committed secrets.
