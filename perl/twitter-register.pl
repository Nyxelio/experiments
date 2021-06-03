#!/usr/bin/perl
 
 use Net::Twitter::OAuth;
  
  #On Initialise L'objet Net::Twitter::OAuth
  my $client = Net::Twitter::OAuth->new(
      consumer_key => "AaLiTzRxVcJVnQLiwycgg",
          consumer_secret => "TcmEPikdr3hJHMfIChfeIOj82p235F4yNFl7qtImzQ",
          );
          #On affiche les clé CONSUMER
          print "consumer_key = ".$client->consumer_key."\n";
          print "consumer_secret = ".$client->consumer_secret."\n";
           
           #On récupère l'URL pour autorisation de l'application
           $url_pin = $client->get_authorization_url;
           print "URL AUTORISATION D'AUTORISATION DE L'APPLICATION = ".$url_pin."\n";
           $pin = <STDIN>;
           print "PIN = ".$pin."\n";
           chomp $pin;
            
            #INIT DU TOKEN AVEC LE PIN
            ($access_key, $access_secret) = $client->request_access_token(verifier => $pin);
             
             #MAJ de client - Facultatif
             if ($access_key && $access_secret) {
                   $client->access_token($access_key);
                         $client->access_token_secret($access_secret);
                         }
                          
                          print "access_token = ".$client->access_token."\n";
                          print "Access_token_secret = ".$client->access_token_secret."\n";
