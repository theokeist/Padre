# PadreIDE Modernization Playbook

A standalone guide for modernizing PadreIDE using current best practices across:
- **Language/runtime architecture (Perl 5.40+, Raku support)**
- **Editor behavior and language tooling**
- **GUI/Wx cross-platform UX**

This document is implementation-oriented and can be used as a checklist for real refactor work.

---

## 1) Modernization Principles

## 1.1 Compatibility-first modernization
- Preserve existing user projects and plugins while modernizing UI and internals.
- Keep risky compatibility pivots behind staged migrations.
- Prefer additive transitions (aliases, shims, feature flags) over abrupt renames.

## 1.2 Small, reversible increments
- Ship small PRs with single concern scope.
- Separate UI text changes from parser/lexer behavior changes.
- Keep a rollback path for each migration step.

## 1.3 Cross-platform by default
- Treat Linux/Windows/macOS behavior as first-class.
- Validate path handling, process spawning, and encoding in each phase.
- Avoid shell assumptions that only work on one platform.

---

## 2) Current Architecture Hotspots (What to modernize first)

## 2.1 High-impact user-facing surfaces
- Preferences and language settings:
  - `lib/Padre/Wx/FBP/Preferences.pm`
- Menu/action text and command routing:
  - `lib/Padre/Wx/ActionLibrary.pm`
  - `lib/Padre/Wx/Main.pm`
- New-file templates and starter UX:
  - `share/templates/perl6/script_p6.tt`
- Translation source strings:
  - `share/locale/messages.pot`

## 2.2 Language detection and editing core
- MIME and extension detection:
  - `lib/Padre/MIME.pm`
- Scintilla lexer and keyword integration:
  - `lib/Padre/Wx/Scintilla.pm`
- Document model and language inference:
  - `lib/Padre/Document.pm`

## 2.3 Dependency and toolkit definitions
- Build-time and runtime dependency declarations:
  - `Makefile.PL`

---

## 3) Modern Practices for Language Layer

## 3.1 Perl 5 modernization approach
- Keep runtime constraints explicit and intentional.
- Raise development/test tooling quality first; raise runtime floor later only with evidence.
- Reduce legacy assumptions gradually (`use 5.008*` era code patterns) in touched modules.

## 3.2 Raku-first but backward-compatible naming
- Move user-facing labels to **Raku**.
- Use transitional labels where needed (e.g., `Raku (Perl 6)`) to reduce user confusion.
- Keep internal compatibility identifiers stable initially (e.g., existing MIME key strategy).

## 3.3 Detection quality standards
- Keep support for known extensions (`.p6`, `.p6l`, `.p6m`, `.pl6`, `.pm6`).
- Validate shebang/content-based detection behavior for mixed/ambiguous files.
- Add regression tests before heuristic changes.

---

## 4) Modern Practices for Editor Layer

## 4.1 Editor UX improvements
- Improve default template quality for new Raku files/projects.
- Ensure discoverable entry points for new-language workflows in menus and actions.
- Keep error/warning surfaces actionable (line mapping accuracy, readable diagnostics).

## 4.2 Syntax/highlighting strategy
- Treat lexer updates as incremental and test-backed.
- Avoid giant one-shot syntax rewrites.
- Separate keyword refresh from parser behavior changes.

## 4.3 Ecosystem exploration from editor
- Keep module/help/search pathways healthy and easy to discover.
- Make CPAN-oriented workflows practical from the IDE where currently supported.
- Ensure both Perl 5 and Raku journeys are represented in templates/actions/docs.

---

## 5) Modern Practices for GUI Layer (Wx)

## 5.1 UI consistency and accessibility
- Keep wording consistent across menu, preferences, dialogs, and status surfaces.
- Preserve keyboard paths and command discoverability while renaming labels.
- Avoid UI-only refactors that silently change behavior.

## 5.2 Generated UI artifacts discipline
- Confirm canonical source/edit workflow before broad FBP updates.
- Avoid mass generated-file churn in mixed behavior PRs.
- Keep generated and hand-written code updates reviewable.

## 5.3 GUI testability
- Add/maintain tests for text-coupled UI behavior where practical.
- Prefer intent-based tests (action behavior) plus focused label assertions.
- Keep platform-specific tests (`t/win32/*`) in the validation plan.

---

## 6) Libraries Reference (moved to standalone file)

All library-specific rationale, usage mapping, and keep/validate policy has been moved to:

- `docs/modernization-libraries-reference.md`

Use that file for dependency decisions and module-level compatibility planning.

---

## 7) Step-by-Step Execution Plan

## Phase A — UX language modernization (low risk)
1. Update user-facing labels to Raku terminology.
2. Refresh templates and translation source strings.
3. Update text-coupled tests.

Exit criteria:
- Core UI surfaces use Raku terminology consistently.
- No behavior regressions in file open/edit/run flows.

## Phase B — Editor/detection hardening (medium risk)
1. Add/expand tests for Perl 5 vs Raku detection parity.
2. Tune MIME and lexer behavior incrementally.
3. Validate ambiguous file handling.

Exit criteria:
- Detection/highlighting regressions are covered and passing.
- Perl 5 behavior remains stable.

## Phase C — Dependency/toolkit modernization (controlled risk)
1. Classify dependencies (runtime-critical vs dev/test vs optional).
2. Improve dev-tooling profile and contributor bootstrap.
3. Prune only proven-unused dependencies.

Exit criteria:
- Dependency updates are evidence-based and documented.
- Cross-platform validation remains green for touched areas.

## Phase D — Ecosystem and project flow polish
1. Improve new-project flows for Raku and Perl 5.
2. Strengthen IDE pathways for module/help/ecosystem exploration.
3. Publish migration notes for plugin authors.

Exit criteria:
- New-user onboarding is smooth for both language paths.
- Plugin compatibility expectations are documented.

---

## 8) Cross-Platform Validation Matrix

For every modernization PR, run:
- Linux core suite for touched areas.
- Windows-sensitive tests for menu/GUI behavior when available.
- Encoding/path/process sanity checks for open/save/run workflows.

Minimum checks:
1. Open/edit/save text and code files on each OS target.
2. Run language actions and external process invocation paths.
3. Confirm no path separator or shell quoting regressions.

---

## 9) Definition of Done

Modernization milestone is complete when all are true:
1. Raku is primary user-facing terminology in core UI paths.
2. Perl 5 workflows and legacy projects remain stable.
3. Raku project/file creation is discoverable and production-usable.
4. Editor language detection/highlighting changes are regression-tested.
5. Dependency changes are justified by usage evidence.
6. Cross-platform behavior is validated for touched components.
7. Migration guidance exists for plugin/integration maintainers.
