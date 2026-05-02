# Screen — Alcotest (TEST)

Alcotest is a gamified active test screen. It gives the app extra signals for the drunk score by making the user play short games that measure reaction time, coordination, memory, focus, movement, optional voice clarity, and self-reported state.

The first choice is always:
- Single Player
- Multiplayer

The screen does not tell people to stop, chill, or go home. It updates drunk score data.

## Main Entry

When the user opens TEST, they choose a mode first.

```text
TEST

[ SINGLE PLAYER ]
[ MULTIPLAYER ]
```

## Single Player

Single Player is for testing only the current user.

Use cases:
- The user wants to update their own drunk score.
- The app needs active data in addition to passive signals.
- The user wants to run a quick test without friends.

Entry labels:
- `SINGLE PLAYER`
- `SOLO TEST`
- `JUST ME`
- `CHECK ME`

After selecting Single Player:

```text
SINGLE PLAYER

[ QUICK ROUND ]
[ FULL ROUND ]
[ CUSTOM ROUND ]
```

### Quick Round

Purpose:
- Fast score update.
- Minimal interruption.

Suggested games:
- Tap The Dot
- Hold Still
- Vibe Check

Output:
- Updates the user's drunk score with low-to-medium confidence.

### Full Round

Purpose:
- More complete score update.
- Better signal diversity.

Suggested games:
- Tap The Dot
- Straight Line
- Memory Tray
- Hold Still
- Vibe Check
- Read It Right if voice analysis is enabled
- Tongue Twister if voice analysis is enabled

Output:
- Updates the user's drunk score with higher confidence than Quick Round.

### Custom Round

Purpose:
- Let the user choose which games to play.

Rules:
- Disabled games should still appear if they are blocked by privacy settings.
- The app should clearly show why a game is unavailable.

Example:

```text
CUSTOM ROUND

[ TAP THE DOT ]
[ STRAIGHT LINE ]
[ MEMORY TRAY ]
[ HOLD STILL ]
[ READ IT RIGHT - voice off ]
[ VIBE CHECK ]
```

## Multiplayer

Multiplayer is for testing multiple people in the same session.

Use cases:
- Friends want to compare active test results.
- A group wants a shared game.
- The app needs drunk-score inputs for more than one user.
- People nearby want to join without creating an account.

Multiplayer must feel like a real shared mode, not several people doing isolated solo tests. Players should react to the same prompts, compare the same round, and see the group progress together.

Entry labels:
- `MULTIPLAYER`
- `GROUP TEST`
- `GROUP SOBRIETY TEST`
- `PARTY CHECK`

After selecting Multiplayer:

```text
MULTIPLAYER

[ PASS THE PHONE ]
[ CONNECTED DEVICES ]
[ GROUP ROUND ]
```

## Temporary Guests

Multiplayer allows temporary guests.

Guest rules:
- Guests can be added by name or nickname.
- Guests do not need an Antidotte account.
- Guest results are part of the current multiplayer round.
- Guest results stay in the local night history.
- Guest results can be linked to an account later if the guest joins Antidotte.
- Guest results should be marked as guest data.

Guest setup examples:
- `Mia`
- `Leo`
- `Noa`
- `Guest 1`
- `Add from contacts/friends`

### Pass The Phone

One phone is passed between players.

Flow:
1. Add players.
2. Choose a round type.
3. Everyone sees the same game instructions.
4. Player 1 completes the shared challenge.
5. The app shows that player's round result.
6. The app shows whose turn is next.
7. Player 2 completes the same shared challenge.
8. Continue until every player has completed the same round.
9. Each player's results update their own drunk score or guest round result.
10. Show a multiplayer scoreboard.

This mode is still multiplayer because everyone is part of the same round, sees the same challenge, and compares results immediately.

### Same Game For Everyone

Everyone completes the same game as part of one shared round.

Good for:
- Comparing reaction time.
- Comparing coordination.
- Creating one clear group scoreboard.

Examples:
- Everyone plays Tap The Dot.
- Everyone traces the same line.
- Everyone does the same Memory Tray.

Rules:
- The game should be identical for every player in the round.
- The app should show progress, such as `2/5 players done`.
- The scoreboard appears only after everyone finishes or the host ends the round.
- If someone skips, mark them as skipped instead of blocking the whole group.

### Connected Devices

