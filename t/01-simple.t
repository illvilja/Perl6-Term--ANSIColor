use Term::ANSIColor;
use Test;
plan 1;
is( Term::ANSIColor::color('red'), "\o33[31m" );

