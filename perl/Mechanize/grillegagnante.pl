#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  lipala.pl
#
#        USAGE:  ./lipala.pl 
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
#      CREATED:  11/01/2013 15:01:18 CET
#     REVISION:  ---
#===============================================================================

#06/01/2013:
# A FAIRE: junglokdo,grille gagnante,lapiwin
#MOZREPL
# barre de fidélité
# points bonus
# jetons gratuits
# base de donnee
# recuperer liste jeux et boucle
# Mechanize ?
# ovh ?
# d'autres site à parser
# gain a valider par mail
#analyser grille de gain
use strict;
use warnings;
use WWW::Mechanize::Firefox;
use HTML::TreeBuilder::XPath;
use Data::Dumper;
#use Firefox::Application;

system("iceweasel &");

sleep(8);

my $m = WWW::Mechanize::Firefox->new(
    #launch => '/usr/bin/iceweasel',
     activate => 1,
    autocheck => 1); #foreground

sleep(2);

$m->autoclose_tab( 0 ); #laisse ouvert apres fin programme

my $link = "grillegagnante.com";
my $response = $m->get($link);

if(!$response->is_success)
{
    die "Site inaccessible $link: ", $response->status_line, "\n";
}

&Connexion(\$m);

#print "appel page principale: ";

#$m->follow_link( tag => 'a', href => 'les_jeux_site.php' );
#$m->get($link."/grille_gagnante.php");

#sleep(2);

#print "ok\n";
my $jetonsGratuits;
my $jetonsPayants;
#my $total_points;
my $total_euros;
my $status;
my $gain;

#Nombre de jetons gratuits
($jetonsGratuits,$jetonsPayants) = &NombreJetons(\$m);
print "Nombre de Jetons Gratuits: ".$jetonsGratuits."\n";
print "Nombre de Jetons Payants: ".$jetonsPayants."\n";

while ( $jetonsGratuits > 0)
{
    ($status,$gain) = &Jeu(\$m);   

    if($status eq "OK")
    {
       print "Gain: ".$gain." €\n";
    }
    elsif($status eq "NOK")
    {
        print "Erreur: ".$gain."\n";
    }
    else
    {
        die "Erreur interne";
    }

    #Nombre de jetons gratuits
    ($jetonsGratuits,$jetonsPayants) = &NombreJetons(\$m);
    print "Nombre de Jetons Gratuits: ".$jetonsGratuits."\n";
    print "Nombre de Jetons Payants: ".$jetonsPayants."\n";

    #Nombre total d'euros
    $total_euros = &NombreTotalEuros(\$m);
    print "Nombre total d'euros: ".$total_euros."\n";

}

#validation banniere pour points
my @points_banniere = &ValidationBannierePoints(\$m);

foreach my $point (@points_banniere)
{
    print "Gain: ".$point." points\n";
}

# A VOIR: LES BANNIERES DISPARRAISSENT...

#validation banniere pour jetons
my @jetons_banniere = &ValidationBanniereJetons(\$m);

foreach my $jeton (@jetons_banniere)
{
    print "Gain: ".$jeton." jetons\n";
}

#appel page principale
print "appel page principale: ";
$m->get($link);

sleep(1);
print "ok\n";

#formulaire de connexion
sub Connexion
{
    print "Connexion: ";

    my($self) = @_;
    my $m = $$self;


    #connexion OK
    $m->form_name('form1');
    $m->field( email_connexion => 'datenshi33@gmail.com' );
    $m->field( mot_de_passe_connexion => 'k3stnWM7' );
    $m->submit();

    sleep(2);
    print "ok\n";
   
}