Connected Devices lets every player use their own phone in the same multiplayer round.

Use cases:
- Everyone has Antidotte installed.
- The group wants simultaneous play.
- The game requires everyone to react at the same time.
- The group does not want to pass one phone around.

Connection options:
- Join with invite link.
- Join with QR code.
- Join from nearby accepted friends.
- Join from current group/location if available.

Host flow:
1. Host starts a multiplayer room.
2. Host invites friends or shows a QR code.
3. Players join on their own phones.
4. Host chooses games.
5. Everyone receives the same prompts.
6. The round starts for everyone together.
7. Results sync into one scoreboard.

Rules:
- Connected players use their own accounts.
- Temporary guests can still be added on the host phone if needed.
- The host can start when enough players are ready.
- Late players can join the next round.
- If a player disconnects, mark them as disconnected and keep the round moving.

Connected-device games can be:
- Synchronous: everyone reacts at the same time.
- Turn-based: everyone gets the same task one after another.
- Voting-based: everyone answers a prompt before results are revealed.

### Live Group Prompt

Live Group Prompt is for games where everyone responds to the same prompt together.

Possible versions:
- Everyone taps their own answer on one phone in order.
- Everyone votes/selects an answer before the result is revealed.
- The app calls out names and players respond quickly.

Good for:
- Vibe Check.
- Memory Tray.
- Reaction Color if players pass the phone quickly.

Output:
- One shared group round.
- Individual score inputs per player.
- One group scoreboard.

### Group Round

The group plays the same set of games.

Suggested group round:
1. Tap The Dot
2. Straight Line
3. Vibe Check

Rules:
- Every player gets the same games in the same order.
- The round should show current player, next player, and progress.
- The app should keep the group in one shared flow.
- Players should not feel like they entered separate single-player sessions.

Output:
- Each account player gets an individual drunk-score update.
- Each guest gets a temporary round result.
- The group gets one shared scoreboard.

Player setup:
- Pick accepted friends if available.
- Add temporary guest names.

## Games

Each game should collect one or more measurable signals. The game result should feed the drunk score, not exist only as entertainment.

The app should offer a multitude of games, not only one default test. Rounds can be built from different games depending on time, permissions, and multiplayer mode.

Game categories:
- Reaction games.
- Coordination games.
- Memory/focus games.
- Motion games.
- Voice games.
- Self-report games.
- Group prompt games.

### Tap The Dot

The user taps a moving target as quickly and accurately as possible.

Signals collected:
- Reaction time
- Tap accuracy
- Miss rate
- Delayed taps
- Consistency across attempts

Scoring notes:
- Slower reaction time can increase the drunk score.
- More missed taps can increase the drunk score.
- Inconsistent reaction time can reduce confidence or indicate impairment.

Round structure:
- 5 to 10 taps.
- Short delay between target appearances.
- Record each tap separately.

Result examples:
- `Fast`
- `Late taps`
- `Dot escaped`
- `Signal added`

### Straight Line

The user traces a displayed path with their finger.

Signals collected:
- Path deviation
- Wobble amount
- Completion time
- Stops/pauses
- Overcorrection

Scoring notes:
- More deviation can increase the drunk score.
- Large pauses can indicate reduced focus.
- Fast but inaccurate tracing should count differently from slow but accurate tracing.

Round structure:
- One short path for Quick Round.
- Two or three paths for Full Round.

Result examples:
- `Clean line`
- `Wobbly line`
- `Modern art`
- `Signal added`

### Memory Tray

The app shows objects briefly, then asks the user to identify them.

Signals collected:
- Short-term memory
- Recognition accuracy
- Response time
- Incorrect selections

Object examples:
- Beer
- Key
- Pizza
- Tram ticket
- Sunglasses
- Shoe
- Phone
- Wallet

Scoring notes:
- Fewer correct answers can increase the drunk score.
- Longer response time can increase the drunk score.
- This signal should be weighted carefully because memory varies by person.

Round structure:
- Show 4 to 7 objects.
- Hide after a few seconds.
- Ask user to select what they saw.

Result examples:
- `Sharp`
- `Kinda fuzzy`
- `Brain buffering`
- `Signal added`

### Hold Still

The user holds the phone still for a short time.

Signals collected:
- Accelerometer movement
- Gyroscope movement
- Shake amount
- Stability over time

