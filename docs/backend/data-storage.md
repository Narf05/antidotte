# Backend - Data Storage

Stores all persistent app data: drink logs, night-out sessions, user profiles,
venue info, privacy settings, and the historical inputs needed for stats.

## Product direction

Antidotte is iOS first. The data layer should therefore be excellent for an
App Store iPhone app first, while avoiding choices that would make a later
Android app painful.

Core storage goals:

- Fast local reads for the map, current night, stats, and offline logging.
- Strong user privacy controls and clean deletion flows.
- Reliable sync between the iPhone and backend when the network returns.
- Structured records for drink history, location history, venue history, and
  session summaries.
- Enough flexibility to add new drunk-score signals without rewriting old data.

## Database Choice

Recommended setup:

- **On device:** SwiftData/Core Data backed by SQLite.
- **Backend relational database:** PostgreSQL.
- **Realtime layer:** WebSocket or push-driven updates backed by the API, not
  direct client access to the database.
- **Optional cache/search later:** Redis for temporary realtime presence, queue
  state, and short-lived session calculations.

Why this is the best fit for an App Store-first app:

- SwiftData/Core Data is native to iOS, works well offline, integrates cleanly
  with Swift app state, and stores data in SQLite under the hood.
- SQLite-backed local storage is mature, fast, battery-friendly, and accepted
  for App Store apps.
- PostgreSQL is the safest backend choice for structured user, friendship,
  session, drink, location, and venue data.
- The backend can enforce privacy and sharing rules centrally instead of
  trusting mobile clients.
- A relational schema makes deletion, export, analytics, and GDPR requests
  easier than a document-only database.

Avoid for the core system:

- A pure document database as the primary store. It would make friendship
  visibility, deletion, session aggregation, and stats harder to keep correct.
- Client-only storage. The app needs social map features, friend visibility,
  synced stats, and account recovery.
- Storing raw audio, raw messages, or unnecessary sensor streams permanently.
  Store only consented summaries and derived scores where possible.

## Schema Overview

Main backend tables:

- `users`
- `user_profiles`
- `privacy_settings`
- `privacy_consents`
- `privacy_audit_events`
- `friend_invite_codes`
- `friend_requests`
- `friendships`
- `user_blocks`
- `groups`
- `group_members`
- `contact_match_requests`
- `session_invites`
- `social_notifications`
- `friend_notification_settings`
- `venues`
- `drink_logs`
- `drink_photo_analysis`
- `drink_log_companions`
- `night_out_sessions`
- `session_participants`
- `session_venues`
- `location_visibility_rules`
- `location_samples`
- `live_location_presence`
- `active_test_results`
- `drunk_score_snapshots`
- `device_sync_state`

Local iPhone storage should mirror only the records needed by the current user:

- Current user profile and settings.
- Recent/current sessions.
- Unsynced drink logs.
- Recent venue cache.
- Recent friend presence records that the user is allowed to see.
- Local sync queue for actions created while offline.

## Drink Log Structure

Every `+1` or manual drink entry creates a `drink_logs` record. A drink log is
owned by one user and may optionally belong to a session/night out.

Required fields:

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Unique drink event ID. |
| `user_id` | UUID | Person who drank it. |
| `session_id` | UUID, nullable | Current night out if one exists. |
| `created_at` | timestamp with timezone | Exact server creation time. |
| `drank_at` | timestamp with timezone | Exact drink time, stored to seconds. |
| `timezone` | string | User timezone at the moment, e.g. `Europe/Paris`. |
| `source` | enum | `plus_one`, `manual`, `imported`, `corrected`. |
| `drink_unit_count` | decimal | User-calibrated units, e.g. 1 beer = 1.0. |
| `alcohol_percentage` | decimal, nullable | ABV, e.g. `5.2` for beer. |
| `volume_ml` | integer, nullable | Helpful for more accurate drunk score. |
| `drink_type` | enum/string | Beer, wine, cocktail, shot, cider, mixed, other. |
| `price_amount` | decimal, nullable | Drink price if known. |
| `price_currency` | string, nullable | ISO currency code, e.g. `EUR`, `CHF`. |
| `price_source` | enum, nullable | `user_entered`, `venue_average`, `photo_detected`, `receipt_detected`. |
| `venue_id` | UUID, nullable | Linked bar/club/venue if known. |
| `venue_name_snapshot` | string, nullable | Name at time of logging. |
| `rough_area_latitude` | decimal, nullable | Rounded/blurred approximate area after privacy conversion. |
| `rough_area_longitude` | decimal, nullable | Rounded/blurred approximate area after privacy conversion. |
| `location_accuracy_m` | decimal, nullable | Accuracy radius after approximate conversion, normally around 150m. |
| `location_source` | enum | `gps`, `venue_checkin`, `manual`, `none`. |
| `visibility` | enum | `private`, `session`, `friends`, `group`. |
| `note` | string, nullable | Optional short note. |
| `photo_analysis_id` | UUID, nullable | Optional link to photo-assisted detection. |
| `is_deleted` | boolean | Soft delete before final purge. |

