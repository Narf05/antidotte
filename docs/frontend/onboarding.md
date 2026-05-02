# Frontend - Onboarding

First-launch flow that creates the user account, applies privacy defaults,
calibrates the score, sets location/friend visibility, and prepares the
main map experience.

The onboarding must be iOS-first and App Store-friendly: ask for sensitive
permissions only when the user understands the feature, keep copy clear, and let
users skip optional tracking features.

## Goals

- Verify the user is old enough to use the app.
- Create the basic profile.
- Collect required score calibration.
- Define the user's `+1` refreshment unit.
- Ask for location sharing and iOS location permission.
- Ask whether friends can see the user's percentage.
- Configure default friend visibility.
- Offer friend discovery.
- Set notification preferences.
- Explain privacy controls without overwhelming the first launch.

## Flow Overview

Recommended screen order:

1. Welcome / app promise.
2. Age gate.
3. Account basics.
4. Score calibration.
5. `+1` refreshment unit setup.
6. Privacy overview.
7. Location sharing.
8. Score sharing.
9. Optional passive signals.
10. Photo-assisted refreshment logging.
11. Friends and visibility defaults.
12. Notifications.
13. Ready screen / enter map.

The flow should save progress so users can resume if they leave during
onboarding.

## 1. Welcome

Purpose:

- Explain that Antidotte is a social night-out map and refreshment-awareness
  app.
- Make clear that the score is an estimate, not a medical or legal test.
- Set expectation that privacy controls are adjustable later.

Requirements:

- Do not request system permissions on the first screen.
- Do not use heavy legal text here; link to privacy policy/terms.
- Continue button starts the required setup.

## 2. Age Gate

Minimum age: 16.

Required input:

- Date of birth or age confirmation that allows verifying the user is 16+.

Rules:

- Users under 16 cannot create an account.
- Store only the minimum age-verification data needed.
- If under 16, show a blocked state and do not continue to social night-out
  features.
- Final regional/legal details need review before launch.

Backend fields/settings:

- Age verification result.
- Minimal date-of-birth or age-band data depending on final legal approach.

## 3. Account Basics

Required:

- Username.
- Display name.

Optional:

- Profile photo.
- Language.

Rules:

- Username must be unique.
- Search visibility should be adjustable later in settings.
- Profile photo is optional.
- Do not expose private data before friend acceptance.

## 4. Score Calibration

Required:

- `body_weight_kg`.
- `drink_unit_definition` as the backend field for the user's `+1`
  refreshment unit.

Optional:

- `usual_refreshments_per_session`.
- `usual_sessions_per_week`.
- `sports` as free-form text.
- `height_cm`.
- `tolerance_self_rating`.

Rules:

- Body weight is required during onboarding.
- Sports is optional and free-form, for example `football twice a week`.
- Do not ask about food eaten before/during sessions in v1.
- Calibration data is private and not shown to friends.
- Explain that calibration improves estimates but does not produce a medical
  result.

## 5. `+1` Refreshment Unit Setup

Purpose:

Define what one `+1` means for this user.

Required:

- Default refreshment type or custom refreshment unit.
- Unit label, e.g. small refreshment, glass, bottle, shot, custom.
- Preset strength/size where possible; user can refine exact details later.

Examples:

- `Small refreshment = 1`
- `Glass = 1`
- `Shot = 0.5`
- `Custom = user-defined`

Rules:

- User can edit this later in settings.
- Use presets during onboarding and let the user refine volume/percentage later.
- This affects refreshment logs, stats, and score estimates.

## 6. Privacy Overview

Purpose:

- Tell users that each sensitive feature has its own toggle.
- Explain that settings can be changed later.
- Mention panic privacy: hides location and the score immediately for 24
  hours.

Requirements:

- Use clear, short explanations.
- Do not bundle all permissions into one broad consent.
- Link to privacy policy.

## 7. Location Sharing

Ask during onboarding.

Choices:

- Enable location sharing.
- Skip for now.

If enabled:

- Ask for iOS location permission after explaining the live map feature.
- Ask whether background location should be enabled.
- Set default precision to exact location for accepted friends, unless user
  changes it.

Default behavior:

- New accepted friends are visible by default.
- Visible for all includes exact location.
- Global location sharing must still be enabled.
- Panic privacy, blocks, and per-friend hidden rules override the default.

If skipped:

- Set `location_sharing_enabled = false`.
- Allow manual city/area and usual bars/venues.
- User can still log refreshments and create sessions.

Settings created:

- `location_sharing_enabled`
- `location_precision`
- `share_when_app_closed`
- `show_me_on_friend_map`

## 8. Score Sharing

Ask whether friends can see the user's percentage.

Choices:

- Share with accepted friends.
- Keep private for now.

Rules:

- Friends can see exact percentage if enabled.
- Percentage is color coded in the app.
- Confidence is not shown to friends.
- User can change sharing per friend/group later.
- Panic privacy hides the score immediately.

Settings created:

- `drunk_score_sharing_enabled`

Note: user-facing copy should say `score`, `percentage`, and `refreshment`.
Internal backend fields may still use existing names such as
`drink_unit_definition` or `drunk_score_sharing_enabled`.

## 9. Optional Passive Signals

Ask separately for each optional signal.

Motion tracking:

- Uses derived motion summaries for score estimates.
- Strongest passive signal.
- Default off until user opts in.

Phone usage tracking:

- Uses derived phone-use deviation summaries.
- Default off until user opts in.
- Do not collect raw message content.

Voice analysis:

- Optional active phone test only.
- Default off.
- Raw audio should be processed on-device or deleted immediately after analysis.

Message analysis:

- Future feature.
- Default off.
- Should not be emphasized in v1 onboarding unless the feature exists.

Settings created:

- `motion_tracking_enabled`
- `phone_usage_tracking_enabled`
- `voice_analysis_enabled`
- `message_analysis_enabled`

## 10. Photo-Assisted Refreshment Logging

Ask whether the user wants photo-assisted refreshment detection.

Choices:

- Enable photo refreshment detection.
- Skip for now.

Then ask separately:

- Save refreshment photos after analysis.
- Delete raw photos after analysis.

Defaults:

- `photo_drink_detection_enabled = false`
- `save_drink_photos_enabled = false`
- If enabled but saving is off, raw photos are deleted after analysis.

Rules:

- User can always edit AI-filled refreshment data before saving.
- Photos are never shared with friends by default.
- User can change photo settings later.

Settings created:

- `photo_drink_detection_enabled`
- `save_drink_photos_enabled`
- `photo_analysis_default`

## 11. Friends and Visibility Defaults

Offer friend discovery methods:

- Username/search.
- Invite code/link, only after tapping "Invite friends".
- Contacts, later from the friends screen.

Rules:

- Friend requests require acceptance.
- Invite codes expire after 3 days.
- Contacts permission is optional and should be requested later from the friends
  screen.
- Contact matching is not part of the required onboarding flow.
- If contact matching is enabled later, refresh matches monthly.
- Raw address book data should not be stored permanently.
- Username search shows minimal public profile before friendship.

Default visibility for new friends:

- Visible for all friend-level social features.
- Includes exact location if global location sharing is enabled.
- Includes percentage if score sharing is enabled.
- Per-friend settings can override this later.

Friend groups:

- Let users create groups later; do not force group setup during onboarding.
- Optionally offer "Create first group" after adding friends.
- Groups can be personal lists or shared groups.

## 12. Notifications

Ask for notification permission after explaining social alerts.

Default:

- General notifications on if the user grants iOS permission.
- Per-friend "starts refreshing" notifications off by default.
- Nearby-friend notifications can exist, but must respect location permissions.

Notification types:

- Friend requests.
- Friend request accepted.
- Group invites.
- Session invites.
- Nearby friend, if both users allow it.
- Friend starts refreshing, only if enabled for that friend.

Rules:

- Do not reveal exact location in notification text.
- Do not reveal percentage in notification text unless allowed.
- User can change notification preferences later.

Settings created:

- `notifications_enabled`
- Initial `friend_notification_settings`

## 13. Ready / Enter Map

Final screen should:

- Confirm setup is complete.
- Show the user can change privacy/settings later.
- Enter the map as the first main experience.

Do not show a marketing landing page after onboarding. Go straight into the
usable app.

## Data Written During Onboarding

Backend records/settings:

- `users`
- `user_profiles`
- `privacy_settings`
- `privacy_consents`
- `privacy_audit_events`
- Calibration fields for score estimation.
- `friend_invite_codes`, if generated.
- `contact_match_requests`, if contact matching is enabled later.
- Initial friend/default visibility settings.
- Initial notification settings.

Local iPhone storage:

- Current user profile.
- Settings snapshot.
- Consent state.
- Calibration fields needed for local score estimation.
- Sync state.

## Required vs Optional Summary

Required:

- Age gate: 16+.
- Account basics.
- Body weight.
- `+1` refreshment unit definition.
- Core privacy acknowledgement.

Asked but optional:

- Location sharing.
- Background location.
- Score sharing.
- Motion tracking.
- Phone usage tracking.
- Voice analysis.
- Photo refreshment detection.
- Saved refreshment photos.
- Contacts matching.
- Notifications.
- Free-form sports.

## Resolved Product Decisions

- Age gate comes before username/account setup.
- Invite codes are generated only after the user taps "Invite friends".
- `+1` setup uses presets first; the user can refine exact details later.
- Contact matching is offered later from the friends screen.
- Panic privacy is introduced during onboarding, but only as a short "this
  exists" privacy feature.
