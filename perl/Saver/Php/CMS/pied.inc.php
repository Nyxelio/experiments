<div id="pied">
<?php
include("./Configdb.inc.php");
mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);
$sql = mysql_query("SELECT COUNT(*) AS nb_membres FROM membres");
$donnee = mysql_fetch_array($sql);
?>
<img src="./img/membres.png" alt="membres">
<?php
echo "Il y a actuellement <strong>".$donnee['nb_membres']."</strong> membres.";
?>
<br>
<?php 
$sql = mysql_query("SELECT login FROM membres WHERE ID='".$donnee['nb_membres']."'");
$donnee = mysql_fetch_array($sql);
echo "Le dernier membre inscrit est ".$donnee['login'];
?>
</div> 