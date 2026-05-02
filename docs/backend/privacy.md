# Backend - Privacy & Data Model

Defines how Antidotte collects, scopes, shares, protects, and deletes user data.
Privacy is a core product feature because the app handles location, drinking
behavior, friend visibility, photos, motion signals, phone-use signals, and
optional voice checks.

This document is product/backend guidance, not final legal text. Before App
Store launch, the privacy policy, App Store privacy labels, consent screens, and
GDPR/region-specific flows should be reviewed properly.

## Core Principles

- Collect only what is needed for the feature the user enabled.
- Use explicit opt-in for sensitive data.
- Let users change privacy settings at any time.
- Enforce visibility on the backend before any friend receives data.
- Prefer derived summaries over raw sensitive data.
- Store exact location only briefly; long-term history should use venue plus
  approximate area.
- Do not persist raw audio, raw messages, or raw sensor streams.
- Make deletion, export, and account removal real product flows, not support
  tickets only.
- Keep App Store privacy disclosures accurate whenever data practices change.

## Privacy Settings

`privacy_settings`

| Setting | Type | Default | Notes |
|---|---|---|---|
| `location_sharing_enabled` | boolean | Ask onboarding | Master live location switch. |
| `location_precision` | enum | `off` | `exact`, `approximate_150m`, `off`. |
| `share_when_app_closed` | boolean | Off | Background location with iOS permission. |
| `photo_drink_detection_enabled` | boolean | Off | Enables photo-assisted drink detection. |
| `save_drink_photos_enabled` | boolean | Off | If off, delete raw photos after analysis. |
| `motion_tracking_enabled` | boolean | Off | Enables derived motion summaries. |
| `phone_usage_tracking_enabled` | boolean | Off | Enables derived phone-use summaries. |
| `voice_analysis_enabled` | boolean | Off | Enables optional active-test voice check. |
| `message_analysis_enabled` | boolean | Off | Future feature; derived metrics only. |
| `drunkness_visibility` | enum | Ask onboarding | `category`, `percentage`, `category_percentage`, `hidden`. |
| `analytics_enabled` | boolean | Off | Product analytics if added later. |
| `notifications_enabled` | boolean | On | Non-sensitive app notifications. |

Rules:

- A feature must check the matching setting before collecting or sending data.
- Turning a setting off must stop new collection immediately.
- Turning off location sharing hides live presence immediately.
- Turning off photo saving should delete future raw photos after analysis and
  offer to delete previously saved drink photos.
- Settings changes should be auditable.

## Consent and Visibility Model

Consent is not one global yes/no. The app needs separate consent for each
sensitive capability.

Consent records:

`privacy_consents`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Consent record. |
| `user_id` | UUID | User who made the choice. |
| `consent_type` | enum | `location`, `background_location`, `motion`, `phone_usage`, `photo_analysis`, `photo_storage`, `voice_analysis`, `drunkness_visibility`. |
| `status` | enum | `granted`, `denied`, `revoked`. |
| `source` | enum | `onboarding`, `settings`, `system_permission`, `migration`. |
| `created_at` | timestamp with timezone | When this record was created. |
| `revoked_at` | timestamp with timezone, nullable | When revoked. |
| `policy_version` | string | Privacy policy/app version shown. |

Friend visibility:

- Being friends does not automatically grant exact location.
- Users can choose visibility per friend and by group.
- Per-friend rules override group rules.
- Hidden/block rules override allow rules.
- Temporary sharing is allowed, for example exact location for 2 hours.
- Every outbound location/drunk-score payload must be filtered per viewer.

Visibility levels:

| Level | Meaning |
|---|---|
| `exact` | Precise live coordinates if enabled. |
| `approximate_150m` | Approximate 150m area. |
| `hidden` | Viewer receives no location. |

## Data Collected By Feature

### Account and Profile

Collected:

- User ID.
- Username/display name.
- Optional profile photo.
- Language/settings.
- Body weight for drunk-score calibration.
- Optional free-form sports description.

Privacy:

- Body weight and calibration fields are private by default.
- Friends should not see body weight or calibration details.

### Drink Logs

Collected:

