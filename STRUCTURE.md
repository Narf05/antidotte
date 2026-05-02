# Antidotte — Coding Structure

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| iOS app | Swift + SwiftUI | Native iOS, App Store-ready |
| Local storage | SwiftData (SQLite) | Native, offline-first, no extra dependency |
| Backend language | TypeScript + Node.js | Fast to iterate, good WebSocket libraries |
| Backend framework | Fastify | Lightweight, typed, fast |
| Database | PostgreSQL | Relational, clean deletion, GDPR-friendly |
| Realtime | WebSocket (ws) | Live map updates |
| Maps (iOS) | MapLibre Native (OSM) | OSM-compatible, no Google dependency |
| Auth | JWT + refresh tokens | Stateless, mobile-friendly |
| Push notifications | APNs (Apple Push) | iOS only for v1 |

---

## iOS App

```
Antidotte/
│
├── App/
│   ├── AntidotteApp.swift          # App entry point
│   ├── AppState.swift              # Global app state (session, auth, night status)
│   └── RootView.swift              # Decides onboarding vs main tab view
│
├── Core/
│   ├── Network/
│   │   ├── APIClient.swift         # REST calls (Fastify backend)
│   │   ├── WebSocketClient.swift   # Live map updates
│   │   └── Endpoints.swift         # All API routes as typed enums
│   ├── Storage/
│   │   ├── Container.swift         # SwiftData container setup
│   │   └── SyncQueue.swift         # Offline actions queued for sync
│   ├── Location/
│   │   ├── LocationManager.swift   # CLLocationManager wrapper
│   │   └── LocationEncoder.swift   # Exact → approximate 150m conversion
│   ├── Sensors/
│   │   ├── MotionProcessor.swift   # Accelerometer/gyro → derived scores
│   │   └── PhoneUsageTracker.swift # Typing/tap deviation tracking
│   ├── Score/
│   │   └── DrunkScoreCache.swift   # Local score state and tipsiness category
│   └── Auth/
│       ├── AuthManager.swift       # JWT storage, refresh, logout
│       └── Keychain.swift          # Secure token storage
│
├── Models/                         # SwiftData local models (mirror backend schema)
│   ├── User.swift
│   ├── DrinkLog.swift
│   ├── NightOutSession.swift
│   ├── Venue.swift
│   ├── FriendPresence.swift        # Received from WebSocket
│   └── ActiveTestResult.swift
│
├── Features/
│   ├── Onboarding/
│   │   ├── OnboardingCoordinator.swift
│   │   ├── WelcomeView.swift
│   │   ├── AgeGateView.swift
│   │   ├── AccountSetupView.swift
│   │   ├── CalibrationView.swift
│   │   ├── DrinkUnitView.swift
│   │   ├── PrivacyOverviewView.swift
│   │   ├── LocationPermissionView.swift
│   │   ├── DrunknessVisibilityView.swift
│   │   ├── AppearanceView.swift
│   │   ├── PassiveSignalsView.swift
│   │   ├── PhotoLoggingView.swift
│   │   ├── FriendsSetupView.swift
│   │   ├── NotificationsView.swift
│   │   └── ReadyView.swift
│   │
│   ├── Map/
│   │   ├── MapView.swift               # Main map screen (BEST)
│   │   ├── MapViewModel.swift
│   │   ├── FriendPinView.swift         # Pin per friend on map
│   │   ├── FriendProfilePopout.swift   # Tap on friend → popout
│   │   ├── GroupClusterView.swift      # Multiple friends at same location
│   │   ├── PlusOneButton.swift         # +1 bottom-left
│   │   ├── LocationPrecisionButton.swift # Top-right precision toggle
│   │   ├── JoinStatusToggle.swift
│   │   └── ThemeSheetButton.swift      # Opens Theme bottom sheet
│   │
│   ├── Stats/
│   │   ├── StatsView.swift             # SEST screen
│   │   ├── StatsViewModel.swift
│   │   ├── ScoreChartView.swift        # Stock-style line chart
│   │   ├── KeyStatsView.swift
│   │   ├── FriendRankingView.swift
│   │   ├── HistoryFeedView.swift
│   │   ├── SessionDetailView.swift
│   │   └── FiltersView.swift
│   │
│   ├── Profile/
│   │   ├── ProfileView.swift           # MEST screen
│   │   ├── ProfileViewModel.swift
│   │   ├── NightStatusView.swift
│   │   ├── DrunkScoreSummaryView.swift
│   │   ├── DrunknessVisibilityPicker.swift
│   │   ├── LocationGroupsView.swift
│   │   └── PrivacySummaryView.swift
│   │
│   ├── Alcotest/
│   │   ├── AlcotestView.swift          # TEST screen entry
│   │   ├── AlcotestViewModel.swift
│   │   ├── ModePickerView.swift        # Single / Multiplayer
│   │   ├── SinglePlayer/
│   │   │   ├── RoundPickerView.swift   # Quick / Full / Custom
│   │   │   └── RoundRunnerView.swift
│   │   ├── Multiplayer/
│   │   │   ├── MultiplayerSetupView.swift
│   │   │   ├── PassThePhoneView.swift
│   │   │   ├── ConnectedDevicesView.swift
│   │   │   ├── ScoreboardView.swift
│   │   │   └── GuestManagerView.swift
│   │   └── Games/
│   │       ├── TapTheDotGame.swift
│   │       ├── StraightLineGame.swift
│   │       ├── MemoryTrayGame.swift
│   │       ├── HoldStillGame.swift
│   │       ├── ReadItRightGame.swift   # Voice — only if voice toggle on
│   │       ├── TongueTwisterGame.swift
│   │       ├── VibeCheckGame.swift
│   │       └── GameResultView.swift
│   │
│   ├── Theme/
│   │   ├── ThemeBottomSheet.swift      # Opens from map
│   │   ├── ThemeViewModel.swift
│   │   ├── ThemePickerView.swift
│   │   ├── DrinkDefaultsView.swift
│   │   ├── MoodPickerView.swift
│   │   └── CalendarPlannerView.swift
│   │
│   └── Settings/
│       ├── SettingsView.swift
│       ├── SettingsViewModel.swift
│       ├── PanicPrivacyBanner.swift    # Fixed at top
│       ├── PrivacyTogglesView.swift
│       ├── LocationSettingsView.swift
│       ├── ScoreCalibrationView.swift
│       ├── DrinkUnitSettingsView.swift
│       ├── PhotoLoggingSettingsView.swift
│       ├── FriendsGroupsView.swift
│       ├── NotificationSettingsView.swift
│       └── DataExportView.swift
│
└── Shared/
    ├── Components/
    │   ├── TipsinessBadge.swift        # Fresh / Buzzing / Loose / Wavy / Gone Mode
    │   ├── JoinStatusBadge.swift
    │   ├── PlusOneOverlay.swift        # Reusable +1 button
    │   └── EmptyStateView.swift
    ├── Extensions/
    │   ├── Color+Theme.swift           # Chaos / Cartoon / Blackout palettes
    │   └── Date+Night.swift
    └── Utils/
        ├── TipsinessCategory.swift     # Category enum + thresholds
        └── PrivacyGate.swift           # Check toggle before collecting data
```

