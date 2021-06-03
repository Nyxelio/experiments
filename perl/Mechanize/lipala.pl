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
#      CREATED:  25/12/2012 15:01:18 CET
#     REVISION:  ---
#===============================================================================

#06/01/2013:
# A FAIRE: junglokdo
#Flash
#MOZREPL
# base de donnee
# recuperer liste jeux et boucle
# Mechanize ?
# ovh ?
# d'autres site à parser
# gain a valider par mail
#messages
use strict;
use warnings;
use WWW::Mechanize::Firefox;
use HTML::TreeBuilder::XPath;
#use Firefox::Application;

system("iceweasel &");

sleep(8);

my $m = WWW::Mechanize::Firefox->new(
    #launch => '/usr/bin/iceweasel',
     activate => 1,
    autocheck => 1); #foreground

=begin
my $ff = Firefox::Application->new(
    launch => '/usr/bin/iceweasel');

my $tab = $ff->addTab(autoclose => 0);

sleep(2);

my $m = WWW::Mechanize::Firefox->new(
    tab => $tab,
    activate => 1,
    autocheck => 1); #foreground
=cut

sleep(2);

$m->autoclose_tab( 0 ); #laisse ouvert apres fin programme

my $link = "lipala.com";
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

my $jetonsGratuits = 0;
my $jetonsPayants = 0;
my $total_points;
my $total_euros;
my $gain;
my $type_gain;

#Nombre de jetons gratuits
$jetonsGratuits = &NombreJetonsGratuits(\$m);
print "Nombre de Jetons Gratuits: ".$jetonsGratuits."\n";

#Nombre de jetons payants
$jetonsPayants = &NombreJetonsPayants(\$m);
print "Nombre de Jetons Payants: ".$jetonsPayants."\n";


while ( $jetonsGratuits > 0)
{
    #Jeu 3
    ($gain,$type_gain) = &Jeu(\$m);
    print "Gain: ".$gain." ".$type_gain."\n";

    #Nombre de jetons gratuits
    $jetonsGratuits = &NombreJetonsGratuits(\$m);
    print "Nombre de Jetons Gratuits: ".$jetonsGratuits."\n";

    #Nombre de jetons payants
    $jetonsPayants = &NombreJetonsPayants(\$m);
    print "Nombre de Jetons Payants: ".$jetonsPayants."\n";

    #Nombre total de points
    $total_points = &NombreTotalPoints(\$m);
    print "Nombre total de points: ".$total_points."\n";

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

#validation banniere pour jetons
my @jetons_banniere = &ValidationBanniereJetons(\$m);

foreach my $jeton (@jetons_banniere)
{
    print "Gain: ".$jeton." jetons\n";
}



# A VOIR: LES BANNIERES DISPARRAISSENT...
#Sinon appel a chaque boucle
#$m->follow_link( tag => 'a', href => 'les_jeux_site.php' );
print "appel page principale: ";
$m->get($link."/les_jeux_site.php");

sleep(2);

print "ok\n";


#09/01/2013
my ($pourcentageBarreFidelite,$jourActu,$totalJours);
($pourcentageBarreFidelite,$jourActu,$totalJours) = &BarreFidelite(\$m);
print "Barre de fidélité: ".$pourcentageBarreFidelite." soit ".$jourActu."/".$totalJours."\n";

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

    #appel du jeu
    print "Appel lancement du jeu: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/xml/ticket_gratuit_score.php?id_jeu=3");

    sleep(1);
    print "ok\n";

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
# (9+0)
#1er chiffre: jetons gratuits par jour
#2eme chiffre: jetons grace aux filleuls
sub NombreJetonsGratuits
{
    print "Infos membre gratuit: ";

    my($self) = @_;
    my $m = $$self;

    $m->get($link."/infos_membre_gratuits.php");
    sleep(1);
    print "ok\n";

    my $res = $m->text();
 
    if($res =~ /(.?.) \(.+.\)/)
    {
       $res = $1; 
    }
    else
    {
        print "Erreur lors de l'analyse";
    }
 
    return $res;
}

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

    return $res;
}

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
#Note: 30/12/12: appel direct page score fonctionne, pas besoin appel jeu et toussa :D

#ne marche pas, pas erreur mais rechargement page princiopale (jeux_site): viens du site ??
#$m->follow_link( xpath => '//a[@href="ticket_gratuit.php?game=3"]' );
#$m->follow_link( tag => 'a', href => 'ticket_gratuit.php?game=3' );
#$m->follow_link( "ticket_gratuit.php?game=3" );


=begin
#Note: 19/01/2013: FONCTIONNE mais inutile
        print "Nécessite une opération...\n";

        print "TEST: ".$counter."\n";     

        if($counter =~ /(.) \+ (.*) = \?/)
        {
            print "opération: ".$counter."\n";
            #print $1." ".$2."\n";
            $counter = $1 + $2;
            print "resultat: ".$counter."\n";
        }
        else    
        {
            die "Erreur lors de l'analyse";
        }
    

        #resultat dans l'url ne correspond pas au vrai resultat.
        #sauf vrai resultat. a verifier au futur 
        # ne change rien puisque condition sur le résultat
        $counter = $tree->findvalue('//div[@id="Counter"]/a[text() = '.$counter.']/@href');
        print "url: ".$counter."\n";

        $m->get($link."/jeuxcmul.php".$counter);
    
        print "Gain: ".$m->content."\n";
        # A MODIFIER
=cut
        #DOM est specifique a firefox aussi donc ne change rien si js ou DOM
        # voir plus tard pour DOM si on se passe de firefox
          #https://developer.mozilla.org/en-US/docs/Gecko_DOM_Reference/Introduction#How_Do_I_Access_the_DOM.3F 
   
=begin
        if ($frame =~ /Nous vous invitons a revenir/)
        {
            print "La page n'est pas cliquable aujourd'hui\n";
        }
        else
        {
            #C'est parti pour des clics
        }
=cut
    #print "DOM:".$m->document();
    
#partie clic, mettre ClicsOK a 1 pour afficher partie operation puis traitement operation
#ou lire variable JS Text_Redirection_Counter, puis traitement operation
# A TESTER       
#$m->allow( subframes => 1);
# $content = $m->xpath('//', frames => 1);

#modifier ClicsOK manuellement dans firebug declenche questions+clics



<>;
