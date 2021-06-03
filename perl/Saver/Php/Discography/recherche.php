<? include("./config.inc.php"); ?>
<html>
<head><title>titre</title></head>
<body>
<form action='./recherche.php' method="get">
	<input type="text" name="rec">
	<select name="sel">
		<option value="Artiste">artiste</option>
		<option value="Album">album</option>
		<option value="Année">année</option>
		<option value="Titre">titre</option>
		<option value="Auteur">auteur</option>
		<option value="Auteur2">auteur2</option>
		<option value="Auteur3">auteur3</option>
		<option value="Auteur4">auteur4</option>
		<option value="Auteur5">auteur5</option>
	</select>
	<input type="submit" value="Rechercher">
</form>

<br>

<form action='./index.php' method='get'>

	<?php
	if(isset($_GET["rec"]) and !empty($_GET["rec"]))
	{
		//code
		if($_GET["sel"] == "Artiste")
		{
			$req = mysql_query("SELECT DISTINCT Artiste FROM ".$TBL_ALB." WHERE Artiste LIKE '%".$_GET["rec"]."%' Order by Artiste Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Artiste)<br>";
			echo "<select name='Artiste' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Artiste"]."'>".$result["Artiste"]."</option>";
				//pourquoi affichage blanc 
			}
			echo "</select>";
		}
		elseif($_GET["sel"] == "Album")
		{
			$req = mysql_query("SELECT DISTINCT Artiste,Album,Année FROM ".$TBL_ALB." WHERE Album LIKE '%".$_GET["rec"]."%' Order by Album Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Album)<br>";
			echo "<select name='Album' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Album"]."'>".$result["Album"]."(".$result["Année"].") - ".$result["Artiste"]."</option>";
			}
			echo "</select>";			
		}
		
		if($_GET["sel"] == "Année")
		{
			$req = mysql_query("SELECT DISTINCT Artiste,Album,Année FROM ".$TBL_ALB." WHERE Année LIKE '%".$_GET["rec"]."%' Order by Année Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Année)<br>"; 
			echo "<select name='Année' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Année"]."'>".$result["Année"]." - ".$result["Album"]."(".$result["Artiste"].")</option>";
			}
			echo "</select>";			
		}
		
		if($_GET["sel"] == "Titre")
		{
			$req = mysql_query("SELECT DISTINCT Titre,Album FROM ".$TBL_TIT." WHERE Titre LIKE '%".$_GET["rec"]."%' Order by Titre Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Titre)<br>"; 
			echo "<select name='Titre' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Titre"]."'>".$result["Titre"]." (".$result["Album"].")</option>";
			}
			echo "</select>";	
		}
		if($_GET["sel"] == "Auteur")
		{
			$req = mysql_query("SELECT DISTINCT Auteur1,Album FROM ".$TBL_TIT." WHERE Auteur1 LIKE '%".$_GET["rec"]."%' Order by Auteur1 Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Auteur)<br>"; 
			echo "<select name='Auteur' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Auteur1"]."'>".$result["Auteur1"]." - ".$result["Album"]."</option>";
			}
			echo "</select>";	
		}
		if($_GET["sel"] == "Auteur2")
		{
			$req = mysql_query("SELECT DISTINCT Auteur2,Album FROM ".$TBL_TIT." WHERE Auteur2 LIKE '%".$_GET["rec"]."%' Order by Auteur2 Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Auteur2)<br>"; 
			echo "<select name='Auteur2' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Auteur2"]."'>".$result["Auteur2"]." - ".$result["Album"]."</option>";
			}
			echo "</select>";
		}
		if($_GET["sel"] == "Auteur3")
		{
			$req = mysql_query("SELECT DISTINCT Auteur3,Album FROM ".$TBL_TIT." WHERE Auteur3 LIKE '%".$_GET["rec"]."%' Order by Auteur3 Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Auteur3)<br>"; 
			echo "<select name='Auteur3' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Auteur3"]."'>".$result["Auteur3"]." - ".$result["Album"]."</option>";
			}
			echo "</select>";
		}
		if($_GET["sel"] == "Auteur4")
		{
			$req = mysql_query("SELECT DISTINCT Auteur4,Album FROM ".$TBL_TIT." WHERE Auteur4 LIKE '%".$_GET["rec"]."%' Order by Auteur4 Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Auteur4)<br>"; 
			echo "<select name='Auteur4' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Auteur4"]."'>".$result["Auteur4"]." - ".$result["Album"]."</option>";
			}
			echo "</select>";
		}
		if($_GET["sel"] == "Auteur5")
		{
			$req = mysql_query("SELECT DISTINCT Auteur5,Album FROM ".$TBL_TIT." WHERE Auteur5 LIKE '%".$_GET["rec"]."%' Order by Auteur5 Asc ") or Die(mysql_error());
			$res = mysql_num_rows($req);

			nbreResultat($res);
			echo " (par Auteur5)<br>"; 
			echo "<select name='Auteur5' size='10' style='width:500'>";
			while($result = mysql_fetch_array($req))
			{
				//afficher résultats avec lien....
				echo "<option value='".$result["Auteur5"]."'>".$result["Auteur5"]." - ".$result["Album"]."</option>";
			}
			echo "</select>";
		}
	}
	function nbreResultat($nbre)
	{
		if(empty($nbre))
		{
			echo "Désolé mais aucun résultat ne correspond à votre demande";
		}
		else
		{
			if ($nbre == 1) 
			{
				echo''.$nbre.' résultat:';
			}
			elseif($nbre >1)
			{
				echo''.$nbre.' résultats:';
			}
		}
	}
?>	
	<input type="submit" value="Valider">
</form>
</body>