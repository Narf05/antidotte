# Backend - Social Graph (Friends & Groups)

Manages friend connections, friend requests, groups, session participation,
visibility rules, and social notifications.

## Product Direction

Antidotte is social, but privacy-first. Users should be able to find friends in
multiple ways, create friend groups, control who sees them, and use those groups
for map visibility, drunk-score visibility, session invites, and notifications.

Friendship is only the base relationship. It does not automatically grant exact
location, drunk score, or session visibility.

## Friend Discovery and Adding

Friends should be addable through all main methods:

- Invite code.
- Contacts.
- Username/search.

### Invite Code

Each user can have a shareable invite code or link.

Flow:

1. User opens "Add friends".
2. User shares an invite code/link.
3. Friend opens the code/link.
4. Backend creates a pending friend request.
5. Receiving user accepts or declines.

Rules:

- Codes should be revocable/regenerable.
- Codes should expire after 3 days by default.
- Codes should not expose private profile data before acceptance.
- Rate-limit invite-code attempts to prevent guessing.

`friend_invite_codes`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Invite code record. |
| `user_id` | UUID | Owner. |
| `code_hash` | string | Store hash, not raw code. |
| `created_at` | timestamp with timezone | Creation time. |
| `expires_at` | timestamp with timezone, nullable | Optional expiry. |
| `revoked_at` | timestamp with timezone, nullable | Revocation time. |

### Contacts

Users can find friends through contacts if they grant iOS Contacts permission.

Rules:

- Contact access is optional.
- The app should not upload raw address books permanently.
- Prefer hashing normalized phone numbers/emails on-device and matching hashed
  values server-side.
- Do not store non-user contacts beyond what is needed for the matching request.
- Clearly explain contact use during permission/onboarding.
- If contact matching is enabled, refresh matches periodically every month.

`contact_match_requests`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Match request ID. |
| `user_id` | UUID | Requesting user. |
| `created_at` | timestamp with timezone | Request time. |
| `matched_user_ids` | UUID array/object | Users found from hashed contact match. |
| `expires_at` | timestamp with timezone | Cleanup time for request result. |

### Username/Search

Users can search by username/display name.

Rules:

- Search should show only minimal public profile info before friendship.
- Allow users to make themselves searchable or hidden.
- Rate-limit search to reduce scraping.
- Do not reveal location, drunk score, sessions, or friends before acceptance.

## Friend Request Flow

`friend_requests`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Request ID. |
| `requester_user_id` | UUID | User who sent the request. |
| `recipient_user_id` | UUID | User receiving the request. |
| `source` | enum | `invite_code`, `contacts`, `username`, `session_invite`. |
| `status` | enum | `pending`, `accepted`, `declined`, `cancelled`, `blocked`. |
| `message` | string, nullable | Optional short note. |
| `created_at` | timestamp with timezone | Request time. |
| `responded_at` | timestamp with timezone, nullable | Accept/decline time. |

Rules:

- Friendships require acceptance.
- Users can cancel outgoing requests.
- Users can decline requests.
- Users can block another user.
- Blocking should hide both users from each other and stop new requests.

## Friendships

`friendships`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Friendship ID. |
| `user_a_id` | UUID | One side of the friendship. |
| `user_b_id` | UUID | Other side of the friendship. |
| `status` | enum | `active`, `removed`, `blocked`. |
| `created_at` | timestamp with timezone | Friendship creation time. |
| `updated_at` | timestamp with timezone | Last change. |

Rules:

- Store one friendship row per pair, not two duplicated rows.
- Friendship gives access to basic friend list/profile only.
- Location, drunk score, and session visibility still require privacy rules.
- Removing a friend should immediately remove their access to future private
  data.
- Existing shared session history should follow session privacy/deletion rules.

## Friend Groups

Users should be able to create friend groups. Groups are personal/social units
used for map visibility, session invites, notifications, and quick sharing.
Groups should support both personal lists and shared groups visible to other
members.

Examples:

- Close friends.
- Uni friends.
- Work friends.
- Clubbing group.
- Football team.
- Vacation group.

`groups`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Group ID. |
| `owner_user_id` | UUID | Creator/owner. |
| `name` | string | Group name. |
| `description` | string, nullable | Optional. |
| `visibility` | enum | `private`, `shared`. |
| `created_at` | timestamp with timezone | Creation time. |
| `updated_at` | timestamp with timezone | Last update. |

`group_members`

| Field | Type | Notes |
|---|---|---|
| `group_id` | UUID | Group. |
| `user_id` | UUID | Member. |
| `role` | enum | `owner`, `admin`, `member`. |
| `status` | enum | `invited`, `active`, `left`, `removed`. |
| `joined_at` | timestamp with timezone, nullable | Join time. |
| `created_at` | timestamp with timezone | Invite/add time. |

