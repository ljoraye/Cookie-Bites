# AI Usage Documentation

This document records how I used AI during the development of my Cookie Bites Flutter project. I used AI as a development assistant, but I remained responsible for the design decisions, testing, editing, debugging, and final implementation of the project.

## 1. How I Used AI

### Entry 1 - Login and Order Board Screen

**Date:** September 22 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude to help create the starting code structure for my Login and Order Board screens based on my own Proposal, Mockup, and Design System.

**What AI gave me:**  
Claude provided the initial Flutter code structure for the screens, including the widgets, layout structure, navigation, and styling.

**What I kept and changed:**  
I used the generated code as a starting point rather than keeping it unchanged. I reviewed the code, ran the application, and modified it to match my own prototype and design requirements. I made changes to the visual styling, spacing, fonts, images, cards, and screen layout.

**Why:**  
The generated code helped me build the basic structure faster, while I still needed to adjust it to match my actual design.

**Commit:**  
COMMIT LINK — https://github.com/ljoraye/Cookie-Bites/commit/ac5fcf3f038b8fbc92b5594653ac0806d3aba1ba

### Entry 2 - Debugging Flutter Setup and Assets

**Date:** September 23 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for help debugging problems with my Flutter project setup.

**What AI gave me:**  
Claude helped me identify problems involving font and image asset paths, a leftover default `main.dart`, and indentation problems in `pubspec.yaml`.

**What I kept and changed:**  
I followed the suggested debugging steps, checked the files myself, and corrected the project configuration. I tested the application after making the changes to make sure the assets and fonts loaded correctly.

**Why:**  
These problems prevented the application from running or displaying assets correctly, so I needed to verify the suggested fixes rather than simply copying them.

**Commit:**  
COMMIT LINK — https://github.com/ljoraye/Cookie-Bites/commit/a6755caac7742d7e113ee05b61c77941af1224bd


### Entry 3 - Visual Refinements

**Date:** September 24 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for coding suggestions for visual refinements to my Login and Order Board screens.

**What AI gave me:**  
Claude suggested Flutter code for changes involving local fonts, the logo image, card borders and shadows, segmented filter chips, text field styling, and header alignment.

**What I kept and changed:**  
I decided which visual changes matched my prototype and applied the suggested code myself. I adjusted the values and styling where necessary instead of using every suggestion exactly as generated.

**Why:**  
I wanted the application to match my own Mockup and Design System rather than simply accepting the AI's default styling.

**Commit:**  
COMMIT LINK — https://github.com/ljoraye/Cookie-Bites/commit/6c5562a2ca4078e13863b2017e4ed24baf121b02


### Entry 4 - Supabase Database and Security Policies

**Date:** September 24 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude to help write SQL for my Supabase `orders` and `expenses` tables and their Row Level Security policies based on the database structure in my Proposal.

**What AI gave me:**  
Claude provided SQL statements for creating the database tables and security policies.

**What I kept and changed:**  
I reviewed the SQL and used it as a starting point for my Supabase database. I checked the table structure and tested the application against the database. I made changes when the database behavior needed to match my application's actual requirements.

**Why:**  
The SQL helped me set up the database faster, but I still needed to understand and verify the schema and security behavior before using it.

**Commit:**  
COMMIT LINK — I did not commit any changes to my files because I made the changes directly in Supabase and had not yet connected them to my application code.


### Entry 5 - Order Entry Form, Expenses Log, and Financial Summary

**Date:** September 27 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude to provide starting code for the Order Entry Form, Expenses Log, Add Expense dialog, and Financial Summary Dashboard while following the visual style of my existing screens.

**What AI gave me:**  
Claude generated the starting Flutter code.

**What I kept and changed:**  
I reviewed and tested the generated screens and modified them to work with my project. I integrated the screens with my existing navigation and design system and adjusted the implementation when the generated code did not match how my application was supposed to work.

**Why:**  
The AI provided a starting point, but the code still needed to be integrated and adapted to my existing application.

**Commit:**  
COMMIT LINK — https://github.com/ljoraye/Cookie-Bites/commit/9e3896d326be78bdce982eaf21cb97e5dcb2986c


### Entry 6 - Device Preview Compatibility Issue

**Date:** September 29, 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude to help identify why `device_preview` was not working correctly in my Flutter project.

**What AI gave me:**  
Claude helped me identify that the problem was related to a version/API compatibility issue with `device_preview`. It explained what part of the implementation was failing and helped me identify where to look for the cause.

**What I kept and changed:**  
I did not directly use Claude's suggested solution. Instead, I checked the Device Preview instructions and the `main.dart` template provided by my professor. I compared the required implementation with the version of `device_preview` installed on my computer and changed the package version in my project to match the professor's provided template.

**Why:**  
The professor's template was the required implementation for this project, so I decided to follow the provided version rather than changing the code based only on AI's suggestion. Claude was useful for identifying what was failing, but I used the official project instructions as the basis for the final solution.

