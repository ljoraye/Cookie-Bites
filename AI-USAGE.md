# AI Usage Documentation

This document records how I used AI during the development of my Cookie Bites Flutter project. I used AI as a development assistant, but I remained responsible for the design decisions, testing, editing, debugging, and final implementation of the project.

## 1. How I Used AI

### Entry 1 — Login and Order Board Screen

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
YOUR COMMIT LINK — 

### Entry 2 — Debugging Flutter Setup and Assets

**Date:** September 22 2026  
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
YOUR COMMIT LINK — 


### Entry 5 — Visual Refinements

**Date:** September 23 2026  
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
YOUR COMMIT LINK — 


### Entry 6 — Supabase Database and Security Policies

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
YOUR COMMIT LINK — 


### Entry 4 — Order Entry Form, Expenses Log, and Financial Summary

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
YOUR COMMIT LINK — 


### Entry — Device Preview Compatibility Issue

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
YOUR COMMIT LINK — 

### Entry 9 — Finalized Screens & Supabase Integration

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
YOUR COMMIT LINK — 
