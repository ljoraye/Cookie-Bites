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

**5. Project structure**

### Updated Lib Structure
![Updated Lib Structure](./SCREEN%20SS/lib%20(update%201).png)

Screens still to be built (not yet in the repo): Order Entry Form, Expense
Log, Add Expense dialog, Financial Summary Dashboard and other minor screens such as profile view. 

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

- Login is not connected to real authentication — any valid-format
  email/password logs in successfully via a stub.
- Order Board displays hardcoded mock data, not data from a database.
- Google/Apple sign-in buttons, "Forgot Password?", and "Sign up" are
  UI-only and not wired to any flow yet.
- The hamburger menu, profile tap
- Supabase project setup (tables, auth) has not been completed yet — this
  is the top-priority next step called out in the project proposal.

