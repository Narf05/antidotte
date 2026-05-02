# Backend - Drunk Score Engine

Aggregates passive and active signals into a single drunkenness estimate per
user. The score is not a medical BAC reading and should never be presented as
proof that someone is safe to drive or make risky decisions.

## Product Direction

The drunk score exists for social awareness and responsibility. If a night-out
session starts, the user's drunk score must automatically become greater than
0 and remain greater than 0 until 12 hours after the session ends.

This means:

- A session start creates an initial score floor, even before any drink is
  logged.
- The score can rise or fall during the night, but it cannot return to 0 during
  the same night.
- The floor remains active until 12 hours after the session ends for
  responsibility reasons.
- Friends should never see a user as fully sober immediately after a session
  has started.

Recommended default:

- `session_start_score_floor`: `5%`
- `active_session_min_score`: `5%`
- `post_session_next_day_min_score`: `1%`

The exact percentages can be tuned later, but the rule should stay: started
session means score is greater than 0 until 12 hours after the session ends.

## Signal Sources

The score should combine several imperfect signals. No single signal should be
trusted completely.

Priority order:

1. **Motion signals** - strongest passive signal.
2. **Phone usage changes** - important, but weighted less than motion.
3. **Drink logs** - important when present, but incomplete because users may
   forget to log every drink.
4. **Session context** - session started, venue type, time of night, group
   behavior.
5. **Optional active phone test** - user-triggered reaction, balance,
   coordination, typing, and optional voice checks.

## Motion Signals

Motion should be the strongest passive factor because drunkenness often changes
how a person walks, turns, stops, and handles balance.

Possible inputs:

- Walking stability.
- Step rhythm irregularity.
- Sudden swerves or direction changes.
- Phone shake patterns.
- Gait variance compared with the user's sober baseline.
- Stillness followed by unstable movement.
- Accelerometer and gyroscope patterns.

Storage rule:

- Prefer derived motion features over raw sensor streams.
- Raw motion data should be processed on-device where possible.
- Backend should receive summaries only when the user has enabled the required
  privacy setting.

Example derived fields:

| Field | Type | Notes |
|---|---|---|
| `motion_instability_score` | decimal | 0-100 estimate from movement. |
| `gait_variance_score` | decimal | Difference from personal baseline. |
| `phone_shake_score` | decimal | Unusual phone movement. |
| `motion_confidence` | decimal | Confidence in the motion estimate. |

## Phone Usage Signals

Phone usage should be weighted below motion because it varies a lot by person,
mood, battery level, social situation, and whether they are using the app.

Possible inputs:

- Typing speed compared with normal.
- Typing correction rate.
- Tap accuracy.
- Scroll rhythm.
- Unlock frequency.
- App switching frequency.
- Screen-on time during the session.
- Message composition pauses, if the user has opted into that feature.

Storage rule:

- Compare usage to the user's own baseline, not a global average.
- Store derived metrics, not private message content.
- Message and call analysis must stay behind explicit privacy toggles.

Example derived fields:

| Field | Type | Notes |
|---|---|---|
| `typing_deviation_score` | decimal | Difference from personal baseline. |
| `tap_accuracy_score` | decimal | Touch accuracy estimate. |
| `unlock_pattern_score` | decimal | Unusual unlock/app-use rhythm. |
| `phone_usage_confidence` | decimal | Confidence in phone-use estimate. |

## Drink Log Signals

Drink logs are valuable because they provide explicit alcohol input, but they
cannot be the only source. Not everybody will log every drink, especially later
in the night.

Drink-log inputs:

- Number of drinks logged.
- Drink unit count.
- Alcohol percentage.
- Volume.
- Time since each drink.
- Drink pace.
- Photo-assisted drink estimates.
- Venue or session theme.

Rules:

- Missing logs should not mean sober.
- Logged drinks should increase the score based on timing, strength, and user
  calibration.
- The model should account for alcohol decay over time, but never decay below
  the active responsibility floor before the 12-hour responsibility window ends.
- Photo-detected drink data can fill gaps, but the user can correct it.

## User Calibration

Calibration should be collected during onboarding and remain editable in
settings. The model should be personal, because the same drink pattern can
affect different people very differently.

Required calibration fields:

