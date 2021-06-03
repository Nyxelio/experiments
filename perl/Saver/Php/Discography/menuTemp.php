<html>

<head>
  <title>menu</title>


/*
*Insérer ce script entre les balises
*/

<script language="JavaScript">

/* DANIEL Fabien - webmaster@script-masters.com
*  Script Masters - http://www.script-masters.com/
*
*  Menu dynamique 2
*  Vous pouvez utilisé ce script sous reserve de conserver ce message
*/

var couleur1 = "#C3C9D4"; 			// Couleur de fond du menu
var couleur2 = "#A7ADB7";			// Couleur de surlignement
var couleurBordure = "#000000";		// Couleur de la bordure
var couleurTexte = "#000000";		// Couleur du texte
var police = "Verdana";				// Police utilisée pour le texte
var tailleTexte = 10;				// Taille du texte

var largeurMenuTotale = 300;		// Largeur totale du menu
var largeurMenuGauche = 100;		// Largeur de la partie gauche du menu
var hauteurMenuTotale = 40;			// Hauteur du menu

// IMPORTANT : Nombre de menus
var nbMenu = 3;						//Nombre de menu principaux



var savTab="";						// Ne pas modifier

var menu = new Array(nbMenu)		// Ne pas modifier
var sousMenuTitre = new Array();	// Ne pas modifier
var sousMenuLien = new Array();		// Ne pas modifier
var sousMenuTarget = new Array();	// Ne pas modifier
for(i=0; i<nbMenu; i++) {			// Ne pas modifier
	sousMenuTitre[i] = new Array();	// Ne pas modifier
	sousMenuLien[i] = new Array();	// Ne pas modifier
	sousMenuTarget[i] = new Array();// Ne pas modifier
}


// Les titres des menus principaux
menu[0] = "Javascript";
menu[1] = "Php"
menu[2] = "Contact";


// Pour chaque sous-menu, renseignez son titre, son lien et sa cible

// [0][x] : Correspond à tous les sousmenus du menu Javascript
sousMenuTitre[0][0] = "Exemples";						// Titre du sous menu
sousMenuLien[0][0] = "http://www.script-masters.com/";	// Lien du sous menu
sousMenuTarget[0][0] = "_blank";						// Cible du sous menu

sousMenuTitre[0][1] = "Cours";
sousMenuLien[0][1] = "http://www.script-masters.com/";
sousMenuTarget[0][1] = "_blank";

sousMenuTitre[0][2] = "Astuces";
sousMenuLien[0][2] = "http://www.script-masters.com/";
sousMenuTarget[0][2] = "_blank";

// [1][x] : Correspond à tous les sousmenus du menu Php
sousMenuTitre[1][0] = "Script";
sousMenuLien[1][0] = "http://www.script-masters.com/";
sousMenuTarget[1][0] = "_blank";

sousMenuTitre[1][1] = "Tutoriaux";
sousMenuLien[1][1] = "http://www.script-masters.com/";
sousMenuTarget[1][1] = "_blank";

sousMenuTitre[1][2] = "Réferences";
sousMenuLien[1][2] = "http://www.script-masters.com/";
sousMenuTarget[1][2] = "_blank";

sousMenuTitre[1][3] = "Réferences2";
sousMenuLien[1][3] = "http://www.script-masters.com/";
sousMenuTarget[1][3] = "_blank";

sousMenuTitre[1][4] = "Réferences2";
sousMenuLien[1][4] = "http://www.script-masters.com/";
sousMenuTarget[1][4] = "_blank";

// [2][x] : Correspond à tous les sousmenus du menu Contact
sousMenuTitre[2][0] = "Webmaster";
sousMenuLien[2][0] = "http://www.script-masters.com/";
sousMenuTarget[2][0] = "_blank";

sousMenuTitre[2][1] = "Editeur";
sousMenuLien[2][1] = "http://www.script-masters.com/";
sousMenuTarget[2][1] = "_blank";


/*
NE PAS MODIFIER SOUS CETTE LIGNE---------------------------
*/
function ouvrirLien(destination,target)
{
	switch(target){
		case "_blank":
			window.open(destination);
			break;
		case "_top":
			window.top.location.href = destination;
			break;
		default:
			window.top.parent.frames[target].location.href  = destination;
			break;
	}
}

