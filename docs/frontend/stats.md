# Frontend - Stats

Personal and social statistics screen for score history, refreshment logs,
session history, friend rankings, and long-term patterns.

User-facing copy should say `score`, `percentage`, and `refreshment`. Internal
backend fields may still use names such as `drunk_score_snapshots`,
`drink_logs`, or `night_out_sessions`.

## Goals

- Show score history in a chart that feels like a stock/market chart.
- Let users switch time ranges: hours, day, week, month, year, all time.
- Show session history and summaries.
- Show friend rankings when privacy allows it.
- Help users understand patterns without presenting the score as medical/legal
  truth.
- Respect privacy settings and deleted sessions.

## Primary Layout

Recommended screen areas:

1. Score chart.
2. Time-range selector.
3. Key stats summary.
4. Friend ranking.
5. History feed.
6. Filters.

This should feel like a dense, useful stats screen, not a marketing page.

## Score Chart

The main chart should show the user's score percentage over time, similar to a
stock chart.

Chart requirements:

- Line chart with time on x-axis and percentage on y-axis.
- Y-axis range: 0-100%.
- Show color-coded score levels.
- Support zoom/scrub interaction.
- Show tooltip/crosshair with timestamp, percentage, session name, and venue if
  available.
- Show active session regions as background bands.
- Show `+1` refreshment events as small markers.
- Show active mini-test events as separate markers.
- Show 12-hour responsibility-window tail after a session ends.
- Do not show internal confidence number.

Time ranges:

| Range | Purpose |
|---|---|
| `1H` | Recent live/current session detail. |
| `6H` | Typical evening view. |
| `24H` | Full night plus 12-hour responsibility window. |
| `1W` | Weekly trend. |
| `1M` | Monthly pattern. |
| `1Y` | Yearly history. |
| `ALL` | Lifetime history. |

Data sources:

- `drunk_score_snapshots` for score points.
- `night_out_sessions` for session bands.
- `drink_logs` for refreshment markers.
- `active_test_results` for mini-test markers.
- `session_venues` for venue annotations.

Rules:

- Missing data should create gaps or low-detail regions, not fake precision.
- If score sharing is off, this does not affect the user's own stats.
- Deleted sessions and logs must disappear from charts after sync.
- The chart should not imply the score is a medical result.

## Chart Interactions

Interactions:

- Scrub horizontally to inspect time.
- Tap a session band to open session detail.
- Tap a refreshment marker to open the log detail.
- Tap a mini-test marker to open test summary.
- Pinch/zoom where native iOS interaction makes sense.
- Quick range selector similar to stock apps.

Tooltip content:

- Date/time.
- Score percentage.
- Session title if present.
- Venue or rough area if available.
- Number of refreshments logged nearby in time.

Do not show:

- Internal confidence number.
- Exact private coordinates.
- Friends' private calibration data.

## Key Stats Summary

Show compact metrics for the selected time range.

Possible metrics:

- Average score.
- Peak score.
- Number of sessions.
- Total logged refreshment units.
- Average session length.
- Total spend if known.
- Venues visited.
- Active mini-tests completed.
- Most common session theme.

Rules:

- Use the selected chart range.
- If a metric is unavailable, hide it or show a neutral empty state.
- Spend should show currency.
- Venue/private location data should respect privacy.

## Friend Ranking

Show a ranking among friends when privacy settings allow it.

Ranking options:

- Highest peak percentage this week/month.
- Most sessions.
- Most active nights.
- Longest session.
- Most venues visited.
- Most active mini-tests completed.
- Most logged refreshment units.

Default ranking metric:

- Peak percentage.

Scope:

- Ranking is among all friends by default.

Privacy rules:

- Only include friends who allow the relevant stat to be visible.
- Do not reveal hidden sessions.
- Do not reveal exact private location.
- Do not show internal confidence.
- If a friend disables score sharing, exclude their score-based ranking or show
  them as hidden.
- Panic privacy should remove a user from realtime/social ranking until it
  expires or is disabled.

Ranking display:

- Rank number.
- Friend display name/photo.
- Metric value.
- Time range.
- Optional color-coded percentage if score is visible.

Avoid shaming language. The ranking should feel playful/social, not punitive.

## History Feed

Historical sessions should appear as a scrollable log.

Each history item should show:

- Session title.
- Date and start/end time.
- Duration.
- Peak percentage.
- Average percentage if available.
- Logged refreshment count/units.
- Total spend if known.
- Venues visited count.
- Friends/participants if visible.
- City/rough area.

Actions:

- Open session detail.
- Edit title/theme.
- Edit or delete refreshment logs.
- Delete session.
- Link to settings for data export if needed.

Rules:

- One session can include multiple venues.
- Auto-created sessions should be editable.
- House parties/private addresses show private/rough labels only.
- Deleted sessions disappear from stats after sync.
- History export should be available only from settings, not directly from
  session detail.

## Session Detail

Session detail should combine timeline, summary, participants, and venues.

Sections:

- Session score chart.
- Timeline of refreshment logs and mini-tests.
- Venue list.
- Participants.
- Spend summary.
- Privacy/visibility summary.

Timeline events:

- Session start/end.
- `+1` refreshment logs.
- Photo-assisted refreshment logs.
- Venue arrival/departure.
- Active mini-test.
- Score peak.

## Filters

Filters should help users explore history.

Filters:

- Date range.
- Friends/group.
- Venue.
- City/area.
- Session theme.
- Score range.
- Refreshment type/preset.
- Price/spend.

Rules:

- Filters should not expose hidden friend data.
- Private places should appear as private labels unless the user owns the data.

## Empty and Fallback States

No data yet:

- Show a simple empty state that points to map/current session or `+1` logging.

Signals disabled:

- If motion/phone signals are off, show stats based on sessions and logs only.
- If location is off, omit venue/map-based stats or use manually selected venues.
- If score sharing is off, friend ranking still can show non-score stats if
  allowed.

Low data:

- Show less precise summaries.
- Do not show internal confidence number.
- The app can suggest an active mini-test elsewhere when confidence is low, but
  stats should not nag.

## Privacy and Deletion

- User always sees their own allowed history.
- Friends only see social stats if sharing/visibility allows it.
- Deleted logs/sessions must be removed from charts, rankings, and summaries.
- Account deletion removes the user from friend rankings immediately during the
  1-month grace period.
- Panic privacy removes the user from live/social stats immediately for 24
  hours.
- Data export/deletion actions live in settings, but stats can link to them.

## Data Requirements

Frontend needs endpoints/views for:

- Score series by range.
- Session summaries by range.
- Session detail.
- Friend ranking by metric/range.
- Refreshment log summaries.
- Venue/session aggregation.
- Spend aggregation.

Spend requirements:

- Stats should include money spent in v1.
- Use known or inferred prices from refreshment logs and venue averages.
- If price data is incomplete, show partial totals clearly.
- Always show currency.

Suggested query parameters:

- `range`: `1h`, `6h`, `24h`, `1w`, `1m`, `1y`, `all`.
- `metric`: ranking/stat metric.
- `friend_group_id`: optional.
- `venue_id`: optional.
- `session_theme`: optional.
- `timezone`: user timezone.

## Resolved Product Decisions

- Default friend ranking metric is peak percentage.
- Friend ranking is among all friends by default.
- Stats should include money spent in v1.
- No chart comparison mode against friends/groups.
- History/data export is available only from settings.
