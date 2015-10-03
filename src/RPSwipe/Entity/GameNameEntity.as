package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import RPSwipe.Global;
	import RPSwipe.World.MainMenuWorld;
	import RPSwipe.World.TutorialWorld;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;
	import RPSwipe.LayerConstants;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameNameEntity extends Entity
	{
		private var touchText:TextField;
		private var gamebyText:TextField;
		private var flikerAlarm:DelayedCall;
		
		private var clickSfx:Sfx;
		private var id:int;
		
		public function GameNameEntity() 
		{
			x = AE.game.width / 2;
			y = AE.game.height / 2 - 10;
			
			id = -1;
			
			clickSfx = new Sfx(AE.assetManager.getSound("clickSound"));
			
			var image:Image = new Image(AE.assetManager.getTexture("gameLogo"));
			image.smoothing = "none";
			image.alignPivot("center", "center");
			
			touchText = new TextField(AE.game.width, 12, "Touch to Start", "gameFont", 12, 0x555555);
			touchText.alignPivot("center", "center");
			touchText.y += touchText.height / 2 + image.height / 2 + 5;
			
			gamebyText = new TextField(AE.game.width, 32, "Game by Amidos\nMusic by Tom Snively", "gameFont", 12, 0x555555);
			gamebyText.alignPivot("center", "bottom");
			gamebyText.y = AE.game.height / 2 + 10;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(image);
			sprite.addChild(touchText);
			sprite.addChild(gamebyText);
			
			graphic = sprite;
			layer = LayerConstants.HUD_LAYER;
			
			flikerAlarm = new DelayedCall(ChangeAlpha, 0.5);
			flikerAlarm.repeatCount = 0;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			Starling.current.juggler.add(flikerAlarm);
			AE.AddPressFunction(PressCheck);
			AE.AddReleaseFunction(GoToMainMenu);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			Starling.current.juggler.remove(flikerAlarm);
			AE.RemovePressFunction(PressCheck);
			AE.RemoveReleaseFunction(GoToMainMenu);
		}
		
		private function ChangeAlpha():void
		{
			touchText.alpha = 1 - touchText.alpha;
		}
		
		private function PressCheck(tX:Number, tY:Number, tID:int):void
		{
			if (AE.NumberOfTouches > Global.MAX_TOUCHES)
			{
				return;
			}
			
			if (id == -1)
			{
				id = tID;
			}
		}
		
		private function GoToMainMenu(tX:Number, tY:Number, tID:int):void
		{
			if (id != tID)
			{
				return;
			}
			
			id = -1;
			clickSfx.Play();
			if (Global.firstTime)
			{
				AE.game.ActiveWorld = new TutorialWorld();
			}
			else
			{
				AE.game.ActiveWorld = new MainMenuWorld(true);
			}
		}
		
	}

}