- Drink time to seconds.
- Drink type/unit/ABV/volume when known.
- Price if entered or inferred.
- Venue plus approximate area if location is enabled.
- Private "with who" metadata.
- Optional photo-analysis result.

Privacy:

- Users can log drinks only for themselves.
- "With who" can remain private metadata visible only to the logger.
- Exact per-drink coordinates should not be stored long term.
- Drink photos are saved only if the user enables photo saving.

### Location

Collected only when enabled:

- Live location presence.
- Short-lived exact samples.
- Approximate area around 150m.
- Venue/check-in context.
- Stale timestamp and hide-after timestamp.

Privacy:

- Ask during onboarding.
- Background location requires explicit iOS permission and app setting.
- Stale locations show with timestamp, then hide after 12 hours.
- If location sharing is turned off, hide immediately.
- Long-term history stores venue plus approximate area, not exact paths.

### Drunk Score

Collected/derived:

- Drunk percentage.
- Internal score confidence.
- Motion component if enabled.
- Phone-usage component if enabled.
- Drink-log component.
- Active phone test results.

Privacy:

- Friends see only the drunkness visibility the user allows: category, percentage, both, or hidden.
- Friends do not see confidence.
- Confidence is internal and used to decide whether to suggest a mini-test.
- The score is not a medical BAC reading and must not be presented as proof of
  safety to drive.

### Motion and Phone Usage

Collected only when enabled:

- Derived motion instability summaries.
- Derived phone usage deviation summaries.
- Baseline status.
- Confidence values.

Privacy:

- Prefer on-device processing.
- Do not store raw accelerometer/gyroscope streams permanently.
- Do not store raw message content.
- Store derived metrics only.

### Active Phone Test and Voice

Collected:

- Mini-test result values.
- Normalized score contribution.
- Active-test confidence.
- Optional voice-derived metrics if voice consent is enabled.

Privacy:

- Users choose which mini-test/minigame to do.
- Voice checks require explicit voice-analysis consent.
- Raw voice should be processed on-device or deleted immediately after
  analysis.
- Active test history is private unless explicitly shared.

### Photos

Collected only if enabled:

- Drink photo for analysis.
- Detected drink type/volume/ABV/price.
- Detection confidence.
- Optional stored photo if saving is enabled.

Privacy:

- Raw photos are deleted after analysis unless `save_drink_photos_enabled` is on.
- Photos are never shared with friends by default.
- User can delete saved drink photos.

## App Store Privacy Notes

For iOS/App Store launch:

- App Store privacy labels must disclose data collected by the app and any
  third-party SDKs.
- Data sent off-device and retained longer than the realtime request should be
  treated as collected.
- If precise location is immediately coarsened before storage, disclose the
  stored/coarsened location category appropriately.
- If raw photos or voice are uploaded for analysis and retained, disclose them.
- If raw voice/photos are processed only transiently and deleted immediately,
  document that behavior carefully.
- Privacy labels must stay accurate when features or third-party SDKs change.
- Avoid tracking/advertising SDKs in the first version unless there is a clear
  product need.

## GDPR / User Rights

The backend should support these flows:

- Right to be informed: clear privacy policy and in-app setting explanations.
- Access/export: user can export their personal data.
- Rectification: user can edit profile, settings, drink logs, and session data.
- Erasure: user can delete drink logs, sessions, photos, location history, and
  account data.
- Restriction/object: user can disable processing by turning off settings.
- Portability: export in a machine-readable format such as JSON.

Deletion request behavior:

- Respond to account deletion requests with a defined internal SLA.
- Account deletion should use a 1-month grace period before final hard-delete.
- During this 1-month grace period, the user can recover the account.
- Soft-delete immediately where needed for sync consistency.
- During the grace period, remove friends' access and disable live/social
  visibility immediately.
- Hard-delete after the 1-month grace period.
- Delete or anonymize related records that are not needed for legal/security
  reasons.
- Remove saved photos from object storage.
- Remove live location presence immediately.
- Remove friends' access to the user's data immediately.
- Backups should retain deleted data for no longer than 3 days.
- Users should not be able to delete only location history while keeping the
  rest of a session; location should be deleted together with the related
  session/account deletion flow.

## Retention Rules

