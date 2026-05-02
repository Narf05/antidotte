# Screen — Map (BEST)

The map is the main screen. It shows where friends are tonight, whether they are open to people joining them, their current drunk score state, and what event/theme they are part of.

## Core Features

- Live map.
- Friend locations.
- Friend drunk score indicators.
- Join status: green `join me` by default, red `do not join me` only when turned off.
- Friend profile preview from the map.
- Active event/theme display.
- `+1` drink logging.
- Top-right location precision control.
- Location sharing groups.
- Group/location view.
- Invite/join flow.
- Location-off fallback.

## Map Data

- Use OpenStreetMap as the map data source.
- Keep OpenStreetMap attribution visible.
- Show accepted friends only.
- Do not show precise data for users who disabled location sharing.
- Update visible friend locations in near real time when permissions allow.

## Location Precision Control

The map should have a button in the top-right corner for location precision.

Purpose:
- Let the user quickly switch from exact location to approximate location.
- Make approximate sharing easy without fully turning location off.

Precision modes:
- Exact location.
- Approximate location, around 150m.
- Location off.

Approximate mode behavior:
- When enabled, friends see an approximate position within about 150m.
- The user's exact coordinates are not shown to friends.
- Profile preview should mark the location as approximate.
- The map should still allow the user to appear active tonight.
- Nearby group/event logic can still work, but should respect the lower precision.

Button behavior:
- Tap top-right location button.
- Show precision options.
- User chooses exact, approximate, or off.
- Change applies immediately to what friends can see.
- The app should clearly show the user's current precision mode.

Example:

```text
LOCATION

[ EXACT ]
[ APPROX 150M ]
[ OFF ]
```

## Friend Pins

Each visible friend should appear on the map with:
- Name or initials.
- Current drunk score state.
- Join status.
- Current event/theme if available.
- Whether they are alone or with a group.

Tipsiness categories:
- `Fresh` - no clear drunk signals yet.
- `Buzzing` - early/light drinking signals.
- `Loose` - noticeable tipsiness.
- `Wavy` - strong drunk signals.
- `Gone Mode` - highest drunk score category.

If there is not enough data, show `Unknown` until the app has enough signals.

Join status:
- Green: `join me`
- Red: `do not join me`

## Join Status System

Each user can set whether they want people to join them.

Statuses:
- `Join me`
- `Do not join me`

Behavior:
- `Join me` is on by default.
- `Join me` means friends can request to join or get directions/context.
- `Do not join me` means friends should not be prompted to join.
- The user stays in `Join me` until they manually turn it off.

Map behavior:
- Friends with `Join me` are shown as available to join.
- Friends with `Do not join me` are shown as unavailable.
- The app should not send join invites to users marked `Do not join me`.
- The user can change their own status from the map.
- When a new night starts, the default join status is `Join me` unless the user has changed their default in Settings.
- The default join status should be toggleable in Settings.

Settings option:

```text
Default join status

[ Join me by default ]
[ Do not join me by default ]
```

## Friend Profile Preview

Tapping a friend on the map opens their profile preview.

Profile preview should show:
- Name.
- Profile photo or initials.
- Current drunk score state.
- Join status.
- Current event/theme.
- Current drink type if shared.
- Current group if they are with others.
- Last updated time.
- Location precision state, such as exact, approximate, or estimated.

Possible actions:
- Request to join, if their status is `Join me`.
- Send message/ping, if allowed.
- View group, if they are in a group.
- Close preview.

If the friend has `Do not join me`:
- Hide or disable the join action.
- Still show allowed shared information.

If drunk score is unavailable:
- Show `Unknown`.
- Explain that not enough signals are available or sharing is off.

## Event / Theme Display

If a friend has joined or created a particular event, the map should show it in their profile preview and optionally on the pin/group view.

Event/theme fields:
- Event name.
- Drink type.
- Mood/role.
- Average drink price.
- Start time.
- Group members if shared.
- Venue or area if shared.

Examples:
- `Beer night`
- `Cocktail night`
- `Birthday pregame`
- `Club night`
- `House party`
- `No event set`

Behavior:
- If a friend has an active event, show which one it is.
- If no event is set, show `No event set`.
- If event sharing is private, show only basic allowed context.
- Event data should feed Stats and current session context.

