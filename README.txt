
LocalModInstall(1)                             LocalModInstall(1)

NAME
       LocalModInstall - Install Perl modules locally
                         (into your home directory)

SYNOPSIS
	 perl -S LocalModInstall.pl
	 make
	 make test
	 make install

DESCRIPTION
       Install the "LocalModInstall" package using the usual
       incantation

	 perl Makefile.PL
	 make install

       or move the file "LocalModInstall.pl" into one of the
       directories in your $PATH and make it executable
       ("chmod a+x LocalModInstall.pl").

       Then use

	 perl -S LocalModInstall.pl

       instead of

	 perl Makefile.PL

       whenever you want to install a module locally.

       After that, use

	 make
	 make test
	 make install

       as usual.

       The script "LocalModInstall.pl" will print out the correct
       settings to use for the "use lib" statement in your scripts
       or the "PERL5LIB" environment variable, as well as the
       "MANPATH" environment variable.

SEE ALSO
       lib(3), perlfaq8(1): "How do I keep my own module/library
       directory?"

VERSION
       This man page documents "LocalModInstall" version 1.0.

AUTHOR
	 Steffen Beyer
	 mailto:sb@engelschall.com
	 http://www.engelschall.com/u/sb/download/
	 http://www.perl.com/CPAN/authors/id/S/ST/STBEY/

COPYRIGHT
       Copyright (c) 2001 by Steffen Beyer. All rights reserved.

LICENSE
       This program is free software; you can redistribute it
       and/or modify it under the same terms as Perl itself,
       i.e., under the terms of the "Artistic License" or the
       "GNU General Public License".

DISCLAIMER
       This program is distributed in the hope that it will be
       useful, but WITHOUT ANY WARRANTY; without even the implied
       warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
       PURPOSE.

       See the "GNU General Public License" for more details.

