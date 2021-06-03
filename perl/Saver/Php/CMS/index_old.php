<html>

<head>
<meta http-equiv="Content-Type"
content="text/html; charset=iso-8859-1">
<title>[EasyPHP] - Accueil www</title>

<style type="text/css">
.text1 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #CCCCCC}
.text2 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #999999}
.titre1 {font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #FFFFFF}

</style>

</head>

<body bgcolor="#505F70" vlink="#CCCCCC" alink="#CCCCCC" link="#CCCCCC">
<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr valign="bottom"> 
		<td> 
			<div align="left">&nbsp;&nbsp;<img src="/images_easyphp/easyphp_anim.gif" width="69" height="23" align="absbottom"></div>
		</td>
	</tr>
</table>

<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr> 
		<td> 
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td> 
						<div align="center"><img src="/images_easyphp/barre_blanche_700.gif" width="700" height="6"></div>
					</td>
				</tr>
				<tr> 
					<td> 
						<div align="center"><img src="/images_easyphp/barre_grise_700.gif" width="700" height="12"></div>
					</td>
				</tr>
				<tr>
					<td class=text1>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="701" border="0" cellspacing="0" cellpadding="1" align="center">
	<tr> 
		<td nowrap valign="top" class=titre1>
			<img src="/images_easyphp/carre_gris.gif" width="8" height="8">&nbsp;R&eacute;pertoires &agrave; la racine d'apache (www)&nbsp;:
		</td>
		<td valign="top" width="100%" class=text1> 

<?
$rep=opendir('.');
while ($file = readdir($rep)) {
	if($file != '..' && $file !='.' && $file !=''){ 
		if (is_dir($file)){
			echo "&nbsp;&nbsp;&nbsp;&nbsp;";
			echo "<img src=\"/images_easyphp/dossier.gif\" width=\"15\" height=\"12\">&nbsp;";
			echo "<a href=\"$file/\" target=_blank class=text1>$file</a>";
			echo "<br>";
		}
	}
}
closedir($rep);
clearstatcache();
?>

		</td>
	</tr>
</table>

<br>
<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td class="text2">Cette page permet de visualiser les r&eacute;pertoires plac&eacute;s 
      &agrave; la racine du serveur. Si vous souhaitez organiser autrement le r&eacute;pertoire 
      &quot;www&quot;, vous pouvez effacer ce fichier. Il en existe une copie 
      de sauvegarde dans le r&eacute;pertoire &quot;safe&quot; (index-safe.php). 
    </td>
  </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
  </tr>
  <tr>
    <td><img src="/images_easyphp/barre_grise_700.gif" width="700" height="12"></td>
  </tr>
</table>

</body>
</html>
