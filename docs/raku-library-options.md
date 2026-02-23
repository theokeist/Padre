# Raku Library Options in Padre (Current State + Next Choices)

This document is a practical guide for deciding how far we should go with Raku-specific libraries.

Goal: keep **Perl 5 + Raku** healthy in one IDE, while avoiding risky rewrites.

---

## 1) What Padre uses today for Raku (current stack)

Padre currently supports Raku mostly through existing core components, not a heavy dedicated Raku library stack.

### 1.1 File type and detection
- MIME key: `application/x-perl6` (internal compatibility key).
- Extension mapping includes modern `.raku`.
- Content/shebang detection handles `raku` interpreter markers.

Source:
- `lib/Padre/MIME.pm`

### 1.2 Run/build command wiring
- Runtime selection is now language-aware in `Padre::Document::Perl`:
  - Perl files use `run_perl_cmd`.
  - Raku files use `run_raku_cmd`.
- Separate defaults exist for interpreter args and script args for Raku.

Source:
- `lib/Padre/Document/Perl.pm`
- `lib/Padre/Config.pm`
- `lib/Padre/Wx/FBP/Preferences.pm`

### 1.3 Editor/highlighting side
- Raku is still handled via the existing `Wx::Scintilla`/lexer integration path.
- No new parser subsystem was introduced (intentionally low-risk).

Source:
- `lib/Padre/Wx/Scintilla.pm`

---

## 2) What this means: current library strategy

Today’s strategy is:
1. **Keep core editor libraries stable** (`Wx`, `Wx::Scintilla`).
2. **Use process-level runtime integration** for Raku (`raku`/`rakudo` executable), instead of embedding a new language engine.
3. **Expose configuration to users** so they can point Padre to their preferred Perl/Raku executables.

This is good for cross-platform safety and minimizes regressions.

---

## 3) Options for Raku libraries (from safest to deepest)

## Option A (recommended now): Keep current approach, improve UX/tests
- Keep using current runtime + MIME + Scintilla structure.
- Add more Raku-focused tests around run command construction and settings persistence.
- Improve docs/tooltips around choosing Raku executable and args.

When to choose:
- You want reliable progress now.
- You do not want to destabilize highlighting or plugin compatibility.

## Option B: Add optional Raku tooling via plugin repositories
- Implement advanced Raku features in `Padre-Plugin-*` first.
- Examples:
  - Raku project scaffolds/templates,
  - formatter/lint command wrappers,
  - ecosystem shortcuts (zef, docs lookup, etc.).

When to choose:
- You want faster Raku iteration without risking core.

## Option C: Add core-integrated Raku analysis libraries
- Introduce a dedicated Raku parser/introspection dependency in core.
- Wire it into syntax checks, symbol extraction, and navigation.

When to choose:
- Only after Option A/B are stable and justified with measurable gains.

Risks:
- Higher maintenance burden,
- more cross-platform failure modes,
- plugin/API impact.

---

## 4) Step-by-step recommendation (practical path)

1. **Stabilize settings and run/build behavior**
   - Verify `run_raku_cmd`, `run_raku_interpreter_args_default`, and `run_raku_script_args_default` on Linux/macOS/Windows.
2. **Harden tests**
   - Add/expand tests for language-aware interpreter and args selection.
3. **Plugin-first advanced features**
   - Prototype Raku tooling in plugin repos before core integration.
4. **Only then evaluate new core libraries**
   - Adopt only with explicit performance/UX win and migration plan.

---

## 5) Raku/Rakudo settings lore (recommended examples)

Use these settings to support both common Raku binary names across platforms:

- **Raku Executable (raku or rakudo):**
  - preferred: absolute path to `raku` (or `rakudo` if that is what the system provides),
  - fallback behavior: if field is empty, Padre tries `raku` first, then `rakudo`.
- **Raku Interpreter Arguments (default):** flags passed before the script path.
- **Raku Script Arguments (default):** arguments passed after the script path.

Practical examples:
- Linux/macOS with PATH configured:
  - Executable: *(empty)*
  - Interpreter args: `-Ilib`
  - Script args: `--verbose`
- Windows with explicit install path:
  - Executable: `C:\Rakudo\bin\raku.exe`
  - Interpreter args: `-Ilib`
  - Script args: `--profile`

This keeps old and new environments working while guiding users toward modern `raku` naming.

---

## 6) Keep vs add decision checklist

Before adding any new Raku library dependency to core, confirm all are true:
- Clear feature gap cannot be solved by current runtime integration.
- Cross-platform behavior is proven.
- Maintenance owner exists.
- Plugin-first prototype already validated usefulness.
- Tests and rollback plan are ready.

If any are missing, keep current stack and continue incrementally.
