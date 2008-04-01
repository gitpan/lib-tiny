use Test::More tests => 4;

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
# I'd like to automate said tests, however Test::More brings in Config.pm...

# w/ out Config:
#   munges @INC properly via use() and no()

my ($orig_a, $orig_b) = @INC;
lib::tiny->import(qw(foo bar));
ok($INC[0] eq 'foo' && $INC[1] eq 'bar', 'adds paths');
lib::tiny->unimport(qw(foo bar));
ok($INC[0] eq $orig_a && $INC[1] eq $orig_b, 'dels paths');

ok(strict::import() eq $strict, 'strict localized properly');

#   Config.pm isn't in %INC - Test::More brings it in...

# w/ Config
#   is normal

# w/ out strict = no errors