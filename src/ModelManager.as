package  
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	import com.gestureworks.cml.away3d.elements.Camera;
	import away3d.entities.Mesh;
	import caurina.transitions.Tweener;	
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.away3d.elements.Model;
	import com.gestureworks.cml.away3d.elements.TouchContainer3D;
	import com.gestureworks.cml.core.CMLAway3D;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.cml.elements.Image; 
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.core.TouchSprite;

	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import flash.geom.ColorTransform;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	* ...
	* @author John-Mark Collins	
	* * */

	public class ModelManager extends Sprite 
	{ 	
		private var overlay:TouchSprite = new TouchSprite();
		private var cam:Camera = new Camera();
		
		private var model1:TouchContainer3D;
		private var model2:TouchContainer3D;
		private var container:ObjectContainer3D;
		private var container2:ObjectContainer3D;
		private var container3:ObjectContainer3D;

		private var engine1:Model;
		private var engine2:Model;
		private var engine3:Model;
		
		private var minScale:Number = .25;
		private var maxScale:Number = 4;
	
private var minExplosion:Number = -200;
private var maxExplosion:Number = 200;

private var maxRotationX:Number = 60;
private var minRotationX:Number = -maxRotationX;
	
//private var scene_3d:Scene3D = document.getElementById("main_scene");
private var popups:Array;

// UI elements
private var point_dial = document.getElementById("point_dial");
private var bar = document.getElementById("bar");
private var viewWindow = document.getElementById("viewWindow");
private var info_overlay:Image = document.getElementById("info_overlay");
private var info_screen = document.getElementById("info_screen");
private var info_screen_exit:Image = document.getElementById("info_screen_icon");

// State of the UI element for various NY images
private var barState:int = 4;
		
// State of the UI element for secondary control
private var dialValue:Number = 0.0;
	
private var txt:Text = new Text();
private var secTimer:Timer = new Timer(1000, 1);
	
public function ModelManager() 
{
TweenPlugin.activate([ShortRotationPlugin]);
super();
}

public function init():void 
{
// Construct main screen and gesture enabling
model1 = document.getElementById("model1");
//model2 = document.getElementById("model2");

//Get Camera from scene
cam = document.getElementById("main_cam");
cam.x = -400;
cam.y = 200;
cam.z = -300;
cam.lookAt( new Vector3D(0, 0, 0) );

stage.addChild(overlay);

// Add 'main' 3d scene 
overlay.addChild(model1);
//overlay.addChild(model2);
		
// add child gestures
overlay.mouseEnabled = true;
overlay.mouseChildren = true;
overlay.clusterBubbling = true;
			
// add events 
overlay.gestureList = { "n-tap": true,
									"n-rotate-3d": true,
									"n-drag": true };

overlay.addChild(point_dial);
fadeInDial(false);
	
overlay.addChild(viewWindow);
fadeInViewer(false);
			
overlay.addChild(bar);
overlay.addChild(txt);
		
container = document.getElementById("container01");
container2 = document.getElementById("container02");
container3 = document.getElementById("container03");
			
engine1 = document.getElementById("engine1");
engine2 = document.getElementById("engine2");
engine3 = document.getElementById("engine3");
				
popups = document.getElementsByTagName(ModelPopup);

document.getElementById("engine1").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
document.getElementById("engine1").vto.addEventListener(GWGestureEvent.SCALE, onModelScale);
//document.getElementById("engine1").vto.addEventListener(GWGestureEvent.ROTATE, onModelRotate);
			
document.getElementById("engine2").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
document.getElementById("engine2").vto.addEventListener(GWGestureEvent.SCALE, onModelScale);
//document.getElementById("engine2").vto.addEventListener(GWGestureEvent.ROTATE, onModelRotate);
		
document.getElementById("engine3").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
document.getElementById("engine3").vto.addEventListener(GWGestureEvent.SCALE, onModelScale);
//document.getElementById("engine3").vto.addEventListener(GWGestureEvent.ROTATE, onModelRotate);
				
/*document.getElementById("hotspot01").vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);
document.getElementById("hotspot02").vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);
document.getElementById("hotspot03").vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);*/
			
//mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
overlay.addEventListener(GWGestureEvent.ROTATE, onRotate);
overlay.addEventListener(GWGestureEvent.DRAG, onDrag);
			
// listeners for viewer options
//document.getElementById("viewWindow").addEventListener(GWGestureEvent.HOLD, onViewerHold);
//document.getElementById("viewWindow").addEventListener(GWGestureEvent.ROTATE, onViewerRotate);
//document.getElementById("viewWindow").addEventListener(GWGestureEvent.DRAG, onViewerDrag);
			
document.getElementById("option1left").addEventListener(GWGestureEvent.TAP, onLeftOption1Tap);
document.getElementById("option2left").addEventListener(GWGestureEvent.TAP, onLeftOption2Tap);
document.getElementById("option3left").addEventListener(GWGestureEvent.TAP, onLeftOption3Tap);
document.getElementById("option1right").addEventListener(GWGestureEvent.TAP, onRightOption1Tap);
document.getElementById("option2right").addEventListener(GWGestureEvent.TAP, onRightOption2Tap);
//document.getElementById("option3right").addEventListener(GWGestureEvent.TAP, onRightOption3Tap);
//document.getElementById("test").addEventListener(GWGestureEvent.TAP, onTap2);
			
document.getElementById("info_overlay").addEventListener(GWGestureEvent.TAP, onInfoTap);
document.getElementById("info_screen_icon").addEventListener(GWGestureEvent.TAP, onInfoTapExit);
		
secTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerFunction);

// Add Text
txt.x = 200;
txt.y = 200;
txt.font = "OpenSansBold";
txt.fontSize = 68;            
txt.color = 0xFFFFFF; 
txt.text = "0"
overlay.addChild(txt);
		
// Add info screen
info_screen.alpha = 0;
overlay.addChild(info_overlay);
}
	
