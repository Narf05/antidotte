# Frontend - Settings

User-facing configuration screen for profile, privacy, score calibration,
drink logging, location, friends, notifications, and account controls.

User-facing copy should say `score`, `percentage`, and `drink`. Internal
backend fields may still use existing names such as `drink_unit_definition`
or `photo_drink_detection_enabled`.

## Goals

- Let users change every choice made during onboarding.
- Make sensitive controls easy to find.
- Keep global privacy switches separate from per-friend/per-group visibility.
- Give users immediate safety controls such as panic privacy.
- Explain fallbacks when a feature is off.
- Support iOS permission state clearly.

## Information Architecture

Recommended settings sections:

0. Panic Privacy
1. Account
2. Appearance
3. Privacy & Safety
4. Location
5. Score & Calibration
6. `+1` Drink Unit
7. Photo-Assisted Drink Logging
8. Friends & Groups
9. Notifications
10. Language
11. Data, Export & Deletion
12. About

Settings should be searchable if the page becomes long.
Use one long settings screen with section anchors rather than separate settings
subpages.
Panic privacy should be fixed at the top of settings so it is always quick to
reach.

## Account

Controls:

- Username.
- Display name.
- Profile photo.
- Search visibility.
- Age verification status, read-only after onboarding unless support/legal flow
  requires change.

Rules:

- Username must remain unique.
- Profile photo is optional.
- Search visibility controls whether other users can find the profile by
  username/search.
- Private calibration data must not appear on the public profile.

## Appearance

Controls:

- Style mode: `Blackout`, `Cartoon`, `Chaos`.
- Main animations: on/off.

Defaults:

- Style mode: `Chaos`.
- Main animations: on, unless device reduced-motion settings require less motion.

Rules:

- Style mode is private to the user and only changes how their app looks.
- Main animations can be turned off independently from style mode.
- Turning animations off removes major wobble, shake, jumping labels, page motion, and animated backgrounds.
- Reduced-motion system settings override the in-app animation setting.

## Privacy & Safety

Top-level controls:

| Control | Default | Notes |
|---|---|---|
| Panic privacy | Off | Hides location and score immediately for 24 hours. |
| Location sharing | Asked onboarding | Master switch. |
| Drunkness visibility | Asked onboarding | Controls whether friends see category, percentage, both, or nothing. |
| Motion tracking | Off | Derived motion summaries only. |
| Phone usage tracking | Off | Derived phone-use summaries only. |
| Voice analysis | Off | Optional active mini-test voice check. |
| Message analysis | Off | Future feature; keep off unless implemented. |

Social visibility shortcut:

- Provide a combined social visibility control for location sharing and
  drunkness visibility.
- This should make it easy to turn both social signals on/off together.
- Advanced users can still edit location and drunkness visibility separately.

Panic privacy:

- Prominent enough to find quickly.
- When enabled, hide live location from everyone immediately.
- Hide score from everyone immediately.
- Stop friend-visible realtime updates.
- Expire automatically after 24 hours unless the user re-enables normal sharing
  earlier.
- Make clear it is not account deletion and does not erase data.

Fallbacks:

- If motion tracking is off, score uses other signals with lower internal
  confidence.
- If phone usage tracking is off, score uses motion, logs, sessions, and active
  mini-tests.
- If voice analysis is off, voice mini-test is hidden or disabled.
- If drunkness visibility is hidden, friends cannot see category or percentage.

## Location

Controls:

| Control | Options | Notes |
|---|---|---|
| Location sharing | on/off | Global location visibility. |
| Location precision | exact, approximate 150m, off | Approximate means friends see a position blurred to about 150m. |
| Background location | on/off | Requires iOS permission. |
| Show me on friend map | on/off | Controls map presence. |
| Share during sessions only | on/off | Optional privacy limiter. |

Per-friend/per-group location:

- Exact.
- Approximate 150m.
- Hidden.
- Temporary sharing, e.g. exact for 2 hours.

Rules:

- Global location sharing off means nobody sees location.
- New accepted friends default to visible for all, including exact location, if
  global location sharing is enabled.
- Per-friend hidden rules override group rules.
- Panic privacy overrides all location sharing.
- Stale location shows with timestamp and hides after 12 hours.
- If iOS permission is denied, show an action to open system settings.

Fallbacks:

- If location is off, user can still create sessions and log drinks.
- User can set manual city/area and usual venues.
- Venue can be selected manually.

## Score & Calibration

Controls:

- Body weight.
- Usual drinks per session.
- Usual sessions per week.
- Free-form sports description.
- Height, optional.
- Tolerance self-rating, optional.
- Drunkness visibility: category only, percentage only, category and percentage, or hidden.
- Active mini-test suggestions on/off, if we decide to expose this.

Rules:

- Body weight is required from onboarding but editable here.
- Calibration data is private and not shown to friends.
- Drunkness can be shared with allowed friends as category only, percentage only, category and percentage, or hidden.
- Confidence is internal and not shown to friends.
- The score must not be presented as a medical or legal test.

