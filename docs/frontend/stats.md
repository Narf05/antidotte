# Screen — Stats (SEST)

Stats shows personal and social drinking history.

## Core Features

- Drinks over time.
- Night/session history.
- Friend leaderboard.
- Group comparisons.
- Drunk score history.
- Spending estimates if theme price data is available.

## Drinks Over Time

Show drink logs across:
- Current night.
- Week.
- Month.
- All time.

Inputs:
- `+1` logs.
- User-defined drink unit.
- Evening theme.
- Session timestamps.

## Drunk Score History

Show how the user's drunk score changed during a night.

Inputs:
- Manual drink logs.
- Alcotest results.
- Passive signals if enabled.
- Theme/context data.

## Leaderboard

Leaderboard compares accepted friends.

Possible rankings:
- Drinks logged tonight.
- Current drunk score state.
- Most active this week.
- Group session participation.

Rules:
- Only show data friends have agreed to share.
- Do not expose private signals.
- Respect privacy settings.

## Historical Nights Out

Each past night should include:
- Date.
- Theme.
- Drink count.
- Friends/group.
- Peak drunk score.
- Alcotest rounds if any.
- Estimated spend if price data exists.

## Empty State

If there is no history yet:
- Show that no stats exist.
- Offer actions such as starting a night, logging a drink, or setting a theme.