Scoring notes:
- More shaking can increase the drunk score.
- If phone usage tracking is off, this game is unavailable.

Round structure:
- 3 to 5 seconds for Quick Round.
- 5 to 8 seconds for Full Round.

Result examples:
- `Solid`
- `Tiny shake`
- `Wobble zone`
- `Signal added`

### Reaction Color

The user taps when a color changes.

Signals collected:
- Reaction time
- False starts
- Missed starts
- Consistency

Scoring notes:
- False starts suggest impulsive tapping and should be tracked separately from slow reactions.
- Reaction Color can be used as an alternative to Tap The Dot.

Round structure:
- Screen waits randomly.
- Color changes.
- User taps as soon as it changes.
- Repeat several times.

Result examples:
- `Ready`
- `Too early`
- `Late`
- `Signal added`

### Balance Path

The user tilts the phone to keep an object inside a path or target zone.

Signals collected:
- Motion control
- Overcorrection
- Stability
- Time in target zone

Scoring notes:
- This should only be available when motion/phone usage tracking is enabled.
- It can add stronger motor-control data than Hold Still.

Round structure:
- 10 to 15 seconds.
- Keep object inside target zone.
- Record stability and exits.

Result examples:
- `Controlled`
- `Overcorrected`
- `All over`
- `Signal added`

### Read It Right

The user reads a short sentence.

Only available when call/voice analysis is enabled.

Signals collected:
- Speech clarity
- Reading pace
- Slurring estimate
- Hesitation
- Repetition

Sentence examples:
- `Three tiny tables tipped twice`
- `Seven tiny tables tipped sideways`
- `Big blue bar bill`
- `Pizza before party problems`

Scoring notes:
- Voice data should be analyzed only when enabled.
- Do not store persistent audio unless the privacy model explicitly allows it.
- If voice is off, skip this game and continue.

Result examples:
- `Clear`
- `Slow read`
- `Mumbled`
- `Voice off`

### Tongue Twister

The user reads a tongue twister out loud.

Only available when call/voice analysis is enabled.

Signals collected:
- Speech clarity
- Slurring estimate
- Word skipping
- Repetition
- Reading pace
- Hesitation

Tongue twister examples:
- `Red lorry, yellow lorry`
- `Unique New York`
- `She sells sea shells`
- `Toy boat, toy boat, toy boat`
- `Six sticky skeletons`
- `Fresh fried fish`

Scoring notes:
- Tongue Twister should be harder than Read It Right.
- It should be optional because it needs voice analysis.
- Do not store persistent audio unless the privacy model explicitly allows it.
- If voice is off, skip this game and continue.
- In multiplayer, everyone should get the same tongue twister for the round.

Result examples:
- `Clean read`
- `Tongue tied`
- `Skipped words`
- `Voice off`

### Vibe Check

The user self-reports how they feel.

Prompt:

```text
HOW ARE YOU FEELING?
```

Options:
- `Chill`
- `Buzzing`
- `Loud`
- `Wobbly`
- `Chaos mode`
- `Still normal`

Signals collected:
- Self-reported state
- Confidence modifier
- Context for interpreting other games

Scoring notes:
- Vibe Check should not overpower measured signals.
- It is useful when permissions are off.
- It can help calibrate the user's personal baseline over time.

### Number Mash

The user taps numbers in order as quickly as possible.

Signals collected:
- Visual scanning
- Tap accuracy
- Reaction time
- Mistakes
- Correction time

Scoring notes:
- Useful as a focus and coordination signal.
- Works in Single Player, Pass The Phone, and Connected Devices.

Result examples:
- `Clean run`
- `Wrong number`
- `Slow scan`
- `Signal added`

### Shape Match

The user matches shapes or symbols under time pressure.

Signals collected:
- Recognition speed
- Wrong selections
- Focus consistency
- Response time

Scoring notes:
- Useful as an attention signal.
- Can be run with the same prompt for everyone in multiplayer.

Result examples:
- `Matched`
- `Mixed up`
- `Close enough`
- `Signal added`

### Rhythm Tap

The user repeats a simple tap rhythm.

Signals collected:
- Timing accuracy
- Missed beats
- Extra taps
- Rhythm drift

Scoring notes:
- Useful for coordination and timing.
- Good for multiplayer because everyone can compare the same rhythm.

