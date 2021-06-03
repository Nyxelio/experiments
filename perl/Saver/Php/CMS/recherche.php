<html>
<head><title>recherche</title>

<link rel="stylesheet" type="text/css" media="screen" href="style.css" />
       
</head>
<body>
<?php include('./Configdb.inc.php'); ?>


<form action="./recherche.php" method="GET">
<input name="recherche" type="text">
<input type="submit" value="=>">
</form>

<?php
if (isset($_GET['recherche']))
{
	if(!empty($_GET['recherche']))
	{
		$recherche = $_GET['recherche'];
		mysql_connect($host,$username,$passwrd);
		mysql_select_db($dbname);
		
		$sql = mysql_query("SELECT ID,login,message,date FROM minichat WHERE message LIKE '%$recherche%'");
		$i=1;
		while($donnees = mysql_fetch_array($sql))
		{
			echo $i.' : <b>'.$donnees['date'].'</b> : <span class="surligne">'.$donnees['login'].'</span> : <i>'.$donnees['message'].'</i><br>';
			$i++;
			
		}
		
	}
}	
?>
</body>
</html>