<div id="colonne4">
<center><u>Livre d'or :</u></center>

<?php 
include("./Configdb.inc.php");
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

$sql = mysql_query('SELECT COUNT(ID) AS nb_id FROM livredor');
$donnee = mysql_fetch_array($sql);

$reponse = mysql_query('SELECT * FROM livredor WHERE ID="'.$donnee['nb_id'].'"');
$donnees = mysql_fetch_array($reponse);
echo '<p><strong>' . $donnees['login'] . '</strong> a écrit :<br />' . $donnees['message'] . '</p>';

mysql_close(); // On n'oublie pas de fermer la connexion à MySQL ;o)
?>
<br>
<center>---</center>
<br>
<center><a href="./livredor.php">Signez le livre !</a></center>
</div>