Recommended extra fields:

| Field | Type | Notes |
|---|---|---|
| `drink_brand` | string, nullable | Optional user-entered brand. |
| `serving_size_label` | string, nullable | Pint, small beer, glass, bottle, shot. |
| `confidence` | decimal | How confident we are about inferred fields. |
| `entered_while_offline` | boolean | Helps sync/debug conflict handling. |
| `client_created_at` | timestamp with timezone | Time from the device. |
| `updated_at` | timestamp with timezone | Last edit time. |

## Photo-Assisted Drink Logging

When the user taps `+1`, the app should optionally allow them to take or upload
a picture of the drink. The app can then pre-fill drink data for the user to
confirm or edit before saving.

This should be controlled by settings:

- `photo_drink_detection_enabled`: user can turn photo detection on/off.
- `save_drink_photos_enabled`: user can decide whether photos are saved after
  analysis.
- `photo_analysis_default`: controls whether the `+1` flow opens as quick log
  only, photo first, or asks each time.

Photo-assisted detection can suggest:

- Drink type.
- Serving size or volume.
- Likely alcohol percentage.
- Venue/bar context if location is enabled.
- Estimated price using both venue averages and visible photo evidence such
  as a menu, receipt, or price board.
- Confidence score for each detected value.

The user must always be able to adjust the detected values before the drink log
is saved. Photo-filled data should be marked as inferred, not treated as guaranteed
truth.

`drink_photo_analysis`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Analysis record ID. |
| `user_id` | UUID | Owner of the photo/action. |
| `drink_log_id` | UUID, nullable | Linked once the drink is saved. |
| `created_at` | timestamp with timezone | Time of analysis. |
| `photo_storage_key` | string, nullable | Only present if user allows saved photos. |
| `photo_deleted_at` | timestamp with timezone, nullable | Deletion timestamp if photo is purged. |
| `detected_drink_type` | string, nullable | Suggested type. |
| `detected_volume_ml` | integer, nullable | Suggested volume. |
| `detected_alcohol_percentage` | decimal, nullable | Suggested ABV. |
| `detected_price_amount` | decimal, nullable | Suggested price. |
| `detected_price_currency` | string, nullable | Suggested currency. |
| `confidence` | decimal | Overall detection confidence. |
| `user_confirmed` | boolean | True after user accepts/saves. |

Privacy rules:

- Photo analysis is opt-in from settings.
- Raw photos are saved or deleted based on the user's photo-saving setting.
- If `save_drink_photos_enabled` is off, raw photos should be deleted
  immediately after analysis.
- Photos must never be shared with friends by default.
- If photo detection is off, `+1` remains a fast manual drink log.

Use a join table for "with who" data:

`drink_log_companions`

| Field | Type | Notes |
|---|---|---|
| `drink_log_id` | UUID | Drink event. |
| `companion_user_id` | UUID, nullable | App user if known. |
| `companion_display_name` | string, nullable | Manual name if not an app user. |
| `source` | enum | `session`, `manual`, `location_overlap`. |

Drink log privacy rules:

- A user can log drinks only for themselves.
- "With who" can be stored as private metadata visible only to the logger.
- Exact per-drink coordinates should not be stored long term.
- If location is enabled, the backend should convert drink location into a
  venue plus approximate area before storing it in the drink log.
- Drink price can be user-entered or inferred from venue/photo data. Inferred
  prices should keep a source and confidence so the user can correct them.

## Session / Night-Out Records

A `night_out_sessions` record represents one drinking context: a preplanned
event, spontaneous night out, bar crawl, house party, festival, or solo evening.
It groups drink logs, location samples, friends, venue visits, and drunk-score
snapshots into one coherent history item.

Required fields:

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Unique session ID. |
| `owner_user_id` | UUID | Person who created the session. |
| `title` | string | Auto title like `Friday night` or user title. |
| `status` | enum | `planned`, `active`, `ended`, `cancelled`. |
| `started_at` | timestamp with timezone | Exact start time. |
| `ended_at` | timestamp with timezone, nullable | Exact end time. |
| `timezone` | string | Timezone used for display and grouping. |
| `theme` | string, nullable | Beer night, cocktail night, club, dinner, etc. |
| `privacy_scope` | enum | `private`, `friends`, `group`, `invite_only`. |
| `primary_city` | string, nullable | Useful for stats and history. |
| `primary_country` | string, nullable | Useful for stats and history. |
| `created_at` | timestamp with timezone | Server creation time. |
| `updated_at` | timestamp with timezone | Last update. |

Calculated summary fields:

