# Frontend Styling Sheet

Antidotte has three selectable visual modes. The user can choose the mode in Settings.

The modes are:
- `Blackout`
- `Cartoon`
- `Chaos`

All modes must be aggressively anti-AI-looking. The app should never look like it came from a generic prompt, template, or smooth startup UI kit.

No:
- Glassmorphism.
- Soft gradient blobs.
- Oversized pill buttons.
- Polished SaaS cards.
- Perfect spacing everywhere.
- Generic rounded rectangles.
- Purple/blue AI gradients.
- Smooth plastic icon bubbles.
- Bland "modern app" panels.
- Symmetrical generated-looking layouts.

## Style Mode Selector

Settings should include a style mode selector.

```text
STYLE MODE

[ BLACKOUT ]
[ CARTOON ]
[ CHAOS ]
```

Rules:
- The mode affects the whole frontend.
- The user can switch modes at any time.
- `Chaos` is the default mode.
- Style mode is private to the user.
- Core layout and navigation stay consistent across modes.
- Privacy and safety-related information must remain readable in every mode.
- Reduced motion settings must override Chaos motion.

Settings should also include a separate animation control:

```text
MAIN ANIMATIONS

[ ON ]
[ OFF ]
```

Animation setting rules:
- This is separate from style mode.
- Turning animations off keeps the selected visual mode but removes main movement.
- It should disable big page motion, wobble, shake, jumping labels, and animated backgrounds.
- Small state changes and necessary feedback can remain.
- Reduced motion settings override this toggle if the device requires less motion.

## Mode 1 — Blackout

Blackout is the dopamine-free mode.

Purpose:
- Calm version of the app.
- Black and white.
- Low stimulation.
- Useful when the user wants the app to feel simple, dry, and not addictive.

Visual direction:
- Mostly black, white, and grayscale.
- Minimal color.
- High contrast.
- No decorative color accents except necessary state colors.
- No unnecessary animation.
- No visual noise.

Palette:
- White: `#FFFFFF`
- Paper white: `#F7F7F2`
- Black: `#111111`
- Gray 1: `#E6E6E6`
- Gray 2: `#A8A8A8`
- Gray 3: `#4A4A4A`

Color rules:
- Use black/white first.
- Use green/red only when a state truly needs it, such as `join me` or `do not join me`.
- Tipsiness categories should use emoji/text more than color.
- Avoid dopamine-heavy accents.

Shape:
- Sharp rectangles.
- Thin to medium black outlines.
- Minimal decoration.
- No pill buttons.
- No smooth floating cards.

Typography:
- Clean and readable.
- Body text can use system font.
- Headings can still be slightly hand-drawn, but not loud.

Motion:
- Almost none.
- No wobble unless it communicates state.
- No background movement.

Map:
- Desaturated.
- High contrast.
- Simple friend indicators.
- Minimal visual clutter.

Best for:
- Users who want less stimulation.
- Daytime use.
- Privacy/settings screens.
- People who hate overly playful apps.

## Mode 2 — Cartoon

Cartoon is the main playful Antidotte mode.

Purpose:
- Fun but still readable.
- Social night-out energy.
- Kid-drawn, sticker-like, colorful.
- A calmer playful alternative to Chaos.

Visual direction:
- A night-out app drawn by a 10-year-old on school paper.
- Handmade, irregular, playful.
- Paper, marker, pencil, sticker, notebook, street-poster energy.
- Crooked but understandable.

Palette:
- Paper white: `#F8F1DD`
- Ink black: `#151515`
- Pencil gray: `#767067`
- Street asphalt: `#2D2A26`
- Beer yellow: `#F6C445`
- Alarm red: `#E94732`
- Friend blue: `#2F80ED`
- Mint gum: `#49C98A`
- Cocktail pink: `#F05CA8`
- Bruise purple: `#6D4BC3`

Shape:
- Uneven rectangles.
- Torn-paper panels.
- Sticker labels.
- Slightly rotated tags.
- Rough borders with inconsistent thickness.
- Max border radius: `4px`.

