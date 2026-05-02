# Backend - Location Service

Handles realtime position updates for the map screen. The service shows the
current user and friends who have explicitly allowed location sharing.

## Product Direction

Antidotte should support a live map where users can see:

- Their own current location.
- Friends who have allowed them to see location.
- Friend drunkness category/percentage state if allowed by drunkness visibility.
- Session/group context when friends are out together.
- Nearby venues and approximate areas when exact sharing is not allowed.

Map display can use OpenStreetMap-based map data. On iOS, the frontend can use
an OSM-compatible map renderer/provider while the backend stays provider-neutral
and stores coordinates, venues, and visibility decisions.

## Core Rules

- Location sharing is opt-in and controlled by settings.
- Location sharing should be asked during onboarding.
- Users can choose who sees them.
- A friendship does not automatically grant live location access.
- The backend must check visibility before sending any location update.
- Exact live location should be treated as sensitive and short-lived.
- Stored drink/session history should prefer venue plus approximate area over exact
  coordinates.
- If location is disabled, the app should degrade gracefully instead of breaking
  the map.

## Location Settings

Users need global and per-person controls.

Global settings:

| Setting | Type | Notes |
|---|---|---|
| `location_sharing_enabled` | boolean | Master switch for live location sharing. |
| `location_precision` | enum | `exact`, `approximate_150m`, `off`. |
| `share_during_sessions_only` | boolean | Optional privacy limiter; default should allow sharing outside sessions if enabled. |
| `share_when_app_closed` | boolean | Allows background location if user grants iOS permission. |
| `show_me_on_friend_map` | boolean | Whether friends can see the user on the map at all. |

Per-friend visibility:

`location_visibility_rules`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Rule ID. |
| `owner_user_id` | UUID | User whose location is being protected. |
| `viewer_user_id` | UUID, nullable | Friend who may view location. |
| `viewer_group_id` | UUID, nullable | Group that may view location. |
| `visibility` | enum | `exact`, `approximate_150m`, `hidden`. |
| `active_only_during_session` | boolean | Restrict sharing to active sessions. |
| `expires_at` | timestamp with timezone, nullable | Optional temporary sharing. |
| `created_at` | timestamp with timezone | Rule creation time. |
| `updated_at` | timestamp with timezone | Last change. |

Users should be able to create temporary sharing rules, for example sharing
exact location with a friend or group for 2 hours.

Rule priority:

1. Global `location_sharing_enabled = false` means nobody sees location.
2. Blocked/hidden per-friend rules win over group rules.
3. Specific friend rules win over group rules.
4. Group rules win over default friendship visibility.
5. If no specific rule exists, use the user's default friend visibility setting; the product default is visible for accepted friends when global sharing is enabled.

Visibility should be configurable both per friend and by group.

## Realtime Infrastructure

Recommended setup:

- iPhone collects location using iOS location services with user permission.
- App sends updates to backend API.
- Backend validates privacy/visibility and stores only the latest presence plus
  short-lived samples when needed.
- Backend pushes allowed updates to friends through WebSocket.
- Push notifications can be used for wake-up/summary events, not continuous
  high-frequency tracking.
- Polling can be a fallback if WebSocket is unavailable.

Why WebSocket:

- Best fit for live map updates.
- Lower latency than polling.
- Backend can filter each outbound event per viewer.

Fallback order:

1. WebSocket live updates.
2. Short polling every 30-60 seconds.
3. Last known allowed presence.
4. Hidden/offline state.

## Update Frequency and Accuracy

Location should balance freshness, battery, privacy, and map usefulness.

Recommended update modes:

| Mode | When | Frequency | Precision |
|---|---|---:|---|
| `active_map` | User has map open | 5-15 seconds | Exact if allowed. |
| `active_session` | Session active, app backgrounded | 30-90 seconds | Exact/approximate based on settings. |
| `low_power` | Battery low or little movement | 2-5 minutes | Rough or last venue. |
| `stationary` | User has not moved | On significant change | Last known/venue. |
| `location_off` | Permission/settings off | None | Hidden or fallback. |

Rules:

- Do not send high-frequency updates when the user is stationary.
- Reduce precision before sending if the viewer is only allowed approximate location.
- Approximate location should use approximately 150m precision.
- Store exact realtime points only as long as needed for live presence and
  session inference.
- Convert session/drink history into venue plus approximate area for long-term
  storage.

## Location Sample Structure

