# AI Usage Documentation

This document records how I used AI during the development of my Cookie Bites Flutter project. I used AI as a development assistant, but I remained responsible for the design decisions, testing, editing, debugging, and final implementation of the project.

## 1. How I Used AI

### Entry 1 — Login and Order Board Screen

**Date:** September 2026  
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
YOUR COMMIT LINK — Login and Order Board implementation


### Entry 2 — Debugging Flutter Setup and Assets

**Date:** September 2026  
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
YOUR COMMIT LINK — Flutter setup and asset fixes


### Entry 3 — README Structure and Documentation

**Date:** September 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for help organizing the structure of my README documentation.

**What AI gave me:**  
Claude suggested a structure for documenting the project, including sections for the project description, setup instructions, and other project information.

**What I kept and changed:**  
I used the suggested structure but wrote and filled in the actual project information myself. I added my own project details, instructions, descriptions, and documentation.

**Why:**  
The structure helped organize the README, but the actual content needed to represent my own project accurately.

**Commit:**  
YOUR COMMIT LINK — README documentation


### Entry 4 — Order Entry Form, Expenses Log, and Financial Summary

**Date:** September 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude to provide starting code for the Order Entry Form, Expenses Log, Add Expense dialog, and Financial Summary Dashboard while following the visual style of my existing screens.

**What AI gave me:**  
Claude generated the starting Flutter code and widget structures for these screens.

**What I kept and changed:**  
I reviewed and tested the generated screens and modified them to work with my project. I integrated the screens with my existing navigation and design system and adjusted the implementation when the generated code did not match how my application was supposed to work.

**Why:**  
The AI provided a starting point, but the code still needed to be integrated and adapted to my existing application.

**Commit:**  
YOUR COMMIT LINK — Order Entry, Expenses, and Financial Summary


### Entry 5 — Visual Refinements

**Date:** September 2026  
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
YOUR COMMIT LINK — Login and Order Board visual refinements


### Entry 6 — Supabase Database and Security Policies

**Date:** September 2026  
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
YOUR COMMIT LINK — Supabase orders and expenses database


### Entry 7 — Git Merge Debugging

**Date:** September 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for help when a Git merge failed because some filenames contained colons, which are invalid in Windows filenames.

**What AI gave me:**  
Claude explained the cause of the merge problem and suggested ways to resolve the filename issue.

**What I kept and changed:**  
I used the explanation to identify the problematic filenames and fix the Git merge. I verified the repository afterward instead of assuming the merge was successful.

**Why:**  
Understanding the actual cause of the Git error helped me safely resolve the problem instead of repeatedly attempting the same merge.

**Commit:**  
YOUR COMMIT LINK — Git merge/file naming fix

### Entry 8 — Device Preview Problem

**Date:** September 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for help when a Git merge failed because some filenames contained colons, which are invalid in Windows filenames.

**What AI gave me:**  
Claude explained the cause of the merge problem and suggested ways to resolve the filename issue.

**What I kept and changed:**  
I used the explanation to identify the problematic filenames and fix the Git merge. I verified the repository afterward instead of assuming the merge was successful.

**Why:**  
Understanding the actual cause of the Git error helped me safely resolve the problem instead of repeatedly attempting the same merge.

**Commit:**  
YOUR COMMIT LINK — Git merge/file naming fix

### Entry 9 — Finalized Screen (Still Mockup)

**Date:** September 29 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for help when a Git merge failed because some filenames contained colons, which are invalid in Windows filenames.

**What AI gave me:**  
Claude explained the cause of the merge problem and suggested ways to resolve the filename issue.

**What I kept and changed:**  
I used the explanation to identify the problematic filenames and fix the Git merge. I verified the repository afterward instead of assuming the merge was successful.

**Why:**  
Understanding the actual cause of the Git error helped me safely resolve the problem instead of repeatedly attempting the same merge.

**Commit:**  
YOUR COMMIT LINK — Git merge/file naming fix

### Entry 10 — Finalized Screen w/ Supabase

**Date:** October 4 2026  
**Tool:** Claude

**What I asked for:**  
I asked Claude for help when a Git merge failed because some filenames contained colons, which are invalid in Windows filenames.

**What AI gave me:**  
Claude explained the cause of the merge problem and suggested ways to resolve the filename issue.

**What I kept and changed:**  
I used the explanation to identify the problematic filenames and fix the Git merge. I verified the repository afterward instead of assuming the merge was successful.

**Why:**  
Understanding the actual cause of the Git error helped me safely resolve the problem instead of repeatedly attempting the same merge.

**Commit:**  
YOUR COMMIT LINK — Git merge/file naming fix


