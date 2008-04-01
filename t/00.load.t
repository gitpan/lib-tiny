use Test::More tests => 2;

my $strict;
BEGIN {
    use strict;
    $strict = strict::import();
}

BEGIN {
use_ok( 'lib::tiny' );
}

diag( "Testing lib::tiny $lib::tiny::VERSION" );

# Even though I've manually tested this by putting debug output in lib.pm
# I'd liek to automate said tests:

# w/ out Config:
#   munges @INC properly via use() and no()
ok(strict::import() eq $strict, 'strict localized properly');
#   Config.pm isn't in %INC - Test::More brings it in...

# w/ Config
#   is normal