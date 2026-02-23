# PadreIDE Modernization Libraries Reference

Standalone reference for library decisions during modernization.

This file contains all library-specific information that was moved out of
`docs/modernization-playbook.md`.

---

## 1) How to use this reference

Use this doc to decide whether a library should be:
- **kept** (core architectural dependency),
- **validated** (unclear/indirect usage),
- or **changed** (only with clear maintainability/security/portability gain).

---

## 2) Core/"normal" Perl libraries (standard building blocks)

These are common Perl/core-style modules used heavily across PadreIDE.

- `Carp`, `Scalar::Util`, `List::Util`
  - **Why used:** defensive coding, argument/type checks, utility operations.
  - **Where used:** `lib/Padre.pm`, `lib/Padre/PluginManager.pm`, `lib/Padre/Search.pm`, and many task/config classes.

- `File::Spec`, `File::Basename`, `File::Temp`, `Cwd`
  - **Why used:** cross-platform paths, temporary files, filesystem navigation.
  - **Where used:** `lib/Padre/Document.pm`, `lib/Padre/Task/*.pm`, `lib/Padre/Project/*.pm`, `lib/Padre/Startup.pm`.

- `Encode`, `Storable`, `Time::HiRes`
  - **Why used:** encoding safety, state serialization, timing and logging precision.
  - **Where used:** `lib/Padre/Search.pm`, `lib/Padre/Task.pm`, `lib/Padre/TaskHandle.pm`, `lib/Padre/Logger.pm`.

- `threads`, `threads::shared`
  - **Why used:** background task orchestration and synchronized shared state.
  - **Where used:** `lib/Padre/Wx.pm`, `lib/Padre/TaskQueue.pm`, `lib/Padre/TaskHandle.pm`, `lib/Padre/Logger.pm`.

---

## 3) Internal Padre libraries (keep stable while refactoring)

Internal modules are architecture contracts. Preserve boundaries and behavior during migration.

- `Padre::Wx::*`
  - **Role:** GUI shell, menus, dialogs, editor widgets, event wiring.
  - **Why keep stable:** high cross-platform regression risk if rewritten broadly.

- `Padre::Document::*`
  - **Role:** language-aware document behavior (syntax, quickfix, starter, outline).
  - **Why keep stable:** detection/highlighting and editor actions flow through this layer.

- `Padre::Task::*`, `Padre::TaskManager`, `Padre::TaskQueue`
  - **Role:** async/background execution and tooling integration.
  - **Why keep stable:** concurrency regressions are high impact.

- `Padre::DB::*`, `Padre::Config*`, `Padre::Plugin*`
  - **Role:** persistence, user/project config, extension loading contracts.
  - **Why keep stable:** directly affects user data, startup behavior, plugin compatibility.

---

## 4) Extension/plugin libraries and ecosystem contracts

Plugin-facing contract modules:
- `Padre::Plugin`
- `Padre::PluginManager`
- `Padre::PluginHandle`

Modernization rules for extension safety:
- preserve plugin API behavior unless deprecation path is documented,
- avoid abrupt internal key changes that break plugin assumptions,
- provide migration notes for terminology transitions (Perl 6 -> Raku).

---

## 5) What `Padre-Plugin-*` repositories are good for in this modernization

Plugin repositories are the safest place to move fast without destabilizing core IDE behavior.

### Why they matter now
- **Feature isolation:** new language/UX experiments (including Raku-oriented helpers) can be developed outside core release risk.
- **Faster iteration:** plugin release cadence can be faster than core IDE cadence.
- **Cross-platform risk control:** platform-specific integrations can be tested and evolved in plugin repos first.
- **Ecosystem growth:** plugins are how users explore workflows (CPAN helpers, project tools, editor extensions) without forcing all users to take every feature.

### Concrete modernization use-cases
- Add Raku project templates/wizards as plugin-first features before core adoption.
- Prototype advanced language intelligence in plugins, then upstream proven behavior.
- Keep niche integrations (VCS/toolchain/domain-specific helpers) in separate repos to reduce core complexity.
- Use plugin repos as compatibility canaries when changing core internals.

