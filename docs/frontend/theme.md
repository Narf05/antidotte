# Frontend - Theme / Session Context

Bottom sheet for setting the context of a planned or active night-out session.
The user opens it from a button on the map page, then chooses the session
options. This helps the app pre-fill `+1` refreshment logs, improve score
estimates, organize history, and make the map/stats feel more personal.

User-facing copy should say `theme`, `session`, `refreshment`, `score`, and
`percentage`. Internal backend fields may still use names such as
`night_out_sessions.theme`, `drink_logs`, or `drink_unit_definition`.

## Goals

- Let the user define what kind of session this is.
- Let the user set default refreshment presets for the session.
- Let the user set mood/role/context.
- Support planned future sessions and logging past sessions.
- Feed useful context into map, stats, refreshment logging, and score estimates.
- Stay optional: the app should still work if the user skips theme setup.

## Entry Points

Theme/session context can open from:

- Map screen button, opening a bottom sheet.
- Current active session panel.
- `+1` flow.
- Session detail/history.
- Calendar/planning flow.
- Settings or profile shortcuts if needed.

Rules:

- If no active session exists, setting a theme can create a planned session or
  prepare defaults for the next auto-created session.
- If an active session exists, changes apply to the current session.
- Users can edit theme after the session has started.
- The main interaction pattern should be a bottom sheet from the map, not a full
  standalone screen.

## Primary Fields

`night_out_sessions`

| Field | User-facing label | Notes |
|---|---|---|
| `title` | Session name | Auto title like `Friday night`; user editable. |
| `theme` | Theme | Context/preset for the session. |
| `started_at` | Start time | Manual or auto-created. |
| `ended_at` | End time | Manual or auto-ended after inactivity. |
| `privacy_scope` | Visibility | Private, friends, group, invite only. |
| `primary_city` | City | Optional/manual or inferred. |
| `primary_country` | Country | Optional/manual or inferred. |

Additional frontend-only/setup fields can be saved as session metadata if the
backend supports it later.

## Theme Presets

Theme presets should be broad and user-friendly.

Examples:

- Casual.
- Dinner.
- Club.
- House party.
- Festival.
- Bar crawl.
- Celebration.
- Date.
- Solo.
- Custom.

Rules:

- Presets should not use explicit backend/internal wording in the UI.
- Custom theme name is allowed.
- Theme should be editable during or after the session.
- Theme feeds stats filters and history grouping.

## Refreshment Defaults

Purpose:

- Pre-fill `+1` refreshment logs during the session.
- Improve score estimates when logs are incomplete.
- Support average price/spend estimates.

Controls:

- Main refreshment preset for the session.
- Secondary refreshment preset, optional.
- Default serving/unit.
- Optional strength/percentage refinement.
- Average price per unit.
- Currency.

Rules:

- Use presets first; user can refine details later.
- User can override values per `+1` log.
- Price can be user-entered or inferred from venue averages/photo evidence.
- Average price should be a session-level default.
- Stats should include money spent in v1 when price data exists.

## Mood / Role Context

Purpose:

- Add lightweight context to the session.
- Make history more personal.
- Potentially influence UI tone or stats grouping later.

Examples:

- Chill.
- Big night.
- Birthday.
- Celebration.
- After work.
- Dancing.
- Meeting friends.
- Solo mode.
- Custom.

Rules:

- Mood/role is optional.
- It should not affect privacy by itself.
- It should not be used to make medical/legal claims.
- It can appear in session detail/history and stats filters.
- Mood/role is visible to friends by default when the session is visible.
- User can remove/hide mood visibility in settings.

## Calendar and Planning

Users should be able to plan future sessions or log past ones.

Planned session:

- Title.
- Date.
- Start time.
- Optional venue/city.
- Optional invited friends/group.
- Theme.
- Refreshment defaults.
- Privacy scope.

Past session:

- Date/time range.
- Theme.
- Venue(s).
- Refreshment logs.
- Participants if user wants to add them privately.

Rules:

- Planning a session does not automatically share location.
- Inviting a group creates session-specific participation/visibility only.
- Future sessions should be editable or cancellable.
- Past sessions should respect deletion/privacy rules.
- Planned sessions should create iOS Calendar events if the user grants Calendar
  permission.
- Calendar event creation should be optional and editable.

## Visibility

Controls:

- Private.
- Friends.
- Group.
- Invite only.

Rules:

- Session visibility cannot override global privacy switches.
- Panic privacy hides live location and score immediately.
- A group invite does not grant permanent location access.
- Friend/group visibility rules still apply.

## Active Session Behavior

When a session is active:

- Theme appears in current session panel.
- `+1` uses session refreshment defaults.
- Map can show session/group context if allowed.
- Stats can group score chart/background bands by session.
- Session can include multiple venues.
- Session auto-ends after 4 hours of no relevant activity.

If user changes theme mid-session:

- Future logs use new defaults.
- Existing logs keep their saved values unless edited.
- Session history should show the final/current theme, with optional edit
  history only if needed later.

## How Theme Feeds Other Screens

Map:

- Shows current session title/theme.
- Can show group/session context.
- Uses venue/city context if location is off.

`+1` flow:

- Pre-fills refreshment unit.
- Pre-fills price/currency if known.
- Offers photo-assisted refreshment detection if enabled.

Stats:

- Filters by theme.
- Shows most common theme.
- Groups history by session.
- Includes spend if available.

History:

- Session cards show theme, title, date, venues, peak percentage, and spend.
- Past sessions can be edited/deleted.

## Empty and Fallback States

- If no active session exists, show options to plan, start, or skip.
- If user skips theme, auto-created session still works.
- If location is off, allow manual city/venue.
- If price is unknown, keep spend blank until user enters or inference exists.
- If refreshment defaults are missing, use the user's global `+1` preset.

## Data Requirements

Frontend needs to read/write:

- Session title.
- Session theme.
- Planned/active/ended status.
- Start/end time.
- Privacy scope.
- Refreshment defaults.
- Price/currency defaults.
- Venue/city.
- Invited friends/groups.

Potential backend additions later:

- `session_refreshment_defaults`
- `session_mood`
- `planned_session_reminders`

For now, simple fields can live on `night_out_sessions` or session metadata if
the backend supports flexible metadata.

## Resolved Product Decisions

- Theme opens as a bottom sheet from a button on the map page.
- Theme remains editable after the session starts.
- Mood/role is visible to friends by default, but users can hide it in settings.
- Planned sessions should create iOS Calendar events when permission is granted.
- Average price is a session-level default.
