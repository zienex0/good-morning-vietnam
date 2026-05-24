# Agent Instructions

This file is the entrypoint for AI coding agents (Claude Code, Codex, Cursor,
Copilot) working in this repository. Read it first. Then follow
`docs/ARCHITECTURE.md`, `docs/ADDING_FEATURE.md`, and `docs/REVIEW_CHECKLIST.md`.

The working reference for a single feature is `lib/features/template/`. For a
real domain split into small per-aggregate features with per-concern providers,
see `lib/features/trips`, `lib/features/accounts`, and `lib/features/transactions`
(the trip dashboard in `features/trips/presentation` shows a cross-cutting screen
that only consumes other features' providers). Copy their shape.

## The Two Rules You Will Most Often Break

### 1. No private helpers in page files

**No private helpers in page files.** No `_buildHeader()` methods returning
`Widget`. No private `_SectionCard` widget classes hiding inside a page file.
No private `_formatX` / `_iconFor` / `_sortBy` functions tucked into
`presentation/`.

If it's worth naming, it's worth a file. If it isn't worth a file, inline it.

If you find yourself typing `Widget _build`, stop. That is the smell.

### 2. Providers live in `application/`; use cases hold the logic

Split a domain into small features by aggregate — `trips`, `accounts`,
`transactions` — each owning its model (`domain/`), repository (`data/`), and
providers (`application/`). A feature owns its model; cross-feature imports are
fine when a feature genuinely needs another's data (e.g. `accounts` reads a
`Trip`).

**Providers live only in `application/`**, split into small per-concern files —
`trips_provider.dart`, `active_trip_provider.dart`, `trip_accounts_provider.dart`,
`trip_account_form_provider.dart`, etc. Never declare a provider in `data/` or
`domain/`. Each provider either exposes repository data (reads, over `watch*`
streams) or derives a value through a use case; writes go through one notifier
per aggregate. There is no manual provider invalidation — streams fan writes out.

**A page only consumes providers; it never invents its own.** A cross-cutting
screen (e.g. the trip dashboard) watches the providers other features already
expose and composes them — it does not create dashboard-specific providers or
"summary" aggregation classes.

**Data manipulation lives in use cases** — plain classes under
`application/use_cases/` that validate, orchestrate multiple repositories, or
derive calculations. A use case is a plain class; never wrap one in its own
provider, and never create a use case that only forwards a single repository
call.

## Decision Flow Before Writing Anything Private

Before writing `_anything` inside a page file, answer in order:

1. **String for display?** → `presentation/<feature>_formatters.dart`.
2. **Enum → icon / color / label?** → `presentation/<feature>_mappers.dart`.
3. **Filtering / sorting / math on domain data?** → a method on the domain
   model, or a use case when it spans entities or needs a repository.
4. **A chunk of UI bigger than ~15 lines, or used twice?** → a public widget
   in `presentation/widgets/<name>.dart`.
5. **Used by a second feature?** → move to `lib/shared/widgets/`.
6. **None of the above and under ~15 lines?** → inline it in `build`. Do not
   wrap it in `_buildX()` or a private widget class just to "tidy up".

## Stop And Ask The User Before

- Adding a new package to `pubspec.yaml`.
- Removing or downgrading a dependency.
- Adding a new folder under `lib/core/` or a new top-level folder under `lib/`.
- Changing an existing public route path in `AppRoutes`.
- Introducing a second state-management library alongside Riverpod.
- Generating files outside the feature you were asked to touch.
- Disabling an analyzer rule in `analysis_options.yaml`.

## Baseline Commands

Run before handing off a change:

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format .
flutter analyze
flutter test
```

If any step fails, fix the cause. Do not skip steps, do not pass `--no-verify`,
do not silence lints to make the diff pass.

## Where To Look

- `docs/ARCHITECTURE.md` — folder shape, dependency direction, do/don't examples.
- `docs/ADDING_FEATURE.md` — checklist for adding a new feature.
- `docs/REVIEW_CHECKLIST.md` — what to verify before opening a PR.
- `lib/features/template/` — working reference feature.
