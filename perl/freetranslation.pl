#!/usr/bin/perl
use strict;
use WWW::Mechanize;
my $m = WWW::Mechanize->new();
$|++;    # autoflush

# charge la première page
$m->get('http://www.freetranslation.com/');
die $m->res()->status_line() . "\n" unless $m->success();

print "? ";
while (<>) {

        # sélectionne le formulaire voulu
        $m->form_name('frmTextTranslator');

        # ou 'French/English', 'English/German', 'Italian/English'
        $m->field( language => 'English/French' );

        $m->field( charset => 'UTF-8' );    # voir ci-dessous
        $m->field( srctext => $_ );
        $m->click();

		$m->form_name('frmResults');
        print $m->current_form()->value('dsttext');
        print "\n? ";
    }
