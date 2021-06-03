<? session_start()?>
<html>
<head>
<title>mini-chat</title>
 <link rel="stylesheet" type="text/css" media="screen" href="style.css" />
</head>
<body bgcolor="99BBFF">
<br>
<div id="entete">Mini-Chat</div>

<?php include ('./Configdb.inc.php'); ?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
<?php

if (isset($_SESSION['logued']) AND isset($_POST['message'])) // Si les variables existent
{
    if ($_SESSION['logued'] != NULL AND $_POST['message'] != NULL) // Si on a quelque chose à enregistrer
    {
	// D'abord, on se connecte à MySQL
       mysql_connect($host,$username,$passwrd);
       mysql_select_db($dbname);
	$message = htmlentities ($_POST['message'], ENT_QUOTES);
	$message = nl2br($message);
	$nom = htmlentities ($_SESSION['logued'], ENT_QUOTES);
	//On initialise la date:
	$dateEcr = date('[d-m à H:i]');
	// Ensuite on enregistre le message
        mysql_query("INSERT INTO minichat VALUES('', '$nom', '$message','$dateEcr')");

        // On se déconnecte de MySQL
        mysql_close();
	

	}
}
else
{
	$nom = "System";
	$message = "Bienvenue dans le chat";
}


?>

<center><u>Mini-Chat</u></center>

<form method="POST" action="chat.php">
<p class="a">
Pseudo :
<?
	if ($_SESSION['logued'])
	{
		echo '<strong>'.$_SESSION['logued'].'</strong>';
	}
	else
	{
		echo "<font color='red'>Vous n'êtes pas connecté.</font> Toute tentative d'ajout ne sera pas prise en compte.";
	}
?>
<br>
<label>
Message :<br>
<TEXTAREA name="message" rows="2" cols="19"></textarea></label>
<br>
<input type="submit" value="OK">
<input type="reset" value="Effacer"></p>
</form>
<center>---------------</center>
<?php

// Maintenant on doit récupérer les 10 dernières entrées de la table
// On se connecte d'abord à MySQL :
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

// On utilise la requête suivante pour récupérer les 10 derniers messages :
$reponse = mysql_query("SELECT * FROM minichat ORDER BY ID DESC LIMIT 0,10");

// On se déconnecte de MySQL
mysql_close();

// Puis on fait une boucle pour afficher tous les résultats :
while ($donnees = mysql_fetch_array($reponse) )
{
?>


<p>

<?php echo $donnees['date']; ?>
<strong>
<?php echo $donnees['login']; ?>
</strong> : 
<?php echo $donnees['message']; ?>
</p>
<?php
}
// Fin de la boucle, le script est terminé !
?>
</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>