<HTML>
<HEAD>
<TITLE>Le nombre caché</title>
</head>
<body>
<H2>JOUER AU NBRE CACHE entre 1000 et 9999</H2>
<form method="post" action="nbrecache.php">
<input name="entree" type="text">
<input type=submit value="Soumettre">
</form>
<?php

$nbrecache = 2540;
$i=0;
	$entree = $_POST['entree'];
	//while ($entree == $_POST['entree'])
	//{}
	//$entree = $_POST['entree'];
	echo $i+1 . ' : ';
if ($entree < $nbrecache)
	echo " plus !!<br>";
if ($entree > $nbrecache)
	echo " moins !! <br>";
if ($entree == $nbrecache)
	echo " bravo !! <br>";
$i++;
if ($i == 10)
	echo 'fini!!';
?>
</body>
</html>