Result examples:
- `On beat`
- `Off beat`
- `Extra taps`
- `Signal added`

### Quick Math

The user answers simple math prompts.

Signals collected:
- Response accuracy
- Response time
- Mistakes
- Hesitation

Scoring notes:
- Should stay simple.
- Should not feel like a school exam.
- Useful as a focus signal, but should be weighted lightly because users vary a lot.

Result examples:
- `Correct`
- `Slow solve`
- `Wrong answer`
- `Signal added`

### Spot The Change

The app briefly shows an image or object set, changes one thing, then asks what changed.

Signals collected:
- Attention
- Memory
- Response accuracy
- Response time

Scoring notes:
- Works well for multiplayer connected devices because everyone can receive the same prompt.

Result examples:
- `Spotted`
- `Missed it`
- `Too slow`
- `Signal added`

## Score Update

Every completed game produces one or more signals.

The drunk score updates only after the full selected round is complete. Individual games collect temporary signals during the round, but they do not update the displayed drunk score immediately.

Example signal object:

```text
game: Tap The Dot
reaction_time_avg: 420ms
miss_rate: 20%
consistency: low
confidence: medium
```

The drunk score should use:
- Existing drink logs.
- Current session duration.
- User's `+1` definition.
- Theme/drink context.
- Passive signals if enabled.
- Alcotest game signals.

Update timing:
- During a round: collect game signals.
- After each game: show only game feedback.
- End of round: calculate the drunk score update.
- Result screen: show the new score label, confidence, and signals used.

## Replay Rule

Users can replay one game if the input was clearly messed up.

Allowed replay examples:
- Someone bumped the phone.
- The wrong person tapped.
- The player misunderstood the instructions.
- The phone lagged or the game glitched.

Rules:
- Allow one replay per game attempt.
- Keep the second attempt as the final one.
- Do not let users replay endlessly to improve the score.
- In Multiplayer, replay should be visible to the group so the round stays fair.

## Confidence

Each test round should produce a confidence level.

Confidence levels:
- Low
- Medium
- High

Examples:
- Quick Round with Vibe Check only: Low.
- Quick Round with Tap The Dot and Hold Still: Medium.
- Full Round with multiple games and available permissions: High.

The result screen should show when the score needs more signals.

## Multiplayer Score Handling

In Multiplayer:
- Each player gets their own test result.
- Each player's result updates only their own drunk score.
- The group scoreboard compares game performance, not private passive data.
- Temporary guests get a round result that stays in the local night history.
- The mode should present one shared group round, not separate solo tests.

Example:

```text
GROUP ROUND COMPLETE

MIA - reaction signal added
LEO - motion signal added
NOA - vibe signal added

Group round saved.
```

## Result Screen

The result screen shows what changed after the round.

Possible score labels:
- `Fresh`
- `Buzzing`
- `Loose`
- `Wavy`
- `Gone Mode`
- `Unknown`
- `Needs more signals`

Single-player example:

```text
YOU SEEM: TIPSY

Score updated with:
- reaction time
- motion
- vibe check

Confidence: medium

Not used:
- voice off
- messages off
```

Multiplayer example:

```text
ROUND RESULTS

MIA - Buzzing - confidence medium
LEO - Loose - confidence high
NOA - Unknown - needs more signals
```

## Privacy

Every test respects the user's settings.

If a signal is off:
- Do not use it.
- Do not estimate from it.
- Mark it as unavailable.
- Continue with the remaining available games.

Privacy examples:
- Voice off: skip Read It Right.
- Phone usage off: skip Hold Still and Balance Path.
- Message analysis off: do not use message-based signals.
- Location off: do not use live location context.

Do not pressure the user to enable a signal.

## Edge Cases

- User quits mid-round: save completed game signals only.
- User receives a call: pause round if possible.
- Motion permission unavailable: remove motion games from recommended rounds.
- Voice permission unavailable: remove voice game from recommended rounds.
- Guest player leaves: save other players' completed results.
- Bad connection: keep local results until sync is possible.
- Clearly messed-up input: allow one replay for that game.
- Connected-device player disconnects: mark disconnected and keep the room open.
- Connected-device player rejoins: allow them back into the current room if the round state supports it.

## Open Questions

- Should connected-device multiplayer be part of MVP, or planned immediately after pass-the-phone?
- Should the host choose games manually, or should the app generate a random game set?
