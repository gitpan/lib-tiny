use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'lib::tiny',
    license             => 'perl',
    dist_author         => 'Daniel Muey <http://drmuey.com/cpan_contact.pl>',
    dist_version_from   => 'lib/lib/tiny.pm',
    requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'lib-tiny-*' ],
);

$builder->create_build_script();

# better way to do this?
use File::Copy;
File::Copy::copy('lib/lib/tiny.pm.in', 'lib/lib/tiny.pm');
use Config;
open my $rfh, '<', 'lib/lib/tiny.pm' or die "Could not read lib/lib/tiny.pm: $!";
my $content = do { local $/;<$rfh> };
close $rfh;

my $mtime = (stat($INC{'Config.pm'}))[9];
$content =~ s/ 'Config_PM_mtime'/ '$mtime'/;
$content =~ s/ 'Config.archname'/ '$Config{archname}'/;
$content =~ s/ 'Config.version'/ '$Config{version}'/;
$content =~ s/ 'Config.inc_version_list'/ '$Config{inc_version_list}'/;

open my $wfh, '>', 'lib/lib/tiny.pm' or die "Could not open lib/lib/tiny.pm: $!";
print {$wfh} $content;
close $wfh;