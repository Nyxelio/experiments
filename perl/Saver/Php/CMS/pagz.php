<?php
$nom = $_POST['nom'];
$prenom = $_POST['prenom']; 
$user_entries = $_POST['s1'];
$date = date("H:i");
echo 'Bienvenue '.$prenom.' '.$nom;
echo '<br>';
echo 'il est '.$date;
echo '<br>';
echo 'vous etes : '.$user_entries;
echo '<br>';
?>