# Tumbling Tricks

An offline planner for stage performances. Performers, choreographers and
directors use it to build an **act**, order the **tricks** inside it, log
rehearsals, keep the technical rider in one place and track how ready the
routine actually is.

This is a productivity app, not a game. There are no levels, no currency, no
rewards for their own sake. Everything runs on-device: no account, no network
calls, no backend.

## Release data

| | |
|---|---|
| Platform | Flutter, iOS (Android target kept building alongside) |
| Bundle ID | `com.tumblingtricks.tricksgame` |
| App ID | 6797948134 |
| Team ID | `Y5PUSTX22G` |
| Language | English only |
| Orientation | Portrait, except the launch sequence which supports both |
| Primary category | Productivity |
| Privacy Policy | https://tumblingtricks.com/privacy-policy.html |
| Support | https://tumblingtricks.com/support.html |

## Requirements

- Flutter 3.44+ / Dart 3.12+
- Xcode 26+, CocoaPods 1.17+
- iOS deployment target 15.0

## Getting started

```bash
flutter pub get
flutter run                # debug on a connected device or simulator
flutter analyze
flutter test
```

Release builds are only produced on explicit request.

## Project layout

```
lib/
  app/          Root widget, orientation policy, routing
  design/       Design system: palette, type scale, metrics, components
    app_assets.dart   GENERATED asset catalogue
  dev/          Temporary scaffolding, removed as real screens land
assets/
  ui/           Curated artwork sliced from the source sheets (WebP)
  audio/        Interface and stage cue sounds
  fonts/        Cinzel, Playfair Display, Inter (bundled, never fetched)
  branding/     App icon masters
  legal/        Font licences; offline Privacy Policy and Support pages
  Tumbling_Tricks_*_assets/   Raw source sheets — NOT bundled
tools/          Asset analysis, slicing and catalogue generation scripts
```

### Assets

The source artwork arrives as sheets containing many elements. `tools/` turns
them into the curated set the app ships:

```bash
python3 tools/analyze_assets.py      # detect elements, write annotated previews
python3 tools/export_assets.py       # slice and export to WebP
python3 tools/gen_asset_catalog.py   # regenerate lib/design/app_assets.dart
```

Run the last one after adding or renaming anything under `assets/ui`,
`assets/audio` or `assets/legal/fonts`. Referencing assets through the generated
catalogue means a renamed file breaks the build instead of silently rendering an
empty box.

The `Notifications_Screen` and `Nowifi_Screen` artwork is deliberately excluded
and never bundled: the app does not fake system notifications or network errors.

### Fonts

All three families are bundled variable fonts, so type renders identically
offline. Their SIL Open Font Licences ship in `assets/legal/fonts/` and are
shown in the app.

## Design system

One dark theme, built for the artwork: bordeaux, stage black, emerald, brass and
aged playbill paper. Import it with a single line:

```dart
import 'package:tumbling_tricks/design/design.dart';
```

- `Palette` — colours and gradients
- `AppText` / `Fonts` — the type scale, named by role
- `Gap`, `Corners`, `Layout`, `Motion` — spacing, radii, layout and timing
- `StageBackdrop`, `MarqueeHeader`, `SectionHeading`, `GoldRule`, `PanelCard`,
  `PaperCard`, `BrassProgressBar` — core components

Authored text always renders as dark ink on paper (`PaperCard` + `PaperInk`);
chrome and data render as cream on dark.

## Build status

| # | Iteration | State |
|---|---|---|
| 0 | Assets sliced, icons and sounds prepared | done |
| 1 | Project skeleton, iOS config, design system | done |
| 2 | Data layer: Drift schema, repositories, trick catalogue seed | next |
| 3 | Launch sequence with honest progress, router, Arena Dock | |
| 4 | Onboarding and Stage Console | |
| 5 | Acts and the Run Order builder | |
| 6 | Timeline, Rehearsal Log, Stage Plot | |
| 7 | Trick Library | |
| 8 | Progress and Playbill Archive | |
| 9 | Profile with performer photo (camera and library) | |
| 10 | Settings, backup, reset | |
| 11 | Privacy Policy and Support, rendered offline | |
| 12 | Sound, haptics, accessibility, App Store checklist | |