**Commit:**  
COMMIT LINK — https://github.com/ljoraye/Cookie-Bites/commit/ca4af17e97e82cc7ab193c1b29ad2feb04ebe1e2

### Entry 7 - Finalized Screens & Supabase Integration

**Date:** October 4 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for step-by-step guidance on wiring my application screens with Supabase and connecting the app's features to the database. I also worked on adding the final touches to my screens, especially the newly added Manage Products, Previous Orders, and Monthly Financial Summary features.

**What AI gave me:**  
Claude provided step-by-step instructions on how to connect my Flutter screens to Supabase, including setting up the Supabase connection and updating the screens to read and save data from the database.

**What I kept and changed:**  
I followed Claude's guidance and updated my application to connect the relevant screens to Supabase. I also added the final touches and improvements to the newly added Manage Products, Previous Orders, and Monthly Financial Summary screens. I wired the login, orders, expenses, products, profile/settings, previous orders, and financial summary features so they could work with Supabase data instead of relying only on mock data.

**Why:**  
I used Claude's step-by-step guidance to understand how each screen should communicate with Supabase. Adding the final touches to the newly added features helped make the screens more complete and consistent with the rest of the application, while the Supabase integration allowed the main features to work with real database data.

**Commit:**  
COMMIT LINK 
https://github.com/ljoraye/Cookie-Bites/commit/d5b3025a4f5557ee04d8036ef7dd5e1ac804e2aa
https://github.com/ljoraye/Cookie-Bites/commit/27e598c10662782ea6329e47d0117863cb754ec9


## 2. Where the AI got it wrong


### Entry 1 - The AI initially left the Previous Orders and Financial Summary features using mock data

**What the AI gave me:**
The earlier implementation used hardcoded/mock information for Previous Orders and Financial Summary, including sample orders and fixed financial values.

**What was wrong with it:**
The screens looked complete, but the information was not coming from the user's actual Supabase data. This meant that adding or changing orders and expenses would not correctly update the Previous Orders or Financial Summary screens.

**What I did instead:**
I changed Previous Orders to retrieve the user's orders from Supabase and changed Monthly Financial Summary to calculate its information from the orders and expenses stored in Supabase. I also added loading and empty states so the screens could handle database results properly.

**Commit:**
COMMIT LINK
https://github.com/ljoraye/Cookie-Bites/commit/d5b3025a4f5557ee04d8036ef7dd5e1ac804e2aa
https://github.com/ljoraye/Cookie-Bites/commit/27e598c10662782ea6329e47d0117863cb754ec9


### Entry 2 - AI's initial code caused an analyzer problem with Order.toMap()

**What the AI gave me:**
The AI suggested using order.toMap() when inserting and updating orders in Supabase.

**What was wrong with it:**
At one point, the Dart analyzer reported: "The method 'toMap' isn't defined for the type 'Order'". However, my Order model already contained a toMap() method. The problem was not that the method needed to be duplicated or rewritten. The project had stale/unsaved code and the analyzer was not correctly recognizing the current model.

**What I did instead:**
I checked the actual Order model instead of blindly changing the code. I confirmed that toMap() was already implemented, saved the files, restarted the Dart analysis server, and rebuilt/analyzed the project. This allowed me to keep the existing toMap() implementation instead of creating unnecessary duplicate code.

**Commit:**
COMMIT LINK 
https://github.com/ljoraye/Cookie-Bites/commit/d5b3025a4f5557ee04d8036ef7dd5e1ac804e2aa
https://github.com/ljoraye/Cookie-Bites/commit/27e598c10662782ea6329e47d0117863cb754ec9


## 3. Who wrote what

**1. Order model and order data structure**

**File:**
lib/models/order.dart
lib/models/expense.dart
lib/models/product.dart

**Commit:** 
COMMIT LINK — https://github.com/ljoraye/Cookie-Bites/commit/ac5fcf3f038b8fbc92b5594653ac0806d3aba1ba

I wrote the model files for my application. This is basically my data sets and serves as blueprints for the information my app works with.

order.dart — Defines the structure of an order, including the customer, order date, items, fulfillment type, payment method, payment status, COGS, notes, and address. It also contains the functions used to convert order data to and from Supabase.
expense.dart — Defines the information stored for an expense, such as the expense details and amount, so the expense data can be used by the Expenses screen and Financial Summary.
product.dart — Defines the structure of the products used by the application, allowing product information to be shared between the product management and ordering features.

I built the models separately so that the data structure is organized and reusable across different screens. This also makes it easier to connect the Flutter application to Supabase because the database data can be converted into Dart objects that the screens can work with.

## Note
I did not commit every change to GitHub immediately. Instead, I usually worked on fixing and improving everything I could first, then committed all the changes together at the end of the day. As a result, multiple changes are included in a single commit link.



