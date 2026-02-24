# PadreIDE Contributor Modernization Manual

A full-path manual for contributors: from environment setup, to reading architecture, to shipping progressively larger changes, up to deep refactor/replacement for modern Perl 5.40 and Raku support.

---

Contributor note: Theokeist (THEOKEIST) — github.com/theokeist.

## 1) Start here: development setup

## 1.1 Baseline prerequisites

- Perl and build tooling capable of building Padre dependencies.
- Wx stack available (or installable) for GUI work.
- Git checkout of this repository.

Primary dependency definition source:
- `Makefile.PL`

Primary orientation docs:
- `docs/modernization-playbook.md`
- `docs/modernization-libraries-reference.md`
- `docs/modernization-todo.md`
- `docs/wx-architecture-and-localization-guide.md`
- `docs/perl5-raku-modules-plugins-separation.md`

## 1.2 First local validation (before coding)

Run a minimum local sanity pass:
1. Configure/build dependencies from `Makefile.PL`.
2. Run selected tests for touched area first.
3. Run full/extended suites as change scope grows.

Rule: small change -> small tests, deep change -> broader tests.

---

## 2) Understand repository architecture before changing code

## 2.1 Core code zones

- `lib/Padre/`
  - core application behavior, configuration, tasks, plugin management.
- `lib/Padre/Wx/`
  - GUI, menus, dialogs, editor integration.
- `lib/Padre/Document/`
  - language/document handling.
- `share/`
  - templates, locale catalogs, static assets.
- `t/`
  - tests.

## 2.2 Critical entry points for modernization

- Main window + runtime wiring:
  - `lib/Padre/Wx/Main.pm`
- Action registry:
  - `lib/Padre/Wx/ActionLibrary.pm`
- Menu composition:
  - `lib/Padre/Wx/Menubar.pm`, `lib/Padre/Wx/Menu/*.pm`
- Language detection/highlighting:
  - `lib/Padre/MIME.pm`, `lib/Padre/Wx/Scintilla.pm`, `lib/Padre/Document.pm`
- Localization:
  - `lib/Padre/Locale.pm`, `lib/Padre/Locale/T.pm`, `share/locale/messages.pot`, `share/locale/*.po`
- Plugin contracts:
  - `lib/Padre/Plugin.pm`, `lib/Padre/PluginManager.pm`, `lib/Padre/PluginHandle.pm`

---

## 3) Understand how things connect

## 3.1 Runtime connection map (high-level)

1. `Padre::Wx::Main` boots frame, locale, actions, menubar.
2. `ActionLibrary` defines named actions.
3. Menu classes bind actions via `Padre::Wx::Menu` helper methods.
4. Editor and syntax stack apply MIME + Scintilla behavior.
5. Plugin manager loads plugins and contributes menu/actions/events.

## 3.2 Localization flow

- `_T(...)` marks strings for extraction.
- `Wx::gettext(...)` translates at runtime.
- `messages.pot` is source catalog; `*.po` are localized catalogs.

---

## 4) Clear work ladder: from minimal to deep changes

This is the recommended change ladder.

## Level A — Minimal/low-risk changes

Goal: modernize wording and contributor-facing clarity without behavior change.

Touch:
- UI text surfaces in `ActionLibrary`, preferences form, template text, translation source strings.

Checklist:
- Keep behavior unchanged.
- Update test expectations for changed strings.
- Keep commits small and focused.

## Level B — Small behavior improvements

Goal: improve Raku and Perl 5 user workflows without deep engine refactor.

Touch:
- menu/action discoverability for project/file creation,
- template defaults,
- lightweight UX flow improvements.

Checklist:
- Validate both Perl 5 and Raku paths.
- Keep plugin behavior stable.

## Level C — Medium engine changes

Goal: improve language detection and highlighting quality.

Touch:
- `lib/Padre/MIME.pm`
- `lib/Padre/Wx/Scintilla.pm`
- related document behavior in `lib/Padre/Document.pm`

Checklist:
- add tests first or in same PR,
- avoid giant one-shot lexer rewrite,
- confirm no Perl 5 regressions.

## Level D — Deep refactor / replacement

Goal: replace problematic internals safely.

Examples:
- replacing legacy logic paths in detection/highlighting,
- introducing new architecture boundaries in editor services,
- deprecating old internals with compatibility shims.

Checklist:
- decompose into migration phases,
- introduce compatibility layers/aliases first,
- publish migration notes for plugin maintainers,
- only remove old code after equivalent behavior is proven.

---

## 5) Perl 5.40 + Raku modernization strategy

## 5.1 Perl 5 path

- Preserve existing Perl 5 project/edit/run/debug behavior.
- Modernize internals incrementally where touched.
- Keep Perl help/syntax/functionality stable while upgrading implementation quality.

## 5.2 Raku path

- Make Raku first-class in UI naming and new-project/new-file flows.
- Preserve existing extension support and compatibility behavior.
- Improve onboarding templates and discoverability.

## 5.3 Shared path

- Keep cross-platform behavior stable.
- Keep plugin contracts stable unless deprecation plan exists.
- Use plugin repos for fast experimentation before core adoption.

---

## 6) Libraries and dependency decisions

Use `docs/modernization-libraries-reference.md` as source of truth.

Decision order:
1. Keep core architecture dependencies.
2. Validate uncertain dependencies with runtime/test evidence.
3. Replace/prune only with measurable wins (security, maintainability, portability, performance).

Never remove a dependency based on grep-only evidence.

---

## 7) When to use core vs modules vs plugins

Use this rule:

- Perl language semantics -> document/language layers (`Padre::Document::Perl::*`, syntax/help).
- Core shared IDE behavior -> core modules (`lib/Padre/*`, `lib/Padre/Wx/*`).
- Optional or experimental behavior -> plugin-first (`Padre::Plugin::*`, `Padre-Plugin-*` repos).

This keeps core stable and innovation fast.

---

## 8) Cross-platform development protocol

For each PR:
1. Validate Linux baseline.
2. Validate Windows-sensitive behavior where possible (`t/win32/*`, path/process checks).
3. Validate macOS behavior when environment is available.
4. Verify no path separator/encoding/shell-quoting regressions.

Cross-platform regressions block merge for medium/deep changes.

---

## 9) Refactor execution blueprint (end-to-end)

Phase 1: wording + localization + tests.
- low-risk, high-visibility wins.

Phase 2: Raku UX and project flow improvements.
- make new-user path strong.

Phase 3: detection/highlighting hardening.
- test-backed internal improvements.

Phase 4: dependency/toolchain modernization.
- evidence-based keep/validate/prune.

Phase 5: deep replacement/refactor where needed.
- compatibility layers first, removal later.

Phase 6: build and release discipline.
- run final suite, document migration notes, tag/release per process.

---

## 10) How to contribute safely (every aspect)

- Read architecture docs before first PR.
- Choose the smallest level (A/B/C/D) that solves your issue.
- Keep PR scope singular (text vs behavior vs internals).
- Add/adjust tests with behavior changes.
- Update docs when responsibilities or flows shift.
- Keep plugin ecosystem informed when contracts may be impacted.

If in doubt: implement plugin-first, gather feedback, then upstream to core.

---

## 11) Build the IDE forward (long-term view)

To modernize Padre for current Perl and Raku reality:
- keep core stable,
- move fast in plugins,
- raise quality gates,
- modernize language UX and semantics in phases,
- and only delete old code after replacement is proven in production-like usage.

That approach gives maintainers a practical path to evolve the IDE without breaking existing users.
