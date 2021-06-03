<?php
echo'<title>Ecriture de fichiers : La difference</title>';
$entree1 = $_GET['entree1'];
$entree2 = $_GET['entree2'];
echo 'La difference vaut :  ';
$f=fopen("test.txt","a+");
if ($entree1 > $entree2)
{
	$sortie = $entree1 - $entree2;
	$var = $entree1 . ' - ' . $entree2;
	fwrite($f,$var);
}
else
{
	$sortie = $entree2 - $entree1;
	$var = $entree2 . ' - ' . $entree1;
	fwrite($f,$var);
}
echo $sortie;
fwrite($f," = ");
fwrite($f,$sortie);
fwrite($f,"\r\n");
fclose($f);
?>