package com.nicolaspigelet.kinect
{
	import com.as3nui.nativeExtensions.air.kinect.constants.CameraResolution;
	import com.as3nui.nativeExtensions.air.kinect.data.SkeletonJoint;
	import com.as3nui.nativeExtensions.air.kinect.data.User;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.DeviceEvent;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.cornflex.ribbons.RibbonManager;
	
	/**
	 * ...
	 * @author nico
	 */
	public class Main extends Sprite 
	{
		private var bmpCamera:Bitmap;
		
		private var kinect:Kinect;
		private var settings:KinectSettings;
		private var skeleton:Sprite;
		
		private var ribbonContainer:Sprite;
		private var rightHandRibbonManager:RibbonManager;
		private var leftHandRibbonManager:RibbonManager;
		
		public function Main():void 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_BORDER;
			stage.displayState = StageDisplayState.FULL_SCREEN;
			stage.nativeWindow.addEventListener( Event.RESIZE, onResize);
			stage.nativeWindow.visible = true;
			
			ribbonContainer = new Sprite();
			ribbonContainer.x = (stage.stageWidth - 640) * .5;
			ribbonContainer.y = (stage.stageHeight - 480) * .5;
			addChild(ribbonContainer);
			
			rightHandRibbonManager = new RibbonManager(ribbonContainer, 2, 50, .2);
			leftHandRibbonManager = new RibbonManager(ribbonContainer, 2, 50, .2);
			rightHandRibbonManager.setGravity(0);
			leftHandRibbonManager.setGravity(0);
			
			if ( Kinect.isSupported() ) {
				
				bmpCamera = new Bitmap();
				bmpCamera.visible = false;
				addChild(bmpCamera);
				
				skeleton = new Sprite();
				skeleton.visible = false;
				addChild(skeleton);
				
				kinect = Kinect.getDevice();
				
				kinect.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageHandler);
				kinect.addEventListener(DeviceEvent.STARTED, startHandler);
				kinect.addEventListener(DeviceEvent.STOPPED, stopHandler);
				
				settings = new KinectSettings();
				settings.depthEnabled = true;
				settings.depthResolution = CameraResolution.RESOLUTION_640_480;
				settings.skeletonEnabled = true;
				
				kinect.start(settings);
				
			}
		}
		
		private function onResize(e:Event):void 
		{
			ribbonContainer.x = (stage.stageWidth - 640) * .5;
			ribbonContainer.y = (stage.stageHeight - 480) * .5;
		}
		
		private function depthImageHandler(e:CameraImageEvent):void 
		{
			bmpCamera.bitmapData = e.imageData;
		}
		
		private function startHandler(e:DeviceEvent):void 
		{
			trace("start");
			addEventListener(Event.ENTER_FRAME, drawSkeleton);
		}
		
		private function stopHandler(e:DeviceEvent):void 
		{
			trace("stop");
			skeleton.graphics.clear();
			removeEventListener(Event.ENTER_FRAME, drawSkeleton);
		}
		
		private function drawSkeleton(e:Event):void 
		{
			skeleton.graphics.clear();
			for each ( var user : User in kinect.usersWithSkeleton ) {
				
				rightHandRibbonManager.update(user.rightHand.depthPosition.x, user.rightHand.depthPosition.y);
				leftHandRibbonManager.update(user.leftHand.depthPosition.x, user.leftHand.depthPosition.y);
				
				for each ( var joint : SkeletonJoint in user.skeletonJoints ) {
					skeleton.graphics.beginFill(0xff0099);
					skeleton.graphics.lineStyle(0, 0, 0);
					skeleton.graphics.drawCircle(joint.depthPosition.x, joint.depthPosition.y, 1);
					skeleton.graphics.endFill();
				}
				
			}
		}
		
	}
	
}