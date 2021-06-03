<?php include('./config.inc.php'); ?>
<html>
<head></head>
<body>
<?php
if (isset($_GET['Biographie']) and !empty($_GET['Biographie']))
{
	$req = mysql_query("SELECT DISTINCT Biographie FROM ".$TBL_BIO." WHERE Artiste='".$_GET['Biographie']."'") or die(mysql_error());
	while ($result = mysql_fetch_array($req))
	{
		if (!empty($result['Biographie']))
		{
			echo $result['Biographie'];
		}
		else
		{
			echo "Pas de biographie disponible actuellement pour ce titre";
		}
	}
}

if(isset($_GET['Texte']) and !empty($_GET['Texte'])and isset($_GET['Album']) and !empty($_GET['Album']))
{
	$req = mysql_query("SELECT Texte FROM ".$TBL_TIT." WHERE Titre='".$_GET['Texte']."' AND Album='".$_GET['Album']."'") or die(mysql_error());
	while ($result = mysql_fetch_array($req))
	{
		if (!empty($result['Texte']))
		{
			echo $result['Texte'];
		}
		else
		{
			echo "Pas de texte disponible actuellement pour ce titre";
		}
	}
}

if(isset($_GET['Son']) and !empty($_GET['Son']) and isset($_GET['Album']) and !empty($_GET['Album']))
{
	$req = mysql_query("SELECT Son FROM ".$TBL_TIT." WHERE Titre='".$_GET['Son']."' AND Album='".$_GET['Album']."'") or die(mysql_error());
	while ($result = mysql_fetch_array($req))
	{
		if (!empty($result['Son']))
		{
			echo "<object type='application/x-shockwave-flash' data='./src/dewplayer.swf?son=".$result['Son']."&autoplay=1' width='200' height='20'>";
			echo "</object>";
		}
		else
		{
			echo "Pas de piste audio disponible actuellement pour ce titre";
		}
	}
		
}

if(isset($_GET['Video']) and !empty($_GET['Video']) and isset($_GET['Album']) and !empty($_GET['Album']))
{
	$req = mysql_query("SELECT Video FROM ".$TBL_TIT." WHERE Titre='".$_GET['Video']."' AND Album='".$_GET['Album']."'") or die(mysql_error());
	while ($result = mysql_fetch_array($req))
	{
		if (!empty($result['Video']))
		{
			//code pour lecture video...
		}
		else
		{
			echo "Pas de piste video disponible actuellement pour ce titre";
		}
	}
}
?>

	<FORM>
		<INPUT TYPE="BUTTON" VALUE="Fermer la fenêtre" ONCLICK="window.close()">
	</FORM>
</body>
</html>