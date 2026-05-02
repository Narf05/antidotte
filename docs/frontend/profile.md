# Screen — Profile (MEST)

Profile is the user's personal area. It shows identity, current night status, drunk score summary, quick actions, and account/settings access.

## Core Features

- User identity.
- Current night status.
- Drunk score summary.
- `+1` drink unit summary.
- Solo Alcotest shortcut.
- Event/theme summary.
- Location and join status controls.
- Friend/location groups access.
- Stats shortcuts.
- Settings access.
- App info/about.

## User Identity

Show:
- Name.
- Username or handle.
- Profile image or initials.
- Current status if enabled.
- Account type if relevant.

Editable fields:
- Display name.
- Username/handle.
- Profile image.
- Bio/status line if supported.

## Current Night Status

Profile should show the user's current night state.

Fields:
- Active event/theme.
- Current join status.
- Current location precision.
- Current tipsiness category.
- Drinks logged tonight.
- Last Alcotest result.

Tipsiness categories:
- `Fresh` - emoji: `🙂`
- `Buzzing` - emoji: `😄`
- `Loose` - emoji: `😵‍💫`
- `Wavy` - emoji: `🌊`
- `Gone Mode` - emoji: `🫠`
- `Unknown` - emoji: `❔`

Join status:
- `Join me`
- `Do not join me`

Location precision:
- Exact.
- Approximate 150m.
- Off.

## Drunk Score Summary

Profile should summarize the user's current and recent drunk score.

Current summary:
- Current tipsiness category.
- Confidence level.
- Signals used.
- Last updated time.

Recent history:
- Last Alcotest round.
- Drinks logged tonight.
- Recent passive signals if enabled.

If there is not enough data:
- Show `Unknown`.
- Explain that more signals are needed.

## Drunkness Visibility

The user should be able to decide how their drunkness is shown to friends.

Visibility options:
- Show category only.
- Show percentage only.
- Show category and percentage.
- Show nothing.

Default:
- Show category only.

Where it appears:
- On the map pin: show the selected drunkness visibility level.
- In the friend profile popout: show the selected drunkness visibility level.
- If set to `show nothing`, friends should not see the user's drunkness on the map or in the popout.

Map behavior:
- If category is visible, show the tipsiness category and its emoji.
- If percentage is visible, show the drunk score percentage.
- If both are visible, show category, emoji, and percentage.
- If hidden, show no drunkness information.

Popout behavior:
- When a friend taps the user's profile from the map, the popout follows the same visibility setting.
- The popout can show more context only if the user allowed it.
- Private signal details should never be shown to friends.

Visibility examples:

```text
Show category only:
Buzzing 😄

Show percentage only:
42%

Show category and percentage:
Buzzing 😄 - 42%

Show nothing:
hidden
```

Profile owner behavior:
- The user should always be able to see their own drunk score summary in Profile.
- Hiding drunkness only affects what friends can see.

Settings:
- This visibility should be configurable from Profile and Settings.
- The user can change it at any time.

## `+1` Drink Unit

Profile should show the user's current `+1` definition.

Examples:
- `33cl beer = 1`
- `glass wine = 1`
- `shot = 0.5`

Actions:
- Edit `+1` definition.
- Open Settings drink unit section.
- Log `+1` if the app allows it from Profile.

## Solo Alcotest

Profile should include a shortcut to Single Player Alcotest.

Behavior:
- Opens the TEST screen in Single Player mode.
- Uses the same privacy rules as Alcotest.
- Updates the user's drunk score only after the full round is complete.

Shortcut options:
- Quick Round.
- Full Round.
- Custom Round.

## Event / Theme Summary

Profile should show the current event/theme if one is active.

Fields:
- Event/theme name.
- Drink type.
- Mood/role.
- Average drink price.
- Start time.
- Group members if shared.

Actions:
- Create event/theme.
- Edit current event/theme.
- End current event/theme.
- Open Theme screen.

If no event/theme is set:
- Show `No event set`.
- Offer action to create one.

## Location And Join Controls

Profile should let the user review and edit how they appear on the map.

Controls:
- Join status.
- Location precision.
- Location sharing groups.

Join status:
- `Join me`
- `Do not join me`

Default behavior:
- `Join me` is on by default unless changed in Settings.
- The user can switch it off from Profile.

Location precision:
- Exact.
- Approximate 150m.
- Off.

Profile should show:
- Who can see exact location.
- Who can see approximate location.
- Which groups are blocked.

## Location Sharing Groups

Profile should provide access to group management.

Group actions:
- Create group.
- Rename group.
- Add friends.
- Remove friends.
- Delete group.
- Set location precision for the group.

Per-group precision:
- Exact.
- Approximate 150m.
- Hidden/off.

Example:

```text
LOCATION GROUPS

Close friends - exact
Uni friends - approx 150m
Work friends - off
Tonight group - exact
```

## Stats Shortcuts

Profile should link into Stats.

Shortcuts:
- Drinks this week.
- Last night out.
- Historical nights.
- Leaderboard.
- Drunk score history.

Possible summary items:
- Drinks this week.
- Last night out.
- Favorite drink.
- Favorite evening theme.
- Most common night-out group.

## Friends / Social Summary

Profile can show lightweight social context.

Examples:
- Number of accepted friends.
- Current active group.
- Pending join requests.
- Pending friend requests.

Actions:
- View friends.
- Manage friend requests.
- Open current group.

## Settings Access

Profile should link to Settings.

Settings covers:
- Language.
- Privacy toggles.
- Notifications.
- Default join status.
- Location group defaults.
- `+1` drink unit.
- Account information.

## Privacy Summary

Profile should show a quick privacy snapshot.

Examples:
- Location: exact / approx 150m / off.
- Voice analysis: on/off.
- Message analysis: on/off.
- Phone usage tracking: on/off.
- Notifications: on/off.

Actions:
- Open full Settings.
- Edit privacy toggles.

## App Info

App info can include:
- Version.
- Privacy explanation.
- Terms/about text.
- Support/contact.

## Empty / First-Time State

If the user has not completed setup:
- Prompt onboarding.
- Ask for `+1` drink unit.
- Ask for privacy choices.
- Ask for default join/location behavior.

If the user has no night history:
- Show no previous nights.
- Offer to create an event/theme or start a night.

## Open Questions

- Should `+1` logging be available directly from Profile, or only Map?
- Should location groups be managed mainly from Profile, Settings, or both?
