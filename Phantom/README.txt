This is a joystick object for the HTML canvas element that can be used on touchscreen or mouse-based devices.  

Instantiating the objects:

var stick = new joystick();

Set teh box on the canvas that the joystick can appear in:

stick.setBox(300,300,400,400);  //upper right hand coords then lower left coords

Set the stick length (defaults to 25)

stick.setStickLength(25);

now add the joystick events to dom event handlers (this is using jquery)
*****
$(document.getElementById('myCanvas')).mousedown(function(event){
 	stick.press(event.pageX,event.pageY);
 	 $(document.getElementById('myCanvas')).mousemove(function(event){
 	 	stick.updatePosition(event.pageX,event.pageY);
 	 });
});

$(document.getElementById('myCanvas')).mouseup(function(event){
 	stick.unpress();
 	$(document.getElementById('myCanvas')).unbind('mousemove');
});


now add the draw method to your animation set interval

setInterval(function(){
		clearCanvas();
		stick.draw(context);
	},30);

Now its all set in order to access the position of the joystick use the getValue() method

stick.getValue();  //this will return an array with the first element the power between 0 and 1 
                      and the second the direction in radians