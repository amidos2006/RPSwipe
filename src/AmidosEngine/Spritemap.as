package AmidosEngine 
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Spritemap extends Sprite
	{
		private var animations:Array;
		private var currentAnimation:String;
		private var endFunction:Function;
		
		private var localScaleX:Number;
		private var localScaleY:Number;
		private var localRotation:Number;
		private var localPivotX:Number;
		private var localPivotY:Number;
		private var localWidth:Number;
		private var localHeight:Number;
		private var localAlpha:Number;
		private var localSmoothing:String;
		
		override public function set pivotX(value:Number):void 
		{
			localPivotX = value;
			UpdateAllAnimation();
		}
		
		override public function get pivotX():Number 
		{
			return localPivotX;
		}
		
		override public function set pivotY(value:Number):void 
		{
			localPivotY = value;
			UpdateAllAnimation();
		}
		
		override public function get pivotY():Number 
		{
			return localPivotY;
		}
		
		override public function set scaleX(value:Number):void 
		{
			localScaleX = value;
			UpdateAllAnimation();
		}
		
		override public function get scaleX():Number 
		{
			return localScaleX;
		}
		
		override public function set scaleY(value:Number):void 
		{
			localScaleY = value;
			UpdateAllAnimation();
		}
		
		override public function get scaleY():Number 
		{
			return localScaleY;
		}
		
		override public function set rotation(value:Number):void 
		{
			localRotation = value;
			UpdateAllAnimation();
		}
		
		override public function get rotation():Number 
		{
			return localRotation;
		}
		
		override public function set alpha(value:Number):void 
		{
			localAlpha = value;
			UpdateAllAnimation();
		}
		
		override public function get alpha():Number 
		{
			return localAlpha;
		}
		
		public function set smoothing(value:String):void 
		{
			localSmoothing = value;
			UpdateAllAnimation();
		}
		
		public function get smoothing():String 
		{
			return localSmoothing;
		}
		
		public function get CurrentAnimation():String
		{
			return this.currentAnimation;
		}
		
		public function get currentFrame():int
		{
			if (currentAnimation != "")
			{
				return animations[currentAnimation].currentFrame;
			}
			
			return -1;
		}
		
		override public function set width(value:Number):void 
		{
			localWidth = value;
		}
		
		override public function get width():Number 
		{
			return localWidth * localScaleX;
		}
		
		override public function set height(value:Number):void 
		{
			localHeight = value;
		}
		
		override public function get height():Number 
		{
			return localHeight * localScaleY;
		}
		
		private function UpdateAllAnimation():void
		{
			for each (var movieClip:MovieClip in animations) 
			{
				movieClip.pivotX = localPivotX;
				movieClip.pivotY = localPivotY;
				movieClip.scaleX = localScaleX;
				movieClip.scaleY = localScaleY;
				movieClip.rotation = localRotation;
				movieClip.alpha = localAlpha;
				movieClip.smoothing = localSmoothing;
			}
		}
		
		override public function alignPivot(hAlign:String = "center", vAlign:String = "center"):void 
		{
			switch (hAlign) 
			{
				case HAlign.CENTER:
					localPivotX = localWidth / 2;
					break;
				case HAlign.LEFT:
					localPivotX = 0;
					break;
				case HAlign.RIGHT:
					localPivotX = localWidth;
					break;
			}
			
			switch (vAlign) 
			{
				case VAlign.CENTER:
					localPivotY = localHeight / 2;
					break;
				case VAlign.TOP:
					localPivotY = 0;
					break;
				case VAlign.BOTTOM:
					localPivotY = localHeight;
					break;
			}
			
			UpdateAllAnimation();
		}
		
		public function Spritemap(w:Number, h:Number, animationEnd:Function = null) 
		{
			localPivotX = 0;
			localPivotY = 0;
			localScaleX = 1;
			localScaleY = 1;
			localRotation = 0;
			localAlpha = 1;
			localSmoothing = "none";
			
			localWidth = w;
			localHeight = h;
			
			currentAnimation = "";
			endFunction = animationEnd;
			animations = new Array();
		}
		
		public function AddAnimation(animationName:String, fps:Number = 1, looping:Boolean = true):void
		{
			var movieClip:MovieClip = new MovieClip(AE.assetManager.getTextures(animationName), fps);
			movieClip.loop = looping;
			movieClip.pivotX = localPivotX;
			movieClip.pivotY = localPivotY;
			movieClip.scaleX = localScaleX;
			movieClip.scaleY = localScaleY;
			movieClip.rotation = localRotation;
			movieClip.alpha = localAlpha;
			movieClip.smoothing = localSmoothing;
			animations[animationName] = movieClip;
		}
		
		public function PlayAnimation(animationName:String, reset:Boolean = false):void
		{
			if (currentAnimation != animationName)
			{
				StopAnimation();
				currentAnimation = animationName;
				
				animations[currentAnimation].addEventListener(Event.COMPLETE, EndAnimation);
				addChild(animations[currentAnimation]);
				animations[currentAnimation].play();
				Starling.current.juggler.add(animations[currentAnimation]);
			}
			else if (reset)
			{
				animations[currentAnimation].stop();
				animations[currentAnimation].play();
			}
		}
		
		private function EndAnimation(e:Event):void
		{
			if (!animations[currentAnimation].loop && endFunction != null)
			{
				PauseAnimation();
				endFunction();
			}
		}
		
		public function PauseAnimation():void
		{
			animations[currentAnimation].pause();
		}
		
		public function ResumeAnimation():void
		{
			animations[currentAnimation].play();
		}
		
		public function StopAnimation():void
		{
			if (currentAnimation != "")
			{
				animations[currentAnimation].removeEventListener(Event.COMPLETE, EndAnimation);
				animations[currentAnimation].stop();
				removeChild(animations[currentAnimation]);
				Starling.current.juggler.remove(animations[currentAnimation]);
			}
			
			currentAnimation = "";
		}
	}

}