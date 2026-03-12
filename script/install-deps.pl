#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;
use Config ();

my $REQUIRED_MI    = '1.04';
my $RECOMMENDED_MI = '1.08';
my $USE_RECOMMENDED = grep { $_ eq '--recommended' } @ARGV;

sub _has_cmd {
	my ($cmd) = @_;
	my $sep = quotemeta( $Config::Config{path_sep} || ':' );
	for my $dir ( split /$sep/, ($ENV{PATH} // '') ) {
		my $path = "$dir/$cmd";
		return $path if -x $path;
		if ( $^O eq 'MSWin32' ) {
			for my $ext (qw(.exe .bat .cmd)) {
				return "$path$ext" if -x "$path$ext";
			}
		}
	}
	return;
}

sub _version_ok {
	my ($want) = @_;
	my $loaded = eval { require Module::Install; 1 };
	return 0 unless $loaded;
	return 0 unless defined $Module::Install::VERSION;
	return $Module::Install::VERSION >= $want ? 1 : 0;
}

my $target = $USE_RECOMMENDED ? $RECOMMENDED_MI : $REQUIRED_MI;

if ( _version_ok($target) ) {
	print "Module::Install $Module::Install::VERSION already satisfies >= $target\n";
} else {
	print "Installing/Updating Module::Install to >= $target ...\n";
	my $ok = 0;
	if ( _has_cmd('cpanm') ) {
		$ok = system( 'cpanm', 'Module::Install' ) == 0;
	}
	if ( !$ok and _has_cmd('cpan') ) {
		$ok = system( 'cpan', '-T', 'Module::Install' ) == 0;
	}
	die "Could not install Module::Install. Install manually then rerun.\n" unless $ok;
	die "Module::Install still below required version $target after install.\n" unless _version_ok($target);
	print "Module::Install $Module::Install::VERSION installed (target >= $target).\n";
}

print "Installing Padre dependencies from cpanfile...\n";
my $installed = 0;
if ( _has_cmd('cpanm') ) {
	$installed = system( 'cpanm', '--with-configure', '--with-test', '--installdeps', '.' ) == 0;
}
if ( !$installed ) {
	die "Failed to install dependencies with cpanm. Please run: cpanm --with-configure --with-test --installdeps .\n";
}

print "Dependency installation complete.\n";
