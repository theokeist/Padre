# Dependency installation (pre-install)

To install dependencies before running `Makefile.PL`, use the new `cpanfile`.

## Standard flow

```bash
cpanm --installdeps .
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
