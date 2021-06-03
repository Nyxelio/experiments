<? $reqSearch = mysql_query("SELECT DISTINCT Artiste FROM ".$TBL_BIO." ORDER BY Artiste") or die(mysql_error());
?>
<SCRIPT LANGUAGE="JavaScript">


var Liste=new CreerListe("Artiste",20,200)

<?php
while($resultSearch = mysql_fetch_array($reqSearch))
{?>
	Liste.Add("<?php echo $resultSearch['Artiste'];?>")
<?php
}
?>
function CreerListe(nom, hauteur, largeur) {
	this.nom=nom; this.hauteur=hauteur; this.largeur=largeur;
	this.search="";
	this.nb=0;
	this.Add=AjouterItem;
	this.Afficher=AfficherListe;
	this.MAJ=MAJListe;
}

function AjouterItem(item) {
	this[this.nb]=item
	this.nb++;
}

function AfficherListe() {
	if (document.layers) {
		var Z="<SELECT name="+this.nom+" size="+this.hauteur+" >";
	} else {
		var Z="<SELECT name="+this.nom+" size="+this.hauteur+" style='width:"+this.largeur+"'>";
	}
	for (var i=0; i<this.nb; i++) {
		Z+="<OPTION value=\""+this[i]+"\">"+this[i]+"</OPTION>";
	}
	Z+="</SELECT>";
	document.write(Z);
}

function MAJListe(txt,f) {
	if (txt!=this.search) {
		this.search=txt
		f.elements[this.nom].options.length=0;
		for (var i=0; i<this.nb; i++) {
			if ( this[i].substring(0,txt.length).toUpperCase()==txt.toUpperCase() ) {
				var o=new Option(this[i], this[i]);
				f.elements[this.nom].options[f.elements[this.nom].options.length]=o;
			}
		}
		if (f.elements[this.nom].options.length==1) {
			f.elements[this.nom].selectedIndex=0;
		}
	}
}

function ListeCheck() {
	Liste.MAJ(document.forms["monform"].search.value,document.forms["monform"])
	if (document.layers) {
		setTimeout("ListeCheck()", 1001)
	} else {
		setTimeout("ListeCheck()", 100)
	}
}


</SCRIPT>