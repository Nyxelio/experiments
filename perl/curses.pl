#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  curses.pl
#
#        USAGE:  ./curses.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [nyxelio]
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  26.06.2008 19:34:41 CEST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use Curses::UI;

my $cui = Curses::UI->new(-color_support => 1,-mouse_support =>1);
#    $cui->progress(
#        -max => 10,
#        -message => "Counting 10 seconds...",
#    );
#
#    for my $second (0..10) {
#        $cui->setprogress($second);
#        sleep 1;
#    }
#
#    $cui->noprogress;
# my $yes = $cui->dialog(
#        -message => "Hello, world?",
#        -buttons => ['yes','no'],
#        -values  => [1,0],
#        -title   => 'Question',
#    );
#
#    if ($yes) {
        # whatever
#    }
#$cui->mainloop;


sub exit_dialog
{
	my $yes = $cui->dialog(
		-message => "Do you really want to quit ?",
		-buttons => ['yes','no'],
		-title => 'Are you sure ?',
	);
	exit (0) if $yes;
}

my @menu = (
           { -label => 'File',
			 -submenu => [
		   	{ -label => 'Save     ^S',-value => \&exit_dialog},
           	{ -label => 'Exit     ^Q',-value => \&exit_dialog}
                         ]
           },
		   { -label => 'Edit',
			 -value => 'Edition',
		   },
	   );

my $menu = $cui->add(
					'menu','Menubar',
					-menu => \@menu,
					-fg => "blue",
					);

my $win = $cui->add(
				'Window','Window',
				-border => 1,
				-y => 1,
				-bfg => 'red',
			);
$win->add(
		'text','TextEditor',
		-text => 'Here is some text',
		);

$cui->mainloop;
