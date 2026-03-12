# Feature Solutions: Local cpanm Search, Full Perl Docs, Markdown Preview

This note proposes practical solutions for three requested capabilities:
- local `cpanm` discovery/search from the editor,
- full Perl documentation access inside workflow,
- Markdown preview support.

---

## 1) Local cpanm search/info from editor (solution)

### Current state
- CPAN Explorer is MetaCPAN-driven and online-first.
- We now also have CPAN Explorer shortcut actions for selection-based lookups.

### Minimal solution (implemented path)
- Add an action that runs local:
  - `cpanm --info <module-or-distribution>`
- Behavior:
  - Use selected text if available.
  - Else prompt user.
  - Run command in Output panel.

### Files to touch
- `lib/Padre/Wx/ActionLibrary.pm` (action + prompt flow)
- `share/locale/messages.pot` (new UI strings)

---

## 2) Full Perl documentation availability (solution)

### Current state
- Padre already contains perldoc help search surfaces (`F1`, Help Search dialog).

### Practical reinforcement
- Add a direct action for local perldoc execution:
  - `perldoc <topic-or-module>`
- Behavior:
  - Uses editor selection first.
  - Falls back to prompt.
  - Sends output to Output panel for terminal-accurate docs.

### Files to touch
- `lib/Padre/Wx/ActionLibrary.pm`
- `share/locale/messages.pot`

---

## 3) Markdown support with preview (solution options)

## Option A (recommended first): external command preview pipeline
- Add a command entry that renders Markdown using a local tool if available
  (for example `pandoc` or `cmark`) into temporary HTML.
- Open rendered HTML in a built-in HTML viewer dialog/panel.
- Keep dependency optional to avoid breaking default installs.

## Option B: pure-Perl fallback renderer
- Optional dependency such as a lightweight Markdown module.
- Render to HTML in-process and show in Padre HTML window.

## Option C: full split editor/preview panel
- Create a dedicated Markdown preview panel with auto-refresh.
- Highest UX quality, but larger refactor and more testing surface.

### Suggested implementation order
1. Option A (fast delivery, minimal risk).
2. Add fallback to Option B.
3. Promote to Option C if maintainers want always-on preview UX.

### Cross-platform notes
- Prefer capability checks at runtime (`which pandoc`, `which cmark`).
- Keep Windows quoting/path handling explicit.
- Do not fail hard when renderer is missing; show guided message.

---

## 4) Acceptance checklist

- [ ] Local `cpanm --info` action works with selection and prompt.
- [ ] Local `perldoc` action works with selection and prompt.
- [ ] Both commands write to Output panel and return visible status.
- [ ] Markdown preview path has graceful fallback messaging.
- [ ] Strings are in `messages.pot` for translation workflow.
