# Very basic test file, essentially to check that the module can be loaded
# and produces some meaningful results.

# Do a cd into the build directory of this module, then run this file
# manually by running
#
# /path/to/your/perl6 t/runtest.p6
#
# and (hopefully) enjoy the colors.

BEGIN { @*INC.push('lib') };

use lib '/home/jilves/Development/github/Perl6-Term--ANSIColor/lib';
use Term::ANSIColor :functions;

print color 'blue';
say "This is text in blue";
print color 'reset';
print color 'blue on_yellow';
say 'This is blue text on yellow background';
print color 'reset';
say "This is text in the default color";
print color 'bright_red on_bright_yellow';
say "This is bright red text on bright yellow background";
print color 'reset';
print color 'bright_red on_red';
say "This is bright red text on darker red background.";
print color 'reset red';
say 'Dark red on default background';
print color 'green reset';
say 'Default color';
print color 'reset';
print color 'not_a_color';

