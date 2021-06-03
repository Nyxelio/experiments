
<div id="bar">

<img src="./img/membres.png">
<a class="barA" href="./index.php">Accueil</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="./img/membres.png">
<a class="barA" href="./connexion.php">Se connecter</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="./img/membres.png">
<a class="barA" href="./inscription.php">S'inscrire</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="./img/membres.png">
<a class="barA" href="./livredor.php">Signer le livre d'or</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="./img/membres.png">
<a class="barA" href="./membres.php">Liste des membres</a>
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="./img/membres.png">

<?php
if (isset($_SESSION['logued']) && !empty($_SESSION['logued']))
{
	echo '<a class="barA" href="./Profil.php">Mon Profil</a>';
}
else
{
	echo '<font color="grey">Mon Profil</font>';
}
?>
<div id="right"> Il est :
<?php
echo date('H:i');
?>
</div>
</div>

