# Flutter Foundation Kit

A source-only Flutter baseline for teams. It gives new apps a working
architecture example, shared UI primitives, strict analyzer defaults, async data
flow, and short guardrail docs that explain how to extend the kit without
diluting it.

## What's Included

- `lib/core`: app-wide routing, theme, brand tokens, logging, result/failure
  primitives, and localization helpers.
- `lib/shared/widgets`: reusable page, chart, form, async, empty-state, and
  layout widgets.
- `lib/features/template`: a small working feature that demonstrates the
  expected data, domain, use case, controller, presentation, formatter, mapper,
  and widget split.
- `docs`: architecture rules, feature-addition steps, template-renaming steps,
  and a review checklist.
- `test`: baseline tests for app boot, shared widgets, and the template
  feature's domain/controller behavior.
- `Makefile`: local shortcuts for generation, formatting, analysis, tests, and
  the full baseline check.

## Reference Flow

The template feature demonstrates the default feature data path:

```text
Repository -> Result<T, Failure> -> UseCase -> Controller -> AsyncValue<T> -> AsyncValueView<T> -> Widgets
```

Keep repositories behind use cases once a feature has a real data boundary.
Controllers should expose user intent methods and translate use case results
into `AsyncValue<T>`. Pages should render full-screen async state through
`AsyncValueView<T>` instead of hand-rolling loading/error/data branches.

## Start A New App

Use this repository as the source baseline, then generate only the platform
folders the app needs:

```sh
flutter create . --platforms=android,ios,web,macos,windows,linux
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
```

Remove any platform from the `--platforms` list when it is not needed.

Then follow `docs/RENAMING_TEMPLATE.md` to rename package metadata, brand
tokens, strings, and the starter feature.

## Guardrails

- AI coding agents: start at `CLAUDE.md`.
- Read `docs/ARCHITECTURE.md` before changing structure, state, routing,
  errors, logging, localization, or test shape.
- Follow `docs/ADDING_FEATURE.md` when adding a new feature.
- Follow `docs/RENAMING_TEMPLATE.md` when creating a real app from the kit.
- Use `docs/REVIEW_CHECKLIST.md` before opening a PR.
- Keep feature-specific widgets inside their feature until they are reused by
  more than one feature.
- Keep `core/` app-wide and stable. Keep `shared/` UI-only and reusable.
- No `Widget _buildX()` methods, no private widget classes inside page files,
  no private helpers in `presentation/`. If it's worth naming, it's worth a
  file. If it isn't worth a file, inline it.

## Baseline Commands

Run the full local baseline before handing off a change:

```sh
make check
```

Or run the same steps manually:

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```