Typography:
- Headings: hand-drawn/comic-style font.
- Body: readable sans-serif.
- Labels: uppercase, marker-like, but readable.

Motion:
- Small sticker pops.
- Tiny wobble on live/fun elements.
- Hand-drawn underline animation for tabs.
- No smooth luxury transitions.

Map:
- OpenStreetMap data with paper-map treatment.
- Roads look like marker strokes.
- Friend pins look like stickers.
- Grouped friends can look stacked.

Best for:
- Main app experience.
- Map.
- Alcotest games.
- Theme selection.
- Social flows.

## Mode 3 — Chaos

Chaos is the intentionally messy mode.

Purpose:
- Make the app feel drunk even when the user is not.
- Visually unstable, loud, overloaded, and funny.
- Still usable enough for core actions.

Visual direction:
- Everything is a little wrong.
- Labels lean too much.
- Borders double up.
- Colors clash.
- Elements feel taped, scribbled, crossed out, and re-stuck.
- The screen should feel like a notebook after a messy night out.

Important:
- Chaos must be an optional user-selected mode.
- Chaos must respect accessibility settings.
- Core actions must remain tappable and readable.
- Privacy controls must not become confusing.

Palette:
- Ink black: `#111111`
- Paper white: `#F8F1DD`
- Beer yellow: `#F6C445`
- Alarm red: `#E94732`
- Toxic green: `#7CFF4D`
- Hot pink: `#FF3EA5`
- Electric blue: `#1D6BFF`
- Dirty purple: `#6D4BC3`

Color rules:
- Use clashing accents.
- Overuse black outlines.
- Allow intentional color conflict.
- Never make critical text unreadable.

Shape:
- Extreme uneven rectangles.
- Torn edges.
- Duplicate outlines.
- Random rotations.
- Stacked labels.
- Scribbles crossing behind components.
- Max border radius: `2px`.

Typography:
- Big handwritten labels.
- Occasional mismatched font sizes.
- Some labels can be tilted or underlined.
- Body text must still be readable.

Motion:
- Wobble.
- Slight shake.
- Jumpy sticker pops.
- Misaligned transitions.
- Drunk-score pins can sway more.

Motion limits:
- Must stop or reduce when reduced motion is enabled.
- Do not animate essential reading text continuously.
- Do not make buttons move away from taps.

Map:
- More distorted than Cartoon.
- Friend pins can wobble.
- Labels can be messy.
- Drunk categories can get stronger visual treatment.
- Keep map interaction functional.

Best for:
- Users who want the funny version.
- Alcotest.
- Nights out.
- Social/group screens.

Avoid:
- Making the app unusable.
- Hiding privacy controls.
- Making text impossible to read.
- Motion sickness.

## Shared Rules Across All Modes

Use:
- Clear hierarchy.
- Strong tap targets.
- State labels in text, not only color.
- Familiar navigation.
- Readable profile popouts.
- Stable placement for core actions.
- Human imperfection.
- Visible edges, outlines, or structure.
- Specific Antidotte personality.

Avoid:
- Large rounded cards.
- Pill buttons.
- Glassmorphism.
- Smooth AI-dashboard gradients.
- Generic startup-app polish.
- Cards inside cards.
- Perfectly centered hero-style layouts.
- Decorative gradient orbs.
- Stock-looking empty states.
- Template-looking settings rows.
- Overly smooth shadows.
- Same-size same-radius everything.

Suggested border radius:
- Blackout: `0px`
- Cartoon: `0px` to `4px`
- Chaos: `0px` to `2px`

## Tipsiness Categories

Every tipsiness category has a name and emoji.

- `Fresh` 🙂
- `Buzzing` 😄
- `Loose` 😵‍💫
- `Wavy` 🌊
- `Gone Mode` 🫠
- `Unknown` ❔

Display rules:
- If the user shares category only, show name + emoji.
- If the user shares percentage only, show percentage.
- If the user shares both, show name + emoji + percentage.
- If hidden, show nothing.
- Do not rely on color alone.

