# PadreIDE Modernization TODO (Step by Step)

A practical checklist for tracking modernization work across:
- **Perl 5 path**
- **Raku path**
- **Shared editor/GUI/dependency work**

Use this as the execution board for contributors.

---

## Status Legend
- [ ] **To do**
- [~] **In doing**
- [x] **Done**

---

## 1) In doing now (current focus)

### 1.1 Documentation and planning
- [~] Maintain standalone modernization docs:
  - `docs/modernization-playbook.md`
  - `docs/modernization-libraries-reference.md`
- [~] Keep library rationale updated (core Perl libs, internal modules, plugin contracts).
- [~] Keep migration guidance clear for plugin repository maintainers.

### 1.2 Raku terminology migration (UI layer)
- [~] Replace primary user-facing “Perl 6” wording with **Raku** in UI text.
- [~] Keep compatibility wording where needed (`Raku (Perl 6)`) during transition.
- [~] Track UI text surfaces still requiring updates (menus, preferences, templates, locale source strings).

### 1.3 Compatibility safeguards
- [~] Keep internal key compatibility (e.g. MIME behavior) stable while UI language is modernized.
- [~] Keep plugin API behavior stable unless deprecation path is published.

---

## 2) Step-by-step TODO (execution order)

## Step 1 — Low-risk UI wording updates

### Perl 5 + Raku shared
- [ ] Update labels in:
  - `lib/Padre/Wx/FBP/Preferences.pm`
  - `lib/Padre/Wx/ActionLibrary.pm`
  - `lib/Padre/Wx/Main.pm`
- [ ] Update starter template text:
  - `share/templates/perl6/script_p6.tt`
- [ ] Update translation source:
  - `share/locale/messages.pot`
- [ ] Update text-coupled tests:
  - `t/win32/002-menu.t` and other affected tests

Exit check:
- [ ] Core UI shows modern naming consistently.
- [ ] No functional behavior change introduced.

---

## Step 2 — Raku project/file creation improvements

### Raku
- [ ] Ensure “new Raku script/project” flow is obvious in menu/action paths.
- [ ] Improve default Raku template quality (headers/comments/newcomer cues).
- [ ] Verify extension handling remains complete (`.p6`, `.p6l`, `.p6m`, `.pl6`, `.pm6`).

### Perl 5
- [ ] Verify Perl 5 starter/project flows remain unchanged.
- [ ] Verify mixed-language project open behavior remains stable.

Exit check:
- [ ] New Raku workflow is discoverable.
- [ ] Perl 5 workflow unchanged.

---

## Step 3 — Detection and highlighting hardening

### Shared language-engine work
- [ ] Add/expand tests for Perl 5 vs Raku detection parity.
- [ ] Improve ambiguous-file handling (shebang/content-based checks).
- [ ] Tune lexer/keyword behavior incrementally in:
  - `lib/Padre/MIME.pm`
  - `lib/Padre/Wx/Scintilla.pm`
  - related document flow in `lib/Padre/Document.pm`

### Guardrails
- [ ] Avoid one-shot giant lexer rewrite.
- [ ] Keep each behavior change in small test-backed PRs.

Exit check:
- [ ] Detection/highlighting regressions covered by tests.
- [ ] Perl 5 and Raku both pass expected behavior checks.

---

## Step 4 — Dependency and toolkit modernization

### Inventory and classification
- [ ] Review `Makefile.PL` dependency groups:
  - runtime-critical
  - dev/test only
  - optional/indirect/plugin-driven

### Keep/validate/prune flow
- [ ] Keep core architecture dependencies identified in:
  - `docs/modernization-libraries-reference.md`
- [ ] Validate “no direct hit” dependencies before any removal.
- [ ] Only prune dependencies with evidence (test + runtime verification).

### Dev ergonomics
- [ ] Improve contributor setup flow for modern dev environment.
- [ ] Prefer upgrading dev/test quality gates first.

Exit check:
- [ ] Dependency changes are evidence-based.
- [ ] No plugin/runtime regressions introduced.

---

## Step 5 — Plugin ecosystem modernization path

### Padre-Plugin repositories
- [ ] Use plugin repos for fast iteration on experimental Raku features.
- [ ] Prototype non-core workflows in plugins first (wizards/templates/tool integrations).
- [ ] Use plugins as compatibility canaries before core changes.

### Contract stability
- [ ] Keep plugin API stable.
- [ ] If change is required, publish migration note + compatibility window.

Exit check:
- [ ] Plugin compatibility preserved.
- [ ] Migration path clearly documented.

---

## Step 6 — Cross-platform validation in each phase

### Linux / Windows / macOS
- [ ] Validate open/edit/save flows.
- [ ] Validate menu and action behavior.
- [ ] Validate process/tool invocation behavior.
- [ ] Validate path/encoding edge cases.

Exit check:
- [ ] No platform-specific regression in touched areas.

---

## 3) Definition of done (project-level)

### Perl 5
- [ ] Existing Perl 5 workflows remain stable end-to-end.
- [ ] No regression in syntax/detection/basic tooling behavior.

### Raku
- [ ] Raku is primary user-facing naming in core UI.
- [ ] New Raku project/file flows are easy to find and usable.
- [ ] Raku-related detection/highlighting behavior is test-backed.

### Platform + ecosystem
- [ ] Cross-platform checks pass for modified areas.
- [ ] Plugin/integration migration notes are published.
- [ ] Dependency changes are documented with rationale.
