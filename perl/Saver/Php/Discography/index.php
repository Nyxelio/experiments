<?php include("./config.inc.php"); ?>

<html>
<head>
  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
  <link rel="stylesheet" href="style_v2.css" type="text/css" media="screen">
  <title>Accueil</title>


<?php include("./menu.inc.php"); ?>

<!--fonction pour les popups-->
<script language="javascript">
function pop (i_url,i_title)
{
fenetre_image=window.open(i_url,i_title,'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=15,top=15');
fenetre_image.focus();
}
</script>

</head>

<body>


<div class="fond_banniere">
	<a href="./index.php">
		<div class='banniere'>
		</div>
	</a>
</div>

	<div class="navigation_top">
		<ul>
			<li><a href="./index.php">Accueil</a></li>
			<li><a href="./Ajout.php">Ajout</a></li>
			<li><a href="./Edition.php">Edition</a></li>
			
		</ul>
	</div>
	
<div id="page">
	<div class="info_left">
		<div class="menu">
			RECHERCHER:(<a href="./index.php?Adv=1">Avancé ?</a>)
			<FORM name=monform>
				<INPUT type=text name=search size="22">
				<input type=submit value="OK"><BR><br>
	
				<SCRIPT language=javascript>
					Liste.Afficher();
					ListeCheck();
				</SCRIPT>

			</FORM>
		</div>

		<div class="navigation_left">
			<ul>
				<li><a href="./index.php">Accueil</a></li>
				<li><a href="./Ajout.php">Ajout</a></li>
				<li><a href="./Edition.php">Edition</a></li>
			</ul>
		</div>
	</div>
	<div class='info'>

<?php

//Passage en argument: Artiste-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		$diffAlb = "";
		if(isset($_GET["Artiste"]) and !empty($_GET["Artiste"]))
		{
			echo "<div class='titreInfo'>";
			//on affiche les infos correspondantes
			$req = mysql_query("SELECT DISTINCT Album,Année,Image FROM ".$TBL_ALB." WHERE Artiste='".$_GET["Artiste"]."'") or Die(mysql_error());
			$res = mysql_num_rows($req);

			if ($res == 1)
			{
				echo "<u><b>".$res." Album</b></u>";
			}
			elseif($res >1)
			{
				echo "<u><b>".$res." Albums</b></u>";
			}
			$link = "./information.php?Biographie=".$_GET["Artiste"];
			echo " pour l'artiste <u><b><a id='artbio' href=Javascript:pop('".$link."','Biographie');>".$_GET["Artiste"]."</a></b></u>:";
			echo "</div>";

			while ($result = mysql_fetch_array($req))
			{

				if ($diffAlb != $result["Album"]) //Le titre fait-il parti du même album ?
				{
					echo "<div class='contenu'>";
					$diffAlb = $result["Album"];
					echo "<div class='img_album'>";
					if (!empty($result["Image"]) and isset($result["Image"]))
					{
						echo "<img src='./images/".$result["Image"]."' width='200px' height='200px' />";
					}
					else
					{
						echo "<img src='./src/images/image_non_disponible.png'/>";
					}
					echo "</div>";
					echo "<div class='contenu_niv2'>";
					echo "<u>".$result["Année"]." - ".$result["Album"]."</u>:<br>";

					//on affiche les infos correspondantes aux titres
					$reqTitre = mysql_query("SELECT DISTINCT Album,Num,Titre,Type FROM " .$TBL_TIT. " WHERE Album='".$result["Album"]."' ORDER BY Num ASC") or Die(mysql_error());

					while ($resultTitre = mysql_fetch_array($reqTitre))
					{
						echo "<font color=navy>".$resultTitre["Num"].". ".$resultTitre["Titre"]."</font>";
						echo " | ".$resultTitre["Type"]." | ";
						echo "<a href='./information.php?Texte=".$resultTitre["Titre"]."&Album=".$resultTitre["Album"]."'>Txt</a> | ";
						echo "<a href='./information.php?Son=".$resultTitre["Titre"]."&Album=".$resultTitre["Album"]."'>Mus</a> | ";
						echo "<a href='./information.php?Video=".$resultTitre["Titre"]."&Album=".$resultTitre["Album"]."'>Vid</a> | ";
						echo "<br>";
						//placement de if pour Txt Mus et Vid si lien est NULL ou pas, grisé.
						
					}
					echo "</div>";
					echo "</div>";
				}


			}

		}

//Recherche avancée-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		elseif (isset($_GET["Adv"]))
		{
			echo "<div class='titreInfo'>Recherche Avancée:</div>";
			echo "<div class='contenu'>";
			
			echo "<form action='./index.php' method=\"get\">\n";
			echo "<input type=\"text\" name=\"rec\">\n";
			echo "<select name=\"sel\">\n";
			echo "<option value=\"Artiste\">artiste</option>\n";
			echo "<option value=\"Album\">album</option>\n";
			echo "<option value=\"Année\">année</option>\n";
			echo "<option value=\"Titre\">titre</option>\n";
			echo "<option value=\"Auteur\">auteur</option>\n";
			echo "<option value=\"Auteur2\">auteur2</option>\n";
			echo "<option value=\"Auteur3\">auteur3</option>\n";
			echo "<option value=\"Auteur4\">auteur4</option>\n";
			echo "<option value=\"Auteur5\">auteur5</option>\n";
			echo "</select>\n";
			echo "<input type='submit' value='Rechercher' name='Adv'>\n";
			echo "</form>\n";

			echo "<br>\n";

			echo "<form action='./index.php' method='get'>\n";


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
			else
			{
				echo "<br>";
				echo "<select size='10' style='width:500'></select>";
				
			}
			
			echo "<br>";
			echo "<input type=\"submit\" value=\"Valider\">\n";
			echo "</form>\n";
			echo "</div>";
		}
		
		
//page d'accueil-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		else
		{
			echo "<div class='titreInfo'>Accueil</div>";
			echo "<div class='contenu'>";
			$req = mysql_query("SELECT DISTINCT Artiste,Album,Image FROM ".$TBL_ALB." LIMIT 0,29") or Die(mysql_error());
			while ($result = mysql_fetch_array($req))
			{
				echo "<div class='img_album'>";
				echo "<a href='./index.php?Artiste=".$result["Artiste"]."'>";
				if (!empty($result["Image"]) and isset($result["Image"]))
				{	
					echo "<img src='./images/".$result["Image"]."' width='200px' height='200px' />";	
				}
				else
				{
					echo "<img src='./src/images/image_non_disponible.png'/>";
				}
				echo "</a>";	
				echo "</div>";
			}
			
		}
?>
	
		<div class="foot">
			<div class="foot_contenu">
				<img src="./src/images/nbre_sauv.gif"/>
				<?php
				$reqArtiste =  mysql_query("SELECT DISTINCT Artiste FROM ".$TBL_BIO." ORDER BY Artiste");
				$result=mysql_num_rows($reqArtiste);
				echo $result." Artistes, ";
				$req = mysql_query("SELECT DISTINCT Album FROM ".$TBL_ALB."");
				$result=mysql_num_rows($req);
				echo $result. " Albums et ";
				$req = mysql_query("SELECT DISTINCT Titre FROM ".$TBL_TIT."");
				$result=mysql_num_rows($req);
				echo $result. " Titres sont enregistrés dans la base ";
				?>
		
			</div>	
			
			<div class="foot_logo">
			<img id="logo" src="./src/images/logo_wire-small.png"/>
			</div>	
			</a>
		</div>
		</div>
	</div>


</div>

</body>
</html>
<?php
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
<?php mysql_close();?>
