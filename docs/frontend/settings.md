# Settings

Settings controls language, privacy, notifications, and the user's `+1` drink definition.

## Sections

- Language
- Privacy
- Notifications
- `+1` drink unit
- Account/app info

## Language Selector

Supported languages:
- EN
- FR
- DE
- HR
- ES

Changing language updates app copy.

## Privacy Toggles

Required toggles:
- Location sharing
- Internet activity tracking
- Call analysis
- Message analysis
- Notifications
- Phone usage tracking

Each toggle must show:
- Current state: `ON` or `OFF`.
- What the feature does.
- What happens when the feature is off.

Defaults:
- Location sharing: On
- Notifications: On
- Internet activity tracking: Off
- Call analysis: Off
- Message analysis: Off
- Phone usage tracking: Off

## Fallback Behavior

When a feature is off:
- Location sharing off: use onboarding fallback data only.
- Internet tracking off: do not use search/browser signals.
- Call analysis off: skip voice-based Alcotest games.
- Message analysis off: do not use message signals.
- Phone usage off: do not use motion, screen, or typing passive signals.
- Notifications off: do not send reminders or friend pings.

## `+1` Drink Unit

The user defines what one drink unit means.

Examples:
- `33cl beer = 1`
- `glass wine = 1`
- `shot = 0.5`

The setting affects:
- Manual drink logs.
- Stats.
- Drunk score.

## Privacy Copy

Use short and clear explanations.

Examples:
- `Off means we do not use this signal.`
- `Location is shared only with accepted friends.`
- `Voice is analyzed only when enabled.`

Avoid vague explanations such as:
- `Make the app smarter`
- `Improve experience`
- `Personalize everything`
