<?php
mysql_connect("localhost","root");
mysql_select_db("minichat");

// On utilise la requête suivante pour récupérer les 10 derniers messages :
$reponse = mysql_query("DELETE minichat");

// On se déconnecte de MySQL
mysql_close();
?>