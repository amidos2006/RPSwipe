package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import RPSwipe.Global;
	import RPSwipe.LayerConstants;
	import RPSwipe.World.MainMenuWorld;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TutorialTextEntity extends Entity
	{
		private var tutorialText:TextField;
		private var textArray:Array;
		private var currentIndex:int;
		private var backButton:BackButtonEntity;
		private var restartButton:RestartButtonEntity;
		
		private var clickSfx:Sfx;
		
		public function TutorialTextEntity() 
		{
			currentIndex = 0;
			
			clickSfx = new Sfx(AE.assetManager.getSound("clickSound"));
			
			textArray = new Array();
			var tutorialXML:XML = AE.assetManager.getXml("tutorialText");
			for each (var text:Object in tutorialXML.Text) 
			{
				var string:String = text[0];
				string = string.replace(/\\n/g, "\n");
				textArray.push(string);
			}
			
			tutorialText = new TextField(AE.game.width, (AE.game.height - GridEntity.Y_TILES * TileEntity.TILE_SIZE) * 0.5, textArray[currentIndex] , "gameFont", 12, 0x777777);
			tutorialText.alignPivot("center", "bottom");
			tutorialText.x = AE.game.width / 2;
			tutorialText.y = Global.GetFromTile(0, 0).y - TileEntity.TILE_SIZE / 2;
			
			backButton = new BackButtonEntity();
			backButton.releaseFunction = GoToMainMenu;
			
			restartButton = new RestartButtonEntity();
			restartButton.releaseFunction = RestartGrid;
			
			graphic = tutorialText;
			layer = LayerConstants.HUD_LAYER;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			world.AddEntity(backButton);
			Global.backFunction = GoToMainMenu;
		}
		
		override public function remove():void 
		{
			super.remove();
			
			world.RemoveEntity(backButton);
			Global.backFunction = null;
		}
		
		private function GoToMainMenu():void
		{
			clickSfx.Play();
			AE.game.ActiveWorld = new MainMenuWorld(false);
		}
		
		public function GetNext():void
		{
			currentIndex += 1;
			tutorialText.text = textArray[currentIndex];
		}
		
		public function GetNumber():int
		{
			return currentIndex;
		}
		
		public function ShowRestart():void
		{
			world.AddEntity(restartButton);
		}
		
		public function HideRestart():void
		{
			world.RemoveEntity(restartButton);
		}
		
		private function RestartGrid():void
		{
			clickSfx.Play();
			(Global.currentGrid as TutorialGridEntity).RestartGrid();
		}
	}

}