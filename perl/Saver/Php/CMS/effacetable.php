<?php
mysql_connect("localhost","root");
mysql_select_db("minichat");

// On utilise la requ�te suivante pour r�cup�rer les 10 derniers messages :
$reponse = mysql_query("DELETE minichat");

// On se d�connecte de MySQL
mysql_close();
?>