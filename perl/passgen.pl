#!/usr/bin/perl
use strict;
use warnings;

#Passez la longueur du mot de passe en paramètre
my @chars = ('a'..'z','A'..'Z',0..9,'&','@','$');
print join ("", map {$chars[int rand scalar @chars]}(1..shift))."\n";

