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
#      CREATED:  08/01/2013 15:01:18 CET
#     REVISION:  ---
#===============================================================================

#06/01/2013:
# A FAIRE: junglokdo,grille gagnante,lapiwin
# barre de fidélité
# points bonus
# jetons gratuits
# base de donnee
# recuperer liste jeux et boucle
# Mechanize ?
# ovh ?
# d'autres site à parser


#08/01/2013
#infos_membre_jetons => 41 jetons (41+0+0)
#infos_membre_points = > 410 points FAIT
#infos_membre_gratuits et infos_membre_payants et infos_membre_euros n 'existent plus !!


use strict;
use warnings;
use WWW::Mechanize::Firefox;
use HTML::TreeBuilder::XPath;
#use Firefox::Application;

system("iceweasel &");

sleep(8);


my $m = WWW::Mechanize::Firefox->new(
#    launch => '/usr/bin/iceweasel',
     activate => 1,
    autocheck => 1); #foreground

sleep(2);

$m->autoclose_tab( 0 ); #laisse ouvert apres fin programme

my $link = "lapiwin.com";
my $response = $m->get($link);

if(!$response->is_success)
{
    die "Site inaccessible $link: ", $response->status_line, "\n";
}

&Connexion(\$m);

print "appel page principale: ";

#$m->follow_link( tag => 'a', href => 'les_jeux_site.php' );
$m->get($link."/les_jeux_site.php");

sleep(2);

print "ok\n";

my $jetonsGratuits;
my $jetonsPayants;
my $total_points;
my $gain;
my $type_gain;
#my $total_euros;

#Nombre de jetons gratuits
($jetonsGratuits,$jetonsPayants) = &NombreJetons(\$m);
print "Nombre de Jetons Gratuits: ".$jetonsGratuits."\n";
print "Nombre de Jetons Payants: ".$jetonsPayants."\n";

#Nombre de jetons payants
#$jetonsPayants = &NombreJetonsPayants(\$m);
#print "Nombre de Jetons Payants: ".$jetonsPayants."\n";


while ( $jetonsGratuits > 0)
{

    #Jeu 3
    ($gain,$type_gain) = &Jeu(\$m);
    print "Gain: ".$gain." ".$type_gain."\n";


    #Nombre de jetons gratuits
    ($jetonsGratuits,$jetonsPayants) = &NombreJetons(\$m);
    print "Nombre de Jetons Gratuits: ".$jetonsGratuits."\n";
    print "Nombre de Jetons Payants: ".$jetonsPayants."\n";


    #Nombre total de points
    $total_points = &NombreTotalPoints(\$m);
    print "Nombre total de points: ".$total_points."\n";

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


#sinon appel a chaque boucle
print "appel page principale: ";

#$m->follow_link( tag => 'a', href => 'les_jeux_site.php' );
$m->get($link."/les_jeux_site.php");

sleep(2);

print "ok\n";


#09/01/2013
my ($pourcentageBarreFidelite,$jourActu,$totalJours);
($pourcentageBarreFidelite,$jourActu,$totalJours) = &BarreFidelite(\$m);
print "Barre de fidélité: ".$pourcentageBarreFidelite." soit ".$jourActu."/".$totalJours."\n";

sub Connexion
{
    print "Connexion: ";

    my($self) = @_;
    my $m = $$self;

    #connexion OK
    $m->form_with_fields('email_connexion','mot_de_passe_connexion');
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

    #appel du jeu
    print "Appel lancement du jeu: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/xml/ticket_gratuit_score.php?id_jeu=3");

    sleep(1);
    print "ok\n";

    #print "Retour: ".$m->text()."\n";

    my $res = $m->text();
    my $type_gain;

    if ($res =~ /score=(\d?\d) (points|euros)/)
    {
        $res = $1;
        $type_gain = $2;
    }
    else
    {
        die "Erreur lors de l'analyse";
    }
    
    
    return ($res,$type_gain);
    
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

=begin
#Jetons payants
sub NombreJetonsPayants
{
    print "Infos membre payant: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_payants.php");
    sleep(1);
    print "ok\n";

    my $res = $m->text();
 
    #print "test: ".$res;

    return $res;
}
=cut

#Nombre total de points
sub NombreTotalPoints
{
    print "Appel total point: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_points.php");
    sleep(1);
    print "ok\n";

    my $res = $m->text();

    if($res =~ /(.*) points/)
    {
       $res = $1; 
    }
    else
    {
        print "Erreur lors de l'analyse";
    }
    
    return $res;
}

sub BarreFidelite
{
    print "Appel barre fidélité: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/barre_de_fidelite.php");
    sleep(1);
    print "ok\n";

    my $jourActu = 0;
    my $totalJours = 0;
    my $tree = HTML::TreeBuilder->new_from_content ( $m->content );
    
    my $res = $tree->findvalue( '//div[@class="corps_texte"]/center');
    
    $tree->delete;

    #print "TEST: ".$res."\n";

    if($res =~ m{Pourcentage.* : (.*%).*(..) jours sur (.?.)})
    {
        $res = $1;
        $jourActu = $2;
        $totalJours = $3;
    }

    return ($res,$jourActu,$totalJours);
    
}

=begin
sub NombreTotalEuros
{
    print "Appel total euros: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_euros.php");
    sleep(1);
    print "ok\n";

    my $res = $m->text();
 
    return $res;
}
=cut
#Note: 30/12/12: appel direct page score fonctionne, pas besoin appel jeu et toussa :D

#ne marche pas, pas erreur mais rechargement page princiopale (jeux_site): viens du site ??
#$m->follow_link( xpath => '//a[@href="ticket_gratuit.php?game=3"]' );
#$m->follow_link( tag => 'a', href => 'ticket_gratuit.php?game=3' );
#$m->follow_link( "ticket_gratuit.php?game=3" );


<>;
