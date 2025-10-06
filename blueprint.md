# Project Blueprint

## Overview

This project is a motivational and inspirational Flutter application. The primary goal is to create a visually appealing and engaging user experience that delivers inspiring content to the user. The UI/UX is a key focus, with an emphasis on modern design principles, subtle animations, and a clean, aesthetically pleasing layout.

## Implemented Features (as of now)

### UI/UX from Design Mockup
- **Faithful Replication:** The user interface has been built to closely match the provided design image.
- **Gradient Background:** A subtle, two-color linear gradient (`#FEF6F1` to `#F9E9E9`) is used for the main background, creating a warm and inviting feel.
- **Custom Typography:**
    - `GoogleFonts.lora` is used for the large "I" and the quotation marks, giving them a distinct serif style.
    - `GoogleFonts.poppins` is used for the main body text, providing a clean and modern sans-serif look.
- **Gradient Text:** The "Portfolio Building" title uses a `ShaderMask` to apply a vibrant orange-to-red gradient, making it a focal point.
- **Avatar Cards:**
    - A stack of four overlapping avatar cards is implemented.
    - Each card has rounded corners (`borderRadius: 16`).
    - A subtle `BoxShadow` is applied to each card to create a sense of depth and lift them off the background.
- **Pill-Shaped Footer:**
    - The footer containing the user's name and avatar is styled as a rounded, pill-shaped container.
    - It includes social media icons and handles, neatly aligned.
- **Responsive Layout:** The layout is designed to be responsive and adapt gracefully to different screen sizes.

### Animations
- **Fade-In Animation:** The main text elements fade in smoothly, drawing the user's attention to the content.
- **Staggered Slide-In Animation:** The avatar cards slide in from the bottom with a staggered delay, creating a dynamic and engaging entrance.

### Code Structure
- **Modular Widgets:** The UI has been broken down into reusable widgets (`AvatarCard`, `Footer`), promoting a clean and maintainable codebase.
- **Screen Separation:** The home page UI has been moved to its own file (`lib/screens/home_page.dart`), separating it from the main application entry point.
- **Service Layer:** A `FirestoreService` (`lib/services/firestore_service.dart`) has been created to handle all interactions with Firestore, promoting a clean separation of concerns.

### State Management & Theming
- **ThemeProvider:** Implemented a `ChangeNotifierProvider` (`lib/providers/theme_provider.dart`) to manage the application's theme state.
- **Light/Dark Mode:** Full support for light and dark themes, including a theme toggle in the `AppBar`.
- **Material 3 Theming:** Utilizes `ThemeData` and `ColorScheme.fromSeed` to create consistent Material 3 compliant themes.
- **Dynamic Text Colors:** Text colors now adapt based on the active theme (light or dark).

### Backend & Data
- **Firebase Integration:** The application is connected to a Firebase project, with Firebase Core and Cloud Firestore integrated.
- **Dynamic Content:** The app now fetches and displays motivational quotes from a "quotes" collection in Firestore.
- **Content Management:** Includes a "Seed Database" feature to easily populate Firestore with initial quotes.
- **Interactive Content:** A "Refresh" button allows users to fetch a new random quote on demand.

## Current Task: Daily Motivational Quote Feature (Completed)

1.  **Firebase Setup:** Added `firebase_core` and `cloud_firestore` dependencies and initialized Firebase in `main.dart`.
2.  **Create FirestoreService:** Developed a service class to abstract all Firestore operations (adding and fetching quotes).
3.  **Implement Quote Fetching:** Integrated the `FirestoreService` into `MyHomePage` to fetch and display a random quote.
4.  **UI for Dynamic Content:** Replaced the static text with a dynamic display for the fetched quote and author.
5.  **Add User Interactivity:** Implemented a `FloatingActionButton` to allow users to refresh the quote.
6.  **Seed Database:** Added a utility to easily add a predefined list of quotes to the Firestore database.

---
This blueprint will be updated as new features are added and changes are made to the application.
