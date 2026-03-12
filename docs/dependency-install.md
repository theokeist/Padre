# Dependency installation (pre-install)

To install dependencies before running `Makefile.PL`, use the new `cpanfile`.

## Standard flow

```bash
cpanm --installdeps .
```

Or use the helper script (checks Module::Install and installs deps):

```bash
perl script/install-deps.pl
```

## Include configure and test dependencies

```bash
cpanm --with-configure --with-test --installdeps .
```

## Why this exists

- avoids DWIM/bootstrap fetch behavior,
- gives a normal distribution install flow,
- lets CI/developers preload dependencies reliably.

Dependency source of truth remains `Makefile.PL`; this file mirrors it for installer tooling.


## Windows fallback when cpanm fetch fails

If `cpanm` cannot fetch distributions on Windows, use one (or more) of these:

```bash
cpan -T Module::Install
cpan -T --installdeps .
```

You can also force HTTPS mirror usage with cpanm:

```bash
cpanm --mirror https://cpan.metacpan.org --mirror-only Module::Install
cpanm --mirror https://cpan.metacpan.org --mirror-only --installdeps .
```

If corporate proxy/firewall is involved, configure `HTTP_PROXY`/`HTTPS_PROXY` before running installers.


## macOS Perl 5.42 build guide

See `docs/build-macos-perl542.md` for a full macOS-oriented build flow.