---

## Backend

```
api/
│
├── src/
│   ├── index.ts                    # Fastify server entry
│   ├── config.ts                   # Env vars, DB URL, JWT secret
│   │
│   ├── db/
│   │   ├── client.ts               # PostgreSQL connection (pg / postgres.js)
│   │   └── migrations/             # SQL migration files (numbered)
│   │       ├── 001_users.sql
│   │       ├── 002_friends.sql
│   │       ├── 003_sessions.sql
│   │       ├── 004_drinks.sql
│   │       ├── 005_location.sql
│   │       ├── 006_score.sql
│   │       └── 007_privacy.sql
│   │
│   ├── routes/                     # One file per domain
│   │   ├── auth.ts                 # Register, login, refresh, logout
│   │   ├── users.ts                # Profile, calibration, settings
│   │   ├── friends.ts              # Requests, accept, block, search
│   │   ├── groups.ts               # Create, manage, visibility rules
│   │   ├── sessions.ts             # Night-out sessions CRUD
│   │   ├── drinks.ts               # +1 logs, photo analysis
│   │   ├── location.ts             # Presence updates, visibility rules
│   │   ├── score.ts                # Score snapshots, active test results
│   │   └── notifications.ts        # Push, read/unread
│   │
│   ├── services/                   # Business logic, separated from routes
│   │   ├── AuthService.ts
│   │   ├── FriendService.ts
│   │   ├── LocationService.ts      # Visibility filtering, approximate conversion
│   │   ├── DrunkScoreService.ts    # Signal aggregation, snapshot writes
│   │   ├── SessionService.ts
│   │   ├── DrinkService.ts
│   │   ├── NotificationService.ts  # APNs dispatch
│   │   └── PrivacyService.ts       # Consent checks, audit events
│   │
│   ├── websocket/
│   │   ├── WSServer.ts             # WebSocket server setup
│   │   ├── rooms.ts                # Per-user rooms / friend fan-out
│   │   └── events.ts               # Typed event payloads (location, score, status)
│   │
│   └── middleware/
│       ├── auth.ts                 # JWT verification
│       ├── rateLimit.ts
│       └── privacyCheck.ts        # Reusable visibility enforcement
│
└── package.json
```

---

## Key Data Flows

### +1 Drink Log
```
User taps +1
  → PlusOneButton (iOS)
  → DrinkLog created locally (SwiftData, offline-safe)
  → POST /drinks synced to backend
  → DrunkScoreService recomputes score
  → Score snapshot written
  → WebSocket pushes updated score to allowed friends
```

### Live Map Update
```
LocationManager fires (iOS)
  → LocationEncoder applies precision (exact / 150m / off)
  → POST /location/presence
  → LocationService checks visibility rules per friend
  → WebSocket pushes filtered payload to each allowed friend
  → FriendPinView updates on friend's map
```

### Alcotest Round
```
User completes a game (iOS)
  → Game result measured and normalized
  → POST /score/active-test
  → DrunkScoreService adds to signal set
  → New score snapshot written
  → WebSocket pushes updated score to allowed friends
```

### Panic Privacy
```
User enables panic privacy (Settings or Profile)
  → PATCH /users/settings { panic_privacy: true }
  → PrivacyService marks all live presence as hidden immediately
  → WebSocket pushes hidden payload to all friends
  → Auto-expires after 24h (server-side job)
```

---

## Environment Variables (backend)

```
DATABASE_URL=
JWT_SECRET=
JWT_REFRESH_SECRET=
APNS_KEY_PATH=
APNS_KEY_ID=
APNS_TEAM_ID=
APNS_BUNDLE_ID=
PORT=3000
```

---

## What We Are NOT Building in v1

- Android app
- Web dashboard
- Message analysis (toggle exists, feature deferred)
- Internet search tracking
- Admin panel
