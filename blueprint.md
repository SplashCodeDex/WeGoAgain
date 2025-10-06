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

## Current Task: Initial UI Implementation (Completed)

1.  **Analyze Design:** Carefully studied the provided image to understand colors, fonts, spacing, and component styles.
2.  **Code Review:** Inspected the initial `lib/main.dart` file to identify existing widgets and structure.
3.  **Refactor UI:**
    *   Removed the `GlassmorphicContainer` as it was not part of the final design.
    *   Adjusted the `Container`'s `decoration` to match the soft background gradient from the image.
    *   Re-styled the main quote text, removing the glassmorphism background and placing it directly on the main container.
    *   Re-implemented the stack of four avatar cards, ensuring the overlap and shadow match the design.
    *   Re-designed the footer, replacing the simple row with a pill-shaped `Container` that holds the user avatar and name, and separated the social media handles.
4.  **Final Touches:** Fine-tuned padding, alignment, and font sizes to ensure the final result is a pixel-perfect match to the design.
5.  **Add Animations:** Implemented fade-in and staggered slide-in animations to enhance the user experience.
6.  **Modularize Code:** Refactored the UI into separate, reusable widgets and moved the home page to its own file.

---
This blueprint will be updated as new features are added and changes are made to the application.