| Data | Retention |
|---|---|
| Live location presence | Latest state only; hidden immediately if disabled. |
| Stale location | Show with timestamp, hide after 12 hours. |
| Exact location samples | Short window, e.g. hours to 7 days. |
| Rough session area | Until session deletion/account deletion. |
| Drink logs | Until user deletes or account deletion. |
| Saved drink photos | Until user deletes, disables saving with cleanup, or account deletion. |
| Photo analysis metadata | Until drink/session deletion/account deletion. |
| Raw voice | Do not persist. |
| Raw messages | Do not persist. |
| Raw sensor streams | Do not persist. |
| Drunk score snapshots | Until user deletes session/account, if enabled at collection time. |
| Privacy audit events | Keep long enough for security/compliance review. |
| Deleted data in backups | Maximum 3 days. |

## Panic Privacy

The app should include a panic privacy switch.

When enabled:

- Hide live location from everyone immediately.
- Hide drunk score from everyone immediately.
- Stop friend-visible realtime updates.
- Expire automatically after 24 hours unless the user re-enables normal sharing
  earlier.
- Preserve private user data unless the user also requests deletion.

This is separate from account deletion. It is an immediate visibility shutdown,
not a data wipe.

## Age Policy

Minimum age should be 16 years old because the app is drinking-related and uses
sensitive social/location signals.

Rules:

- Ask age/date of birth during onboarding.
- Users under 16 should not be allowed to create an account.
- Do not show underage users drinking-related social features.
- Store only the minimum age-verification data needed.
- Final regional age/legal requirements need review before launch.

## Third-Party SDK Data Collection

The product stance is: third-party SDKs may be used for app functionality, but
they should not collect extra user data for analytics, advertising, profiling,
or tracking.

Rules:

- Map, crash, analytics, or infrastructure SDKs may be used only if configured
  for necessary functionality.
- No advertising/tracking SDKs in the first version.
- No SDK should collect data beyond what is needed to provide the feature.
- If a third-party SDK collects or retains any user data, it must be documented
  and reflected in App Store privacy labels.
- Prefer providers/configurations where data is processed transiently and not
  retained by the provider.

Recommended direction before vendors are chosen:

| Need | Recommended approach | Privacy note |
|---|---|---|
| Maps | OpenStreetMap-compatible provider/renderer | Use for display; avoid tracking users through map SDKs. |
| Crash reporting | Apple/Xcode crash tools first | Prefer platform-native crash data before adding third-party SDKs. |
| Product analytics | Start without third-party analytics | Add only privacy-preserving, opt-in analytics if needed. |
| Push notifications | Apple Push Notification service | Use for app functionality, not tracking. |
| Backend logs | Own server-side structured logs | Avoid logging raw location, photos, voice, or message data. |

## Enforcement Points

Backend must check privacy at:

- Location update ingestion.
- Friend map payload generation.
- Drunkness visibility.
- Session participant visibility.
- Drink log sharing.
- Photo storage/deletion.
- Active test and voice result storage.
- Data export.
- Data deletion.

Implementation rule:

- Never rely only on frontend visibility logic.
- Frontend can hide controls, but backend must enforce access.

## Audit Events

`privacy_audit_events`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Event ID. |
| `user_id` | UUID | User affected. |
| `actor_user_id` | UUID, nullable | User/admin/system that caused event. |
| `event_type` | enum | `setting_changed`, `consent_granted`, `consent_revoked`, `data_exported`, `data_deleted`, `visibility_changed`. |
| `created_at` | timestamp with timezone | Event time. |
| `metadata` | JSON/object | Minimal non-sensitive details. |

Audit metadata should avoid storing sensitive raw data.

## Open Questions

- What exact third-party SDKs/providers will be used for maps, crash reporting,
  analytics, and push infrastructure?

## References

- Apple App Store privacy details:
  https://developer.apple.com/app-store/app-privacy-details/
- Apple user privacy and data use:
  https://developer.apple.com/app-store/user-privacy-and-data-use/
- European Commission GDPR individual rights:
  https://commission.europa.eu/law/law-topic/data-protection/information-individuals_en
- European Commission GDPR principles:
  https://commission.europa.eu/law/law-topic/data-protection/reform/what-does-general-data-protection-regulation-gdpr-govern_en
