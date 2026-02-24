# This cpanfile is a pre-install dependency manifest for Padre.
# It mirrors Makefile.PL so dependencies can be installed beforehand.
# Usage:
#   cpanm --installdeps .
#   cpanm --with-configure --with-test --installdeps .

on 'configure' => sub {
    requires 'ExtUtils::MakeMaker', '6.52';
    requires 'ExtUtils::Embed', '1.250601';
    requires 'Alien::wxWidgets', '0.62';
};

on 'runtime' => sub {
    requires 'perl', '5.011000';
    requires 'Algorithm::Diff', '1.19';
    requires 'App::cpanminus', '0.9923';
    requires 'B::Deparse', '0';
    requires 'Capture::Tiny', '0.06';
    requires 'CGI', '3.47';
    requires 'Class::Adapter', '1.05';
    requires 'Class::Inspector', '1.22';
    requires 'Class::XSAccessor', '1.13';
    requires 'Cwd', '3.2701';
    requires 'Data::Dumper', '2.101';
    requires 'DBD::SQLite', '1.35';
    requires 'DBI', '1.58';
    requires 'Debug::Client', '0.29';
    requires 'Devel::Dumpvar', '0.04';
    requires 'Devel::Refactor', '0.05';
    requires 'Encode', '2.26';
    requires 'ExtUtils::MakeMaker', '6.56';
    requires 'ExtUtils::Manifest', '1.56';
    requires 'File::Basename', '0';
    requires 'File::Glob', '0';
    requires 'File::Copy::Recursive', '0.37';
    requires 'File::Find::Rule', '0.30';
    requires 'File::Path', '2.08';
    requires 'File::ShareDir', '1.00';
    requires 'File::Spec', '3.2701';
    requires 'File::Spec::Functions', '3.2701';
    requires 'File::Temp', '0.20';
    requires 'File::Which', '1.08';
    requires 'File::pushd', '1.00';
    requires 'FindBin', '0';
    requires 'Getopt::Long', '0';
    requires 'HTML::Entities', '3.57';
    requires 'HTML::Parser', '3.58';
    requires 'IO::Socket', '1.30';
    requires 'IO::String', '1.08';
    requires 'IPC::Run', '0.83';
    requires 'IPC::Open2', '0';
    requires 'IPC::Open3', '0';
    requires 'JSON::XS', '2.29';
    requires 'List::Util', '1.18';
    requires 'Parse::Functions', '0.01';
    requires 'List::MoreUtils', '0.22';
    requires 'LWP', '5.815';
    requires 'LWP::UserAgent', '5.815';
    requires 'Module::Build', '0.3603';
    requires 'Module::CoreList', '2.22';
    requires 'Module::Manifest', '0.07';
    requires 'ORLite', '1.98';
    requires 'ORLite::Migrate', '1.10';
    requires 'Params::Util', '0.33';
    requires 'Parse::ErrorString::Perl', '0.18';
    requires 'Parse::ExuberantCTags', '1.00';
    requires 'Pod::Functions', '0';
    requires 'Pod::POM', '0.17';
    requires 'Pod::Simple', '3.07';
    requires 'Pod::Simple::XHTML', '3.04';
    requires 'Pod::Abstract', '0.16';
    requires 'Pod::Perldoc', '3.23';
    requires 'POD2::Base', '0.043';
    requires 'POSIX', '0';
    requires 'PPI', '1.218';
    requires 'PPIx::EditorTools', '0.18';
    requires 'PPIx::Regexp', '0.011';
    requires 'Probe::Perl', '0.01';
    requires 'Storable', '2.16';
    requires 'Sort::Versions', '1.5';
    requires 'Template::Tiny', '0.11';
    requires 'Term::ReadLine', '0';
    requires 'Text::Balanced', '2.01';
    requires 'Text::Diff', '1.41';
    requires 'Text::FindIndent', '0.10';
    requires 'Time::HiRes', '1.9718';
    requires 'Text::Patch', '1.8';
    requires 'threads', '1.71';
    requires 'threads::shared', '1.33';
    requires 'URI', '0';
    requires 'version', '0.80';
    requires 'Wx', '0.9916';
    requires 'Wx::Perl::ProcessStream', '0.32';
    requires 'Wx::Scintilla', '0.39';
    requires 'YAML::Tiny', '1.32';
    requires 'IO::Scalar', '2.110';

    # Platform-specific runtime dependencies
    on 'MSWin32' => sub {
        requires 'File::Glob::Windows', '0.1.3';
        requires 'Win32', '0.31';
        requires 'Win32::Shortcut', '0.07';
        requires 'Win32::TieRegistry', '0.26';
    };

    # Non-Windows helper from Makefile.PL (`if not win32`):
    #   requires 'Module::Starter', '1.60';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Warn', '0.24';
    requires 'Test::MockObject', '1.09';
    requires 'Test::Script', '1.07';
    requires 'Test::Exception', '0.27';
    requires 'Test::NoWarnings', '1.04';
};
