<?session_start()?>
<html>
<head>
<title>Deconnexion</title>
 <link rel="stylesheet" type="text/css" media="screen" href="style.css" >
</head>
<body bgcolor="99BBFF">
<br>
<div id="entete">Deconnexion</div>

<?php include ('./Configdb.inc.php'); ?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
<?php
$_SESSION['logued'] = "";
?>
<center><u>D�connexion </u>:</center>
<br>
<p>
Vous �tes maintenant d�connect�.
<br>
<a href="index.php">Retourner � l'accueil</a>
</p>
</div>

<?php include("./pied.inc.php"); ?>

</body>
</html>