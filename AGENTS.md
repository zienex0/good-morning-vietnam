# Agent Instructions

This file is the entrypoint for AI coding agents (Codex, Codex, Cursor,
Copilot) working in this repository. Read it first. Then follow
`docs/ARCHITECTURE.md`, `docs/ADDING_FEATURE.md`, and `docs/REVIEW_CHECKLIST.md`.

The working reference for every pattern in this kit is
`lib/features/template/`. Copy its shape.

## The Two Rules You Will Most Often Break

### 1. No private helpers in page files

**No private helpers in page files.** No `_buildHeader()` methods returning
`Widget`. No private `_SectionCard` widget classes hiding inside a page file.
No private `_formatX` / `_iconFor` / `_sortBy` functions tucked into
`presentation/`.

If it's worth naming, it's worth a file. If it isn't worth a file, inline it.

If you find yourself typing `Widget _build`, stop. That is the smell.

### 2. Controllers never import repositories

**Controllers go through use cases. Always.** If you find yourself writing
`import '.../data/some_repository.dart'` inside `application/`, stop. Create a
use case instead. Business validation, pre-checks, and any logic that sits
above the repository boundary belong in the use case, not the controller.

## Decision Flow Before Writing Anything Private

Before writing `_anything` inside a page file, answer in order:

1. **String for display?** → `presentation/<feature>_formatters.dart`.
2. **Enum → icon / color / label?** → `presentation/<feature>_mappers.dart`.
3. **Filtering / sorting / math on domain data?** → a getter on state, or a
   method on the domain model.
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
