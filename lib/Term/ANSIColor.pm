=begin Pod

=head1 Term::ANSIColor

C<Term::ANSIColor> is a module for supporting ANSI control sequences
in Perl 6.  It is intended to be a port of the corresponding Perl 5 module.

=head1 Synopsis

    use Term::ANSIColor :functions;
    print colored('This is bright yellow','bright_yellow'),"\n";
    print color 'blue';
    print 'This text is blue';
    print color 'reset',"\n";
    say "This text uses the default colors.";
    say color 'bright_red on_black',
        'Text being bright_red on black',
        color 'reset';
    say color 'bright_red on_bright_yellow',
        'This is bright red on bright yellow',
        color 'reset';

=head1 Usage

The function color() takes a string as it's argument containing a
number of color specifications separated by whitespace.  It
returns the corresponding ANSI control codes needed to get that
specified color.

There are a number of color specifications allowed:

black, red, green, yellow, blue, magenta, cyan and white will give you
these colors (sometimes referred to as ANSI Colors 0 through 7) but bear
in mind that they all will be a bit dark on most terminal emulators.  The
black usually is pitch black, but the white color is actually grey.

If any of these eight colors have the string 'on_' prepended (e.g 'on_black')
you specify that you want the texts background to be of that color.

If any of these colors have the string 'bright_' prepended, you get the
corresponding bright color.  "Bright white" will give you a real white color
on most terminal emulators, but "bright black" might vary.  Some emulators
will give you a pitch black color, others display the text at dark grey.

(The 'bright' colors are sometimes referred to
as ANSI colors 8 through 15).

If you prepend the string 'on_bright_' before one of the basic colors,
you get the bright version of that color as the background for your text.

Finally, if you want to reset the colors back to the default background and
foreground, use the color specification 'reset'.

So, in a nutshell, a color specification of

'red' will give you (dark) red text

'on_yellow' will print text on a (dark) yellow background

'black on_bright_white' will print real black text on real white background.

'on_bright_white black' will do the same.

'bright_red on_bright_yellow' will give a clear red on clear yellow text.

'reset' will give you the default color and background.

'reset on_bright_black' will give you the default text color on dark grey
(or black on some terminals).

Note that 'red on_white' and 'on_white red' will give the same visual output,
but the ANSI control codes generated will be in different order.  When
specifying just colors, this does not matter, but when 'reset' is part
of the specification you have to pay attention to order:

'reset on_red' gives default foreground color on red background.
'on_red reset' gives default foreground AND background color.

Specifying multiple foreground colors in one call to color() is pointless as
only the last color mentioned will end up being the color of the text.  All
the ANSI control codes will be generated but as terminals work, only the last
control code will take effect.  Same thing for specifying multiple background
('on_') colors.

This module only emits certain ANSI control codes.  It is up to the terminal
emulator at the end of the day to decide what color to display.  Bright black
is one example of a color that might or might not display as you expect.
Another such color is basic (dark) yellow (with color specs 'yellow' and
'on_yellow'), on some terminals it is displayed as bright orange or as brown.

=head1 TODO

Better POD.

Better handling/documentation for the situation when an unrecognized
color specification is provided.

Constants as found in the corresponding Perl 5 module

colored() as found in the corresponding Perl 5 module.

Support more ANSI attributes (bold etc).

=head AUTHOR

Jakob Ilves <illvilja@gmail.com>
    
=head Credits

A lot of inspiration naturally comes from Russ Allbery's
Perl 5 Term::ANSIColor.

Inspiration of how to setup a Perl 6 module in general comes
from Moritz Lenz' json module.

Thanks to Jonathan Leto on advice on how to get started with
git and github.com

Thanks to Carl Mäsak and the other folks on #perl6 on freenode
for just being very encouraging

=end Pod

module Term::ANSIColor;

my @color_names =  < black red green yellow blue magenta cyan white >;

my %ANSI_ATTRIBUTES =
    reset => '00';

my %meta_attributes =
    ''           => '3',
    'on_'        => '4',
    'bright_'    => '9',
    'on_bright_' => '10',
    ;

for %meta_attributes.kv -> $meta_attr, $meta_attr_code {
    for 0 .. @color_names.end -> $color_code {
        my $color_name = @color_names[$color_code];
        my $attribute_name = $meta_attr ~ $color_name;
        my $attribute_code = $meta_attr_code ~ $color_code;
        %ANSI_ATTRIBUTES{$attribute_name} = $attribute_code;
    }
}

sub color ($color_spec) is export(:functions) {
    my $lc_color_spec = $color_spec.lc;
    my @color_specs = $lc_color_spec.split(/\s+/);
    my @ansi_codes = ();
    for @color_specs -> $color_spec {
        if (%ANSI_ATTRIBUTES.exists($color_spec)) {
            @ansi_codes.push(%ANSI_ATTRIBUTES{$color_spec});
        }
        else {
            fail "Unsupported color spec $color_spec";
        }
    }
    
    my $ansi_codes_string = @ansi_codes.join(';');
    my $control_sequence_string = "\o33[" ~ $ansi_codes_string ~ 'm';
    
    return $control_sequence_string;
};

