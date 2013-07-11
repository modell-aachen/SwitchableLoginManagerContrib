# See bottom of file for default license and copyright information

=begin TML

---+ package Foswiki::Contrib::SwitchableLoginManagerContrib

A login manager that allows for admins to switch to arbitrary user accounts for
testing purpose (especially for testing permissions).

=cut

package Foswiki::Contrib::SwitchableLoginManagerContrib;

# Always use strict to enforce variable scoping
use strict;
use warnings;

our $VERSION = '$Rev$';

our $RELEASE = '1.0.2';

our $SHORTDESCRIPTION = 'Alternative login manager that supports sudoing to arbitrary users';

1;

__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: %$AUTHOR%

Copyright (C) 2008-2011 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
