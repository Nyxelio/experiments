<div id="colonne3">
<center><u>Zone Membre :</u></center>


<?php
if (isset ($_SESSION['logued']) && !empty($_SESSION['logued']))
{
	echo '<p>Bienvenue <strong>'.$_SESSION['logued'].'</strong></p>';
	echo '<p><a href="./deconnexion.php">Déconnecter</a></p>';
	echo '<p><a href="profil.php?membre='.$_SESSION['logued'].'">Voir mon profil</a></p>';
	echo '<p><a href="monProfil.php">Modifier mon profil</a></p>';
}
	else
{
	echo '<p class="a">Bienvenue visiteur</p>';
	echo '<p><a href="./connexion.php">Se connecter</a></p>';
}
?>
</div>