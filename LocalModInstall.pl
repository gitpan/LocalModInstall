#!perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 2001 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This program is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use strict;
use Config;

my $Prefix = Normalize( $ENV{'HOME'} . '/' . 'perl' );

my $Error = '';

sub Normalize
{
    my $dir = $_[0];
    my $drv = '';

    if ($dir =~ s!^([A-Za-z]:)!!) { $drv = $1; }
    $dir = "/$dir/";
    $dir =~ s!\\!/!g;
    $dir =~ s!//+!/!g;
    while ($dir =~ s!/(?:\./)+!/!g) {};
    while ($dir =~ s,/(?!\.\./)[^/]+/\.\./,/,g) {};
    $dir =~ s!^/(?:\.\./)+!/!g;
    $dir =~ s!^/!!;
    $dir =~ s!/$!!;

    return wantarray ? ($drv,$dir) : "$drv/$dir";
}

sub MakeDir
{
    my($drv,$dir) = Normalize($_[0]);
    my(@dir);

    $Error = '';
    return 1 if (-d "$drv/$dir");
    print "Making directory $drv/$dir\n";
    @dir = split(/\//, $dir);
    $dir = $drv;
    while (@dir)
    {
        $dir .= '/' . shift(@dir);
        unless (-d $dir)
        {
            unless (mkdir($dir,0777))
            {
                $Error = "Can't mkdir '$dir': $!";
                return 0;
            }
        }
    }
    return 1;
}

sub MakeSystem
{
    my($command) = join(' ', @_);

    $Error = '';
    print "$command\n";
    if (system($command))
    {
        $Error = "Can't execute '$command'!";
        return 0;
    }
    return 1;
}

sub MakePerl
{
    my($command) = join(' ', @_);

    $Error = '';
    print "$command\n";
    eval "$command";
    if ($@)
    {
        $@ =~ s!\s+! !g;
        $@ =~ s!\(.*$!!;
        $@ =~ s!\s+at\s.*$!!;
        $@ =~ s!\s+$!!;
        $Error = "Can't execute '$command': $@";
        return 0;
    }
    return 1;
}

my %SubDirs = ();

my @LibDirs = qw(installarchlib installprivlib installsitearch installsitelib);

my @ManDirs = qw(installman1dir installman3dir);

my $Perl    = $Config{'perlpath'};

my $prefix  = $Config{'prefix'};

$prefix =~ s!/+$!!;

my($key,$dir);

foreach $key ( @LibDirs, @ManDirs )
{
    $dir = $Config{$key};
    $dir =~ s!^$prefix!!o;
    $dir = Normalize( $Prefix . '/' . $dir );
    goto ERROR unless (MakeDir($dir));
    $SubDirs{$key} = $dir;
}

goto ERROR unless (MakeSystem( $Perl, 'Makefile.PL', "PREFIX=$Prefix", map("\U$_\E=$SubDirs{$_}", @ManDirs) ));

my $flag = 0;

my $uselib   = join( "\n      ", map( $SubDirs{$_}, @LibDirs ) );

my $perl5lib = join( "\n  ", map { $flag++ ? qq(PERL5LIB="\$PERL5LIB:$SubDirs{$_}") : qq(PERL5LIB="$SubDirs{$_}") } @LibDirs );

my $manpath  = join( "\n  ", map { qq(MANPATH="\$MANPATH:$SubDirs{$_}") } @ManDirs );

print <<"VERBATIM";

Don't forget to

  use lib
  qw(
      $uselib
  );

in your scripts (prior to any other "use" statements) or to set

  $perl5lib
  export PERL5LIB

in your shell (or shell configuration file) and to set

  $manpath
  export MANPATH

in your shell (or shell configuration file).

VERBATIM

exit(0);

ERROR:

print <<"VERBATIM";

Execution failed:

  $Error

VERBATIM

exit(1);

__END__

=head1 NAME

LocalModInstall - Install Perl modules locally (into your home directory)

=head1 SYNOPSIS

  perl -S LocalModInstall.pl
  make
  make test
  make install

=head1 DESCRIPTION

Install the "LocalModInstall" package using the usual incantation

  perl Makefile.PL
  make install

or move the file "LocalModInstall.pl" into one of the directories in your
C<$PATH> and make it executable ("C<chmod a+x LocalModInstall.pl>").

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

The script "LocalModInstall.pl" will print out the correct settings
to use for the "use lib" statement in your scripts or the "PERL5LIB"
environment variable, as well as the "MANPATH" environment variable.

=head1 SEE ALSO

lib(3), perlfaq8(1): "How do I keep my own module/library directory?"

=head1 VERSION

This man page documents "LocalModInstall" version 1.0.

=head1 AUTHOR

  Steffen Beyer
  mailto:sb@engelschall.com
  http://www.engelschall.com/u/sb/download/
  http://www.perl.com/CPAN/authors/id/S/ST/STBEY/

=head1 COPYRIGHT

Copyright (c) 2001 by Steffen Beyer. All rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself, i.e., under the
terms of the "Artistic License" or the "GNU General Public License".

=head1 DISCLAIMER

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the "GNU General Public License" for more details.

