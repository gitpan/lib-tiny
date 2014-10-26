package lib::tiny;

# use strict; # disabled for production, since it doesn't gain any thing in this mod and adds appx 184K to memory
# use vars qw($VERSION); # plus you know have to 'use vars' which bumps it up to 272K
$VERSION = 0.4;

# get real lib.pm, faking out the Config part of it...
{
    if (!exists $INC{'Config.pm'}) {
        # fake out 'use strict' in lib.pm so our $Config can be used
        local $INC{'strict.pm'};
        local $^W; # no redefine warnings   
        local *strict::import = sub { 1; };
        
        local $INC{'Config.pm'}          = 'Config_PM_mtime';  # this is the mtime of Config.pm that these variables where fetched
        $lib::Config{'archname'}         = 'Config.archname';
        $lib::Config{'version'}          = 'Config.version';
        $lib::Config{'inc_version_list'} = 'Config.inc_version_list';
        
        require lib;
    }
    else {
        require lib;
    }
}

sub import {
    goto &lib::import;
}

sub unimport {
    goto &lib::unimport;
}

1; 

__END__

=head1 NAME

lib::tiny - use lib, without having to use Config!

=head1 VERSION

This document describes lib::tiny version 0.4

=head1 SYNOPSIS

    use lib::tiny @list;
    no lib::tiny @list;

=head1 DESCRIPTION

lib.pm has to load the entire %Config and only uses 3 variables from it.

This module looks them up once and stores them internally at buildtime for reuse from then on.

=head1 METHODS

=head2 import()

IE use lib::tiny

=head2 unimport()

IE no lib::tiny

=head1 CONFIGURATION AND ENVIRONMENT

lib::tiny requires no configuration files or environment variables.

=head1 DEPENDENCIES

None.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-lib-tiny@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 TODO

=over 4

=item Finish automating tests I've done manually (Test:: mods iterfere with %INC behavior checks )

=item Do Makefile.PL .pm munge more "proper" ?

=item use inside lib::restrict

=back

=head1 AUTHOR

Daniel Muey  C<< <http://drmuey.com/cpan_contact.pl> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2008, Daniel Muey C<< <http://drmuey.com/cpan_contact.pl> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