## Own Status Controls

The current user should be able to set:
- `Join me`
- `Do not join me`
- Current event/theme
- Current drink/theme
- Location precision: exact, approximate 150m, or off
- Which groups can see location

These controls affect how the user appears on friends' maps.

## Location Sharing Groups

Users should be able to create groups to decide who can see their location.

Purpose:
- Share exact location with close friends.
- Share approximate location with wider friend groups.
- Hide location from people who should not see it.
- Avoid one global location setting for everyone.

Group examples:
- Close friends
- Uni friends
- Work friends
- Night out group
- House party group
- Custom group

Group controls:
- Create group.
- Rename group.
- Add friends.
- Remove friends.
- Delete group.
- Set location precision per group.

Per-group location precision:
- Exact location.
- Approximate location, around 150m.
- Hidden/off.

Example:

```text
LOCATION GROUPS

Close friends - exact
Uni friends - approx 150m
Work friends - off
Tonight group - exact
```

Rules:
- A friend's most permissive shared group should decide what they can see.
- If a friend is in no allowed group, they should not see the user's location.
- If the user sets global location off, no group can see location.
- If the user sets approximate mode globally, groups should not receive exact location unless the user explicitly changes it.
- The app should make it clear who can currently see exact vs approximate location.
- Location group defaults should be configurable in Settings.

Map behavior:
- The user can access group sharing from the map.
- The profile preview for the current user can show who can see them.
- Friends only see the precision level allowed for their group.

## `+1` Drink Button

The `+1` button logs a drink for the current user.

Behavior:
- Tap once to add one drink unit.
- Use the user's `+1` definition from Settings.
- Update the user's current night session.
- Update Stats and drunk score inputs.
- Keep the action available from the map because the map is the main night-out screen.

## Group View

When multiple friends are at the same or nearby location:
- Show them as a group.
- Allow opening group details.
- Show who is in the group.
- Show each member's drunk score state if shared.
- Show each member's join status.
- Show shared event/theme if the group has one.

Group details should include:
- Group name or location name if available.
- Members.
- Average or overall group drunk score state if useful.
- Active event/theme.
- Join availability.

If some members are `Join me` and others are `Do not join me`:
- Let the user request to join only the friends who allow it.
- Do not imply the whole group is open if some people are not.

## Invite / Join Flow

Users can request to join friends who are open to it.

Flow:
1. Tap a friend or group.
2. Open profile preview or group preview.
3. If status is `Join me`, show join/request action.
4. User sends request.
5. Friend receives notification if notifications are enabled.
6. Friend can accept, ignore, or decline.

Rules:
- Do not allow join requests to users marked `Do not join me`.
- Do not send repeated spam requests.
- Respect notification settings.
- Show request status after sending.

## Swipe Invite

Swipe invite can still exist as a faster friend discovery flow.

Flow:
1. Open invite view.
2. See suggested friends.
3. Swipe right to request/join if allowed.
4. Swipe left to skip.
5. Hide or mark people who are `Do not join me`.

Suggested friends should prioritize:
- Nearby accepted friends.
- Friends with `Join me`.
- Friends in the same or similar event/theme.
- Friends with recent activity tonight.

## Location-Off Fallback

If a friend has location off:
- Do not show their precise location.
- Use onboarding fallback data if available.
- Show street/area only if the user provided it.
- Suggest likely bars only when enough fallback data exists.
- Mark the result as estimated.

Profile preview should show:
- `Location off`
- Estimated area if available
- Event/theme if shared
- Drunk score state if shared
- Join status if shared

## Privacy Rules

- Show only accepted friends.
- Respect location sharing.
- Respect event/theme sharing.
- Respect drunk score sharing.
- Respect notification settings.
- Do not show precise location when location is off.
- Do not expose private signals behind the drunk score.

## Empty / Quiet States

If no friends are out:
- Show that no accepted friends are currently active.
- Allow the user to set their own status/event.
- Keep `+1` available.

If friends are out but hidden by privacy:
- Show only the allowed information.
- Do not imply unavailable private data.

## Open Questions

- Should `Do not join me` hide the user from swipe invite entirely?
- Should friends be able to see exact drunk score percentages, or only labels?
- Should event/theme sharing be automatic or separately toggleable?
