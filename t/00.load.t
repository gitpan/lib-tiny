use Test::More tests => 4;

BEGIN {
    require_ok( 'lib::tiny' );
}

diag( "Testing lib::tiny $lib::tiny::VERSION" );

my @dirs = qw(tiny_foo tiny_bar);
mkdir $_ for @dirs; # set up

my @ORIG = @INC;

lib::tiny->import(@dirs);
ok($INC[0] eq $dirs[0] && $INC[1] eq $dirs[1], 'adds paths');

lib::tiny->unimport(@dirs);
ok($INC[0] eq $ORIG[0] && $INC[1] eq $ORIG[1], 'dels paths');

require lib;
lib->import(@dirs);
ok($INC[0] eq $dirs[0] && $INC[1] eq $dirs[1], 'adds paths ordered same as lib.pm');

rmdir $_ for @dirs; # clean up