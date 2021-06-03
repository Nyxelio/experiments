<? session_start()?>
<html>
<head>
<title>Membres</title>
 <link rel="stylesheet" type="text/css" media="screen" href="style.css" />
</head>
<body bgcolor="99BBFF">
<div id="entete">Membres</div>

<br>
<?php include ('./Configdb.inc.php'); ?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
<center><u>Liste des membres inscrits</u></center>
<br>
<?php
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);
$sql = mysql_query("SELECT login,email FROM membres ORDER BY ID DESC");


while($donnee = mysql_fetch_array($sql))
{
	echo '<p>'.$donnee['login'].' <a href="./profil.php?membre='.$donnee['login'].'">Voir la fiche</a> <a href="mailto:'.$donnee['email'].'">Contacter ce membre</a></p>';
}

?>
</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>