function ecrire(id)
{
	// on affiche le menu
	codeHtml = "<table border='0' cellspacing='0' cellpadding='0' width='100%'>";
	for(j=0;j<sousMenuTitre[id].length;j++)
		{
			codeHtml += "<tr><td  onMouseOver='changeCouleur(this,0)' onMouseOut='changeCouleur(this,1)' onClick='ouvrirLien(\"" + sousMenuLien[id][j] + "\",\"" + sousMenuTarget[id][j] + "\")'>" + sousMenuTitre[id][j] + "</td></tr>";
		}
	codeHtml += "</table>";
	document.getElementById("menu").innerHTML = codeHtml;
}

function changeCouleur(tab,type)
{
	switch(type){
		case 0 :
			// mouseover
			if(tab != savTab)
				tab.bgColor = couleur2;
			break;
		case 1 :
			// mouseout
			if(tab != savTab)
				tab.bgColor = couleur1;
			break;
		case 2 :
			// clic!
			sav = savTab;
			savTab = tab;
			changeCouleur(sav,1);
			tab.bgColor = couleur2;
			break;
		}
}

function generate()
{
	// Génération du menu
	codeHTML = "<table width='" + largeurMenuTotale + "' border='0' cellspacing='0' cellpadding='0'>";
	codeHTML += "<tr><td width='" + largeurMenuGauche + "' class='menu' valign='top'><table width='" + largeurMenuGauche + "'";
	codeHTML += " border='0' cellspacing='0' cellpadding='0'>";

	for( i=0; i<nbMenu; i++){
		codeHTML += "<tr><td onClick='ecrire(" + i + ");changeCouleur(this,2);' onMouseOver='changeCouleur(this,0)' onMouseOut='changeCouleur(this,1)'>" + menu[i] + "</td></tr>";
	}
	codeHTML += "</table></td><td width='" + (largeurMenuTotale - largeurMenuGauche) + "' valign='top'  class='sousmenu'>";
	codeHTML += "<div id='menu' style='position:relative;height:" + hauteurMenuTotale + "px;width:" + (largeurMenuTotale - largeurMenuGauche) + "px;top:0px;left:0px;visibility:visible;background-color:" + couleur1 + "'>";
    codeHTML += "</div></td></tr></table>";

	document.write(codeHTML);

	codeCSS = "<style type='text/css'>";
	codeCSS += "td.menu {";
	codeCSS += "	font-family: " + police + ";";
	codeCSS += "	font-size: "+ tailleTexte +"px;";
	codeCSS += "	color: " + couleurTexte + ";";
	codeCSS += "	cursor: hand;";
	codeCSS += "	background-color: " + couleur1 + ";";
	codeCSS += "	border: 1px solid " + couleurBordure + ";";
	codeCSS += "	}";
	codeCSS += "td.sousmenu {";
	codeCSS += "	font-family: " + police + ";";
	codeCSS += "	font-size: "+ tailleTexte +"px;";
	codeCSS += "	color: " + couleurTexte + ";";
	codeCSS += "	cursor: hand;";
	codeCSS += "	background-color: " + couleur1 + ";";
	codeCSS += "	border-top: 1px solid " + couleurBordure + ";";
	codeCSS += "	border-right: 1px solid " + couleurBordure + ";";
	codeCSS += "	border-bottom: 1px solid " + couleurBordure + ";";
	codeCSS += "	border-left: 0px solid " + couleurBordure + ";";
	codeCSS += "	}";
	codeCSS += "td {";
	codeCSS += "	font-family: " + police + ";";
	codeCSS += "	font-size: "+ tailleTexte +"px;";
	codeCSS += "	color: " + couleurTexte + ";";
	codeCSS += "	cursor: hand;";
	codeCSS += "	}";
	codeCSS += "</style>";

	document.write(codeCSS);
}
</script>
</head>

<body>

/*
*Insérer ce code entre les balises
*/

<script language="JavaScript">
	generate();
</script>

</body>

</html>