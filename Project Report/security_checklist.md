# Security checklist

Project: Flutter app with Supabase backend, deployed to GitHub Pages via GitHub Actions.

## Secrets and credentials

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 1 | No API key, token or password is hardcoded in `lib/`, including comments | Yes | 	Searched all .dart files in lib/ for supabase.co, eyJ, apikey, secret, password and token. The only matches were password field names, UI labels and comments, with no real key or value. |
| 2 | Private config is gitignored with an example file committed | Yes | .env is listed in .gitignore and .env.example with placeholder values is committed. (Say Yes only after you’ve created and committed that file.) |
| 3 | No keystore or signing credential in the repo | Yes | Ran git ls-files and searched for keystore, .jks and key.properties. Nothing was found. This is a web build. |
| 4 | Git history is clean | Yes | Ran git log -p and searched for password, secret, api key, eyJ, service_role and supabase.co. Matches were only password-field code and workflow lines referencing ${{ secrets.* }}. git log --all --full-history -- .env returned nothing, so .env was never committed. |
| 5 | Any committed credential has been rotated | N/A | No credential was ever committed (see row 4), so there was nothing to rotate. |

## GitHub Actions

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 6 | No secret value is written literally in workflow YAML | TODO | Open `.github/workflows/deploy.yml`. The `.env` step should use `${{ secrets.SUPABASE_URL }}` and `${{ secrets.SUPABASE_ANON_KEY }}`, not literal values. |
| 7 | Secrets are in repository Actions secrets and read with `${{ secrets.NAME }}` | TODO | Check Settings > Secrets and variables > Actions shows both secrets, and the workflow references them. |
| 8 | No step echoes a secret; recent run log checked | TODO | Open a recent run in the Actions tab and read the "Recreate .env" step. GitHub masks secrets as `***`, but confirm nothing prints the file (no `cat .env`). |
| 9 | Signed APK keystore handled as base64 secret | N/A |The project builds a Flutter web app for GitHub Pages. No APK or keystore is built. |
| 10 | Uploaded build artifacts contain no key file or generated config | No | The Pages artifact is `build/web`. Because `.env` is declared as a Flutter asset, the build contains `assets/.env` and it is downloadable from the live site. It holds only the Supabase URL and anon key (designed to be public), but it is generated config. Verify at `https://<user>.github.io/<repo>/assets/.env`. |
| 11 | Third-party actions pinned to a commit SHA | No | The workflow uses moveable tags: `actions/checkout@v4`, `subosito/flutter-action@v2`, `actions/upload-pages-artifact@v3`, `actions/deploy-pages@v4`. Fix by replacing each tag with the full commit SHA from that action's releases page, keeping the tag as a comment. |
| 12 | Secret scanning and push protection enabled | TODO | Check Settings > Code security > Secret scanning and Push protection. Turn both on (free for public repos). |

## Backend and security rules

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 13 | Firestore/Storage rules not open | N/A | The backend is Supabase, not Firebase, so there are no Firestore or Firebase Storage rules.|
| 14 | Rules restrict a user to their own data | TODO | In Supabase SQL editor run `select tablename, policyname, cmd, qual from pg_policies where schemaname='public';`. Policies on `orders`, `expenses` and `products` should compare `user_id = auth.uid()`. Note the app's select calls do not filter by user, so RLS is the only thing separating users. |
| 15 | Supabase RLS on for every table | TODO | Run `select tablename, rowsecurity from pg_tables where schemaname='public';`. Every row must show `true`. Also check Table Editor shows no "RLS disabled" badge. |
| 16 | Firebase/Google API keys restricted | N/A | No Firebase or Google API keys are used; only Supabase. |
| 17 | Opened app signed out and confirmed no access | TODO | Open the site in a private window, signed out. Try loading orders. Also test the anon key directly: with RLS on, `https://<project>.supabase.co/rest/v1/orders` with only the anon key should return an empty list, not your data. |
| 18 | Seed/sample data is invented | TODO | Check any SQL, JSON or seed files in the repo, and what is in your tables. Customer names should be fake, not real customers. |

## Input and app surface

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 19 | Input is validated before it is written | TODO | Review `order_entry_form_page.dart` and `add_expense_dialog.dart`. Confirm they check required fields, numeric quantity/price, and non-negative values in code, not just via keyboard type. Add database constraints too, e.g. `alter table orders add constraint cogs_nonneg check (cogs >= 0);`. |
| 20 | Nothing secret recoverable from the built app | No | The Supabase URL and publishable key can be recovered from the built web app. This is by design, and RLS protects the data. I confirmed service_role appears nowhere in lib/. |

## Repository and privacy

| # | Check | Yes / No / N/A | Evidence |
| --- | --- | --- | --- |
| 21 | No student number, personal email, phone, home address in repo or commits | No | No emails or phone numbers appear in lib/ or the README, but my Git commits use my personal email. I turned on GitHub’s private email setting for future commits. (Only write the second sentence if you did it. Otherwise say the old commits still show it.)|
| 22 | No classmate's personal data in repo | TODO | Confirm no classmates' names or contacts appear in code, seed data or screenshots. |
| 23 | Deps from pub.dev; `build/` and `.dart_tool/` gitignored | TODO | Check `.gitignore` lists `build/` and `.dart_tool/`, and `pubspec.yaml` has no `git:` or `path:` dependencies unless deliberate. |
| 24 | Assets are mine, licensed or credited | TODO | List `assets/` and fonts. Confirm each is yours, licensed, or credited in the README. |
| 25 | Repository visibility is deliberate, checked after last push | TODO | Settings > General > Danger Zone shows the current visibility. Check it again after your final push. |

## Anything I found and fixed

The checklist showed that my commits carried my personal email, so I enabled GitHub’s private email setting. It also reminded me that my .env is bundled into the web build and my Supabase key is therefore public, so I confirmed RLS protects my data. I also created a .env.example file, which I had been missing. My git history had no committed secrets.
