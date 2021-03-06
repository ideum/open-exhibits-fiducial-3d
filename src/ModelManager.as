package  
{
	import away3d.containers.ObjectContainer3D;
	import com.gestureworks.cml.away3d.elements.Scene;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.core.partition.SkyBoxNode;
	import away3d.primitives.SkyBox;
	import away3d.textures.BitmapTexture;
	import away3d.controllers.HoverController;
	import away3d.lights.DirectionalLight;
	import com.gestureworks.cml.elements.View;
	import com.gestureworks.objects.ClusterObject;

	import away3d.debug.Trident;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	
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
	//import flash.net.Socket;

	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.plugins.TweenPlugin;
	import flash.display.Sprite;

	// Get network and flash events
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.DataEvent;
	
	import flash.geom.Vector3D;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.DataEvent;
	
	/**
	* ...
	* @author John-Mark Collins	
	* * */
	
	public class ModelManager extends Sprite 
	{ 	
		//Controller for keeping the object in view
		private var cameraController:HoverController;	
        private var light:DirectionalLight;
		private var view:View3D;
		private var scene:Scene;
		
		// set to true for debugging purposes
		private var debug:Boolean = false;
		
		private var overlay:TouchSprite = new TouchSprite();
		private var cam:Camera = new Camera();
		private var model_container:TouchContainer3D;
		
		//scalable images for adjusting graphic size, based on fiducial size
		private var rotationGraphic:Image;
		
		//private var rotationGraphicBackward:Image;
		private var cameraGraphic:Image;
		
		//private var rotationGraphicBackward:Image;
		private var modelGraphic:Image;
		private var main:ObjectContainer3D;

		// specific models for complex radial transform operations
		private var rotor1:Model;
		private var rotor2:Model;
		private var rotor3:Model;
		private var pipes:Model;
		private var outerShell:Model;
		private var backShell:Model;
		private var centralShell:Model;
		private var innerShell:Model;
		private var combustionChamber:Model;
		
		private var minScale:Number = .25;
		private var maxScale:Number = 4;

		private var maxRotationX:Number = 20;
		private var minRotationX:Number = -maxRotationX;
		private var maxRotationY:Number = 45;
		private var minRotationY:Number = -maxRotationY;
	
		// array of popups for each model piece
		private var popups:Array;
		
		// array of models for rotating each one independently
		private var models:Array;
		
		//sample independent 3D model explosion
		private var model:Model;
		
		// array of models for rotating each one independently
		private var containers:Array;

		// UI elements for guidance
		private var rotation_dial:Container = document.getElementById("rotation_dial");
		private var cameraArrows:Container = document.getElementById("cameraArrows");
		private var modelArrows:Container = document.getElementById("modelArrows");

		// Elements for info screen and reset button 
		private var info_overlay:Image = document.getElementById("info_overlay");
		private var reset_overlay:Image = document.getElementById("reset_overlay");
		private var info_screen:Container = document.getElementById("info_screen");
		private var info_screen_exit:Image = document.getElementById("info_screen_icon");
		
		// State of the UI element for rotating dial rotation degree
		private var dialValue:Number = 0.0;
	
		// Timer for removing info screen 
		private var secTimer:Timer = new Timer(1000, 1);
		
		private var infoOn:Boolean = false;
		private var first:Boolean = true;
	
		public function ModelManager() 
		{
			TweenPlugin.activate([ShortRotationPlugin]);
			super();
		}
 
		public function init():void 
		{	
			scene = document.getElementById("main_scene");
			//view = scene.getChildAt(0);
			
			// get model
			model_container = document.getElementById("model_container");

            // Construct main screen and gesture enabling
			stage.addChild(overlay);
			
			//Get Camera from scene
			cam = document.getElementById("main_cam");
			cam.clipping = "20,5000";
			light = document.getElementById("light-1");
			
			// create camera controller
			cameraController = new HoverController( cam, null, 0, 0, -1500);
			cameraController.yFactor = 1;
			cameraController.wrapPanAngle = true;				
			//cameraController.lookAtPosition = new Vector3D(-500+Math.random()*500, -500+Math.random()*500, -500+Math.random()*500);
			
			// Add model to 3D scene 
			overlay.addChild(model_container);
		
			// add child gestures
			overlay.mouseChildren = true;
			overlay.clusterBubbling = true;
			
			// add events 
			overlay.gestureList = { "1-finger-tap": false, //finger
									"1-finger-drag": false, //finger
									"2-finger-scale": true, //finger
									"4-tag-rotate-3d": true, //tag
									"3-tag-drag-3d": true, // tag
									"5-tag-drag-3d": true}; //tag
									
		
			main = document.getElementById("main");
			
			// grab complex radial elements for explosions individually
			rotor1 = document.getElementById("front_fan");
			rotor2 = document.getElementById("central_fan");
			rotor3 = document.getElementById("back_fan");
			pipes = document.getElementById("pipes");
			outerShell = document.getElementById("outer_shell");
			backShell = document.getElementById("back_shell");
			centralShell = document.getElementById("central_shell");
			innerShell = document.getElementById("inner_shell");
			combustionChamber = document.getElementById("combustion_chamber");
				
			// grab all of the cml popup elements
			popups = document.getElementsByTagName(ModelPopup);
			
			// grab all of the cml popup elements
			models = document.getElementsByTagName(Model);
			
			var i:int;
			// Add popups to overlay as well
			for (i = 0; i < popups.length; i++)
			{
				overlay.addChild(popups[i]);
			}
			
			// grab all of the 3D container elements
			containers = document.getElementsByTagName(ObjectContainer3D);
			
			// graphics for fiducial objects
			rotationGraphic = document.getElementById("rotation_graphic");
			cameraGraphic = document.getElementById("camera_graphic");
			modelGraphic = document.getElementById("model_graphic");
		
			for (i = 0; i < models.length; i++)
			{
				models[i].vto.addEventListener(GWGestureEvent.DRAG, onModelDrag); //n=1
				models[i].vto.addEventListener(GWGestureEvent.TAP, onHotspotTap);
			}
				
			//mainScreen.addEventListener(GWGestureEvent.TAP, onTap);
			overlay.addEventListener(GWGestureEvent.ROTATE, onRotate); //will be TAG_ROTATE N=40
			overlay.addEventListener(GWGestureEvent.DRAG, onDrag); // will be TAG_DRAG N=3 AND N=5
			overlay.addEventListener(GWGestureEvent.SCALE, onScale); // WILL BE SCALE n=2
			overlay.addEventListener(GWGestureEvent.RELEASE, clear);
			
			// Add listeners for infor screen, exit button and reset button
			document.getElementById("info_overlay").addEventListener(GWGestureEvent.TAP, onInfoTap);
			document.getElementById("reset_overlay").addEventListener(GWGestureEvent.TAP, resetScreen);
			document.getElementById("info_screen_icon").addEventListener(GWGestureEvent.TAP, onInfoTapExit);
			
			// add event listener to every frame for animations
			this.stage.addEventListener( Event.ENTER_FRAME, this._onUpdate );
		
			// add listener for completion of timer event
			secTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerFunction);
		
			// create transparency for info screen and initial UI elements
			info_screen.alpha = 0;
			rotation_dial.alpha = 0;
			cameraArrows.alpha = 0;
			modelArrows.alpha = 0;
			
			// Add UI elements
			overlay.addChild(rotation_dial);
			overlay.addChild(cameraArrows);
			overlay.addChild(modelArrows);
			overlay.addChild(info_overlay);
			overlay.addChild(reset_overlay);
			
			// Set initial state of UI elements
			fade(rotation_dial, "out");
			fade(cameraArrows, "out");
			fade(modelArrows, "out");
		}
		
		// our update function
		private function _onUpdate( e:Event ):void
		{
			// call your function here
			dialValue = dialValue + 4.0;
			if (dialValue == 360) dialValue = 0.0;

			// up our count
			rotation_dial.rotationZ = dialValue;
			
			//point light at camera's view
			light.direction = cam.forwardVector;
		}
		
		private function onModelDrag(e:GWGestureEvent):void 
		{
			/*var clusterObject:ClusterObject = e.target.cO;
			trace(clusterObject.x, clusterObject.y);
			
			var pt1:Point = new Point(clusterObject.x, clusterObject.y);
			var pt2:Point;
			
			if (!first) pt2 = new Point(clusterObject.history[0].x, clusterObject.history[0].y);
			else 
			{
				pt2 = new Point(clusterObject.x, clusterObject.y);
				first = false;
			}
			
			trace(pt1);
			trace(pt2);
			
			var v1:Vector3D = view.unproject(pt1.x, pt1.y, e.target.distance);
			var v2:Vector3D = view.unproject(pt2.x, pt2.y, e.target.distance);
			
			trace(v1);
			trace(v2);
			
			//var v:Vector3D = view.unproject(e.value.stageX, e.value.stageY, e.target.distance);
			//var cubeParentMtxInv:Matrix3D = cube.parent.inverseSceneTransform;
			//v1 = cubeParentMtxInv.transformVector(v1);
			//v2 = cubeParentMtxInv.transformVector(v2);
			
			var dx:Number = v1.x - v2.x;
			var dy:Number = v1.y - v2.y;
			var dz:Number = v1.z - v2.z;
			
			e.target.parent.x += dx;
			e.target.parent.y += dy;
			e.target.parent.z += dz;
			
			//cube.position = new Vector3D(dx, dy, dz);
			
			trace(e.target.parent.position);
			//newV = new Vector3D(e.value.stageX, e.value.stageY, e.target.distance);
			
			
			/*var current_model:Model = document.getElementById(e.target.id);
			var current_container:ObjectContainer3D = current_model.parent;

			if (e.value.n == 1)
			{
			  viewerBasedTranslation(current_container, e.value.drag_dx, e.value.drag_dy);
			}*/
		}
		
		private function onRotate(e:GWGestureEvent):void 
		{
			if (!infoOn)
			{
				if (e.value.n == 4)
				{
					// Create various speeds for explosion based on user input
					var fastest_displacement:Number = e.value.rotate_dthetaZ * 5;
					var fast_displacement:Number = e.value.rotate_dthetaZ * 4;
					var slow_displacement:Number = e.value.rotate_dthetaZ * 2;
					var slowest_displacement:Number = e.value.rotate_dthetaZ * 1;
					var curr_position:Vector3D = main.scenePosition;
					
					
					// Move each model piece in a partcular motion, based on its size and location
					// within the model
					for (var i:int = 0; i < containers.length; i++)
					{
						var final_position:Number = 0;
						
						if (containers[i].id == "container09") 
						{
							containers[i].moveLeft(slow_displacement);
							final_position = containers[i].x;
							if (final_position > 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container10") 
						{
							containers[i].moveLeft(fastest_displacement);
							final_position = containers[i].x;
							if (final_position > 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container11") 
						{
							containers[i].moveRight(fastest_displacement);
							final_position = containers[i].x;
							if (final_position < 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container12") 
						{
							containers[i].moveRight(slow_displacement);	
							final_position = containers[i].x;
							if (final_position < 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container13") 
						{
							containers[i].moveLeft(slow_displacement);
							final_position = containers[i].x;
							if (final_position > 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container14") 
						{
							containers[i].moveRight(fast_displacement);
							final_position = containers[i].x;
							if (final_position < 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container19") 
						{
							containers[i].moveLeft(fast_displacement);
							final_position = containers[i].x;
							if (final_position > 0) containers[i].x = 0;
						}
						else if (containers[i].id == "container20") 
						{
							containers[i].moveRight(slow_displacement);
							final_position = containers[i].z;
							if (final_position < 0) containers[i].z = 0;
						}
						else if (containers[i].id == "container21") 
						{
							containers[i].moveRight(slowest_displacement);
							final_position = containers[i].z;
							if (final_position < 0) containers[i].z = 0;
						}
						else if (containers[i].id == "container22") 
						{
							containers[i].moveLeft(slowest_displacement);
							final_position = containers[i].x;
							if (final_position > 0) containers[i].x = 0;
						}
					}
					
					// explode radial pieces based on how many pieces there are
					// and the location (degree) of the starting piece.
					explodeRadialModelYZ(rotor1, fast_displacement, 180.0);
					explodeRadialModelYZ(rotor2, fast_displacement, 180.0);
					explodeRadialModelYZ(rotor3, slow_displacement, 180.0);
					explodeRadialModelYZ(pipes, slow_displacement, 180.0);
					explodeRadialModelYZ(outerShell, fastest_displacement, 90.0);
					explodeRadialModelYZ(backShell, slowest_displacement, 180.0);
					explodeRadialModelYZ(centralShell, slow_displacement, 180.0);
					explodeRadialModelYZ(innerShell, fast_displacement, 180.0);
					explodeRadialModelYZ(combustionChamber, slowest_displacement, 90.0);
					
					// re-orient the containers back to their original orientation
					// negates viewer interaction and rotation
					if (e.value.rotate_dthetaZ < -10.0)
					{
						reOrderContainers();
						implodeRadialModelYZ(rotor1);
						implodeRadialModelYZ(rotor2);
						implodeRadialModelYZ(rotor3);
						implodeRadialModelYZ(pipes);
						implodeRadialModelYZ(outerShell);
						implodeRadialModelYZ(backShell);
						implodeRadialModelYZ(centralShell);
						implodeRadialModelYZ(innerShell);
						implodeRadialModelYZ(combustionChamber);
					}

					// draw rotating dial animation
					var x:int = e.value.localX;
					var y:int = e.value.localY;
					rotation_dial.x = x;
					rotation_dial.y = y;
				
					fade(rotation_dial, "in");
					fade(cameraArrows, "out");
					fade(modelArrows, "out");

				}
				else fade(rotation_dial, "out");
			}
		}
		
		private function onDrag(e:GWGestureEvent):void
		{
			var valX:Number;
			var valY:Number;
			var imageScale:Number;
			var x:int;
			var y:int;
			
			if (!infoOn)
			{
				/*if (e.value.n == 3)
				{
					// redraw model rotate arrows at fiducial location
					x = e.value.localX;
					y = e.value.localY;
					modelArrows.x = x;
					modelArrows.y = y;
					
					fade(modelArrows, "in");
					fade(cameraArrows, "out");
					fade(rotation_dial, "out");
					
					// get current full model rotation and apply new change in rotation
					valY = main.rotationY + e.value.drag_dx * -.25;
					valX = main.rotationX + e.value.drag_dy * -.25;
				
					main.rotationY = valY;
					main.rotationX = valX;
				}*/
				if (e.value.n == 3)
				{
					// redraw camera arrows at fiducial location
					x = e.value.localX;
					y = e.value.localY;
					cameraArrows.x = x;
					cameraArrows.y = y;
					
					fade(cameraArrows, "in");
					fade(rotation_dial, "out");
					fade(modelArrows, "out");
					
					// move camera controller based on fiducial drag
					onCameraDrag(e);
				}
				else fade(cameraArrows, "out");
			}
		}
		
		private function onScale(e:GWGestureEvent):void
		{
			trace("scaling");
			if (!infoOn)
			{
				var val:Number = main.scaleX + e.value.scale_dsx * .5;
				if (val < minScale) val = minScale;
				else if (val > maxScale) val = maxScale;
				
				// scale the entire model, not individual pieces
				main.scaleX = val;
				main.scaleY = val;
				main.scaleZ = val;
			}
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
				// Make sure the popup stays on the screen
				if (this.mouseX + 330 > overlay.width) popup.x = overlay.width - 330;
				else popup.x = this.mouseX;
				if (this.mouseY + 435 > overlay.height) popup.y = overlay.height - 435;
				else popup.y = this.mouseY;

				popup.tweenIn(); 
			}
			else popup.tweenOut();	
		}
		
		private function timerFunction(e:Event = null):void
		{
			if (overlay.contains(info_screen))  overlay.removeChild(info_screen);
		}
		
		private function onInfoTap(e:GWGestureEvent):void
		{
			info_screen.alpha = 0;
			overlay.addChild(info_screen);
			if (info_screen.visible == false) info_screen.visible = true;
			fade(info_screen, "in");
			infoOn = true;
			clearPopups();
		}
			
		private function onInfoTapExit(e:GWGestureEvent):void
		{
			infoOn = false;
			fade(info_screen, "out");
			secTimer.start();
		}
					
		private function fade(item: Container, direction:String):void 
		{
			if (direction == "in")
			{
				if (item.visible == false) item.visible = true;
				TweenLite.to(item, 0.5, { alpha:1} );
			}
			else
			{
				TweenLite.to(item, 0.5, { alpha:0 } );	
				if (item.visible == false) item.visible = true;
			}
		}
				
		private function reOrderContainers():void
		{
			
			for (var i:int = 0; i < containers.length; i++) 
			{
				// return all containers other than the camera, main model container and light 
				// back to original starting coordinates
				if (containers[i].id != "main_cam" && containers[i].id != "light-1") 
				{
					trace("Container = " + containers[i].id  + ", z location = ", + containers[i].z);
					TweenLite.to(containers[i], 1, { rotationX:0 } );
					if (containers[i].id == "main")
					{
						TweenLite.to(containers[i], 1, { rotationY:-55 } );
					}
					else TweenLite.to(containers[i], 1, { rotationY:0 } );
					TweenLite.to(containers[i], 1, { rotationZ:0 } );
					TweenLite.to(containers[i], 1, { x:0 } );
					TweenLite.to(containers[i], 1, { y:0 } );
					TweenLite.to(containers[i], 1, { z:0 } );
				}
			}
		}	
		
		private function implodeRadialModelYZ(whole_model:Model):void 
		{
			for (var i:int = 0; i < whole_model.numChildren; i++) 
			{
				// return all radial elements to the center
				TweenLite.to(whole_model.getChildAt(i), 1, { y:0 } );
				TweenLite.to(whole_model.getChildAt(i), 1, { z:0 } );
			}
		}	
		
		private function explodeRadialModelYZ(whole_model:Model, displacement:Number, startingAngle:Number):void 
		{
			// starting point of first radial element (at 180 for this demo)
			// set the starting angle of your index[0] element
			// e.g: if you first radial element is straight up, set to 90
			var totalRotation:Number = startingAngle;
			
			// gets the total number of elements
			var degree:int = whole_model.numChildren;
			
			// sets the degree amount between elements
			var spacer:Number = 360 / degree;
			
			// amount to change on eah call (based on user input rotation)
			var newZ:Number = 0;
			var newY:Number = 0;
			
			// loop through each of the elements in the model
			for (var i:int = 0; i < degree; i++) 
			{
				// swith to radians for cosine and sine calculations
				var radianValue:Number = radians(totalRotation);
				
				newZ = (displacement * ((-1)*Math.cos(radianValue)));
				newY = (displacement * Math.sin(radianValue));
				
				if (debug)
				{
				  trace(" ");
				  trace("Sin totalRotation = " + Math.sin(radianValue));
				  trace("Cos totalRotation = " + Math.cos(radianValue));
				  trace("total rotation = " + totalRotation);
				  trace("New z = " + newZ);
				  trace("New y = " + newY);
				  trace(whole_model.getChildAt(i).id);
				  trace(whole_model.getChildAt(i).name);
				}
				
				whole_model.getChildAt(i).y += newY;
				whole_model.getChildAt(i).z += newZ;
				
				// limit objects to starting vertical position upon reverse motion
				if (totalRotation < 180 && whole_model.getChildAt(i).y < 0) whole_model.getChildAt(i).y = 0;
				if (totalRotation > 180 && whole_model.getChildAt(i).y > 0) whole_model.getChildAt(i).y = 0;
				
				// limit objects to starting horizontal position upon reverse motion
				if ((totalRotation < 90 || totalRotation > 270) && whole_model.getChildAt(i).z > 0) whole_model.getChildAt(i).z = 0;
				if (totalRotation > 90 && totalRotation < 270 && whole_model.getChildAt(i).z < 0) whole_model.getChildAt(i).z = 0;

				// decrease the degrees as you move through elements
				// for this demo, elements were arranged in increasing fashion going clockwise, 
				// thus the negative, counterclockwise would be positive
				totalRotation -= spacer;
				if (totalRotation <= 0) totalRotation = totalRotation + 360;
			}
		}
	
		
		
		private function clear(e:GWGestureEvent=null):void
		{
			fade(cameraArrows, "out");
			fade(rotation_dial, "out");
			fade(modelArrows, "out");
			first = true; 
		}
		
		private function clearPopups(e:GWGestureEvent=null):void
		{
			for (var i:int = 0; i < popups.length; i++) 
			{
				if (popups[i].visible) 
				{
					popups[i].tweenOut();
				}
			}
		}
		
		private function resetScreen(e:GWGestureEvent = null):void
		{
			clearPopups();
			clear();
		    reOrderContainers();
			implodeRadialModelYZ(rotor1);
			implodeRadialModelYZ(rotor2);
			implodeRadialModelYZ(rotor3);
			implodeRadialModelYZ(pipes);
			implodeRadialModelYZ(outerShell);
			implodeRadialModelYZ(backShell);
			implodeRadialModelYZ(centralShell);
			implodeRadialModelYZ(innerShell);
			implodeRadialModelYZ(combustionChamber);
			resetCamera();
		}
		
		private function viewerBasedTranslation(currentContainer:ObjectContainer3D, distanceX:Number, distanceY:Number):void
		{
			trace("X change = " + distanceX);
			trace("Y change = " + distanceY);
			trace("Container = " + currentContainer.id);
						  
			// translate each model, based on orientation
			var valZ:Number = currentContainer.z + (int)(distanceX * .1 * (cam.rotationY/90));
			var valX:Number = currentContainer.x + (int)(distanceX * .1 * (1 - cam.rotationY/90));
			var valY:Number = currentContainer.y + (int)(distanceY * .1);
			
			//var valY:Number = current_container.z + (int)(e.value.drag_dy * .1);
			currentContainer.y = valY;
			currentContainer.x = valX;
			currentContainer.z = valZ;
			  
			trace("newX =" + currentContainer.x);
			trace("newY =" + currentContainer.y);
			trace("newZ =" + currentContainer.z);
			
		}
		
		private function resetCamera(e:GWGestureEvent = null):void
		{
			TweenLite.to(cam, 1, { rotationY:0 } );
			TweenLite.to(cam, 1, { rotationX:0 } );
			TweenLite.to(cam, 1, { x:0 } );
			TweenLite.to(cam, 1, { y:200 } );
			TweenLite.to(cam, 1, { z: -1500 } );
			
			TweenLite.to(main, 1, { scaleX: 1 } );
			TweenLite.to(main, 1, { scaleY: 1 } );
			TweenLite.to(main, 1, { scaleZ: 1 } );
		}
		
		private function radians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		
		/**
		 * Camera drag event handler
		 */
		private function onCameraDrag(e:GWGestureEvent):void 
		{		
			// apply gesture drag values to cameraController with arbituary scale factor (.25);
			cameraController.panAngle += e.value.drag_dx * .25;
			cameraController.tiltAngle += e.value.drag_dy * .25;
					
			trace("camera drag values:", e.value.drag_dx, e.value.drag_dy);
		}
	}		
}