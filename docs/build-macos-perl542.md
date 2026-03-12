# Build Padre on macOS with Perl 5.42

This is the recommended process for building Padre on macOS with a modern Perl toolchain.

## 1) Install system prerequisites

Using Homebrew:

```bash
brew update
brew install perl cpanminus pkg-config wxwidgets
```

Notes:
- Homebrew `perl` provides a modern Perl (target here: 5.42).
- `wxwidgets` is required for `Alien::wxWidgets` / `Wx` build flow.

## 2) Ensure Perl 5.42 is active

```bash
which perl
perl -v
```

Expected: Perl reports `v5.42.x` (or newer in the same major line).

If not, prepend Homebrew Perl to PATH (Apple Silicon default shown):

```bash
export PATH="/opt/homebrew/opt/perl/bin:$PATH"
export PATH="/opt/homebrew/opt/perl/sbin:$PATH"
```

(For Intel macs, use `/usr/local/opt/perl/...`.)

## 3) Install Padre dependencies before configure

From repository root:

```bash
perl script/install-deps.pl
```

Alternative explicit flow:

```bash
cpanm Module::Install
cpanm --with-configure --with-test --installdeps .
```

## 4) Configure and build

```bash
perl Makefile.PL
make
```

Optional test pass:

```bash
make test
```

## 5) Run Padre from repo

```bash
./dev
```

## 6) Common macOS troubleshooting

### Wx / Alien::wxWidgets issues
- Confirm `wxwidgets` is installed with Homebrew.
- Ensure the same Perl used for `cpanm` is used for `perl Makefile.PL`.

### Module::Install not found
Run:

```bash
cpanm Module::Install
```

Then re-run:

```bash
perl Makefile.PL
```

### Mixed Perl paths
If you see modules installed but not found, compare:

```bash
which perl
which cpanm
perl -V:sitearch
perl -V:sitelib
```

Use one consistent Perl toolchain for all steps.