Fallbacks:

- If optional calibration is blank, use default model assumptions with lower
  internal confidence.

## `+1` Drink Unit

Controls:

- Default drink preset.
- Custom unit label.
- Volume/size.
- Strength/percentage, if user wants to refine it.
- Reset to presets.

Rules:

- Use user-facing language around drink units.
- Let users refine details after onboarding.
- Changes affect future logs and estimates.
- Historical logs should keep the values saved at the time unless user chooses
  to edit them.

## Photo-Assisted Drink Logging

Controls:

| Control | Default | Notes |
|---|---|---|
| Photo detection | Off | Enables optional photo-assisted pre-fill. |
| Save photos after analysis | Off | If off, delete raw photo after analysis. |
| `+1` photo flow default | quick log / photo first / ask each time | User preference. |

Rules:

- User can always edit photo-filled values before saving.
- Photos are never shared with friends by default.
- If saving is turned off, future raw photos are deleted after analysis.
- If turning saving off, offer cleanup for previously saved drink photos.

Fallbacks:

- If photo detection is off, `+1` remains a fast manual drink log.

## Friends & Groups

Controls:

- Add friends by username/search.
- Invite friends with code/link.
- Generate invite code only after tapping "Invite friends".
- Contacts matching from friends screen, not required onboarding.
- Create/edit personal groups.
- Create/edit shared groups.
- Per-friend visibility.
- Per-group visibility.
- Apply visibility preset to all friends.
- Blocked users.

Rules:

- Invite codes expire after 3 days.
- Contact matching refreshes monthly if enabled.
- Raw address book data should not be stored permanently.
- New accepted friends default to visible for all friend-level social features.
- Visible for all includes exact location if global location sharing is enabled.
- Visible for all follows the user's drunkness visibility setting.
- Per-friend settings can override defaults.
- Users can apply a visibility preset to all friends at once.
- Groups cannot override global privacy switches.
- Blocking removes active visibility immediately.

Per-friend settings:

- Location visibility: exact, approximate 150m, hidden.
- Drunkness visibility: category only, percentage only, category and percentage, hidden.
- Nearby notification: on/off.
- Starts-drinking notification: off by default.
- Session notification: on/off.
- Remove friend.
- Block user.

Bulk visibility presets:

- Visible for all.
- Exact location + selected drunkness visibility.
- Approximate 150m + selected drunkness visibility.
- Hide location, show selected drunkness visibility.
- Hide from all.

## Notifications

Global controls:

- Notifications on/off.
- Friend requests.
- Friend request accepted.
- Group invites.
- Session invites.
- Nearby friends.
- Friend starts drinking.
- Privacy events.

Rules:

- General notifications are on only if the user grants iOS permission.
- Per-friend "starts drinking" notifications exist but are off by default.
- Notification text should not reveal exact location.
- Notification text should not reveal drunkness category or percentage unless
  the recipient can see it in-app.
- If iOS notification permission is denied, show an action to open system
  settings.

## Language

Supported languages:

- English.
- French.
- German.
- Croatian.
- Spanish.

Rules:

- Language can be changed without losing user data.
- Use system language by default when supported.
- Fall back to English.

## Data, Export & Deletion

Controls:

- Export my data.
- Delete saved drink photos.
- Delete a session from history.
- Delete account.
- Recover account during deletion grace period.

Account deletion:

- 1-month grace period before hard-delete.
- Account can be recovered during the grace period.
- Friends lose access immediately during the grace period.
- Live/social visibility is disabled immediately.
- Deleted data remains in backups for maximum 3 days.

Rules:

- Users cannot delete only location history while keeping the rest of a session.
- Location is deleted with the related session/account deletion flow.
- Data export should be machine-readable, e.g. JSON.
- Deletion flows should explain consequences clearly.

## About

Content:

- App version.
- Privacy policy.
- Terms.
- Open-source licenses.
- Map attribution/OpenStreetMap attribution.
- Support/contact.

Rules:

- App Store privacy labels must match actual data practices.
- Third-party SDKs should not collect extra data for analytics, advertising,
  profiling, or tracking.

## iOS Permission States

Settings must reflect both app-level toggles and iOS system permission states.

Examples:

- App location sharing on, iOS location denied: show blocked state and system
  settings action.
- App notifications on, iOS notifications denied: show blocked state and system
  settings action.
- Background location on, iOS allows only foreground: show limited state.
- Contacts matching requested, iOS contacts denied: show manual friend search
  and invite code options.

## User-Facing Copy Rules

- Say `drink`, not backend/internal terms.
- Say `score` or `percentage`, not medical/legal claims.
- Do not present the app as a medical tool.
- Do not present score as proof of safety.
- Keep sensitive controls understandable and direct.

## Resolved Product Decisions

- Settings should be one long screen with section anchors.
- Panic privacy should be fixed at the top of settings.
- Drunkness visibility and location sharing should have a combined social visibility
  shortcut.
- Users can apply visibility presets to all friends at once.
