<? session_start()?>
<html>
<head>
<title>livredor</title>
 <link rel="stylesheet" type="text/css" media="screen" href="style.css" />
</head>
<body bgcolor="99BBFF">
<div id="entete">Livre d'or</div>

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

if (isset($_POST['login']) AND isset($_POST['message'])) // Si les variables existent
{
    if (!(empty($_POST['login'])) && !(empty($_POST['message']))) // Si on a quelque chose à enregistrer
    {
	// D'abord, on se connecte à MySQL
       mysql_connect($host,$username,$passwrd);
       mysql_select_db($dbname);
	$message = htmlentities ($_POST['message'], ENT_QUOTES);
	$message = nl2br($message);
	$nom = htmlentities ($_POST['login'], ENT_QUOTES);
	//On initialise la date:
	$dateEcr = date('[d-m à H:i]');
	// Ensuite on enregistre le message
        mysql_query("INSERT INTO livredor VALUES('', '$nom', '$message','$dateEcr')");

       
	

	}
}
else
{
	$nom = "System";
	$message = "Bienvenue dans le chat";
}


?>

<center><u>Livre d'or</u> :</center>

<?php if (isset($_SESSION['logued']) && !empty($_SESSION['logued']))
	{
	$nlogin = $_SESSION['logued'];
	}
	else
	$nlogin = "";
?>
<form method="POST" action="livredor.php">
<p><center>
Pseudo :
<br>
<? echo "<input name='login' type='text' size='25' value='".$nlogin."'>"; ?>
<br>
Message :<br>
<TEXTAREA name="message" rows="2" cols="19"></textarea>
<br>
<input type="submit" value="OK">
<input type="reset" value="Effacer"></center></p>
</form>

<br>
----------
<br>
Note: Les messages sont classés du plus récent au plus ancien.
<br>
----------

<br>

<?php
// Maintenant on doit récupérer les 10 dernières entrées de la table
// On se connecte d'abord à MySQL :
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

$reponse = mysql_query("SELECT COUNT(*) AS nb_messages FROM livredor");
$donnee = mysql_fetch_array($reponse);
$nbremessage = $donnee['nb_messages'];
$nbremessageparpage = 3;
$nbrepage = ceil($nbremessage / $nbremessageparpage);
for ($i = 1;$i<=$nbrepage;$i++)
{
	echo '<a href="livredor.php?page='.$i.'">'.$i.'</a>&nbsp;';
}

?>
<br>
<?php

// Maintenant on doit récupérer les 10 dernières entrées de la table
// On se connecte d'abord à MySQL :


// On utilise la requête suivante pour récupérer les 10 derniers messages :
if (isset($_GET['page']))
{
    $page = $_GET['page']; // On récupère le numéro de la page indiqué dans l'adresse (livreor.php?page=4)
}
else // La variable n'existe pas, c'est la première fois qu'on charge la page
{
    $page = 1; // On se met sur la page 1 (par défaut)
}

// On calcule le numéro du premier message qu'on prend pour le LIMIT de MySQL
$premierMessageAafficher = ($page - 1) * $nbremessageparpage;

$reponse = mysql_query('SELECT * FROM livredor ORDER BY ID DESC LIMIT ' . $premierMessageAafficher . ', ' . $nbremessageparpage);

while ($donnees = mysql_fetch_array($reponse))
{
    echo '<p>Le '.$donnees['date'].', <strong>' . $donnees['login'] . '</strong> a écrit :<br />' . $donnees['message'] . '</p>';
}
mysql_close(); // On n'oublie pas de fermer la connexion à MySQL ;o)

?>
2007-Fyrefauks-OrProjekt-v.Beta1 (NB: Ce sript n'est pas exempt de bugs)
</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>