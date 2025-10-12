# WeGoAgain - Development Plan

**Date:** 2025-10-12

**Version:** 1.3.2

## Implemented Changes (v1.3.1 -> v1.3.2)

- [x] Fixed compilation errors related to Forui integration:
    - [x] Corrected `FScaffold` usage (using `header` instead of `appBar`).
    - [x] Corrected `FButton` usage (removed `variant` and used standard `Icon` widgets).
    - [x] Replaced `FIcons` members with standard `Icons` from `material.dart`.
    - [x] Replaced `FColors` members with standard `Colors` from `material.dart`.
    - [x] Removed `const` from `FText` widgets where it caused errors.

## Upcoming Features (v1.4.0)

- [ ] **Quote Categories:**
    - [ ] Introduce categories like "Stoicism," "Mindfulness," and "Grit" to allow users to tailor the content to their interests.
- [ ] **User-Submitted Quotes:**
    - [ ] Foster a community by allowing users to submit their own quotes, which can be reviewed and added to the app.
