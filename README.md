# MarvelApp

MarvelApp is an iOS application for browsing Marvel characters, viewing character details, and navigating between list and detail experiences.

## Features
- Characters list with pagination.
- Character details screen with sections for comics, series, stories, and events.
- Image loading and caching.
- Coordinator-based navigation flow.

## Architecture
The project follows a layered, modular structure:

- `Domain Layer`
  - Business entities (`CharacterEntity`).
  - Repository contracts and implementations.
  - Use cases (`GetCharactersUseCase`) to isolate business logic.

- `Network Layer`
  - Endpoint definitions and API clients.
  - Base request/response handling.
  - Marvel API integration.

- `Modules`
  - `CharactersScreen`: list UI + pagination logic.
  - `CharactersDetails`: details UI and presentation logic.

- `Coordinator`
  - Centralized navigation between modules.

## Branches
- `main`
  - Release-ready branch.
  - Intended for production/App Store builds.
  - Uses live Marvel API flow.

- `Dev`
  - Active development branch.
  - Uses mock data mode for UI development and testing scenarios.

## Branch Usage
1. Use `Dev` for daily development, UI tuning, and feature iteration with mock data.
2. Validate features against real API behavior before release.
3. Merge stable, tested changes into `main` for release preparation.

## Getting Started
1. Open `MarvelApp.xcodeproj` in Xcode.
2. Select the `MarvelApp` scheme.
3. Build and run on simulator or device.

## API Configuration (main branch)
Add the following keys to `Info.plist`:
- `MARVEL_PUBLIC_KEY`
- `MARVEL_PRIVATE_KEY`

Without these keys, remote API requests will fail.
