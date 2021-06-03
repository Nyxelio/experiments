#!/usr/bin/perl
use strict;
use warnings;
use GD::Graph::lines;

my @data = ([-5..5],[map{$_ ** 2}(-5..5)]);
my $graph = GD::Graph::lines->new(200,200);
$graph->set_text_clr('blue');
$graph->set(
	x_label => 'axe X',
	y_label => 'axe Y',
	title => "f(x) = x^2",
	box_axis => 0,
	zero_axis_only => 1) or die $graph->error;
my $gd = $graph->plot(\@data) or die $graph->error;

open my $img, ">","graph.png" or die $!;
binmode $img;
print $img $gd->png;

