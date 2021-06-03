<?php
if (isset($_GET["btRecherche"]) and ($_GET["btRecherche"]==1)) {
			if (!empty($_GET["keyword"]) and isset($_GET["keyword"])) {
				$req = mysql_query("SELECT DISTINCT ".$_GET["selectRecherche"]." FROM " .$TABLE." WHERE ".$_GET["selectRecherche"]." LIKE '%" .$_GET["keyword"]. "%' Order by ".$_GET["selectRecherche"]." Asc ") or die("Erreur SQL");
				$res = mysql_num_rows($req);

				if(empty($res)){
					echo"Désolé mais aucun résultat ne correspond à votre demande";
								}
				else{
					if ($res == 1) {
						echo''.$res.' résultat<br>';
									}
					elseif($res >1){
						echo''.$res.' résultats<br>';
									}
					while($result = mysql_fetch_array($req))
					{
						//afficher résultats avec lien....
      					 echo "<a href='./index.php?".$_GET["selectRecherche"]."=".$result[$_GET["selectRecherche"]]."'>".$result[$_GET["selectRecherche"]]."</a>";
					}


					}
				}
			}


?>


<form action='./recherche.php' method="get">
<input type="text" name="rec">
<select name="sel">
<option value="artiste">artiste</option>
<option value="album">album</option>
<option value="annee">année</option>
<option value="titre">titre</option>
<option value="auteur">auteur</option>
<option value="auteur2">auteur2</option>
<option value="auteur3">auteur3</option>
<option value="auteur4">auteur4</option>
<option value="auteur5">auteur5</option>
</select>
<input type="submit" value="Rechercher">
</form>