### Operational guidance
- Keep plugin API compatibility stable while modernizing internals.
- When API changes are unavoidable, publish migration notes and compatibility windows.
- Prioritize plugin smoke tests during each modernization phase.

---

## 6) Third-party libraries: why used and where

- `Wx`
  - **Why used:** main GUI toolkit abstraction (windows, dialogs, events, controls).
  - **Where used:** pervasive across UI modules, including `Padre::Wx::Editor` and `Padre::Wx::Syntax`.

- `Wx::Scintilla` / `Wx::Scintilla::Constant`
  - **Why used:** core editor component (syntax highlighting, margins, markers, annotations).
  - **Where used:** `lib/Padre/Wx/Editor.pm`, `lib/Padre/Wx/Syntax.pm`, `lib/Padre/Wx/Scintilla.pm`.

- `PPI`, `PPIx::EditorTools`, `PPIx::Regexp`
  - **Why used:** Perl-aware parsing/refactoring and regex tooling.
  - **Where used:** `lib/Padre/Task/IntroduceTemporaryVariable.pm`, `lib/Padre/Wx/Dialog/RegexEditor.pm`, Perl document classes.

- `Parse::ErrorString::Perl`
  - **Why used:** structured Perl diagnostics for IDE syntax/error surfaces.
  - **Where used:** `lib/Padre/Document/Perl/Syntax.pm`.

- `DBI`, `DBD::SQLite`, `ORLite`, `ORLite::Migrate`
  - **Why used:** local persistence for sessions/history/timeline and metadata.
  - **Where used:** `lib/Padre.pm` runtime imports and `lib/Padre/DB/*.pm`.

- `JSON::XS`
  - **Why used:** fast structured serialization for server/worker coordination.
  - **Where used:** `lib/Padre/ServerManager.pm`.

- `YAML::Tiny`
  - **Why used:** lightweight config and plugin metadata handling.
  - **Where used:** `lib/Padre/Plugin.pm`, `lib/Padre/Document/Perl.pm`.

- `Params::Util`
  - **Why used:** lightweight parameter/type validation across modules.
  - **Where used:** `lib/Padre/Wx/Action.pm`, `lib/Padre/Wx/Editor.pm`, `lib/Padre/Plugin.pm`, many others.

- `Class::XSAccessor`
  - **Why used:** efficient accessor generation for frequently instantiated objects.
  - **Where used:** `lib/Padre.pm`, `lib/Padre/Wx/Action.pm`, dialog/filter classes.

---

## 7) Keep / Validate / Evolve policy

## 7.1 Keep (core architecture dependencies)
- UI/toolkit: `Wx`, `Wx::Scintilla`, `Wx::Perl::ProcessStream`, `Alien::wxWidgets`
- Language/editing: `PPI`, `PPIx::EditorTools`, `PPIx::Regexp`, `Parse::ErrorString::Perl`
- Data/runtime: `DBI`, `DBD::SQLite`, `ORLite`, `ORLite::Migrate`, `JSON::XS`, `YAML::Tiny`

## 7.2 Keep for quality gates
- `Test::More`, `Test::Exception`, `Test::NoWarnings`, `Test::Warn` (until proven unnecessary)

## 7.3 Validate before pruning
If a declared dependency appears unused in static search, verify dynamic/plugin/transitive usage first.

Validation candidates previously identified:
- `File::Copy::Recursive`
- `HTML::Entities`
- `HTML::Parser`
- `IO::String`
- `POD2::Base`
- `Pod::POM`
- `Term::ReadLine`
- `Test::Warn`

---

## 8) Library change rule of thumb

- If a library has a clear architectural role and active call sites, **keep it**.
- If a library has no direct static hit, **validate runtime/dynamic usage first**.
- Replace dependencies only when there is a **concrete, measurable** win.

---

## 9) Raku-specific library options

For a focused decision guide on current Raku libraries and safe expansion paths, see:
- `docs/raku-library-options.md`
