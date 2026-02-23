# PadreIDE Refactor for Dummies

A practical, step-by-step plan to modernize PadreIDE for:
- **Modern Perl 5 (5.40+)**
- **Raku-first UX for new projects**
- **Cross-platform stability (Linux/Windows/macOS)**

This guide is intentionally action-oriented: what to touch first, what to keep, and what to avoid breaking.

---

## 0) What success looks like

By the end of this refactor track:
1. Users can create and work on **Raku projects** naturally in the UI.
2. Perl 5 workflows still work exactly as expected.
3. The IDE remains cross-platform with no platform-specific regressions.
4. Dependency/toolkit updates are safe and incremental.

---

## 1) Ground rules before touching code

1. **Do not rename internal MIME key yet** (`application/x-perl6`).
   - Rename display labels first, keep internal compatibility.
2. **Change UI strings first, behavior second.**
3. **Add tests before risky refactors** (or at the same time).
4. **Keep cross-platform checks in every phase** (Linux + Windows minimum; macOS when available).

---

## 2) Source-code touch order (exactly where to start)

Start in this order to minimize breakage.

## Step 1 — UI labels and menu wording (lowest risk)

### Touch first
- `lib/Padre/Wx/FBP/Preferences.pm`
- `lib/Padre/Wx/ActionLibrary.pm`
- `lib/Padre/Wx/Main.pm`
- `share/templates/perl6/script_p6.tt`
- `share/locale/messages.pot`
- `t/win32/002-menu.t` (and any string-based UI tests)

### Do
- Replace primary user-facing “Perl 6” with **Raku**.
- Use transitional wording where helpful: **Raku (Perl 6)**.
- Keep behavior identical; this step is mostly text/UX.

### Don’t
- Don’t change MIME identifiers yet.
- Don’t refactor parser logic in this step.

---

## Step 2 — Raku project creation and file experience

### Touch next
- `lib/Padre/Wx/Main.pm` (new-document/project entry points)
- `lib/Padre/Wx/ActionLibrary.pm` (menu/action descriptions)
- `share/templates/perl6/script_p6.tt` (starter template quality)
- `lib/Padre/MIME.pm` (detection/display behavior, compatibility-safe)

### Do
- Ensure “New Raku Project/Script” flow is obvious in menus.
- Improve default Raku template headers/comments for modern usage.
- Keep extension support (`.p6`, `.p6l`, `.p6m`, `.pl6`, `.pm6`) working.

### Don’t
- Don’t remove old extension recognition.
- Don’t break mixed Perl5/Raku detection in shared extensions.

---

## Step 3 — Syntax/highlighting/tooling pass

### Touch after UI/project flow is stable
- `lib/Padre/Wx/Scintilla.pm`
- `lib/Padre/MIME.pm`
- `lib/Padre/Document.pm` and Perl-related document logic where needed
- tests under `t/perl/` and language detection tests

### Do
- Audit keyword lists and lexer config for current Raku usage.
- Keep Perl 5 highlighting behavior untouched unless explicitly fixing bugs.
- Add regression tests for ambiguous files and shebang/content detection.

### Don’t
- Don’t do a giant lexer rewrite in one PR.
- Don’t merge UI rename + deep lexer changes without test coverage.

---

## Step 4 — Toolkit/dependency modernization (controlled)

### Primary dependency file
- `Makefile.PL`

### Strategy
1. **Classify dependencies** into:
   - runtime-critical
   - test/dev-only
   - optional/integration-specific
2. **Upgrade dev/test ergonomics first**, runtime floor later.
3. **Validate “declared but no direct hit” deps** before removal.

### Declared-but-no-direct-hit candidates to validate before pruning
- `File::Copy::Recursive`
- `HTML::Entities`
- `HTML::Parser`
- `IO::String`
- `POD2::Base`
- `Pod::POM`
- `Term::ReadLine`
- `Test::Warn`

These may still be required via dynamic loading, transitive paths, or optional features.

---

## 3) Third-party libraries: what to keep

## Keep (core for current architecture)
- UI/toolkit:
  - `Wx`
  - `Wx::Scintilla`
  - `Wx::Perl::ProcessStream`
  - `Alien::wxWidgets` (configure-time)
- Perl editing stack:
  - `PPI`
  - `PPIx::EditorTools`
  - `PPIx::Regexp`
  - `Parse::ErrorString::Perl`
- Data/runtime:
  - `DBI`
  - `DBD::SQLite`
  - `ORLite`
  - `ORLite::Migrate`
  - `JSON::XS`
  - `YAML::Tiny`

## Keep for test/developer quality
- `Test::More`
- `Test::Exception`
- `Test::NoWarnings`
- `Test::Warn` (until proven unnecessary)

## Don’t remove quickly
- Anything used in plugin flows, dynamic `require`, platform-specific branches, or release scripts.

---

## 4) Cross-platform safety checklist (every phase)

For each phase/PR:
1. Run core tests on Linux.
2. Run Win32-sensitive tests (`t/win32/*`) when environment allows.
3. Confirm no path/encoding regressions for file open/save flows.
4. Confirm external tool invocation works on Windows and Unix shells.

### Platform hot spots to watch
- Path handling and globs (`File::Spec`, win32 branches).
- Process spawning and shell behavior.
- UI widget behavior differences in Wx across platforms.

---

## 5) “Refactor for dummies” implementation sequence

If you are new to this codebase, do these mini-PRs in order:

1. **PR-1: wording only**
   - Update UI strings + template text + matching tests.
2. **PR-2: Raku project UX**
   - Improve actions/templates for creating Raku files/projects.
3. **PR-3: detection/highlighting quality**
   - Add tests, then tune MIME/Scintilla behavior.
4. **PR-4: dependency/toolkit cleanup**
   - Validate and prune only proven-unused deps; document dev profile.
5. **PR-5: docs + migration note**
   - Explain naming migration and plugin compatibility policy.

Small PRs are easier to review, revert, and keep cross-platform stable.

---

## 6) Modern language + ecosystem direction (important)

PadreIDE should actively support modern developer expectations:

- **Raku-first onboarding**
  - New project/file flows should explicitly mention Raku.
  - Templates should guide modern Raku style.

- **Perl ecosystem exploration from IDE**
  - Improve CPAN discovery/navigation surfaces where possible.
  - Keep module help/search flows healthy and visible.
  - Ensure project scaffolding supports both Perl 5 and Raku journeys.

- **Extension ecosystem readiness**
  - Preserve broad extension detection while modernizing labels.
  - Keep compatibility for old projects; optimize UX for new ones.

---

## 7) Definition of Done (practical)

Done means all of these are true:
1. Core UI uses Raku terminology for user-facing actions.
2. Perl 5 editing/run/debug flows remain stable.
3. Raku file/project creation is straightforward and discoverable.
4. Cross-platform checks pass for touched areas.
5. Dependency changes are evidence-based (not guess-based).
6. Migration notes exist for plugin/integration maintainers.