| Field | Type | Notes |
|---|---|---|
| `total_drink_units` | decimal | Sum of calibrated drink units. |
| `total_spend_amount` | decimal, nullable | Sum of known drink prices. |
| `spend_currency` | string, nullable | Currency for the session total. |
| `peak_drunk_percentage` | decimal, nullable | Highest estimated drunk score. |
| `average_drunk_percentage` | decimal, nullable | Optional summary. |
| `venue_count` | integer | Number of unique venues visited. |
| `drink_count` | integer | Number of logged drink events. |
| `participant_count` | integer | Number of people involved. |

Session venue structure:

One session can include multiple venues. This supports bar crawls, dinner then
club, festival movement, and any night where the group changes places without
creating separate history records.

`session_venues`

| Field | Type | Notes |
|---|---|---|
| `session_id` | UUID | Night out. |
| `venue_id` | UUID, nullable | Venue if known. |
| `venue_name_snapshot` | string, nullable | Name at the time. |
| `arrived_at` | timestamp with timezone, nullable | First detected/manual arrival. |
| `left_at` | timestamp with timezone, nullable | Detected/manual departure. |
| `source` | enum | `gps`, `manual`, `drink_log`, `friend_group`. |
| `is_private_place` | boolean | True for homes/private addresses. |

Session participant structure:

| Field | Type | Notes |
|---|---|---|
| `session_id` | UUID | Night out. |
| `user_id` | UUID | Participant. |
| `role` | enum | `owner`, `invited`, `joined`, `detected_nearby`. |
| `joined_at` | timestamp with timezone | When they joined. |
| `left_at` | timestamp with timezone, nullable | When they left. |
| `visibility_status` | enum | `visible`, `hidden`, `location_off`. |
| `consent_status` | enum | `accepted`, `pending`, `declined`. |

What a session is used for:

- Showing the current night on the map.
- Grouping drinks into one history item.
- Calculating totals: drinks, money spent, venues visited, peak drunk score.
- Showing who was out together.
- Building stats over time.
- Applying privacy rules consistently for a whole evening.
- Letting the app infer "current night" without making every drink separate.

Session start/end logic:

- A session is auto-created on the first `+1` if no active session exists.
- User can also manually start a session before the first drink.
- App can suggest starting a session after venue arrival or friend group
  activity, even before the first drink is logged.
- Session can end manually.
- App should auto-end after 4 hours with no drinks, no relevant location
  movement, and no session activity.
- Never silently publish a session without privacy consent.

## Venue Data

Venues are shared reference data, but user-specific visits stay private unless
the user shares them.

`venues`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Venue ID. |
| `name` | string | Bar, club, restaurant, house party label. |
| `type` | enum | `bar`, `club`, `restaurant`, `home`, `festival`, `other`. |
| `latitude` | decimal, nullable | Public venue coordinate. |
| `longitude` | decimal, nullable | Public venue coordinate. |
| `address` | string, nullable | Avoid storing private home addresses as shared venues. |
| `city` | string, nullable | City. |
| `country` | string, nullable | Country. |
| `avg_drink_price_amount` | decimal, nullable | Venue average if known. |
| `avg_drink_price_currency` | string, nullable | ISO currency. |
| `price_confidence` | decimal | Confidence in average price. |
| `source` | enum | `user_reported`, `map_provider`, `admin`, `inferred`. |

Private places:

- House parties and private addresses should be stored privately.
- Private places should not become shared/public venues.
- Friends may see a rough/private label only if the session privacy settings
  allow it, for example `House party` or `Private place`.
- Exact private coordinates should stay visible only to the user unless they
  explicitly share their live location.

For fast lookup, the app can keep a hashmap-style cache locally:

```json
{
  "venue_id": {
    "name": "Example Bar",
    "lat": 46.2044,
    "lon": 6.1432,
    "avg_drink_price": 8.5,
    "currency": "CHF",
    "type": "bar"
  }
}
```

## Retention and Deletion Policies

- Users can delete individual drinks.
- Users can delete a full session/night out.
- Users can request full account deletion.
- Soft-delete first for sync consistency, then hard-delete after the retention
  window.
- Exact location samples should have shorter retention than summarized session
  history.
- Raw audio, raw messages, and raw call data should not be stored persistently.
- Derived drunk-score snapshots can be kept only when the relevant privacy
  toggle was enabled at the time.
- Deleted drink logs must be removed from session totals after sync.

Recommended retention:

| Data | Retention |
|---|---|
| Drink logs | Until user deletes or account deletion. |
| Session summaries | Until user deletes or account deletion. |
| Precise location samples | Short window, e.g. 7-30 days, then aggregate/delete. |
| Venue visits | Keep as session-level summary unless deleted. |
| Realtime friend presence | Minutes to hours, not permanent history. |
| Raw voice/message data | Do not persist. |

## Sync Rules

- Mobile creates records with UUIDs so offline logs can sync later.
- Backend remains source of truth for shared visibility and final timestamps.
- Conflicts should prefer explicit user edits over inferred values.
- Every synced record should include `created_at`, `updated_at`, and deletion
  state.
- Location and social visibility must be checked server-side before any friend
  receives an update.
