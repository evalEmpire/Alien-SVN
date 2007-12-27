package Alien::SVN;

use version;  our $VERSION = qw(1.4.6.0);

=head1 NAME

Alien::SVN - A wrapper for installing the SVN Perl bindings

=head1 DESCRIPTION

Alien::SVN is a wrapper to install the Perl bindings for subversion, also known as L<SVN::Core>.  If your module needs L<SVN::Core> it can depend on L<Alien::SVN> instead and then the CPAN shell can handle automatic installation.  This is particularly useful for programs like SVK.

It comes with a copy of Subversion 1.4.6 which it will compile but only installs the Perl and Subversion libraries.  B<The subversion binaries will not be installed>.


=head1 BUGS and FEEDBACK

Please send bug reports, problems and feedback to E<lt>bug-Alien-SVNE<gt> at E<lt>rt.cpan.orgE<gt>.  Or use the web interface at L<http://rt.cpan.org>.

Report early, report often.


=head1 LICENSE

Alien::SVN is copyright 2007 Michael G Schwern E<lt>schwern@pobox.comE<gt> and is
licensed under the same terms as Perl itself.  See L<http://www.perl.com/perl/misc/Artistic.html> for licensing.

This product includes software developed by CollabNet L<http://www.Collab.Net/>.
Subversion and SVN::Core are copyright (c) 2000-2007 CollabNet L<http://www.colabnet.net>.
All rights reserved.  See L<http://subversion.tigris.org/license-1.html> for licensing.

=cut

1;