| Field | Type | Notes |
|---|---|---|
| `body_weight_kg` | decimal | Required during onboarding; used for alcohol effect estimates. |
| `drink_unit_definition` | object | User definition of one `+1`. |
| `usual_drinks_per_session` | decimal, nullable | Baseline from onboarding/settings. |
| `usual_sessions_per_week` | decimal, nullable | Drinking frequency baseline. |
| `motion_baseline_status` | enum | `not_started`, `collecting`, `ready`. |
| `phone_usage_baseline_status` | enum | `not_started`, `collecting`, `ready`. |

Sports information is optional and free-form because it may affect movement
baseline, balance, body composition assumptions, and recovery patterns. It
should not be treated as a guarantee that someone is less drunk.

Optional calibration fields:

| Field | Type | Notes |
|---|---|---|
| `height_cm` | decimal, nullable | Useful if we later estimate body composition. |
| `sex_for_metabolism_model` | enum, nullable | Sensitive; ask only if truly needed. |
| `tolerance_self_rating` | enum, nullable | User estimate: low, medium, high. |
| `sports` | string, nullable | Optional free-form sports/practice description. |

Sports is free-form so users can describe what matters naturally, for example
`football twice a week`, `gym daily`, `running sometimes`, or leave it blank.
It should not be required.

## Active Phone Test

Users should not manually mark themselves as sober or drunk. If they want to
check their state or improve the estimate, they can run an active phone test.
The test produces signal data; it does not let the user directly override the
score.

The active phone test should be short, repeatable, and usable during a night out.
It should be presented as an estimate, not a medical or legal sobriety test.
The user should be able to choose which mini-test/minigame they want to do.
Exact duration, pacing, and interaction design belong to the frontend.

Suggested first version:

1. **Reaction tap test**
   - The screen changes color or shows a target.
   - User taps as quickly as possible.
   - Measures reaction time and missed/early taps.

2. **Hold-steady balance test**
   - User holds the phone still for a few seconds.
   - Uses accelerometer/gyroscope movement.
   - Measures shake, drift, and stability compared with baseline.

3. **Trace or target test**
   - User follows a moving dot or taps targets in order.
   - Measures coordination, timing, and touch accuracy.

4. **Typing phrase test**
   - User types a short phrase shown on screen.
   - Measures typing speed, correction rate, missed keys, and pauses.
   - Stores derived metrics only, not private messages.

5. **Optional voice check**
   - User reads a short phrase.
   - Measures pace, pauses, clarity, and slurring-like changes.
   - Requires explicit voice-analysis consent.
   - Raw audio should be processed on-device or deleted immediately after
     analysis.

Active test outputs:

`active_test_results`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Test result ID. |
| `user_id` | UUID | Owner. |
| `session_id` | UUID, nullable | Related active session if present. |
| `created_at` | timestamp with timezone | Server timestamp. |
| `test_type` | enum | `reaction`, `balance`, `coordination`, `typing`, `voice`. |
| `raw_result` | JSON/object | Mini-test-specific result values. |
| `normalized_score` | decimal | 0-100 contribution to drunk-score model. |
| `active_test_confidence` | decimal | Confidence in active test result. |
| `used_in_score_snapshot_id` | UUID, nullable | Snapshot that consumed this result. |

Active test rules:

- The user can start the test manually from the alcotest screen.
- The user can choose an individual mini-test/minigame instead of being forced
  through one combined flow.
- The app may suggest a test when confidence is low, but should not force it.
- Results can influence the score, but cannot reduce it below the responsibility
  floor.
- Test history should be private unless the user explicitly shares it.
- Active test confidence should be stored in the database, but not shown as a
  public/friend-visible number.

## Scoring Model

Recommended first version: weighted heuristic model with per-signal confidence.
This is easier to explain, debug, and tune than a black-box model.

Suggested starting weights:

| Signal | Weight | Notes |
|---|---:|---|
| Motion | 40% | Strongest passive signal. |
| Phone usage deviation | 25% | Useful but noisier than motion. |
| Drink logs and drink estimates | 25% | Strong when logged, incomplete when not. |
| Session/venue/time context | 10% | Adds responsibility floor and context. |

Formula shape:

```text
raw_score =
  motion_score * 0.40 +
  phone_usage_score * 0.25 +
  drink_log_score * 0.25 +
  context_score * 0.10

final_score = max(raw_score, active_floor)
```

Where `active_floor` is:

