<? session_start();?>
<HTML>
<HEAD>
<TITLE>Page d'accueil</title>
<link rel="stylesheet" type="text/css" media="screen" href="style.css" >
</head>
<body bgcolor="99BBFF">



<div id="entete">ACCUEIL</div>



<?include("./Configdb.inc.php")?>
<?php include("./bar.inc.php"); ?>
<?php include("./colonne1.inc.php"); ?>
<?php include("./colonne3.inc.php"); ?>
<?php include("./colonne4.inc.php"); ?>
<?php include("./colonne5.inc.php"); ?>
<?php include("./colonne6.inc.php"); ?>

<div id="colonne2">
<p class='a'>
<br>
Bienvenue sur le site !!
<br>
<br>
<br>
LES NEWS :
<br></p>

<?php include ('./news.php'); ?>

</div>


<?php include("./pied.inc.php"); ?>

</body>
</html> 