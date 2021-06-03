
 // Une fois le chargment de la page terminé ...
$(document).ready(  function()
{

$('#game_area').mousedown(function(event)
{
	$('#game_area').mousemove(function(event){
		x=event.pageX;
		y=event.pageY;
	});
});


$('#game_area').mouseup(function(event)
{
	x=250;
	y=250;
	
 	$('#game_area').unbind('mousemove');
});

$('#idUpButton').mousedown(function(event)
{
	up = true;
});

$('#idUpButton').mouseup(function(event)
{
	up = false;
});

$('#idDownButton').mousedown(function(event)
{
	down = true;
});

$('#idDownButton').mouseup(function(event)
{
	down = false;
});

$('#idRightButton').mousedown(function(event)
{
	right = true;
});

$('#idRightButton').mouseup(function(event)
{
	right = false;
});

$('#idLeftButton').mousedown(function(event)
{
	left = true;
});

$('#idLeftButton').mouseup(function(event)
{
	left = false;
});

/*
$('#tab_1').click(function(event)
{
	changeTab(1,4,'tab_','content_');
});
$('#tab_2').click(function(event)
{
	changeTab(2,4,'tab_','content_');
});
$('#tab_3').click(function(event)
{
	changeTab(3,4,'tab_','content_');
});
$('#tab_4').click(function(event)
{
	changeTab(4,4,'tab_','content_');
});

$('#tab_control_1').click(function(event)
{
	changeTab(1,2,'tab_control_','content_control_');
});
$('#tab_control_2').click(function(event)
{
	changeTab(2,2,'tab_control_','content_control_');
});

$('#tab_cam_control_1').click(function(event)
{
	changeTab(1,2,'tab_cam_control_','content_cam_control_');
});
$('#tab_cam_control_2').click(function(event)
{
	changeTab(2,2,'tab_cam_control_','content_cam_control_');
});

$('#tab_overview_1').click(function(event)
{
	changeTab(1,3,'tab_overview_','content_overview_');
});
$('#tab_overview_2').click(function(event)
{
	changeTab(2,3,'tab_overview_','content_overview_');
});

$('#tab_overview_3').click(function(event)
{
	changeTab(3,3,'tab_overview_','content_overview_');
});

$('#tab_view_1').click(function(event)
{
	changeTab(1,2,'tab_view_','content_view_');
});
$('#tab_view_2').click(function(event)
{
	changeTab(2,2,'tab_view_','content_view_');
});

$('#tab_tool_1').click(function(event)
{
	changeTab(1,2,'tab_tool_','content_tool_');
});
$('#tab_tool_2').click(function(event)
{
	changeTab(2,2,'tab_tool_','content_tool_');
});
*/

$("a.menu_tab_hover").click(   function () 
{
	// Mettre tous les onglets non actifs
	$(".active").removeClass("active");
	
	//idem
	$(".menu_tab_hover").stop().animate({"opacity":"0"},'slow');
	

	// Mettre l'onglet cliqué actif
	$(this).addClass("active");
  
	//bouton
	$(this).stop().animate({"opacity":"1"},'slow');

	//bar
	$(".head_bar_hover").stop().animate({"opacity" : "0"},'slow');

	// Cacher les boites de contenu
	$(".content").slideUp();

	// Pour afficher la bote de contenu associé, nous
	// avons modifié le titre du lien par le nom de
	// l'identifiant de la boite de contenu
	var contenu_aff = $(this).attr("title");
	$("#" + contenu_aff).slideDown();
});

$("a.tab_control").click(   function () 
{
	// Mettre tous les onglets non actifs
	$(".active_control").removeClass("active_control");
	
	// Mettre l'onglet cliqué actif
	$(this).addClass("active_control");
  	
	// Cacher les boites de contenu
	$(".content_control").slideUp();

	// Pour afficher la bote de contenu associé, nous
	// avons modifié le titre du lien par le nom de
	// l'identifiant de la boite de contenu
	var contenu_aff = $(this).attr("title");
	$("#" + contenu_aff).slideDown();
});

$("a.tab_cam_control").click(   function () 
{
	// Mettre tous les onglets non actifs
	$(".active_cam_control").removeClass("active_cam_control");
	
	// Mettre l'onglet cliqué actif
	$(this).addClass("active_cam_control");
  	
	// Cacher les boites de contenu
	$(".content_cam_control").slideUp();

	// Pour afficher la bote de contenu associé, nous
	// avons modifié le titre du lien par le nom de
	// l'identifiant de la boite de contenu
	var contenu_aff = $(this).attr("title");
	$("#" + contenu_aff).slideDown();
});

$("a.tab_overview").click(   function () 
{
	// Mettre tous les onglets non actifs
	$(".active_overview").removeClass("active_overview");
	
	// Mettre l'onglet cliqué actif
	$(this).addClass("active_overview");
  	
	// Cacher les boites de contenu
	$(".content_overview").slideUp();

	// Pour afficher la bote de contenu associé, nous
	// avons modifié le titre du lien par le nom de
	// l'identifiant de la boite de contenu
	var contenu_aff = $(this).attr("title");
	$("#" + contenu_aff).slideDown();
});

$("a.tab_view").click(   function () 
{
	// Mettre tous les onglets non actifs
	$(".active_view").removeClass("active_view");
	
	// Mettre l'onglet cliqué actif
	$(this).addClass("active_view");
  	
	// Cacher les boites de contenu
	$(".content_view").slideUp();

	// Pour afficher la bote de contenu associé, nous
	// avons modifié le titre du lien par le nom de
	// l'identifiant de la boite de contenu
	var contenu_aff = $(this).attr("title");
	$("#" + contenu_aff).slideDown();
});

$("a.tab_tool").click(   function () 
{
	// Mettre tous les onglets non actifs
	$(".active_tool").removeClass("active_tool");
	
	// Mettre l'onglet cliqué actif
	$(this).addClass("active_tool");
  	
	// Cacher les boites de contenu
	$(".content_tool").slideUp();

	// Pour afficher la bote de contenu associé, nous
	// avons modifié le titre du lien par le nom de
	// l'identifiant de la boite de contenu
	var contenu_aff = $(this).attr("title");
	$("#" + contenu_aff).slideDown();
});


//MENU
$("a.menu_tab_hover").hover( function()
{
	string = $(this).attr('class');

	if(string.search("active") == -1)
	{
		$(".head_bar_hover").stop().animate({"opacity" : "1"},'slow');

		//$(this).addClass('hover');

		//bouton
		$(this).stop().animate({"opacity" : "1"},"slow");
	}




},function()
{
	$(".head_bar_hover").stop().animate({"opacity" : "0"},'slow');


	string = $(this).attr('class');
	

	if(string.search("active") == -1)
	{
		//bouton
		$(this).stop().animate({"opacity" : "0"},"slow");
	}

});



//TEST
$("#test_battery").click(function()
{
	changeBatteryValue("Phantom_As",4.8,1);
});

document.onkeydown = function(event) {
     var key_pressed; 
     if(event == null){
          key_pressed = window.event.keyCode; 
     }
     else {
          key_pressed = event.keyCode; 
     }
     switch(key_pressed){
          case 37:
               left=true;
               break; 
          case 38:
               up=true;
               break; 
          case 39:
               right=true;
               break;
          case 40:
	       down=true;
	       break; 

     } 
}
 
document.onkeyup = function(event) {
     var key_pressed; 
     if(event == null){
          key_pressed = window.event.keyCode; 
     }
     else {
          key_pressed = event.keyCode; 
     }
     switch(key_pressed){
          case 37:
               left=false;
               break; 
          case 38:
               up=false;
               break; 
          case 39:
               right=false;
               break;
          case 40:
               down=false;
               break; 
     } 
}
 
var context;
var x_speed=0;
var y_speed=0;
var y=250;
var x=250;

var left=false;
var right=false;
var up=false;
var down=false;
//var friction=0.95;

function on_enter_frame(){
     if(left){
          x_speed--;
     }
     if(right){
          x_speed++;
     }
     if(up){
          y_speed--;
     }
     if(down){
          y_speed++;
     }
    context=game_area.getContext('2d');
   
context.clearRect(0,0,500,500);

context.fillStyle="#000000";
context.fillRect(x,y,50,100);    

    x+=x_speed;
    y+=y_speed;
    x_speed*=0.98;
    y_speed*=0.98;
}
 
setInterval(on_enter_frame,30);

function on_saisie_clavier()
{
	var clavier = document.getElementById("idClavier");
	clavier.innerHTML = "L'etat des touches:<br> gauche:"+left+"<br>droite:"+right+"<br>Haut:"+up+"<br>Bas:"+down;
}

setInterval(on_saisie_clavier,30);


/*function changeTab(active, nombre, tab_prefix, contenu_prefix) 
{   
	for (var i=1; i < nombre + 1; i++) 
	{
		document.getElementById(contenu_prefix + i).style.display = 'none';
		document.getElementById(tab_prefix + i).className = '';
	}  
       
	document.getElementById(contenu_prefix+active).style.display = 'block';
	document.getElementById(tab_prefix+active).className = 'active';   
}*/    

//battery: battery's Owner (ex: Phantom_As) 
//value: in voltage
//charging: 1 if device is charging, 0 else.
function changeBatteryValue(batteryOwner,value,charging)
{
	//9.6v max
	maxBatteryVolt = 9.6;
	//1% = 1.8px
	minStepPx = 1.8;	

	//calcul percentage
	percentage=Math.round((value/maxBatteryVolt)*100);
	if (percentage > 100)
	{
		percentage = 100;
	}
	else if (percentage == 0)
	{
		document.getElementById("battery_state_"+batteryOwner).style.display = "visible";
		document.getElementById("battery_state_"+batteryOwner).style.background = "url('bar_error.png') no-repeat 0 0";
	}
	
	if(charging == 1)
	{
		document.getElementById("battery_state_"+batteryOwner).style.display = "visible";
		document.getElementById("battery_state_"+batteryOwner).style.background = "url('bar_charge.png') no-repeat 0 0";
	}

	//percentage > px
	px = Math.floor(percentage * minStepPx);

	//affichage valeurs % et reel
	document.getElementById("battery_value_"+batteryOwner).innerHTML = percentage + "%<br>" + value + "V";	
	document.getElementById("battery_cover_"+batteryOwner).style.left = "-"+px+"px";
}

});


