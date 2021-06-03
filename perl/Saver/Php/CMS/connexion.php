<?php session_start(); ?>
<html>
<head>
<title>
Connexion
</title>
<link rel="stylesheet" type="text/css" media="screen" href="style.css" >
<style type="text/css">
#colonne2{height:360px}

</style>
</head>
<body bgcolor="99BBFF">
<div id="entete">ACCUEIL</div>

<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
<center><u>Se connecter :</u></center><br><br>
<center>
<!--Formulaire de connexion-->
<form action="connexion.php" method="post">
<p class="a">
<label>Login :
<br>
<input name="login" type="text"></label>
<br>

<label>Mot de passe :
<br>
<input name="motdepasse" type="password"></label>
<br>

<label>Se souvenir de moi ?
<input name="souvenir" type="checkbox"></label>
<br>

<input name="B1" type="submit" value="OK">
<a href="./inscription.php">s'inscrire...</a>
</p>
</form>
<?php
if (isset($_POST["login"]) && isset($_POST["motdepasse"]))
{
	if(!empty($_POST["login"]) && !empty($_POST["motdepasse"]))
	{
		$login = htmlentities ($_POST["login"],  ENT_QUOTES);
		$motdepasse = htmlentities ($_POST["motdepasse"],  ENT_QUOTES);
		
		include('./Configdb.inc.php');
		
		//cryptage du mot de passe
		$motdepasse_hash = md5($motdepasse);
		
		//connexion au serveur
		mysql_connect($host,$username,$passwrd);
		
		//a la base de donnees
		mysql_select_db($dbname);
		
		//requete de correspondance 
		$sql = mysql_query("SELECT ID,login,motdepasse,confirmation FROM membres WHERE login='".$login."'");
		$donnees = mysql_fetch_array($sql);
		
		//si l'utilisateur existe
		if($login == $donnees["login"])
		{
			//si l'utilisateur existe et que c'est le bon mot de passe
			if($motdepasse_hash == $donnees["motdepasse"])
			{
					//test pour une confirmation egale a 1		
				if($donnees["confirmation"] == 1)
				{
					echo " bienvenue ".$login;
					$_SESSION['logued'] = $login;
					
				}
				else
				{
					echo "Votre compte n'a pas été validé !!";
				}
			}
			else
			{
				echo "mot de passe incorrect";
			}
		}
		else
		{
			echo "login incorrect";
		}
	}
	else
	{
		echo "mot de passe ou login incorrect";
	}
}
?>
</center>
</div>

<?php include("./pied.inc.php"); ?>
</body>
</html>