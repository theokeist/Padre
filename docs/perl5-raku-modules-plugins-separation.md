# PadreIDE: Perl 5 Built-ins vs Modules vs Plugins/Extensions

This guide separates concerns so contributors know where each behavior belongs.

---

## 1) Perl 5 built-ins / core language functions

These are language-level features (keywords/operators/built-ins) that belong to Perl itself.

In Padre, built-in and core function assistance is handled through Perl-help/indexing paths (for example in `lib/Padre/Document/Perl/Help.pm`, including perlfunc/perlop references).

### Practical rule
- If behavior is about **Perl language semantics** (syntax errors, built-in docs, keyword lookup), prefer language/document/help layers.

---

## 2) Modules (CPAN/core modules used by IDE internals)

These are implementation dependencies used to build IDE functionality.

Examples:
- UI toolkit: `Wx`, `Wx::Scintilla`
- Parsing/tooling: `PPI`, `PPIx::*`, `Parse::ErrorString::Perl`
- Persistence: `DBI`, `DBD::SQLite`, `ORLite`
- Serialization/config: `JSON::XS`, `YAML::Tiny`

Dependency declarations live in `Makefile.PL`. Detailed rationale and “keep/validate/evolve” policy is documented in:
- `docs/modernization-libraries-reference.md`

### Practical rule
- If behavior is about **how Padre implements features**, this belongs to module/dependency architecture, not plugin API.

---

## 3) Plugins/extensions (`Padre::Plugin::*` and plugin repos)

Plugins extend IDE behavior without forcing every feature into core.

Core plugin contract surfaces:
- `lib/Padre/Plugin.pm`
- `lib/Padre/PluginManager.pm`
- `lib/Padre/PluginHandle.pm`

Plugin repositories (`Padre-Plugin-*`) are ideal for:
- experimenting with Raku-focused workflows,
- shipping niche or domain-specific integrations,
- canary testing compatibility before core migrations.

### Practical rule
- If behavior is optional, experimental, or ecosystem-specific, prefer plugin-first implementation.

---

## 4) “Half function / half module” confusion: decision matrix

Use this decision matrix when unsure where a feature belongs:

1. **Is this Perl language semantics?**
   - Yes -> `Padre::Document::Perl::*`, syntax/help/detection layer.
2. **Is this core IDE infrastructure shared by all users?**
   - Yes -> core modules under `lib/Padre/*` or `lib/Padre/Wx/*`.
3. **Is this optional or fast-evolving?**
   - Yes -> plugin/extension route first.

---

## 5) Recommended separation during modernization

For Perl 5 + Raku modernization, keep boundaries clear:

- **Core IDE (must stay stable)**
  - menu framework, editor engine, config/DB, base language detection.
- **Language-specific enhancements**
  - detection and highlighting improvements in document/mime/scintilla layers.
- **Extension-first changes**
  - advanced Raku workflows, specialized integrations, experimental UX.

This separation reduces regressions and keeps cross-platform behavior predictable.
