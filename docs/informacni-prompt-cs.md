# PadreIDE — Informační prompt (shrnutí projektu a provedených změn)

## O co jde v projektu

Padre je desktopové IDE/editor pro Perl postavené na wxWidgets (wxPerl).
Projekt historicky cílí na širokou kompatibilitu, ale současně se modernizuje směrem k:
- modernímu Perl 5 workflow,
- Raku-first uživatelskému značení,
- stabilnějšímu build/dependency procesu napříč platformami.

Architektura je primárně v `lib/Padre/*`:
- GUI vrstvy: `lib/Padre/Wx/*`,
- dokumenty/jazykové chování: `lib/Padre/Document*`,
- MIME/detekce typů souborů: `lib/Padre/MIME.pm`,
- konfigurace běhu a nastavení: `lib/Padre/Config.pm`.

---

## Co se provedlo (v této modernizační vlně)

### 1) Build a závislosti (méně DWIM, více standardní distro flow)
- `Makefile.PL` byl upraven na jasný požadavek `Module::Install >= 1.04`.
- Chybové hlášky nyní dávají explicitní instalační kroky (`cpanm`, fallback `cpan -T`).
- Přidán `cpanfile` pro předinstalaci závislostí (`cpanm --installdeps .`).
- Přidán helper skript `script/install-deps.pl` pro ověření/instalaci `Module::Install` + instalaci deps z `cpanfile`.
- Přidána dokumentace instalačních flow (včetně Windows fallbacku a macOS Perl 5.42 postupu).

### 2) Raku modernizace (UI + runtime)
- User-facing texty byly sjednoceny směrem k názvu **Raku** (místo „Perl 6“ v UI vrstvách).
- Přidána Raku-specific runtime konfigurace:
  - `run_raku_cmd`,
  - `run_raku_interpreter_args_default`,
  - `run_raku_script_args_default`.
- Preference UI rozšířeno o Raku executable/args položky.
- Runtime volba interpretru byla upravena tak, aby rozlišila Perl vs Raku podle MIME.

### 3) MIME/detekce a uživatelské workflow
- Zlepšena detekce Raku (`.raku`, shebang/pro obsahové heuristiky).
- Zachována interní kompatibilita tam, kde je potřeba (historické interní klíče).

### 4) CPAN/perldoc ergonomie v IDE
- Přidány akce pro:
  - hledání CPAN dle výběru,
  - lokální `cpanm --info` dle výběru/promptu,
  - lokální `perldoc` dle výběru/promptu.
- Cíl: rychlejší orientace v ekosystému přímo z editoru.

### 5) Win32 kompatibilitní opravy
- Ošetření `Win32::GetOSName()` proti undef (bez warningu v `uc`).
- Kompatibilnější čtení labelu z `Wx::MenuItem` přes fallback metody (dle dostupné Wx verze).

---

## Praktický prompt pro nového přispěvatele

> Cíl: Udržet Padre stabilní cross-platform editor pro Perl + Raku, modernizovat build/dependency flow a postupně zlepšovat UX bez rozbití kompatibility pluginů a starších workflow.
>
> Priorita při změnách:
> 1. nejdřív bezpečný build/install (cpanfile + jasné instrukce),
> 2. potom user-facing UX (Raku názvosloví, menu/akce),
> 3. potom runtime behavior (interpreter/args podle jazyka),
> 4. teprve pak hlubší refaktor jádra.
>
> Povinné zásady:
> - malé, reverzibilní kroky,
> - explicitní test/validace pro dotčenou oblast,
> - zachování cross-platform chování,
> - kompatibilita plugin API, pokud není výslovně migrační plán.

---

## Kde začít číst v repozitáři

- Build/deps: `Makefile.PL`, `cpanfile`, `script/install-deps.pl`
- GUI akce/menu: `lib/Padre/Wx/ActionLibrary.pm`, `lib/Padre/Wx/Menu.pm`
- Raku/Perl runtime: `lib/Padre/Document/Perl.pm`, `lib/Padre/Config.pm`, `lib/Padre/Wx/FBP/Preferences.pm`
- Detekce jazyků: `lib/Padre/MIME.pm`
- Přehledové docs: `docs/modernization-playbook.md`, `docs/dependency-install.md`, `docs/build-macos-perl542.md`
