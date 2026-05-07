# ARKO — AI Fitness Coach

iOS SwiftUI app with CrewAI backend. Target: iOS 16+. Language: Swift.

## Project Structure

```
arko-fitnesscoach/          ← Swift source files
arko-fitnesscoachTests/     ← unit tests (Swift Testing framework)
arko-fitnesscoachUITests/   ← UI tests
AGENTS.md                   ← multi-agent architecture (read before AI work)
```

## Features (complexity order — tackle in this sequence)

1. Daily calorie goal (SwiftData model + HealthKit)
2. Apple Health active energy progress (HealthKit + async queries)
3. Workout recommendations (Claude API via CrewAI backend)
4. Camera-based exercise form feedback (Vision + Core ML + UIAgent)
5. Vision and Core ML pipeline (pose estimation, on-device)
6. App Store readiness (entitlements, privacy manifests, signing)

## Tech Stack

### iOS App
- **UI:** SwiftUI + Lottie (complex animations)
- **State:** `@Observable` + SwiftData (iOS 17+)
- **Health:** HealthKit (requires entitlement)
- **Camera/ML:** AVFoundation + Vision + Core ML
- **Async:** Swift Concurrency (async/await, actors)
- **Auth/DB:** Firebase Auth + Firestore (cloud) + SwiftData (local cache)
- **Networking:** URLSession async for backend API calls

### AI Backend (separate Python repo)
- FastAPI + CrewAI + Claude API (claude-sonnet-4-6)
- Deployed on Railway or Render
- See AGENTS.md for agent definitions

## SwiftUI Guidelines

Active skills (`.agents/skills/`):
- `swiftui-expert-skill` — state management, view composition, performance
- `swift-concurrency` — async/await for HealthKit and API calls
- `swift-testing-expert` — unit tests for fitness logic
- `core-data-expert` — SwiftData models for local persistence
- `healthkit` — HealthKit queries, permissions, energy/workout data
- `vision-framework` — Vision framework, pose estimation, Core ML integration
- `lottie` — Lottie animations for workout UI and celebrations

Rules:
- `@State` properties must be `private`
- Use `@Observable` for view models (iOS 17+)
- `ForEach` always uses stable `.id` (never `.indices` on dynamic lists)
- Gate iOS 17+ APIs with `#available(iOS 17, *)`
- All HealthKit queries use `async/await` (never completion handlers)
- All API calls to backend use structured concurrency (`async let`, `TaskGroup`)

## Required Xcode Capabilities

Add in Xcode → Signing & Capabilities:
- HealthKit
- Camera (NSCameraUsageDescription in Info.plist)
- Push Notifications (for workout reminders)

## Firebase Setup

- `GoogleService-Info.plist` must be in `arko-fitnesscoach/` folder (never commit to git)
- Auth method: Sign in with Apple (App Store requirement for apps with auth)
- Firestore collections: `users/{uid}/goals`, `users/{uid}/workouts`, `users/{uid}/history`

## Environment Variables (never hardcode)

```
ANTHROPIC_API_KEY    ← backend only, never in iOS app
FIREBASE_API_KEY     ← use GoogleService-Info.plist, not raw key
```

## App Store Requirements Checklist

- [ ] Privacy Nutrition Labels (HealthKit, Camera, Location if used)
- [ ] NSHealthShareUsageDescription in Info.plist
- [ ] NSCameraUsageDescription in Info.plist
- [ ] PrivacyInfo.xcprivacy manifest (required iOS 17+)
- [ ] Sign in with Apple if using other auth
- [ ] No UDFA/MAC address collection
- [ ] QAAgent safety disclaimers visible in workout recommendations UI