Group rules:

- Group creation is available to users.
- Groups can be personal lists only the owner sees.
- Groups can also be shared groups where members see the group and each other.
- Groups can be used in privacy rules, for example "share rough location with
  Close Friends".
- Group visibility rules must still respect each user's own privacy settings.
- Leaving/removing a member should revoke future group-based access.
- Groups should not override a user's global privacy switches.

## Visibility Rules

Social graph decides who is connected; privacy/location decides what each
viewer can see.

Visibility surfaces:

- Live location.
- Drunk percentage.
- Active session presence.
- Session invite/join status.
- Drink activity notifications.

Rules:

- Friendship is required before ongoing social visibility.
- Default visibility for a new accepted friend should be visible for all
  friend-level social features, unless the user changes the default.
- By default, visible for all includes exact location for accepted friends.
- Exact location still requires the user's global location sharing to be enabled.
- Drunk score sharing requires `drunk_score_sharing_enabled`.
- Per-friend hidden rules override group allow rules.
- Group allow rules can grant rough/venue/drunk-score visibility to a group.
- Panic privacy overrides all friend/group visibility immediately.
- Account deletion/removal removes social visibility immediately.

## Session and Night-Out Groups

Sessions can include friends and group context.

Use cases:

- Start a night out and invite a group.
- See who is out in the same group.
- Use group visibility for the live map.
- Auto-detect nearby friends only if both users allow location/session sharing.

`session_invites`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Invite ID. |
| `session_id` | UUID | Night-out session. |
| `sender_user_id` | UUID | Inviter. |
| `recipient_user_id` | UUID, nullable | Individual invite. |
| `recipient_group_id` | UUID, nullable | Group invite. |
| `status` | enum | `pending`, `accepted`, `declined`, `expired`, `cancelled`. |
| `created_at` | timestamp with timezone | Invite time. |
| `responded_at` | timestamp with timezone, nullable | Response time. |

Rules:

- Inviting a group creates visibility only for that session, not permanent
  location access.
- Joining a session does not automatically become friendship.
- Session participant visibility follows session privacy plus user privacy.

## Notifications

Notifications should be useful but not creepy.

Possible notifications:

- Friend request received.
- Friend request accepted.
- Added to group.
- Invited to session/night out.
- Friend/group started a session, if allowed.
- Friend starts drinking, if enabled for that friend.
- Friend is nearby, only if both users allow location-based social features.
- Panic privacy activated/deactivated on own account.

Rules:

- Notifications respect privacy settings.
- Do not reveal exact location in notification text.
- Do not reveal drunk percentage in notification text unless the recipient is
  allowed to see it in-app.
- Users can disable notifications.
- Per-friend "friend starts drinking" notifications should exist but be off by
  default.
- Sensitive notifications should be phrased cautiously.

`social_notifications`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Notification ID. |
| `recipient_user_id` | UUID | Receiver. |
| `actor_user_id` | UUID, nullable | User who caused it. |
| `type` | enum | `friend_request`, `friend_accepted`, `group_invite`, `session_invite`, `session_started`, `nearby_friend`, `privacy_event`. |
| `related_id` | UUID, nullable | Request/group/session ID. |
| `created_at` | timestamp with timezone | Creation time. |
| `read_at` | timestamp with timezone, nullable | Read time. |
| `delivered_at` | timestamp with timezone, nullable | Push delivery time. |

`friend_notification_settings`

| Field | Type | Notes |
|---|---|---|
| `owner_user_id` | UUID | User receiving notifications. |
| `friend_user_id` | UUID | Friend the setting applies to. |
| `nearby_friend_enabled` | boolean | Nearby-friend notifications. |
| `starts_drinking_enabled` | boolean | Default off. |
| `session_started_enabled` | boolean | Friend/session notifications. |
| `updated_at` | timestamp with timezone | Last setting change. |

## Blocking and Safety

`user_blocks`

| Field | Type | Notes |
|---|---|---|
| `blocker_user_id` | UUID | User who blocked. |
| `blocked_user_id` | UUID | User being blocked. |
| `created_at` | timestamp with timezone | Block time. |
| `reason` | string, nullable | Optional private reason. |

Block rules:

- Blocked users cannot send friend requests.
- Blocked users cannot see profile/search results beyond minimal hidden state.
- Blocked users cannot see live location, drunk score, sessions, or groups.
- Blocking should remove active friend visibility immediately.

## Privacy and Retention

- Friend requests can be deleted/expired after a retention period.
- Removed friendships should stop all future visibility immediately.
- Group membership history can be kept for audit/session history until deletion.
- User blocks should remain until the blocker removes them.
- Social graph data should be included in account export/deletion.
