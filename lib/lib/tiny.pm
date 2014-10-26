package lib::tiny;

# use strict; # this works but is disabled for production, since it doesn't gain any thing in this mod and adds appx 184K to memory
$lib::tiny::VERSION = 0.5;

sub import {
    shift;
    my %seen;
    for (reverse @_) {
        next if !defined $_ || $_ eq '';
        unshift @INC, $_ if -d $_;
        # if we can do this without Config and 'tiny' File::Spec-ness to properly join their names into a path...
        # handle '$_/@{'inc_version_list'} here
        # unshift @INC, "$_/$archname")          if -d "$_/$archname/auto";
    	# unshift @INC, "$_/$version")           if -d "$_/$version";
    	# unshift @INC, "$_/$version/$archname") if -d "$_/$version/$archname";
    }
    @INC = grep { $seen{$_}++ == 0 } @INC;
}

sub unimport {
    shift;
    my %ditch;
    @ditch{ @_ } = ();
    # if import ever does version/archname/inc_version_list paths we need to remove them here
    @INC = grep { !exists $ditch{ $_ } } @INC;
}

1; 

__END__

=head1 NAME

lib::tiny - use lib, without having to use memory by loading Config

=head1 VERSION

This document describes lib::tiny version 0.5

=head1 SYNOPSIS

    use lib::tiny @list;
    no lib::tiny @list;

=head1 DESCRIPTION

This module simply adds and removes the given (existant on add) paths as-is to/from @INC in the same manner as L<lib> but in a '::Tiny' manner.

The idea is this: lib.pm has to load the entire %Config and only uses 3 small variables from it.

As far as I can tell L<Config> still gets use()d in L<lib> even if perl was compiled with PERL_BUILD_EXPAND_CONFIG_VARS

Also the assumption is that if you are using this to shave off a bit of memory (appx 200K +/- over 'use lib') then you 
are probably not interested in the arch/version/inc_version_list alternate paths anyway.

That being the case it doesn't bother with them since it'd require L<Config> and also more memory for L<File::Spec>.

For the same reason we don't have a @lib::tiny::ORIG_INC copy

If you are interested in those things just use L<lib> instead.

=head1 METHODS

=head2 import()

Is used when you:

    use lib::tiny @list;

=head2 unimport()

Is used when you:

   no lib::tiny @list;

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

=head1 A NOTE ABOUT TINY MEMORY

Here are some quick tests to showing how it uses over 50% less memory than use lib; 
(at least at this moment on this machine, your mileage may vary obviously)

    multivac:~ dmuey$ perl -le 'print `ps u -p $$`;'
    USER    PID %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
    dmuey 12815   0.0  0.1   601232   1172 s001  S+    5:07PM   0:00.01 perl -le print `ps u -p $$`;
    
    multivac:~ dmuey$ perl -le 'use lib "/tmp";print `ps u -p $$`;'
    USER    PID %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
    dmuey 12817   2.7  0.1   601232   1544 s001  S+    5:08PM   0:00.01 perl -le use lib "/tmp";print `ps u -p $$`;
    
    multivac:~ dmuey$ perl -le 'use lib::tiny "/tmp";print `ps u -p $$`;'
    USER    PID %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
    dmuey 12819   0.0  0.1   601232   1360 s001  S+    5:08PM   0:00.01 perl -le use lib::tiny "/tmp";print `ps u -p $$`;
    
    multivac:~ dmuey$ perl -le 'print 1544 - 1172;'
    372
    multivac:~ dmuey$ perl -le 'print 1360 - 1172;'
    188
    multivac:~ dmuey$ perl -le 'print ((188/372)*100);'
    50.5376344086022
    multivac:~ dmuey$

=head1 TODO

If there is great demand we may:

=over 4

=item Do the archtype/version/inc_version_list dir structure without needing Config or File::Spec?

or at least a mechanism to pass the data and have it done?

=back

=head1 THANKS

To Adam Kennedy for the helpful feedback to make this module actually fit in the '::Tiny' spec.

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