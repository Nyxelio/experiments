<? session_start();?>
<html>
<head>
<title>Confirmation</title>
 <link rel="stylesheet" type="text/css" media="screen" href="style.css" />
</head>
<body bgcolor="99BBFF">
<div id="entete">Modification de profil</div>

<br>
<?php include ('./Configdb.inc.php'); ?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">

<?
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

if(isset($_POST['motdepasse']) && !empty($_POST['motdepasse']))
{
	
	$login = htmlentities($_SESSION['logued'],ENT_QUOTES);
	$motdepasse = md5($_POST['motdepasse']);
	//vérification longueur mot de passe !!
	mysql_query("UPDATE membres SET motdepasse='".$motdepasse."' WHERE login='".$login."'");
}
if(isset($_POST['email']) && !empty($_POST['email']))
{
	echo $_SESSION['logued'];
	$login = htmlentities($_SESSION['logued'],ENT_QUOTES);
	//vérification email !!
	$email = htmlentities($_POST['email'],ENT_QUOTES);
	
	mysql_query("UPDATE membres SET email='".$email."' WHERE login='".$login."'");
}
?>

<form action="monProfil.php" method="post">
mot de passe : <br>
<input name="motdepasse" type="password">
email : <br>
<input name="email" type="text" ><br>
<input type="submit" value="Envoyer">
</form>



</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>