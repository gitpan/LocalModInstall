#!perl -w

###############################################################################
##                                                                           ##
##    Copyright (c) 2001 by Steffen Beyer.                                   ##
##    All rights reserved.                                                   ##
##                                                                           ##
##    This package is free software; you can redistribute it                 ##
##    and/or modify it under the same terms as Perl itself.                  ##
##                                                                           ##
###############################################################################

use strict;

use ExtUtils::MakeMaker;

use Config;

WriteMakefile(
    'NAME'              => 'LocalModInstall',
    'VERSION'           => '1.0',
    'EXE_FILES'         => [ 'LocalModInstall.pl' ],
#   ($] >= 5.005 ?
#       ('ABSTRACT'     => 'Script to install Perl modules locally',
#        'AUTHOR'       => 'Steffen Beyer (sb@engelschall.com)') : ()),
#   ($] >= 5.005 && $^O eq 'MSWin32' && $Config{archname} =~ /-object\b/i ?
#       ('CAPI'         => 'TRUE') : ()),
    'dist'              => { COMPRESS => "gzip -9", SUFFIX => "gz" }
);

__END__

