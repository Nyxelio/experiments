#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  butineoScripter.pl
#
#        USAGE:  ./butineoScripter.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  [], <>
#      COMPANY:  
#      VERSION:  0.1
#      CREATED:  04/12/2012 15:15:31 CET
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;
use WWW::Scripter;
use WWW::Scripter::Plugin::JavaScript;
use HTML::Display;
use Data::Dumper;

my $w = WWW::Scripter->new( autocheck => 1);
$w->agent_alias( 'Linux Mozilla' );

#$w->use_plugin('JavaScript');
$w->use_plugin('Ajax');

#my $link = 'http://datenshi-design.fr/gallery3';
my $link = 'http://butineo.fr';
my $response = $w->get($link);

if(!$response->is_success)
{
    die "Site inaccessible $link: ", $response->status_line, "\n";
}

#$w->add_header(
#"Connection" => "keep-alive",
#"Keep-Alive" => "115");

#my @links = $w->links();
#foreach(@links)
#{

#    print $_->url(), " - ", $_->text(), "\n";
#}

#my @link = $w->find_link( id => 'g-login-link');

#foreach (@link)
#{
#    print $_->url(), " - ", $_->text(), "\n";
#}

print "Au Départ:". $w->uri."\n"; #ok

#=a reactiver
#$response = $w->follow_link( text => 'Connexion');
$response = $w->follow_link( id => 'log2');

if(!$response->is_success)
{
    print "erreur sur follow_link\n";
}

print "retour: ",$w->response->status_line;

print "Après appel du lien:". $w->uri."\n"; #ok

#
#=cut

=a reactiver
$w->form_name('g-login-form');

$w->field('name','datenshi33');
$w->field('password','k3stnWM7');
$response = $w->click();

if($response->is_success)
{
    print "Authentification réussi!\n";
}
else
{
    print "Authentification échouée!\n";
}


$response = $w->get($link);

=cut

my $browser = HTML::Display->new();
display(html => $w->content, location => $link);
print $w->content;
<>;

