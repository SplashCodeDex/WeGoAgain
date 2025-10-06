# WeGoAgain - Project Blueprint

## Overview

**Purpose:** A mobile application for iOS and Android built with Flutter, designed to provide users with daily motivation and inspiration.

**App Name:** WeGoAgain

## Style, Design, and Features (Version 1.0)

### Key Technologies

- **Frontend:** Flutter
- **UI/UX:** Material Design 3, with a clean and uplifting aesthetic.
- **Typography:** `google_fonts` for custom fonts.
- **State Management:** `provider` for theme management.

### Main Features

- A main screen displaying a motivational quote.
- A button to generate a new quote.
- A theme toggle to switch between light and dark mode.

### Visual Design and UX

- A simple, single-screen interface.
- A custom font for the quotes to make them stand out.
- A color scheme that is both calming and inspiring.
- A theme toggle for user preference.

## Current Development Plan

1.  **Dependencies:** Add `google_fonts` and `provider` to `pubspec.yaml`.
2.  **Theming:**
    - Create a `ThemeProvider` to manage light/dark mode.
    - Define `ThemeData` for both light and dark themes using `ColorScheme.fromSeed` and `google_fonts`.
3.  **UI:**
    - Modify `lib/main.dart`.
    - Create a `HomePage` widget.
    - Display a quote using a `Text` widget with the custom font.
    - Add an `ElevatedButton` to get a new quote.
    - Add a theme toggle `IconButton` in the `AppBar`.
4.  **Logic:**
    - Create a simple list of motivational quotes.
    - Implement the logic to randomly select a quote from the list.
