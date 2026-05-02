# Antidotte — App Setup

## Concept

Antidotte is a social iOS app for tracking nights out with friends. Two core pillars:

1. **Where are your friends tonight** — a live map showing who is out, where, and with whom.
2. **How drunk are they** — a passive + active drunkenness tracking system using multiple signals.

---

## Screens (Frontend)

### 1. Map (BEST)
The main screen. Shows a live map with friends' locations, join status, current tipsiness category, and active event/theme.

- Pins per friend with a visual drunk indicator
- Five tipsiness categories: `Fresh`, `Buzzing`, `Loose`, `Wavy`, `Gone Mode`
- Green `join me` by default, red `do not join me` when turned off
- Top-right location precision control: exact, approximate 150m, or off
- Location sharing groups so users can decide who sees exact/approximate/off
- `+1` button (bottom-left corner) to log a drink
- Party theme selector — set the evening type (beer night, cocktail night, etc.) and the average drink price
- See who is already drinking and who hasn't started
- Tinder-style swipe to invite someone to drink with you
- Group view — see who is in the same group/location
- If a friend has location off: show only allowed fallback context, such as approximate area, event/theme, or manually provided usual bars

### 2. Stats (SEST)
Personal and social drinking stats.

- Drinks over time (graphs)
- Leaderboard / ranking among friends
- Historical nights out

### 3. Profile / Solo (MEST)
Personal space, mostly standalone actions.

- Run a solo alcotest
- Control drunkness visibility: category only, percentage only, both, or hidden
- Review join status, location precision, events, groups, and privacy summary
- App info and account settings

### 4. Alcotest (TEST)
Gamified active test panel that adds extra signals to the drunk score.

- First choice: Single Player or Multiplayer
- Multiplayer supports pass-the-phone and connected-device rounds
- Temporary guests are allowed and stay in local night history
- Games include reaction, coordination, memory, motion, voice, tongue twister, and vibe checks
- Score updates only after the full round is complete

### 5. Evening Theme (THÈME / SOIRÉE)
Set context for the current night before going out.

- "Je bois que…" — what you're drinking tonight (beer, cocktails, shots…)
- "Je suis que…" — your mood/role for the evening
- Calendar integration to plan or log future nights

---

## Drunkenness Tracking

The app estimates intoxication passively and actively using several signals, always with user consent (see Privacy).

### Passive signals (background)
| Signal | How it's used |
|---|---|
| Phone usage patterns | Typing speed, error rate, unlock frequency |
| Motion sensors | Accelerometer / gyroscope — gait detection, instability |
| Screen interaction | How the user looks at / holds the phone |
| Location + venue price | Cross-reference location with avg beer/cocktail price at that bar |

### Active signals (user-triggered)
| Signal | How it's used |
|---|---|
| `+1` button | Manual drink log — user taps each time they finish a drink |
| Voice analysis | Optional active tests analyze speech clarity, slurring, pace, and tongue twisters |
| Message analysis | Typing patterns and language in messages |
| Internet search behavior | Query patterns as a proxy for cognitive state |
| Alcotest screen | Dedicated test combining the above for a snapshot reading |

> Note: All passive signals require explicit opt-in. Voice/message analysis requires the call/message privacy setting to be enabled.

---

## Onboarding Questionnaire

Collected on first launch to calibrate the tracking and set defaults.

1. **Location sharing?**
   - Yes → standard map features enabled
   - No → ask: your street? usual bars? how often? when do you typically go out?

2. **What do you drink?** + frequency (times per week / per session)

3. **What counts as a `+1`?** — user defines their unit (pint, shot, glass of wine…)

---

## Settings

### Languages
EN, FR, DE, HR, ES

### Style Modes
Blackout, Cartoon, Chaos

- Chaos is the default
- Style mode is private to the user
- Main animations can be turned off separately
- All modes must stay anti-AI-looking, with no generic rounded app style

### Privacy Levels
All toggleable independently. When a feature is off, the app falls back gracefully (e.g. location off → questionnaire fills the gap).

| Setting | Default | Notes |
|---|---|---|
| Location sharing | Asked onboarding | If off, triggers onboarding fallback questions |
| Location precision | Exact | Can be exact, approximate 150m, or off |
| Default join status | Join me | Toggleable in settings |
| Drunkness visibility | Category only | Can be category, percentage, both, or hidden |
| Internet activity tracking | Off | To be developed |
| Call analysis | Off | Used for alcotest voice feature |
| Message analysis | Off | Used for alcotest message feature |
| Notifications | On | |
| Phone usage tracking | Off | Motion + screen interaction signals |

> No data is ever recorded without a matching privacy toggle being on.

### `+1` Definition
User sets what one drink unit means for them (e.g. 33cl beer = 1, glass of wine = 1, shot = 0.5…). This affects all stats and tracking.

---

## Backend

### Core responsibilities
- **Location service** — real-time position updates for the map
- **Data storage** — drink logs, drunk estimates, session history, user profiles
- **Privacy enforcement** — data is scoped strictly per user; nothing shared without consent
- **Drunk score computation** — aggregates all passive/active signals into a single estimate

### Data model notes
- User data stored privately; friend data shared only within accepted friend groups
- Hashmap-style structure for venue/style data (bar → average drink price, type)
- No persistent audio/call recording — analysis is on-device or ephemeral

---

## Platform

- **Primary target:** iOS (iPhone)
- Android and other platforms are out of scope for v
- Visual design must be anti-AI-looking: no generic rounded app style, no glassmorphism, no polished template UI.