`location_samples`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Sample ID. |
| `user_id` | UUID | Owner. |
| `session_id` | UUID, nullable | Active session if present. |
| `created_at` | timestamp with timezone | Server timestamp. |
| `sampled_at` | timestamp with timezone | Device location timestamp. |
| `latitude` | decimal | Exact coordinate while sample is retained. |
| `longitude` | decimal | Exact coordinate while sample is retained. |
| `accuracy_m` | decimal | Device accuracy radius. |
| `speed_mps` | decimal, nullable | Optional movement speed. |
| `heading_deg` | decimal, nullable | Optional heading. |
| `source` | enum | `gps`, `wifi`, `cell`, `manual`, `venue_checkin`. |
| `retention_class` | enum | `realtime`, `session_inference`, `approximate_history`. |

`live_location_presence`

| Field | Type | Notes |
|---|---|---|
| `user_id` | UUID | User being located. |
| `session_id` | UUID, nullable | Active session if present. |
| `last_seen_at` | timestamp with timezone | Last location update. |
| `latitude` | decimal, nullable | Exact live coordinate if retained. |
| `longitude` | decimal, nullable | Exact live coordinate if retained. |
| `rough_area_latitude` | decimal, nullable | Rounded/blurred approximate coordinate. |
| `rough_area_longitude` | decimal, nullable | Rounded/blurred approximate coordinate. |
| `venue_id` | UUID, nullable | Current/likely venue. |
| `venue_name_snapshot` | string, nullable | Current venue name. |
| `presence_state` | enum | `live`, `stale`, `hidden`, `location_off`. |
| `stale_since` | timestamp with timezone, nullable | When live updates became stale. |
| `hide_after` | timestamp with timezone, nullable | Usually 12 hours after stale state starts. |
| `battery_mode` | enum, nullable | `normal`, `low_power`, `background`. |

## Outbound Friend Location Payload

The backend should create a different payload per viewer based on visibility.

Exact visibility:

```json
{
  "user_id": "friend-id",
  "visibility": "exact",
  "lat": 46.2044,
  "lon": 6.1432,
  "accuracy_m": 20,
  "last_seen_at": "2026-05-02T21:15:30Z",
  "session_id": "session-id"
}
```

Approximate 150m visibility:

```json
{
  "user_id": "friend-id",
  "visibility": "approximate_150m",
  "rough_area_lat": 46.20,
  "rough_area_lon": 6.14,
  "last_seen_at": "2026-05-02T21:15:30Z",
  "session_id": "session-id"
}
```

Hidden/off:

```json
{
  "user_id": "friend-id",
  "visibility": "hidden",
  "presence_state": "location_off"
}
```

## OpenStreetMap Usage

OpenStreetMap can be used for the visual map layer and venue/place context.

Backend responsibilities:

- Store coordinates and venue IDs.
- Store venue snapshots when a place is used in drink/session history.
- Return map-ready friend/venue payloads to the frontend.
- Avoid depending on a single map display provider in backend data models.

Frontend responsibilities:

- Render map tiles/markers.
- Show friend pins, approximate areas, venues, and session groups.
- Respect OSM tile/provider usage limits and attribution requirements.
- Cache map tiles only according to the chosen provider's terms.

## Fallback When Location Is Off

If a user disables location sharing:

- Friends should see `location_off` or hidden based on visibility settings.
- The map should still show the user their own manually selected city/area if
  they entered one.
- Drink logs can still be created without location.
- Sessions can still exist without location.
- Venue can be selected manually.
- The app may suggest nearby/usual bars only from user-provided settings or
  manual search, not hidden tracking.

If GPS permission is denied but the user wants social features:

- Ask for usual city/area.
- Ask for usual bars/venues.
- Allow manual check-in to a venue.
- Allow friend/group participation without exact map location.

## Stale Location Rules

- If a friend has stopped sending updates, show their stale location with a
  timestamp.
- Stale location should make it clear that the point is not live.
- Hide stale location after 12 hours.
- If the user disables location sharing, hide immediately instead of showing a
  stale point.

## Privacy and Retention

- Live location is sensitive and should be retained briefly.
- Friend-visible location should be generated per request/viewer, not globally
  cached as one shared truth.
- Exact samples should expire quickly unless needed for an active session.
- Long-term history should store venue plus approximate area, not exact path history.
- Users must be able to disable location sharing immediately.
- Users must be able to delete location/session history.

Recommended retention:

| Data | Retention |
|---|---|
| Live presence | Latest state only. |
| Exact realtime samples | Short window, e.g. hours to 7 days. |
| Session inference samples | Until converted to venue/approximate summary. |
| Rough session area | Kept with session until user deletes. |
| Manual venue check-ins | Kept with session until user deletes. |

## Background Location

- Background location can be allowed all the time if the user enables it and
  grants the required iOS permission.
- It should not be limited only to active sessions.
- The user must be able to turn it off immediately from settings.
