package  
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.core.partition.SkyBoxNode;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapTexture;
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	import com.gestureworks.cml.away3d.elements.Camera;
	import away3d.entities.Mesh;
	import caurina.transitions.Tweener;	
	import com.gestureworks.away3d.TouchManager3D;
	import com.gestureworks.cml.away3d.elements.Container3D;
	import com.gestureworks.cml.away3d.elements.Model;
	import com.gestureworks.cml.away3d.elements.Scene;
	import com.gestureworks.cml.away3d.elements.TouchContainer3D;
	import com.gestureworks.cml.core.CMLAway3D;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.events.GWClusterEvent;
	import com.gestureworks.events.GWGestureEvent;
	import com.gestureworks.cml.elements.Image; 
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.core.TouchSprite;
	import flash.display.BitmapData;

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
		//private var scene:Scene = new Scene();
		
		//private var model1:ObjectContainer3D;
		private var model_container:TouchContainer3D;
		
		private var main:ObjectContainer3D;
		private var container1:ObjectContainer3D;
		private var container2:ObjectContainer3D;
		private var container3:ObjectContainer3D;
		private var container4:ObjectContainer3D;
		private var container5:ObjectContainer3D;
		private var container6:ObjectContainer3D;
		private var container7:ObjectContainer3D;
		private var container8:ObjectContainer3D;
		private var container9:ObjectContainer3D;
		private var container10:ObjectContainer3D;
		private var container11:ObjectContainer3D;
		private var container12:ObjectContainer3D;
		private var container13:ObjectContainer3D;

		private var engine:Model;
		private var rod:Model;
		private var rotor1:Model;
		private var engine_nose:Model;
		private var engine_tail:Model;
		
		private var minScale:Number = .25;
		private var maxScale:Number = 4;
	
		private var minExplosion:Number = -200;
		private var maxExplosion:Number = 200;

		private var maxRotationX:Number = 60;
		private var minRotationX:Number = -maxRotationX;
	
		//private var scene_3d:Scene3D = document.getElementById("main_scene");
		private var popups:Array;
		
		// array of models for rotating each one independently
		private var models:Array;
		
		// array of models for rotating each one independently
		private var containers:Array;

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
			
			// get models
			model_container = document.getElementById("model_container");
			//model2 = document.getElementById("model2");
			
			
			/*var backgroundImg:BitmapData = new Sky().bitmapData;
			scene = document.getElementById("main_scene");
			scene.view.background = new BitmapTexture(backgroundImg);*/
			
			//Get Camera from scene
			cam = document.getElementById("main_cam");
			/*cam.x = -400;
			cam.y = 200;
			cam.z = -300;	
			cam.lookAt( new Vector3D(0, 0, 0) );*/

			// add touch overlay for fiducial gestures
			stage.addChild(overlay);

			// Add models to 3D scene 
			overlay.addChild(model_container);
			//overlay.addChild(model2);
		
			// add child gestures
			//overlay.mouseEnabled = true;
			overlay.mouseChildren = true;
			overlay.clusterBubbling = true;
			
			// add events 
			overlay.gestureList = { "n-tap": true,
									"n-rotate-3d": true,
									"n-drag": true, 
									"n-scale-3d": true };

			overlay.addChild(point_dial);
			fadeInDial(false);
	
			//overlay.addChild(viewWindow);
			//fadeInViewer(false);
			
			//overlay.addChild(bar);
			//overlay.addChild(txt);
		
			main = document.getElementById("main");
			container1 = document.getElementById("container01");
			container2 = document.getElementById("container02");
			container3 = document.getElementById("container03");
			container4 = document.getElementById("container04");
			container5 = document.getElementById("container05");
			container6 = document.getElementById("container06");
			container7 = document.getElementById("container07");
			container8 = document.getElementById("container08");
			container9 = document.getElementById("container09");
			container10 = document.getElementById("container10");
			container11 = document.getElementById("container11");
			container12 = document.getElementById("container12");
			container13 = document.getElementById("container13");
			
			engine = document.getElementById("engine");
			/*rod = document.getElementById("rod");
			rotor1 = document.getElementById("rotor1");
			engine_nose = document.getElementById("engine_nose");
			engine_tail = document.getElementById("engine_tail");*/
				
			// grab all of the cml popup elements
			popups = document.getElementsByTagName(ModelPopup);
			
			// grab all of the cml model elements
			models = document.getElementsByTagName(Model);
			
			// grab all of the 3D container elements
			containers = document.getElementsByTagName(ObjectContainer3D);
			
			document.getElementById("back_shell_left").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("back_shell_left").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("back_shell_right").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("back_shell_right").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("central_shell_left").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("central_shell_left").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("central_shell_right").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("central_shell_right").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("inner_shell_left").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("inner_shell_left").vto.addEventListener(GWGestureEvent.SCALE, onScale);
		
			document.getElementById("inner_shell_right").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("inner_shell_right").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("outer_shell_left").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("outer_shell_left").vto.addEventListener(GWGestureEvent.SCALE, onScale);

			document.getElementById("outer_shell_right").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("outer_shell_right").vto.addEventListener(GWGestureEvent.SCALE, onScale);
	
			document.getElementById("engine").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("engine").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("engine_nose").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("engine_nose").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("engine_tail").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("engine_tail").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("rod").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("rod").vto.addEventListener(GWGestureEvent.SCALE, onScale);
			
			document.getElementById("rotor1").vto.addEventListener(GWGestureEvent.DRAG, onModelDrag);
			document.getElementById("rotor1").vto.addEventListener(GWGestureEvent.SCALE, onScale);
				
			document.getElementById("outer_shell_right").vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);
			document.getElementById("outer_shell_left").vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);
			//document.getElementById("hotspot03").vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);*/
			
			//mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
			overlay.addEventListener(GWGestureEvent.ROTATE, onRotate);
			overlay.addEventListener(GWGestureEvent.DRAG, onDrag);
			overlay.addEventListener(GWGestureEvent.SCALE, onScale);
			
			// listeners for viewer options
			//document.getElementById("viewWindow").addEventListener(GWGestureEvent.HOLD, onViewerHold);
			//document.getElementById("viewWindow").addEventListener(GWGestureEvent.ROTATE, onViewerRotate);
			//document.getElementById("viewWindow").addEventListener(GWGestureEvent.DRAG, onViewerDrag);
			
			//document.getElementById("option1left").addEventListener(GWGestureEvent.TAP, onLeftOption1Tap);
			//document.getElementById("option2left").addEventListener(GWGestureEvent.TAP, onLeftOption2Tap);
			//document.getElementById("option3left").addEventListener(GWGestureEvent.TAP, onLeftOption3Tap);
			//document.getElementById("option1right").addEventListener(GWGestureEvent.TAP, onRightOption1Tap);
			//document.getElementById("option2right").addEventListener(GWGestureEvent.TAP, onRightOption2Tap);
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
			var current_model:Model = document.getElementById(e.target.id);
			var current_container:ObjectContainer3D = current_model.parent;
			
			if (e.value.n == 1)
			{
			  var val:Number = current_container.rotationX + e.value.drag_dy * .25;
			
			  if (val < minRotationX) val = minRotationX;
			  else if (val > maxRotationX) val = maxRotationX;
				
			  current_container.rotationY -= e.value.drag_dx * .5;
			  current_container.rotationX = val;
			}
		}
		
		private function onModelScale(e:GWGestureEvent):void 
		{
			var val:Number = main.scaleX + e.value.scale_dsx * .75;
			if (val < minScale) val = minScale;
			else if (val > maxScale)val = maxScale;
				
			main.scaleX = val;
			main.scaleY = val;
			main.scaleZ = val;
		}	
		
		private function onRotate(e:GWGestureEvent):void 
		{
			if (e.value.n == 8)
			{
				var fastest_displacement:Number = e.value.rotate_dthetaZ * 5;
				var fast_displacement:Number = e.value.rotate_dthetaZ * 4;
				var slow_displacement:Number = e.value.rotate_dthetaZ * 2;
				var slowest_displacement:Number = e.value.rotate_dthetaZ * 1;
				var curr_position:Vector3D = main.scenePosition;

				container1.moveForward(slowest_displacement);
				container2.moveBackward(slowest_displacement);
				container3.moveForward(slow_displacement);	
				container4.moveBackward(slow_displacement);
				container5.moveForward(fast_displacement);
				container6.moveBackward(fast_displacement);
				container7.moveBackward(fastest_displacement);
				container8.moveForward(fastest_displacement);

				container10.moveLeft(fast_displacement);
				container11.moveRight(fast_displacement);
				container12.moveRight(slow_displacement);	
				container13.moveLeft(slow_displacement);
				
				if (e.value.rotate_dthetaZ < -10.0)
				{
					reOrderContainers();
				}
				
				/*container5.moveRight(fast_displacement);
				container6.moveRight(slow_displacement);
				container7.moveLeft(fast_displacement);
				container8.moveRight(fast_displacement);*/
				
				// Check shell container position, so that everything combines back 
				// to the initial starting point and not beyond
				var final_position:Number = container1.z;
				if (final_position < 0) container1.z = 0;
				
				final_position = container2.z;
				if (final_position > 0) container2.z = 0;
				
				final_position = container3.z;
				if (final_position < 0) container3.z = 0;
				
				final_position = container4.z;
				if (final_position > 0) container4.z = 0;
				
				final_position = container5.z;
				if (final_position < 0) container5.z = 0;
				
				final_position = container6.z;
				if (final_position > 0) container6.z = 0;
				
				final_position = container7.z;
				if (final_position > 0) container7.z = 0;
				
				final_position = container8.z;
				if (final_position < 0) container8.z = 0;
			
				var finalX_position:Number = container10.x;
				if (finalX_position > 0) container10.x = 0;
				
				finalX_position = container11.x;
				if (finalX_position < 0) container11.x = 0;
				
				finalX_position = container12.x;
				if (finalX_position < 0) container12.x = 0;
				
				finalX_position = container13.x;
				if (finalX_position > 0) container13.x = 0;

				/*var final_position:Number = container1.x;
				
				//if (final_position > 700) container.x = 700;
				if (final_position < 0) container1.x = 0;
				//final_position = container1.x;
				//trace("final position of 1: " + final_position);
				
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
				
				final_position = container2.x;
				if (final_position > 0) container2.x = 0;
				if (final_position < -700) container2.x = -500;
				final_position = container2.x;
				trace("final position of 2: " + final_position);
					
				final_position = container3.x;
				if (final_position > 0) container3.x = 0;
				if (final_position < -700) container3.x = -300;
				final_position = container3.x;
				trace("final position of 3: " + final_position);*/

				var x:int = e.value.localX;
				var y:int = e.value.localY;
				point_dial.x = x;
				point_dial.y = y;
			
				fadeInDial(true);
				
				//dialValue = dialValue + event.value.rotate_dtheta;
			}
			else fadeInDial(false);
		}
		
		private function onDrag(event:GWGestureEvent):void
		{
			if (event.value.n == 3)
			{
				var val:Number = main.rotationX + event.value.drag_dy * .25;
			
				if (val < minRotationX) val = minRotationX;
				else if (val > maxRotationX) val = maxRotationX;
				
				main.rotationY -= event.value.drag_dx * .5;
				main.rotationX = val;
			}
			
			if (event.value.n == 5)
			{
				var val:Number = cam.rotationX + event.value.drag_dy * .25;
			
				if (val < minRotationX) val = minRotationX;
				else if (val > maxRotationX) val = maxRotationX;
				
				cam.rotationY -= event.value.drag_dx * .5;
				cam.rotationX = val;
			}
				
			/*if (event.value.n == 4)
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
			}*/
			//else animateBar(false);
		}
		
		private function onScale(e:GWGestureEvent):void
		{
			var val:Number = main.scaleX + e.value.scale_dsx * .75;
			
			if (val < minScale) val = minScale;
			else if (val > maxScale)val = maxScale;
			trace("Scaling: " + val);
			main.scaleX = val;
			main.scaleY = val;
			main.scaleZ = val;
		}

		private function onHotspotTap(e:GWGestureEvent):void 
		{
			var popup:ModelPopup = document.getElementById(e.target.vto.name);
			for (var i:int = 0; i < popups.length; i++) 
			{
				if (popups[i].visible && popups[i] != popup) 
				{
					popups[i].tweenOut();
				}
			}
			if (!popup.visible) 
			{
				//Center the popup on the finger tap
				popup.x = this.mouseX - popup.width/2;
				popup.y = this.mouseY - popup.height / 2;
				popup.tweenIn(); 
			}
			else popup.tweenOut();	
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
				
		
		private function reOrderContainers():void
		{
			//var popup:ModelPopup = document.getElementById(e.target.vto.name);
			
			
			// TODO: Issues with independent models rotating properly
			for (var i:int = 0; i < containers.length; i++) 
			{
				
				if (containers[i].id != "main") 
				{
					trace("Container = " + containers[i].id  + ", z location = ", + containers[i].z);
					TweenLite.to(containers[i], 3, { rotationX:0 } );
					TweenLite.to(containers[i], 3, { rotationY:0 } );
					TweenLite.to(containers[i], 3, { rotationZ:0 } );
					TweenLite.to(containers[i], 3, { x:0 } );
					TweenLite.to(containers[i], 3, { y:0 } );
					
					// Issue with z-axis re-orientation...
					//TweenLite.to(containers[i], 1, { z:0 } );
				}
			}
		}	
	}		
}