#Banniere de points
sub ValidationBannierePoints 
{

    print "Appel Validation bannières Points: ";
    
    my($self) = @_;
    my $m = $$self;


    $m->get($link."/moyens-paiement/jeuxc.php?type_gain=0");#et 1 pour les jetons

    sleep(2);

    print "ok\n";

    my $tree = HTML::TreeBuilder->new_from_content ( $m->content );

    my @links = $tree->findnodes_as_strings( '//a[contains(@href,"jeuxcmul.php")]/@href');

    $tree->delete;

    print "Nombre de bannières points à valider: ".@links."\n\n";

    my $target;
    my $value;
    my $type;
    my @gain;

    #../jeuxcmul.php?id_ban=***********
    foreach my $sublink (@links)
    {
        #print $sublink."\n";

        if( $sublink =~ /id_ban=(.*)/)
        {
            $target = $1;
        }
        else
        {
            die "Erreur lors de l'analyse";
        }

        $m->get($link."/jeuxcmul.php?id_ban=".$target);

        sleep(2);


        #Technique JS
        #cette variable contient le texte de l'opération (comme ci dessus). Elle s'affiche normalement une fois le nombre de clic effectué ou timer ecoulé.
        #en lisant direct et en appelant le resultat, on evite de devoir faire des clics ou de devoir attendre.

        ($value,$type) = $m->eval_in_page('Text_Redirection_Counter');
        
        if ( length($value) > 0 )
        {
            #print $value."\n";
     
            $tree = HTML::TreeBuilder->new_from_content ( $value );

            print "Nécessite une opération...\n";
                
            #Seul le vrai résultat de l'opération possède un texte et une partie du href identique
            #inutile de traiter l'operation
            $value = $tree->findvalue('//a[text() = substring-after(@href,"resultat=")]/@href');
            #print "url: ".$value."\n";

            if($value =~ /^\?id_ban=.*&resultat=\d?\d$/)
            {
                        
                $tree->delete;

                $m->get($link."/jeuxcmul.php".$value);
                
                sleep(2);
         
                $tree = HTML::TreeBuilder->new_from_content ( $m->content );
                
                #$gain = $tree->findvalue('//td[contains(text(),"Vous avez gagné")]/text()');
                $value = $tree->findvalue('//div[@id="top"]/table/tbody/tr/td[contains(text(),"points")]/text()');
                            
                #print "Gain: ".$gain."\n";

                if($value =~ / (\d?\d) points./)
                {
                    push (@gain, $1);
                }

                $tree->delete;

                #print "Gain: ".$gain."\n";
                
            }
            else
            {
                print "Le format d'url de la réponse n'est pas valide. On passe à la banniere suivante\n";
                next;
            }
        }
        else    
        {
            #²die "Erreur lors de l'analyse de la bannière";
            print "Erreur lors de l'analyse de la bannière ! On passe a la suivante.";
            next;
        }

    }

    return @gain;

}

#Banniere de jetons
sub ValidationBanniereJetons 
{

    print "Appel Validation bannières Jetons: ";
    
    my($self) = @_;
    my $m = $$self;


    $m->get($link."/moyens-paiement/jeuxc.php?type_gain=1");#et 1 pour les jetons

    sleep(2);

    print "ok\n";

    my $tree = HTML::TreeBuilder->new_from_content ( $m->content );

    my @links = $tree->findnodes_as_strings( '//a[contains(@href,"jeuxcmul.php")]/@href');

    $tree->delete;

    print "Nombre de bannières jetons à valider: ".@links."\n\n";

    my $target;
    my $value;
    my $type;
    my @gain;

    #../jeuxcmul.php?id_ban=***********
    foreach my $sublink (@links)
    {
        #print $sublink."\n";

        if( $sublink =~ /id_ban=(.*)/)
        {
            $target = $1;
        }
        else
        {
            die "Erreur lors de l'analyse";
        }

        $m->get($link."/jeuxcmul.php?id_ban=".$target);

        sleep(2);


        #Technique JS
        #cette variable contient le texte de l'opération (comme ci dessus). Elle s'affiche normalement une fois le nombre de clic effectué ou timer ecoulé.
        #en lisant direct et en appelant le resultat, on evite de devoir faire des clics ou de devoir attendre.

        ($value,$type) = $m->eval_in_page('Text_Redirection_Counter');
        
        if ( length($value) > 0 )
        {
            #print $value."\n";
     
            $tree = HTML::TreeBuilder->new_from_content ( $value );

            print "Nécessite une opération...\n";
                
            #Seul le vrai résultat de l'opération possède un texte et une partie du href identique
            #inutile de traiter l'operation
            $value = $tree->findvalue('//a[text() = substring-after(@href,"resultat=")]/@href');
            #print "url: ".$value."\n";

            if($value =~ /^\?id_ban=.*&resultat=\d?\d$/)
            {
                        
                $tree->delete;

                $m->get($link."/jeuxcmul.php".$value);
                
                sleep(2);
         
                $tree = HTML::TreeBuilder->new_from_content ( $m->content );
                
                #$gain = $tree->findvalue('//td[contains(text(),"Vous avez gagné")]/text()');
                $value = $tree->findvalue('//div[@id="top"]/table/tbody/tr/td[contains(text(),"jetons")]/text()');
                            
                #print "Gain: ".$gain."\n";

                if($value =~ / (\d?\d) jetons./)
                {
                    push (@gain, $1);
                }

                $tree->delete;

                #print "Gain: ".$gain."\n";
                
            }
            else
            {
                print "Le format d'url de la réponse n'est pas valide. On passe à la banniere suivante\n";
                next;
            }
        }
        else    
        {
            #²die "Erreur lors de l'analyse de la bannière";
            print "Erreur lors de l'analyse de la bannière ! On passe a la suivante.";
            next;
        }

    }

    return @gain;

}


