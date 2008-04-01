use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'lib::tiny',
    AUTHOR              => 'Daniel Muey <http://drmuey.com/cpan_contact.pl>',
    VERSION_FROM        => 'lib/lib/tiny.pm',
    ABSTRACT_FROM       => 'lib/lib/tiny.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'lib-tiny-*' },
);

# better way to do this?
use File::Copy;
File::Copy::copy('lib/lib/tiny.pm.in', 'lib/lib/tiny.pm');
use Config;
open RFH, '<lib/lib/tiny.pm' or die "Could not read lib/lib/tiny.pm: $!";
my $content = do { local $/;<RFH> };
close RFH;

my $mtime = (stat($INC{'Config.pm'}))[9];
$content =~ s/ 'Config_PM_mtime'/ '$mtime'/;
$content =~ s/ 'Config.archname'/ '$Config{archname}'/;
$content =~ s/ 'Config.version'/ '$Config{version}'/;
$content =~ s/ 'Config.inc_version_list'/ '$Config{inc_version_list}'/;

open WFH, '>lib/lib/tiny.pm' or die "Could not open lib/lib/tiny.pm: $!";
print WFH $content;
close WFH;