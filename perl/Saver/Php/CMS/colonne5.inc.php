<div id="colonne5">
<center><u>Mini-Chat :</u></center>

<?php 
include("./Configdb.inc.php");
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

$sql = mysql_query('SELECT COUNT(ID) AS nb_id FROM minichat');
$donnee = mysql_fetch_array($sql);

$reponse = mysql_query('SELECT * FROM minichat WHERE ID="'.$donnee['nb_id'].'"');
$donnees = mysql_fetch_array($reponse);
echo '<p><strong>' . $donnees['login'] . '</strong> a �crit :<br />' . $donnees['message'] . '</p>';

mysql_close(); // On n'oublie pas de fermer la connexion � MySQL ;o)
?>
<br>
<center>---</center>
<br>
<center><a href="./livredor.php">Acc�der au Chat !</a></center>
</div>