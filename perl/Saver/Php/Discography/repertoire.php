<?php recursive_readdir("./"); ?>
<html>
<head>
<title>contenu du FTP:</title>
</head>
<body>
<?php recursive_readdir('/'); ?>
</body>
</html>

<?php
//Source tout simple permettant d'afficher un repertoire et ses sous-repertoires (recursivement).
//Une mise en forme sommaire l'accompagne.
function recursive_readdir ($dir) {
 $dir = rtrim ($dir, '/'); // on vire un eventuel slash mis par l'utilisateur de la fonction a droite du repertoire
 if (is_dir ($dir)) // si c'est un repertoire
  $dh = opendir ($dir); // on l'ouvre
 else {
  echo $dir, ' n\'est pas un repertoire valide'; // sinon on sort! Appel de fonction non valide
  exit;
  }
 while (($file = readdir ($dh)) !== false ) { //boucle pour parcourir le repertoire 
  if ($file !== '.' && $file !== '..') { // no comment
   $path =$dir.'/'.$file; // construction d'un joli chemin...
   if (is_dir ($path)) { //si on tombe sur un sous-repertoire
    echo '<p style="font-weight: bold; border : 1pt solid #000000;">', $path, ' 
-> dir</p>'; // ptit style...
    echo '<div style="padding-left: 20px; border: 1pt dashed #000000;">'; // idem...
    recursive_readdir ($path); // appel recursif pour lire a l'interieur de ce sous-repertoire
    echo '</div><br />';
   }
   else
    echo $path, '<br />'; // si il s'agit d'un fichier, on affiche, tout simplement.
  }
 }
 closedir ($dh); // on ferme le repertoire courant
} 
?>
