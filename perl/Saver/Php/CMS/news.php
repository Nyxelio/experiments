
<?php
include('./Configdb.inc.php');
include('./config.inc.php');


mysql_connect($host,$username,$passwrd);
mysql_select_db($dbname);

if(isset($_POST['titrenews']) && isset($_POST['messagenews']))
{

	if(!empty($_POST['titrenews']) && !empty($_POST['messagenews']))
	{
		$titrenews = $_POST['titrenews'];
		
		$messagenews = addslashes($_POST['messagenews']);
		$messagenews = nl2br($messagenews);
		$date = date('[d:m:y]');
		
		mysql_query('INSERT INTO news VALUES("","'.$titrenews.'","'.$messagenews.'","'.$date.'")');
	}
}

$sql = mysql_query('SELECT date,titre,message FROM news ORDER BY ID DESC LIMIT '.$nbreNewsAAfficher) ;

while($reponse = mysql_fetch_array($sql))
{
	echo '<div id="news">';
	echo $reponse['date'].'&nbsp;&nbsp;&nbsp;'.$reponse['titre'].'<br><br>';
	echo '<p>'.$reponse['message'].'</p><br>';
	echo '</div>';
}
mysql_close();
?>

		
		