# PadreIDE Wx Architecture and Localization Guide

This guide explains how the Wx GUI is structured, where localization is handled, how the menu bar is assembled, and how GUI pieces connect at runtime.

---

## 1) Wx structure: where to look first

`lib/Padre/Wx/` is organized by responsibility:

- **Application and main frame**
  - `lib/Padre/Wx/App.pm` — Wx application wrapper.
  - `lib/Padre/Wx/Main.pm` — main IDE window (`Wx::Frame`), startup wiring, menu/toolbar/notebook/panels.

- **Menu system**
  - `lib/Padre/Wx/Menubar.pm` — builds top-level menu bar and controls dynamic menu insertion/removal.
  - `lib/Padre/Wx/Menu.pm` — base menu behavior (`add_menu_action`, accelerator/hotkey registration).
  - `lib/Padre/Wx/Menu/*.pm` — concrete menus (`File`, `Edit`, `Search`, `View`, `Perl`, `Run`, `Tools`, `Window`, `Help`, etc.).

- **Actions and commands**
  - `lib/Padre/Wx/ActionLibrary.pm` — central registry of named actions and handlers used by menu and toolbar.
  - `lib/Padre/Wx/Action.pm` — action object abstraction.

- **Editor integration**
  - `lib/Padre/Wx/Editor.pm` — editor widget behavior.
  - `lib/Padre/Wx/Scintilla.pm` — lexer/mime mapping and language keyword integration.
  - `lib/Padre/Wx/Syntax.pm` — syntax annotation behavior.

- **Dialogs, panels, and generated forms**
  - `lib/Padre/Wx/Dialog/*.pm` — dialog logic.
  - `lib/Padre/Wx/Panel/*.pm` — side/bottom panels.
  - `lib/Padre/Wx/FBP/*.pm` — generated form classes (treat as generated artifacts).

---

## 2) How things connect at runtime

## 2.1 Main frame boot sequence

The high-level runtime wiring happens in `Padre::Wx::Main->new`:

1. Build frame and apply config/layout defaults.
2. Initialize locale object early (before heavy UI work).
3. Initialize action system via `Padre::Wx::ActionLibrary->init($self)`.
4. Build menubar via `Padre::Wx::Menubar->new($self)` and attach with `SetMenuBar`.
5. Continue with notebook/panels/output/status and plugin interactions.

## 2.2 Action -> menu -> event flow

1. Actions are declared centrally in `ActionLibrary` (name, label, event callback, optional toolbar metadata).
2. Menu classes call `add_menu_action(...)` from `Padre::Wx::Menu`.
3. `add_menu_action` binds Wx menu events to the action callback.
4. Result: one action definition can drive both menu behavior and toolbar behavior.

## 2.3 Plugin interaction path

- Plugin lifecycle and loading are in `lib/Padre/PluginManager.pm`.
- Plugins can contribute menu entries using `menu_plugins_simple` / `menu_plugins` APIs from `lib/Padre/Plugin.pm`.
- Main frame triggers plugin events at key points (`editor_changed`, relocaling, etc.).

---

## 3) Menu bar composition: what it consists of

`Padre::Wx::Menubar` assembles top-level menus.

### Always-present core menus
- File
- Edit
- Search
- View
- Run
- Tools/Plugins
- Window
- Help

### Context-dependent menus
- **Perl** and **Refactor** are inserted when current document/project is Perl-related.
- **Debug** is conditionally included when debugger feature is enabled.

### Refresh behavior
- Menubar refresh evaluates current context and adds/removes context-sensitive menus.
- Individual menu classes also run `refresh(...)` to enable/disable specific items.

---

## 4) Where localization lives

Localization is split between source markers, runtime translation calls, and catalog files.

## 4.1 Translation markers vs runtime translation

- `_T('...')` from `Padre::Locale::T` marks strings for extraction tools.
- `Wx::gettext(...)` is used for runtime translation.

Important: `_T` is intentionally a pass-through marker function, not a runtime translator.

## 4.2 Language metadata and locale selection

- `lib/Padre/Locale.pm` contains language metadata, locale mapping, and fallback logic.
- `Padre::Wx::Main` bootstraps locale object during startup.

## 4.3 Catalog files and where to edit

- Source catalog template: `share/locale/messages.pot`.
- Translations: `share/locale/*.po`.
- Changing user-facing strings typically requires updating source strings and translation workflow.

---

## 5) Where to edit for common modernization tasks

- **Rename UI terminology (Perl 6 -> Raku)**:
  - `lib/Padre/Wx/ActionLibrary.pm`
  - `lib/Padre/Wx/FBP/Preferences.pm`
  - `lib/Padre/Wx/Main.pm`
  - `share/templates/perl6/script_p6.tt`
  - `share/locale/messages.pot`

- **Adjust menu behavior**:
  - `lib/Padre/Wx/Menubar.pm`
  - `lib/Padre/Wx/Menu/*.pm`
  - `lib/Padre/Wx/Menu.pm`

- **Language detection/highlighting**:
  - `lib/Padre/MIME.pm`
  - `lib/Padre/Wx/Scintilla.pm`
  - `lib/Padre/Document.pm`
