<?php
$textcolor = "#E0C0E0C0";
$fichier = " compteur.txt";
$f = fopen($fichier, "r");
$nbvisites = fread($f,4);
echo '<font color='.$textcolor.'>';
echo 'Vous etes le '.$nbvisites.' ieme visiteur . Bonne Journée !';
echo '</font>';
fclose($f);
$f = fopen($fichier, "w");
$nbvisites++;
fwrite($f,$nbvisites);
fclose($f);
?>
