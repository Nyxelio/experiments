<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<? include("./config.inc.php"); ?>

<html>
<head>
  <meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
  <title>Ajout</title>
</head>

<body>

<?php
$error="";
if ((isset($_POST['artiste']) and !empty($_POST['artiste'])))
{
  if (isset($_POST['album']) and !empty($_POST['album']))
  {
	if (isset($_POST['année']) and !empty($_POST['année']))
	{
		if (isset($_POST['titre']) and !empty($_POST['titre']))
		{
			if (isset($_POST['auteur']) and !empty($_POST['auteur']))
			{
				$artiste = addslashes($_POST['artiste']);
				$album = addslashes($_POST['album']);
				$annee = addslashes($_POST['année']);
				$num = $_POST['num'];
				$titre = addslashes($_POST['titre']);
				$type = $_POST['type'];
				$auteur = addslashes($_POST['auteur']);


				if (isset($_POST['auteur2']) and !empty($_POST['auteur2']))
				{
					$auteur2 = addslashes($_POST['auteur2']);
				}
				else
				{
					$auteur2 = "";
				}

				if (isset($_POST['auteur3']) and !empty($_POST['auteur3']))
				{
					$auteur3 = addslashes($_POST['auteur3']);
				}
				else
				{
					$auteur3 = "";
				}

				if (isset($_POST['auteur4']) and !empty($_POST['auteur4']))
				{
					$auteur4 = addslashes($_POST['auteur4']);
				}
				else
				{
					$auteur4 = "";
				}

				if (isset($_POST['auteur5']) and !empty($_POST['auteur5']))
				{
					$auteur5 = addslashes($_POST['auteur5']);
				}
				else
				{
					$auteur5 = "";
				}

				if (isset($_POST['image']) and !empty($_POST['image']))
				{
					$image = addslashes($_POST['image']);
				}
				else
				{
					$image = "";
				}

				if (isset($_POST['son']) and !empty($_POST['son']))
				{
					$son = addslashes($_POST['son']);
				}
				else
				{
					$son = "";
				}

				if (isset($_POST['video']) and !empty($_POST['video']))
				{
					$video = addslashes($_POST['video']);
				}
				else
				{
					$video = "";
				}

				if (isset($_POST['texte']) and !empty($_POST['texte']))
				{
					$texte = addslashes($_POST['texte']);
				}
				else
				{
					$texte = "";
				}

                if (isset($_POST['biographie']) and !empty($_POST['biographie']))
				{
					$biographie = addslashes($_POST['biographie']);
				}
				else
				{
					$biographie = "";
				}
				
				mysql_query("INSERT INTO ".$TBL_BIO." VALUES('".$artiste."','".$biographie."')") or die(mysql_error());
				mysql_query("INSERT INTO ".$TBL_ALB." VALUES('".$artiste."','".$album."','".$annee."','".$image."')") or die(mysql_error());
				mysql_query("INSERT INTO " .$TBL_TIT. " VALUES('".$album."','".$num."','".$titre."','".$type."','".$auteur."','".$auteur2."','".$auteur3."','".$auteur4."','".$auteur5."','".$son."','".$video."','".$texte."')") or Die(mysql_error());
				
				echo "<font color='green'>Les données ont été enregistrées.</font>";

			}
		}
	}
	 else
  {
  	$error="<font color='red'>Vous n'avez pas entré l'année de sortie de l'album</font>";
  }
  }
  else
  {
  	$error="<font color='red'>Vous n'avez pas entré le nom de l'album</font>";
  }
}

?>

<form method="post" action="./Ajout.php" name="ajout">
<label>Artiste:<input name="artiste" type="text"></label>
<br>

<label>Album:<input name="album" type="text"></label>
<br>

<label>Année:<input name="année" type="text"></label><br>
<label>Num de piste:<input name="num" type="text"></label><br>
<label>Titre:<input name="titre" type="text"></label><br>
<label>Type(L ou M):<input name="type" type="text" size="1"></label><br>
<label>Auteur:<input name="auteur" type="text"></label><br>
<label>2ème Auteur:<input name="auteur2" type="text"></label><br>
<label>3ème Auteur:<input name="auteur3" type="text"></label><br>
<label>4ème Auteur:<input name="auteur4" type="text"></label><br>
<label>5ème Auteur:<input name="auteur5" type="text"></label><br>
<label>Image:<input name="image" type="file"></label><br>
<label>Son:<input name="son" type="file"></label><br>
<label>Video:<input name="video" type="file"></label><br>
<label>Texte de la chanson:<br><textarea name="texte" rows="45" cols="45"></textarea></label>
<textarea name="biographie" rows="45" cols="45" wrap="off"></textarea>
<br>
<button type="submit">>>> Ajouter mes données <<<</button>
<br>
<? echo $error; ?>
<br>
<br><a href="./admin.php">Retourner &agrave; la page d'Administration du site</a>
<br><a href="./index.php">Retourner &agrave; la page d'Accueil du site</a>
</form>
<? mysql_close(); ?>
</body>
</html>
