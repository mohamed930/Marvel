# MarvelApp

iOS app to browse Marvel characters with a paginated list and character details.

## Task Reference
This project was checked against `Mobile Task.docx` (provided by you on Feb 21, 2026).

## Branch Strategy
- `main`: release branch (intended for App Store build, uses live Marvel API).
- `Dev`: development branch (uses mock data for UI/demo/testing).

## Run Project
1. Open `MarvelApp.xcodeproj`.
2. Select the `MarvelApp` scheme.
3. Run on simulator/device.

## API Keys (for `main`)
Add Marvel keys in `Info.plist`:
- `MARVEL_PUBLIC_KEY`
- `MARVEL_PRIVATE_KEY`

Without keys, remote fetch will fail.

## Architecture
- `Domain Layer`: entities, repositories, use cases.
- `Network Layer`: API target/configuration/request handling.
- `Modules`: `CharactersScreen`, `CharactersDetails`.
- `Coordinator`: navigation flow.

## Requirement Check (main vs Dev)
Based on the task file requirements:

1. Characters list loaded from Marvel API with pagination
- `main`: Meets (remote API + pagination in list view model).
- `Dev`: Uses mock data by design (not remote API), pagination behavior exists.

2. Open character details on selection
- `main`: Meets.
- `Dev`: Meets.

3. Hide sections with no data
- `main`: Meets (section visibility checks in details view).
- `Dev`: Meets.

4. Comics/series/stories/events images from `resourceURI` with lazy loading
- `main`: Not fully meeting requirement.
- `Dev`: Not fully meeting requirement.
- Current implementation loads `item.resourceURI` directly as an image URL, but task expects fetching resource details and then lazy-loading the returned thumbnail(s).

5. Replicate mockup quality + appropriate transitions
- `main`: Partially meets (basic transitions/UX exist).
- `Dev`: Partially meets.

## Branch Usage Instruction
- Work on features/integration in `Dev` (mock mode enabled).
- Merge stabilized, API-ready code into `main` for release/store builds.
- Before release from `main`, complete missing requirement #4 (resourceURI detail fetch + lazy image loading).
