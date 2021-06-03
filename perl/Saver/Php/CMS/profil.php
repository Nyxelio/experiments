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
<?php
if (isset($_GET['membre']) && !empty($_GET['membre']))
{
	$membre = htmlentities($_GET['membre'],ENT_QUOTES);
}
else
{
	$membre = $_SESSION['logued'];
}
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

$sql = mysql_query("SELECT * FROM membres WHERE login ='".$membre."'");
if($donnees = mysql_fetch_array($sql))
{
	echo 'Fiche de profil de <u>'.$membre.'</u> :';
	echo '<br>Son email : '.$donnees['email'];
	echo '<br>Inscrit le : '.$donnees['date'];
}
else
{
	echo "n'existe pas !!";
}
?>
</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>