- `5%` during an active session.
- `1%` after the session ends until the 12-hour responsibility window expires.
- `0%` only after the 12-hour responsibility window expires.

The score should be stored as both:

- `drunk_percentage`: user-facing 0-100 estimate.
- `confidence`: how reliable the estimate is based on signal quality,
  freshness, quantity, and agreement. This is stored in the database for
  backend/app logic, not shown to friends as a number.

Confidence is not the same as drunkenness. A score can be high-confidence or
low-confidence at any percentage.

Examples:

- `60% drunk, 90% confidence`: many fresh signals agree, such as motion,
  phone usage, drink logs, and an active test.
- `60% drunk, 35% confidence`: the app has weak evidence, for example only an
  old drink log and no recent motion data.
- `10% drunk, 80% confidence`: the user recently started a session but signals
  are stable and consistent.

How confidence is used:

- If confidence is low, the app should suggest that the user does an active
  mini-test.
- If confidence is high, the app does not need to ask for a test.
- Confidence should help the backend decide when to refresh, recalculate, or
  request more signal data.
- Confidence should not be exposed as a friend-visible percentage.

## Score Lifecycle

Session starts:

- Create a `drunk_score_snapshots` record.
- Set `drunk_percentage` to at least `5%`.
- Set `floor_reason` to `session_started`.
- Begin collecting allowed passive signals.

During session:

- Recalculate after drink logs.
- Recalculate after meaningful motion batches.
- Recalculate after phone-usage deviation batches.
- Recalculate after active phone test checks if enabled.
- Push allowed score updates to friends/map based on privacy settings.
- Push friend-visible score updates every 30 minutes during an active session,
  unless a higher-priority safety/privacy rule blocks sharing.

Session ends:

- Stop active session scoring.
- Keep score greater than 0 for 12 hours after the session ends.
- Continue decay estimates if allowed.
- Keep the user-facing state cautious, e.g. recently drinking / recovering.

After the responsibility window:

- Allow score to return to 0 after 12 hours have passed since session end.
- Keep historical session summaries for stats if the user has not deleted them.

## Drunk Score Snapshot Structure

`drunk_score_snapshots`

| Field | Type | Notes |
|---|---|---|
| `id` | UUID | Snapshot ID. |
| `user_id` | UUID | Owner. |
| `session_id` | UUID, nullable | Related session. |
| `created_at` | timestamp with timezone | Server timestamp. |
| `score_at` | timestamp with timezone | Time represented by the score. |
| `drunk_percentage` | decimal | User-facing 0-100 estimate. |
| `confidence` | decimal | 0-100 confidence. |
| `motion_component` | decimal, nullable | Motion contribution. |
| `phone_usage_component` | decimal, nullable | Phone usage contribution. |
| `drink_log_component` | decimal, nullable | Drink/log contribution. |
| `context_component` | decimal, nullable | Session/time/venue contribution. |
| `active_floor` | decimal | Current minimum score. |
| `floor_reason` | enum, nullable | `session_started`, `active_session`, `responsibility_window`. |
| `visibility` | enum | `private`, `friends`, `group`, `session`. |

## On-Device vs Backend

On-device:

- Process raw motion data.
- Process raw phone usage patterns.
- Compare signals to local personal baseline.
- Run sensitive analysis where possible.
- Queue summaries while offline.

Backend:

- Store derived signal summaries.
- Combine signals into final score.
- Enforce privacy and friend visibility.
- Push realtime score updates.
- Keep historical snapshots and session summaries.

## Privacy

- No passive signal is collected unless the matching privacy toggle is enabled.
- Raw messages, raw voice, and raw motion streams should not be stored
  permanently.
- Friends only see the score if the user's visibility settings allow it.
- If a signal is disabled, the score should still work with the remaining
  signals and lower confidence.
- The app should communicate uncertainty clearly.

## Display Rules

- The user should see their exact drunk percentage.
- Friends see only what the user's drunkness visibility allows: category only,
  percentage only, category and percentage, or hidden.
- Friend-visible categories should use the shared tipsiness names: `Fresh`,
  `Buzzing`, `Loose`, `Wavy`, `Gone Mode`, and `Unknown`.
- Confidence should not be shown as a number to friends.
- Confidence is used internally to decide whether the app should suggest an
  active mini-test.
- The app should not ask about food eaten before or during the session in the
  first version.
