<html>
<head>
<script language="javascript" type="text/javascript">
var Timer;
var Pas = 3;
function moveLayer(Sens) {
	Objet=document.getElementById("contenu");
    if(parseInt(Objet.style.top) + (Pas*Sens)>0)  {
		clearTimeout(Timer);
	}
	else if(parseInt(Objet.style.top) + (Pas*Sens)<-(Objet.offsetHeight-document.getElementById("support").offsetHeight)) {
		clearTimeout(Timer);
	}
    else {
        Objet.style.top = (parseInt(Objet.style.top) + (Pas*Sens)) + "px";
	}
	Timer = setTimeout("moveLayer(" + Sens + ");", 30);
}
</script>
</head>
<body>
<div id="support" style="position:relative; width:150px; height:280px; overflow:hidden; border:1px solid #000;">	
	<div id="contenu" style="position:absolute; top:0;">
		DEBUT<br />ligne1<br />ligne2<br />ligne3<br />ligne4<br />ligne5<br />ligne6<br />
		ligne7<br />ligne8<br />ligne9<br />ligne10<br />ligne11<br />ligne12<br />ligne13<br />
		ligne14<br />ligne15<br />ligne16<br />ligne17<br />ligne18<br />ligne19<br />FIN<br />
	</div>
	<div style="background-color:#0F0; width:22px; height:280px; position:absolute; right:0; border-left:1px solid #000;">
		<img onmouseover="moveLayer(1);" onmouseout="clearTimeout(Timer);" src="slideup.png" style="cursor:pointer; position:absolute; right:0;" alt="" />
		<img onmouseover="moveLayer(-1);" onmouseout="clearTimeout(Timer);" src="slideup.png" style="cursor:pointer; position:absolute; right:0; bottom:0;" alt="" />		
	</div>
</div>
</body>
</html>