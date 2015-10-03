package 
{
	import AmidosEngine.AE;
	import AmidosEngine.Game;
	import AmidosEngine.OS;
	import com.mesmotronic.ane.AndroidFullScreen;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import com.sticksports.nativeExtensions.SilentSwitch;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import RPSwipe.Data.EmbeddedData;
	import RPSwipe.Data.EmbeddedGraphics;
	import RPSwipe.Data.EmbeddedSounds;
	import RPSwipe.Global;
	import RPSwipe.World.GameNameWorld;
	import RPSwipe.World.GameplayWorld;
	import starling.core.Starling;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class Main extends Sprite 
	{
		public static const FRAMERATE:int = 30;
		public static const SCREEN_WIDTH:Number = 240;
		
		[Embed(source = "../assets/graphics/LoadingPictures/1024.png")]private var ipadClass:Class;
		[Embed(source = "../assets/graphics/LoadingPictures/1136.png")]private var iphone5Class:Class;
		[Embed(source = "../assets/graphics/LoadingPictures/960.png")]private var iphone4Class:Class;
		
		private var mStarling:Starling;
		
		public static var currentLoadingScreen:Bitmap;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = FRAMERATE;
			stage.quality = StageQuality.LOW;
			
			stage.addEventListener(flash.events.Event.DEACTIVATE, Deactivate);
			stage.addEventListener(flash.events.Event.ACTIVATE, Activate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			var screenWidth:Number = stage.fullScreenWidth;
			var screenHeight:Number = stage.fullScreenHeight;
			if (AndroidFullScreen.isSupported && AndroidFullScreen.isImmersiveModeSupported)
			{
				screenWidth = AndroidFullScreen.immersiveWidth;
				screenHeight = AndroidFullScreen.immersiveHeight;
				
				AndroidFullScreen.immersiveMode();
			}
			
			//For Covering the loading
			if (screenHeight < 980)
			{
				currentLoadingScreen = new iphone4Class();
			}
			else if (screenHeight / screenWidth == 4 / 3)
			{
				currentLoadingScreen = new ipadClass();
			}
			else
			{
				currentLoadingScreen = new iphone5Class();
			}
			currentLoadingScreen.scaleX = screenWidth / currentLoadingScreen.width;
			currentLoadingScreen.scaleY = screenHeight / currentLoadingScreen.height;
			stage.addChild(currentLoadingScreen);
			
			// entry point
			AE.Intialize();
			
			if (GameCenter.isSupported())
			{
				SilentSwitch.apply();
			}
			
			if (GameCenter.isSupported())
			{
				GameCenter.create(stage);
				if (GameCenter.gameCenter.isGameCenterAvailable())
				{
					GameCenter.gameCenter.authenticateLocalUser();
				}
			}
			
			if (GoogleGames.isSupported())
			{
				GoogleGames.create();
				GoogleGames.games.signIn();
			}
			
			//loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
			
			Starling.multitouchEnabled = true;
			Starling.handleLostContext = true;
			
			mStarling = new Starling(Game, stage, new Rectangle(0, 0, screenWidth, screenHeight));
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, GameStarted);
			mStarling.stage.stageHeight = SCREEN_WIDTH * screenHeight / screenWidth;
			mStarling.stage.stageWidth = SCREEN_WIDTH;
			//mStarling.showStatsAt("right", "bottom", 1);
			mStarling.start();
		}
		
		//private function onUncaughtError(e:UncaughtErrorEvent):void
		//{
			//var text:TextField = new TextField();
			//text.text = e.error;
			//text.textColor = 0xFF000000;
			//addChild(text)
		//}
		
		private function GameStarted(e:starling.events.Event):void
		{
			mStarling.removeEventListener(starling.events.Event.ROOT_CREATED, GameStarted);
			
			AE.assetManager.enqueue(EmbeddedData);
			AE.assetManager.enqueue(EmbeddedSounds);
			AE.assetManager.enqueue(EmbeddedGraphics);
			
			AE.assetManager.loadQueue(LoadingFunction);
		}
		
		private function LoadingFunction(ratio:Number):void
		{
			if (ratio == 1)
			{
				NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, CheckButtonPressed);
				
				//start game
				AE.game.background.color = 0xFFFFFFFF;
				Global.Initialize();
				AE.game.ActiveWorld = new GameNameWorld();
				Global.PlayMusic();
			}
		}
		
		private function Deactivate(e:flash.events.Event):void 
		{
			Global.PauseMusic();
			if (mStarling != null)
			{
				mStarling.stop(true);
			}
		}
		
		private function Activate(e:flash.events.Event):void 
		{
			Global.ResumeMusic();
			if (mStarling != null)
			{
				mStarling.start();
			}
			
			if (GameCenter.isSupported())
			{
				SilentSwitch.apply();
			}
		}
		
		public static function CheckButtonPressed(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.BACK)
			{
				if (Global.backFunction != null)
				{
					e.preventDefault();
					Global.backFunction();
				}
			}
		}
	}
	
}