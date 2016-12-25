#!/usr/bin/perl
use strict;
use WWW::Mechanize;
use Getopt::Long;
use DateTime;

$|++;    # autoflush

my $res;

my %CONF = (
language => 'English/French',
charset => 'UTF-8',
srctext => '',
);

GetOptions(\%CONF,"language=s","charset=s","srctext=s") or die "Bad options\n";

#creation d'objet
my $m = WWW::Mechanize->new();

# charge la première page
$m->get('http://www.freetranslation.com/');
die $m->res()->status_line() . "\n" unless $m->success();

print "Convertion: " . $CONF{language}."\n";

if($CONF{srctext})
{
 print "convert>> $CONF{srctext}\n";
 
 # sélectionne le formulaire voulu
 $m->form_name('frmTextTranslator');
 $m->set_fields(%CONF);
 $m->submit;
 
 $m->form_name('frmResults');
 $res =  $m->current_form()->value('dsttext');
 print $res . "\n";
 ecrire($CONF{srctext},$res);
}
else
{ 
print "convert>> "; 
while (<>) {

		chomp;
		last if($_ eq "exit");
        # sélectionne le formulaire voulu
        $m->form_name('frmTextTranslator');

   		$m->set_fields(%CONF);
        $m->field( srctext => $_ );
        $m->submit();

		$m->form_name('frmResults');
        $res =  $m->current_form()->value('dsttext');
        print "$res" ."\n? ";
        ecrire($_,$res);
    }
}

sub ecrire
{
	#datetime
	my $dt = DateTime->new(year => 2008);
	$dt = DateTime->now;
	
	open my $fd,">>","traduction.txt" or die "Problème ouverture fichier\n";
	print $fd "[" . $dt->dmy . "] ";
	print $fd shift (@_) . " => " . shift (@_) ."\n";
}	