private function onModelDrag(e:GWGestureEvent):void 
{
		var val:Number = container.rotationX + e.value.drag_dy * .25;
			
		if (val < minRotationX)
			val = minRotationX;
			else if (val > maxRotationX)
				val = maxRotationX;
				
		container.rotationY -= e.value.drag_dx * .5;
			container.rotationX = val;
	}

	private function onModelScale(e:GWGestureEvent):void 
	{
		/*var val:Number = container.scaleX + e.value.scale_dsx * .75;
			
			if (val < minScale)
			val = minScale;
		else if (val > maxScale)
				val = maxScale;
				
		container.scaleX = val;
			container.scaleY = val;
			container.scaleZ = val;*/
		}	
		
		private function onRotate(e:GWGestureEvent):void 
		{
			trace("actually doing something...");
			if (e.value.n == 5)
			{
			var fast_displacement:Number = e.value.rotate_dthetaZ * 5;
			var slow_displacement:Number = e.value.rotate_dthetaZ * 3;
	var curr_position:Vector3D = container.scenePosition;

			trace("initial position: " + curr_position);
			trace("rotating: " + slow_displacement);
			
			trace("expanding out right");
				container.moveLeft(fast_displacement);
				container2.moveRight(fast_displacement);
				container3.moveRight(slow_displacement);	
			
				var final_position:Number = container.x;
				if (final_position > 700) container.x = 700;
				if (final_position < 0) container.x = 0;
				final_position = container.x;
				trace("final position of 1: " + final_position);
					
				final_position = container2.x;
				if (final_position > 0) container2.x = 0;
				if (final_position < -700) container2.x = -500;
				final_position = container2.x;
				trace("final position of 2: " + final_position);
					
			final_position = container3.x;
				if (final_position > 0) container3.x = 0;
			if (final_position < -700) container3.x = -300;
				final_position = container3.x;
			trace("final position of 3: " + final_position);

				var x:int = e.value.localX;
				var y:int = e.value.localY;
				point_dial.x = x;
				point_dial.y = y;
			
				fadeInDial(true);
				
				//dialValue = dialValue + event.value.rotate_dtheta;
			}
			else fadeInDial(false);

		}

		private function onHotspotTap(e:GWGestureEvent):void 
		{
			trace("model tap", e.target.vto.x, e.target.vto.y, e.target.z);

			var popup:ModelPopup = document.getElementById(e.target.vto.name);
			for (var i:int = 0; i < popups.length; i++) {
				if (popups[i].visible && popups[i] != popup) {
					popups[i].tweenOut();
				}
			}
			if (!popup.visible)
				popup.tweenIn();
			else
				popup.tweenOut();	
		}
		
			private function timerFunction(event:Event = null):void
		{
				overlay.removeChild(info_screen);
		}
		
		
		private function onInfoTap(event:GWGestureEvent):void
			{
			info_screen.alpha = 0;
			overlay.addChild(info_screen);
				if (info_screen.visible == false) info_screen.visible = true;
				fadeInInfoScreen(true);
		}
			
		private function onInfoTapExit(event:GWGestureEvent):void
			{
				fadeInInfoScreen(false);
				secTimer.start();
			}
			
			private function onLeftOption1Tap(event:GWGestureEvent):void
			{
				if (event.value.n == 1 && barState == 4)
				{
				trace("city screen");
	
				}
				
				if (event.value.n == 1 && barState == 3)
				{
					trace("city screen");
				}
			}
			
			private function onLeftOption2Tap(event:GWGestureEvent):void
			{
				if (event.value.n == 1 && barState == 4)
				{
					trace("subway screen");
				}
				
				if (event.value.n == 1 && barState == 3)
				{
				trace("subway screen");
				}
			}
		
			private function onLeftOption3Tap(event:GWGestureEvent):void
			{
				if (event.value.n == 1 && barState == 4)
				{
				trace("historical screen");

			}
				
			if (event.value.n == 1 && barState == 3)
				{
					trace("historical screen");
			}
			}
		
			private function onRightOption1Tap(event:GWGestureEvent):void
		{
			if (event.value.n == 1 && barState == 3)
				{
				trace("bikes screen");
				}
			}
			
			private function onRightOption2Tap(event:GWGestureEvent):void
		{
				if (event.value.n == 1 && barState == 3)
			{
					trace("roads screen");
				}
			}
			
			private function onRightOption3Tap(event:GWGestureEvent):void
			{
				if (event.value.n == 1)
				{
				trace("undetermined screen");
				}
			}
			
			private function onViewerHold(event:GWGestureEvent):void
		{
				if (event.value.n == 3)
				{
					//fadeInViewer(true);
					var x:int = event.value.localX;
					var y:int = event.value.localY;
					viewWindow.x = x;
					viewWindow.y = y;
				}
				else 
				{
					fadeInViewer(false);
				}
			}
			
			private function onViewerDrag(event:GWGestureEvent):void
			{
				if (event.value.n == 3)
				{
					//fadeInViewer(true);
				var x:int = event.value.localX;
					var y:int = event.value.localY;
					viewWindow.x = x;
					viewWindow.y = y;
				}
				else 
				{
					fadeInViewer(false);
				}
			}
			
			private function onViewerRotate(event:GWGestureEvent):void
			{
				if (event.value.n == 3)
				{
					//trace("viewer rotate");
				}
			}
			
			/*function onTap(event:GWGestureEvent):void
			{
				if (event.value.n == 3)
			{
					if (viewWindow.visible == false) viewWindow.visible = "true";
					var x:int = event.value.localX;
					var y:int = event.value.localY;
					viewWindow.x = x;
					viewWindow.y = y;
					fadeInViewer(true);
				}
				else fadeInViewer(false);
				
				if (event.value.n == 4)
				{
					animateBar(true);
				}
				else animateBar(false);
				
			if (event.value.n == 2)
				{
					var x:int = event.value.localX;
					var y:int = event.value.localY;
					point_dial.x = x;
					point_dial.y = y;
					fadeInDial(true);
				}
				else fadeInDial(false);
			}*/
			
			private function onDrag(event:GWGestureEvent):void
			{
				/*if (event.value.n == 3)
				{
					if (viewWindow.visible == false) viewWindow.visible = "true";
					var x:int = event.value.localX;
					var y:int = event.value.localY;
					viewWindow.x = x;
					viewWindow.y = y;
					fadeInViewer(true);
				}
				else fadeInViewer(false);*/
				
				if (event.value.n == 4)
				{
					animateBar(true);
					var dx:int = event.value.drag_dx as int;
						
					if (dx > 10)
					{
						barState = barState - 1;
						if (barState < 0) barState = 0;		
						//displayModel(barState);
						
						for (var i:int = 0; i < 5; i++)
						{
							if (i == barState)
							{
								bar.getChildAt(i).visible = true;
								//clearOthers();
								//trace("setting " + i + "true");
							}
							else 
							{
								bar.getChildAt(i).visible = false;
								//trace("setting " + i + "false");
							}
					}
					}
					else if (dx < -10)
					{
						barState = barState + 1;
						//trace("dx = " + event.value.drag_dx);
						//trace("Negative Drag");
						//trace("barState = " + barState);
						//displayModel(barState);
						if (barState > 4) barState = 4;
	
						for (var i:int = 0; i < 5; i++)
						{
							if (i == barState)
							{
								bar.getChildAt(i).visible = true;
								//clearOthers();
								dialValue = 0;
								//trace("setting " + i + "true");
						}
							else 
							{
								bar.getChildAt(i).visible = false;
								//trace("setting " + i + "false");
							}
						}
					}
					
				}
			else animateBar(false);
			}
			
			private function animateBar(on:Boolean):void
			{
				if (on == true)
				{
				TweenLite.to(bar, 1, { y:0 } );
				}
				else
				{
				  TweenLite.to(bar, 1, { y:-174 } );	
				}
			}
			
			private function fadeInViewer(on:Boolean):void 
			{
				if (on == true)
				{
					TweenLite.to(viewWindow, 1, { alpha:1 } );
				}
				/*else
				{
					TweenLite.to(viewWindow, 1, { alpha:0 } );	
				}*/
			}
			
			private function fadeInDial(on:Boolean):void 
			{
				if (on == true)
				{
					TweenLite.to(point_dial, 1, { alpha:1} );
				}
				else
				{
					TweenLite.to(point_dial, 1, { alpha:0 } );	
				}
			}
			
			private function fadeInInfoScreen(on:Boolean):void 
			{
				if (on == true)
				{
					TweenLite.to(info_screen, 1, { alpha:1} );
				}
				else
				{
					TweenLite.to(info_screen, 1, { alpha:0 } );
				}
			}
				
			private function map(num:Number, min1:Number, max1:Number, min2:Number, max2:Number, round:Boolean = false, constrainMin:Boolean = true, constrainMax:Boolean = true):Number
			{
				if (constrainMin && num < min1) return min2;
				if (constrainMax && num > max1) return max2;
	 
				var num1:Number = (num - min1) / (max1 - min1);
				var num2:Number = (num1 * (max2 - min2)) + min2;
				if (round) return Math.round(num2);
				return num2;
			}
			
			private function clearOthers():void
			{
				if (barState == 4)
				{
					//nyc.visible = true;
					//sf.visible = false;
				}
				if (barState == 3)
				{
					//nyc.visible = false;
					//sf.visible = true;
				}
			}
			
			/*private function displayModel(state:int):void 
			{
				if (state == 4)
				{
					overlay.getChildByName("model1").visible = true;
					overlay.getChildByName("model2").visible = false;
	
					if (overlay.contains(model2)) overlay.removeChild(model2);
					overlay.addChild(model1);
				}
				else if (state == 3)
				{
					overlay.getChildByName("model1").visible = false;
					overlay.getChildByName("model2").visible = true;
					if (overlay.contains(model1)) overlay.removeChild(model1);
					overlay.addChild(model2);
				}
			}*/
		}
	}