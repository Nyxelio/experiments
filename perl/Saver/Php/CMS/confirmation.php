<html>
<head>
<title>Confirmation</title>
 <link rel="stylesheet" type="text/css" media="screen" href="style.css" />
</head>
<body bgcolor="99BBFF">
<div id="entete">Confirmation</div>

<br>
<?php include ('./Configdb.inc.php'); ?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
	
<?php

if (isset($_GET["code"]) && isset($_GET["login"]))
{
	if (!empty($_GET["code"]) && !empty($_GET["login"]))
	{
		//recupere les donnees de l'url pour confirmation
		$code = $_GET["code"];
		$login = $_GET["login"];
		
		//connexion  au serveur et choix de la base de donnee 
		mysql_connect($host,$username,$passwrd);
		mysql_select_db($dbname);

		//requete de verification
		$sql = mysql_query("SELECT login,confirmation_code,confirmation FROM membres WHERE login='".$login."'");
		$donnees = mysql_fetch_array($sql);

		//si le compte n'as pas ete deja confirmé
		if($donnees['confirmation'] == 0)
		{
			//si le code fournit dans l'url est bon
			if($donnees["confirmation_code"] == $code)
			{
				$date = date('d/m/y');
				//requete de mise a jour du champ 'confirmation' (passe a 1) et'date'
				mysql_query("UPDATE membres SET confirmation=1,date='".$date."' WHERE login='".$login."'");
				$message =  "Le compte est maintenant confirmé !!";
			}
			else
			{
				$message =  "Le code ou le login n'est pas valide !!";
			}
		}
		else
		{
			$message =  "Le compte a déjà été validé !!";
		}
	}
}
else
{
	$message =  "Le code ou le login n'est pas valide !!";
}

?>
<center><u>Confirmation</u> :</center>
<br>
<p class="a"><?echo $message; ?></p>
<p class="a"><a href="./index.php">page d'accueil</a></p>
</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>