Mode treatment:
- Blackout: emoji + text, minimal color.
- Cartoon: emoji + sticker-like category badge.
- Chaos: emoji + messy badge, stronger wobble/outline.

## Join Status

Join status appears on the map and profile popouts.

States:
- `Join me`
- `Do not join me`

Display:
- `Join me` should be green.
- `Do not join me` should be red.
- Always include text, not only color.

Mode treatment:
- Blackout: simple label with minimal green/red.
- Cartoon: sticker label.
- Chaos: loud label with heavy outline.

## Buttons

Buttons must avoid the generic rounded look.

Shared button rules:
- Clear label.
- Strong outline.
- Large enough for thumbs.
- Pressed state should be obvious.
- No pill buttons.

Blackout:
- Rectangular.
- Monochrome.
- Minimal motion.

Cartoon:
- Sticker/block style.
- Bright accent fills.
- Slight rotation allowed.

Chaos:
- Aggressive outline.
- Messy label.
- Strong press effect.

The `+1` drink button:
- Must be one of the loudest controls on the map in Cartoon and Chaos.
- Must stay simple and readable in Blackout.

## Navigation

Tabs:
- BEST
- SEST
- MEST
- TEST

Shared rules:
- Tabs stay in the same order across modes.
- Active tab must be obvious.
- Inactive tabs must remain readable.

Blackout:
- Minimal tab bar.
- Black/white active state.

Cartoon:
- Notebook-tab feel.
- Marker active state.

Chaos:
- Crooked, loud active state.
- Still easy to tap.

## Settings

Settings must be the clearest screen in every mode.

Must include:
- Style mode selector.
- Main animations toggle.
- Language.
- Privacy toggles.
- Default join status.
- Location group defaults.
- Drunkness visibility.
- `+1` drink unit.

Settings rules:
- Every toggle shows `ON` or `OFF`.
- Privacy copy stays plain.
- Chaos mode cannot obscure privacy meaning.
- Blackout mode should be the most calm Settings experience.
- Style mode is private and only changes how the app looks for the current user.
- Main animations can be turned off independently of style mode.

## Map Style

The map uses OpenStreetMap data in every mode.

Shared:
- Keep OpenStreetMap attribution visible.
- Friend pins show allowed location precision.
- Approximate 150m location should be visually distinct from exact location.
- `Join me` / `Do not join me` must be visible.

Blackout:
- Desaturated map.
- Minimal friend indicators.
- Text-first status.

Cartoon:
- Paper-map treatment.
- Sticker friend pins.
- Marker roads.

Chaos:
- Distorted paper-map treatment.
- More wobble and clutter.
- Still navigable.

## Alcotest Style

Alcotest should follow the selected mode.

Blackout:
- Simple test UI.
- Minimal animation.
- Focus on signal collection.

Cartoon:
- Party-game feel.
- Fun game cards.
- Playful score labels.

Chaos:
- The most extreme mode.
- Games can feel intentionally drunk.
- Results and controls must still be clear.

## Accessibility

All three modes must respect accessibility.

Rules:
- Text must remain readable.
- Tap targets stay large.
- Important states use text and icons, not color alone.
- Reduced motion disables or reduces Chaos movement.
- Privacy settings stay clear.
- Blackout should be available for users who want low stimulation.

## Anti-AI Checklist

Before accepting a screen, check:
- Are there big rounded cards? Remove or sharpen them.
- Are buttons pill-shaped? Replace them.
- Does it look like a generic startup app? Push it toward the selected Antidotte mode.
- Could this screenshot be mistaken for an AI-generated app mockup? If yes, make it weirder and more specific.
- Are all surfaces too clean? Add human structure: outlines, labels, paper, ink, or deliberate imbalance.
- Are icons too perfect? Use rougher icons or stronger labels.
- Are colors too tasteful? Make the palette fit the selected mode instead of looking like a template.
- Is Chaos unreadable? Pull it back.
- Is Blackout too playful? Calm it down.
- Is Cartoon too polished? Make it more handmade.

## Open Questions

- Should `Chaos` unlock only after setup, or be available immediately?
