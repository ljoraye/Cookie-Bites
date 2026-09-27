**1. Overview**

Cookie Bites is a Flutter app that helps home-based pastry and sweet
businesses track customer orders, expenses, and profit without relying on
manual spreadsheets or notebooks. It's built for solo or small-team sellers
like students and home-based entrepreneurs who currently compute sales, costs, and
profit by hand and want a single place to log orders, track payment status,
and see their financial summary at a glance.

**2. Setup and installation**

Built with:
- Flutter 3.47.4 
- Dart SDK version:  3.13.3

**Code:**
- git clone https://github.com/ljoraye/Cookie-Bites

**Install Dependencies:**
- flutter pub get

**Fonts & Logo:**
The app uses local font and image assets rather than fetching fonts at
runtime. 

![assets](SCREEN%20SS/assets.png)

The app is designed to use Supabase (cloud Postgres + built-in auth) for
storing orders and expenses per user account. This is not yet connected —
the Login and Order Board screens currently run on mock data.

**3. How to run it**
flutter run -d chrome

**4. Features and usage**
What the app does and how to use its main screens. Walk through the primary flow, screen by screen.

LOGIN 
- Email and password fields with basic validation (a valid-looking email,
  a non-empty password).
- "Forgot Password?" link and "Sign up" text are present in the UI but not
  yet wired to another screen.
- "Continue with Google" / "Continue with Apple" buttons are present in the
  UI but not yet functional.
- Submitting valid-format credentials logs in (via a stubbed delay, not
  real authentication yet) and navigates to the Order Board.

ORDER BOARD
- Header shows the current user's name/role and a profile avatar
  (tap actions not yet wired) plus a hamburger menu (not yet wired to a
  drawer).
- Search bar filters the visible order list by customer name in real time.
- Filter chips ("All Orders", "Pick-up", "Meet-up", "Delivery") narrow the
  list by fulfillment type.
- Each order card shows the customer name, a paid/not-yet-paid status
  badge, item summary, fulfillment type, payment mode, and total price.
- "+ New" button and the bottom navigation bar are present in the UI but
  not yet wired to the Order Entry Form or other screens (see Known
  Issues).
- Order data is currently 3 hardcoded sample orders, not live data.

ORDER ENTRY FORM
- Enter the customer's name and pick a delivery date (tapping the date field opens a date picker).
- Select the fulfillment type — Pick-up, Delivery, or Meet-up — from the segmented chips.
- Adjust quantities for each product (Pistachio, Matcha, Biscoff) using the +/- selector next to each; Total, Cost of Goods, and Profit update live as quantities change.
- Select a payment mode — Cash, Gcash, or Bank Transfer — from the segmented chips.
- Optional note field for anything extra about the order.
- Tapping Add Order validates the form (customer name required, at least one item required) and returns to the Order Board. Tapping an existing order card on the Order Board opens this same form pre-filled for editing, with the title and button switching to "Edit Order" / "Update Order".
- Currently mock: saving does not yet write to a database — it validates and closes the screen, but the new/edited order does not appear back on the Order Board yet.

EXPENSES LOG 
- Four summary cards at the top total your expenses by category — Marketing, Packaging, Delivery, and an overall Total.
- Below that, a scrollable list shows each individual expense with its name, description, category tag, date, and amount.
- Tapping the delete icon on an expense card removes it from the list immediately.
- Tapping + Add opens the Add Expense dialog (see below).
- Currently mock: starts with 3 sample expenses; new expenses added through the dialog do appear in this list right away, but nothing is saved permanently between app restarts yet.

ADD EXPENSE
- A pop-out dialog over the Expenses Log screen (not a separate full page).
- Fields: Expense Name, Date (tap to open a date picker), Description, Category, and Amount — all except Category are required.
- Tapping the X in the top corner closes the dialog without saving.
 -Tapping ADD ENTRY validates the form and adds the new expense to the Expenses Log list.

 FINANCIAL SUMMARY DASHBOARD
- A Net Profit card at the top shows the current month's net profit, alongside Revenue, Expenses, and Margin.
- Three smaller cards show Total Orders, Paid Orders, and Unpaid Orders counts.
- A Monthly Trend chart compares Revenue and Expenses across recent months as paired bars.
- A Top Ordered row shows which products have sold the most, scrollable horizontally.
- Currently mock: every figure on this screen (net profit, revenue, order counts, the monthly trend, top products) is placeholder data, not calculated from real orders or expenses yet.

**5. Project structure**

### Updated Lib Structure
![Updated Lib Structure](./SCREEN%20SS/lib%20(update%201).png)

**6. Screenshots**

### Login Page
![Login Page](SCREEN%20SS/login%20page.png)

### Order Board
![Order Board](SCREEN%20SS/Order%20Board.png)

### Order Entry Form
![Order Entry Form](./SCREEN%20SS/Order%20Entry%20Form.png)

### Expenses
![Expenses](./SCREEN%20SS/Expenses.png)

### Add Expense
![Add Expense](./SCREEN%20SS/Add%20Expense.png)

### Financial Summary Dashboard
![Financial Summary Dashboard](./SCREEN%20SS/Financial%20Summary%20Dashboard.png)

**7. Known issues and next steps**

ISSUES
1. Login is not connected to real authentication — any valid-format email/password logs in successfully via a stub.
2. Order Board, Order Entry Form, Expenses Log, and Financial Summary all run on hardcoded mock data, not real data from a database.
3. Order Entry Form does not yet persist new or edited orders — saving validates the form and closes the screen, but the order does not appear back on the Order Board.
4. Expenses added through the Add Expense dialog only persist in memory — they reset if the app restarts.
5. Every figure on the Financial Summary Dashboard (net profit, revenue, order counts, monthly trend, top products) is placeholder data, not calculated from real orders/expenses.
6. Google/Apple sign-in buttons now show the real logos but are still UI-only — tapping them does not trigger an actual sign-in flow.
7. "Forgot Password?" and "Sign up" are UI-only and not wired to any flow yet.
8. The hamburger menu and profile tap (top-right avatar) are present on every screen but have no action behind them yet.
9. The Profile view screen and a hamburger menu/settings screen have not been built yet.
10. Supabase project setup is partially complete — the orders and expenses tables exist with Row Level Security policies in place, but the Flutter app is not yet connected to Supabase; this is the top-priority next step.

NEXT STEPS
1. Add supabase_flutter to the project and initialize it in main.dart.
2. Replace the mock-data stubs in Login, Order Board, Order Entry Form, and Expenses Log with real Supabase calls (auth, and reading/writing orders/expenses).
3. Build the Profile view screen and the hamburger menu/settings screen.
4. Wire the hamburger menu and profile tap to their respective screens once built.
5. Replace Financial Summary's placeholder figures with real aggregates computed from the orders/expenses tables.



