# Onboarding Questionnaire

Onboarding collects the minimum information needed to set up the app and calibrate the user's defaults.

## Flow

1. Welcome.
2. Location sharing choice.
3. Location fallback questions if location is off.
4. Drink preferences.
5. `+1` drink unit definition.
6. Privacy settings summary.
7. Finish setup.

## Location Sharing

Question:

```text
Do you want to share your location with accepted friends?
```

If yes:
- Enable standard map features.
- Show user on friend map.

If no:
- Ask fallback questions.
- Do not show precise live location.

Fallback questions:
- Street or rough area.
- Usual bars.
- How often the user goes out.
- When the user typically goes out.

## Drink Preferences

Collect:
- Usual drink types.
- Drinking frequency.
- Typical drinks per session.

This helps:
- Set default themes.
- Improve drunk score calibration.
- Fill initial stats context.

## `+1` Drink Unit

The user defines what one drink unit means.

Examples:
- `33cl beer = 1`
- `glass wine = 1`
- `shot = 0.5`

This affects:
- Drink logs.
- Stats.
- Drunk score calculations.

## Privacy Defaults

Show the user the initial privacy settings before finishing.

Defaults:
- Location sharing: On, unless declined.
- Notifications: On.
- Internet activity tracking: Off.
- Call analysis: Off.
- Message analysis: Off.
- Phone usage tracking: Off.

No passive signal should be enabled unless the user explicitly opts in.
