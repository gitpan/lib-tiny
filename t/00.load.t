use Test::More tests => 4;

BEGIN {
    require_ok( 'lib::tiny' );
}

diag( "Testing lib::tiny $lib::tiny::VERSION" );

my @dirs = qw(tiny_foo tiny_bar);
mkdir($_,umask()) for @dirs; # set up, umask() is for old perl's

my @ORIG = @INC;

lib::tiny->import(@dirs);
ok($INC[0] eq $dirs[0] && $INC[1] eq $dirs[1], 'adds paths');

lib::tiny->unimport(@dirs);
ok($INC[0] eq $ORIG[0] && $INC[1] eq $ORIG[1], 'dels paths');

# eval because at least one 
eval {
    require lib;
    lib->import(@dirs);
};

SKIP: {
    skip 'apparently too old to handle: Unquoted string "lib" may clash with future reserved word at t/00.load.t line 21.', 1 if $@;
    ok($INC[0] eq $dirs[0] && $INC[1] eq $dirs[1], 'adds paths ordered same as lib.pm');
};

rmdir $_ for @dirs; # clean up