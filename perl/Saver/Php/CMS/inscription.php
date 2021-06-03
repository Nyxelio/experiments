<?php session_start(); ?>
<html>
<head>
<title>Formulaire d'inscription</title>
<link rel="stylesheet" type="text/css" media="screen" href="style.css" >
</head>
<body bgcolor="99BBFF">
<div id="entete">Inscription</div>
<?php include("./Configdb.inc.php"); ?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
<?php
if(isset($_POST["login"]) && isset($_POST["motdepasse"]) && isset($_POST["email"]))
{
	if(!empty($_POST["login"]) && !empty($_POST["motdepasse"]) && !empty($_POST["email"]))
	{
		$login = trim($_POST["login"]);
		$motdepasse = trim($_POST["motdepasse"]);
		$email = trim($_POST["email"]);
		
		if(strlen($login) > 3 && strlen($login) < 35)
		{
			if(strlen($motdepasse) > 4 )
			{
				//transforme en html
				$login = htmlentities($login, ENT_QUOTES);
				$motdepasse_hash = htmlentities($motdepasse, ENT_QUOTES);
				
				//crypte le mot de passe
				$motdepasse_hash = md5($motdepasse_hash);
				
				//connecte au serveur sql et selectionne la base de donnee 
				mysql_connect($host,$username,$passwrd);
				mysql_select_db($dbname);
				
				//requete pour voir si le login existe déjà
				$sql = mysql_query("SELECT COUNT(*) AS nb_login FROM membres WHERE login='".$login."'");
				$donnees = mysql_fetch_array($sql);
				
				//si le login n'existe pas 
				if ($donnees["nb_login"] == 0)
				{
					//creation du code de confirmation
					$lettre_chiffre = "abcdefghijklmnopqrstuvwxyz0123456789";
					$lettre_chiffre_melangee = str_shuffle($lettre_chiffre);
					$codeConfirmation = substr($lettre_chiffre_melangee,1,10);
					
					//enregistrement des donnees du nouvel utilisateur
					$sql = mysql_query("INSERT INTO membres (login,motdepasse,email,confirmation_code,confirmation,date) VALUES ('".$login."','".$motdepasse_hash."','".$email."','".$codeConfirmation."',0,'')");
					
					
					
					//envoi de mail
					 
                    $message = 'Bonjour '.$login.'
								Votre compte a été créé correctement, il ne vous reste qu\'à l\'activer.
								Pour l\'activer vous pouvez cliquer sur le lien ci-dessous ou le copier/coller dans votre navigateur:
								http://localhost/confirmation.php?code='.$codeConfirmation.'&login='.$login.'
								Après l\'activation vous pourrez vous connecter à http://localhost en utilisant le nom d\'utilisateur et le mot de passe suivant:
								
								Nom d\'utilisateur : '.$login.'
								
								Mot de passe : '.$motdepasse;
                               
                                    //Si le mail a été envoyé on peut enregistrer le membre
                                    if (mail($email, 'Confirmation de l\'inscription sur [Nom_du_site]', $message) or die("Erreur !"))
									{
									$message= "votre compte a été créé!";
									}
									else
									{
									$message= "erreur lors de l'envoi";
									}
				}						
				else
				{
					$message= "le login spécifié est déjà utilisé";
				}
				mysql_close();
			}
			else
			{
				$message= "Votre mot de passe n'est pas assez grand";
			}
		}
		else
		{
			$message= "Votre login n'est pas aux normes indiqués ( de 4 à 35 caractères )";
		}
	}
	else
	{
		$message= "Veuillez remplir tous les champs indiqués.";
	}
}
else
{
$message="";
}
?>
<center> Formulaire d'inscription<br>--------</center>
<!--Formulaire d'inscription-->

<form action="inscription.php" method="post">
<p class="a">
<label>Votre login : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name="login" type="text"></label>
<br>
<br>
<label>Votre mot de passe :
<input name="motdepasse" type="password"></label>
<br>
<br>
<label>votre email :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name="email" type="text"></label>
<br>
<br>
<input type="submit" value="Envoyer">
</p>
</form>

<?echo '<font color="red">'.$message.'</font>';?>
</div>
<?php include("./pied.inc.php"); ?> 


</body>
</html>