sub Jeu
{
    my $status;
    my $grille;
    my $case;


    #appel du jeu
    print "Appel lancement du jeu: ";

    my($self) = @_;
    my $m = $$self;

   $m->get($link."/grille_gagnante.php");

    sleep(1);
    print "ok\n";

    my $tree = HTML::TreeBuilder->new_from_content ( $m->content );
        
    my $res = $tree->findvalue( '//a[contains(@onclick,"gg_clic")][1]/@onclick');
    
    #print "TEST: ".$res."\n";
    
    if($res =~ /gg_clic\((.*),(.*)\)/)
    {
       $grille = $1;
       $case = $2; 
    }
    else
    {
        die "Erreur lors de l'analyse";
    }

    print "grille: ".$grille." case: ".$case."\n";
    #$res = $tree->find( '//a[contains(@onclick,"gg_clic")]');
        
    $tree->delete;

    $m->get($link."/gg_clic.php?id_gg=".$grille."&id_case=".$case);
    sleep(1);

    $res = $m->text();

    #Supprime caractere non ascii (€ pose probleme)
    #voir pour encoder plutot
    $res =~ s/[^[:ascii:]]+//g;

    print $res."\n";

    if($res =~ /(\d\.\d\d\d?\d?)/)
    {
       $res = $1;
       $status = "OK";
       #print "Gain: ".$res." €\n";
    }
    elsif($res =~ /NOK/)
    {
        $status = "NOK";
        #print "Erreur: ".$res."\n";
    }
    else
    {
        die "Erreur lors de l'analyse";
    }

    return ($status,$res);
}

#Jetons gratuits par jour
# 9 jetons (9+0+0)
#1er chiffre: jetons gratuits par jour
#2eme chiffre: jetons grace aux filleuls
#3eme chiffre jetons payants
sub NombreJetons
{
    print "Infos membre jetons: ";

    my $res = 0;
    my $jetonsGratuits = 0;
    my $jetonsPayants = 0;

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_jetons.php");
    sleep(1);
    print "ok\n";

    $res = $m->text();
 
    #print "test: ".$res;
 
    if($res =~ /(.?.?.) jeton.? \(.+.+(.)\)/)
    {
       $jetonsGratuits = $1 - $2;
       $jetonsPayants = $2; 
    }
    else
    {
        print "Erreur lors de l'analyse";
    }
 
    return ($jetonsGratuits,$jetonsPayants);
}



sub NombreTotalPoints
{
    print "Appel total point: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_points.php");
    sleep(1);
    print "ok\n";

    my $res = $m->text();
 
    return $res;
}

sub NombreTotalEuros
{
    print "Appel total euros: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_euros.php");
    sleep(1);
    print "ok\n";

    my $res = $m->text();

    # modifier retour 
    return $res;
}

#Note: 30/12/12: appel direct page score fonctionne, pas besoin appel jeu et toussa :D

#ne marche pas, pas erreur mais rechargement page princiopale (jeux_site): viens du site ??
#$m->follow_link( xpath => '//a[@href="ticket_gratuit.php?game=3"]' );
#$m->follow_link( tag => 'a', href => 'ticket_gratuit.php?game=3' );
#$m->follow_link( "ticket_gratuit.php?game=3" );


#my $link = $m->xpath('substring(//a[contains(@onclick,"gg_clic")][1]/@onclick,1,6)',single => 1);
<>;
