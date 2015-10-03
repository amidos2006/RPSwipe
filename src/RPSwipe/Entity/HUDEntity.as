package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.NumberOfTurns;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Global;
	import RPSwipe.World.GameplayWorld;
	import RPSwipe.World.MainMenuWorld;
	import starling.display.Image;
	import starling.display.Sprite;
	import RPSwipe.LayerConstants;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HUDEntity extends Entity
	{
		private var scoreText:TextField;
		private var scoreValueText:TextField;
		
		private var blueScoreText:TextField;
		private var blueScoreValueText:TextField;
		private var redScoreText:TextField;
		private var redScoreValueText:TextField;
		
		private var turnsText:TextField;
		private var turnsValueText:TextField;
		
		private var playerTurnText:TextField;
		
		private var nextText:TextField;
		private var nextTileImage:Image;
		
		private var backButton:BackButtonEntity;
		private var restartButton:RestartButtonEntity;
		
		private var clickSfx:Sfx;
		
		public function HUDEntity(nextColor:String, nextType:String) 
		{
			x = AE.game.width / 2;
			
			clickSfx = new Sfx(AE.assetManager.getSound("clickSound"));
			
			if (Global.currentMode != GameplayTypes.MULTIPLAYER && Global.currentMode != GameplayTypes.VERSUS)
			{
				scoreValueText = new TextField(AE.game.width / 2, 48, "0", "gameFont", 48, 0x777777);
				scoreValueText.alignPivot("center", "bottom");
				scoreValueText.y = AE.game.height;
				
				scoreText = new TextField(AE.game.width / 2, 12, "score", "gameFont", 12, 0x555555);
				scoreText.alignPivot("center", "bottom");
				scoreText.y = scoreValueText.y - scoreValueText.height;
				
				if (Global.currentTurns != NumberOfTurns.TURNS_INF)
				{
					scoreValueText.hAlign = "left";
					scoreValueText.alignPivot("left", "bottom");
					scoreValueText.x = -AE.game.width / 2 + 10;
					
					scoreText.hAlign = "left";
					scoreText.alignPivot("left", "bottom");
					scoreText.x = scoreValueText.x;
				}
			}
			else
			{
				blueScoreValueText = new TextField(AE.game.width / 2, 48, "0", "gameFont", 48, TileColor.GetColor(TileColor.BLUE));
				blueScoreValueText.hAlign = "left";
				blueScoreValueText.alignPivot("left", "bottom");
				blueScoreValueText.x = -AE.game.width / 2 + 10;
				blueScoreValueText.y = AE.game.height;
				
				blueScoreText = new TextField(AE.game.width / 2, 12, "score", "gameFont", 12, TileColor.GetColor(TileColor.BLUE) - 0x333333);
				blueScoreText.hAlign = "left";
				blueScoreText.alignPivot("left", "bottom");
				blueScoreText.x = blueScoreValueText.x;
				blueScoreText.y = blueScoreValueText.y - blueScoreValueText.height;
				
				redScoreValueText = new TextField(AE.game.width / 2, 48, "0", "gameFont", 48, TileColor.GetColor(TileColor.RED));
				redScoreValueText.hAlign = "right";
				redScoreValueText.alignPivot("right", "bottom");
				redScoreValueText.x = AE.game.width / 2 - 10;
				redScoreValueText.y = AE.game.height;
				
				redScoreText = new TextField(AE.game.width / 2, 12, "score", "gameFont", 12, TileColor.GetColor(TileColor.RED) - 0x333333);
				redScoreText.hAlign = "right";
				redScoreText.alignPivot("right", "bottom");
				redScoreText.x = redScoreValueText.x;
				redScoreText.y = redScoreValueText.y - redScoreValueText.height;
				
				playerTurnText = new TextField(AE.game.width, 12, "Blue Player Turn", "gameFont", 12, TileColor.GetColor(TileColor.BLUE));
				playerTurnText.alignPivot("center", "bottom");
				playerTurnText.y = Global.GetFromTile(0, 0).y - TileEntity.TILE_SIZE / 2 - 3;
			}
			
			if (Global.currentTurns != NumberOfTurns.TURNS_INF)
			{
				turnsValueText = new TextField(AE.game.width / 2, 48, NumberOfTurns.GetNumberTurns(Global.currentTurns).toString(), "gameFont", 48, 0x777777);
				turnsValueText.alignPivot("center", "bottom");
				turnsValueText.y = AE.game.height;
				
				turnsText = new TextField(AE.game.width / 2, 12, "turns", "gameFont", 12, 0x555555);
				turnsText.alignPivot("center", "bottom");
				turnsText.y = AE.game.height - turnsValueText.height;
				
				if (Global.currentMode != GameplayTypes.MULTIPLAYER && Global.currentMode != GameplayTypes.VERSUS)
				{
					turnsValueText.hAlign = "right";
					turnsValueText.alignPivot("right", "bottom");
					turnsValueText.x = AE.game.width / 2 - 10;
					
					turnsText.hAlign = "right";
					turnsText.alignPivot("right", "bottom");
					turnsText.x = turnsValueText.x;
				}
			}
			
			nextText = new TextField(AE.game.width, 12, "next", "gameFont", 12, 0x555555);
			nextText.alignPivot("center", "top");
			nextText.y = 10;
			
			nextTileImage = new Image(AE.assetManager.getTexture("next" + nextColor + nextType));
			nextTileImage.alignPivot("center", "top");
			nextTileImage.smoothing = "none";
			nextTileImage.y = nextText.y + nextText.height;
			
			var sprite:Sprite = new Sprite();
			if (Global.currentMode != GameplayTypes.MULTIPLAYER && Global.currentMode != GameplayTypes.VERSUS)
			{
				sprite.addChild(scoreText);
				sprite.addChild(scoreValueText);
			}
			else
			{
				sprite.addChild(blueScoreText);
				sprite.addChild(blueScoreValueText);
				
				sprite.addChild(redScoreText);
				sprite.addChild(redScoreValueText);
				
				sprite.addChild(playerTurnText);
			}
			
			if (Global.currentTurns != NumberOfTurns.TURNS_INF)
			{
				sprite.addChild(turnsText);
				sprite.addChild(turnsValueText);
			}
			sprite.addChild(nextText);
			sprite.addChild(nextTileImage);
			
			backButton = new BackButtonEntity();
			backButton.releaseFunction = GoToMainMenu;
			restartButton = new RestartButtonEntity();
			restartButton.releaseFunction = RestartGame;
			
			graphic = sprite;
			layer = LayerConstants.HUD_LAYER;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			Global.backFunction = GoToMainMenu;
			world.AddEntity(backButton);
			world.AddEntity(restartButton);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			Global.backFunction = null;
			world.RemoveEntity(backButton);
			world.RemoveEntity(restartButton);
		}
		
		public function UpdateScore(score:int):void
		{
			scoreValueText.text = score.toString();
		}
		
		public function ChangePlayerTurn(color:String):void
		{
			if (color == TileColor.RED)
			{
				playerTurnText.text = "Red Player Turn";
				playerTurnText.color = TileColor.GetColor(TileColor.RED);
			}
			else
			{
				playerTurnText.text = "Blue Player Turn";
				playerTurnText.color = TileColor.GetColor(TileColor.BLUE);
			}
		}
		
		public function UpdateMultiplayerScore(blueScore:int, redScore:int):void
		{
			blueScoreValueText.text = blueScore.toString();
			redScoreValueText.text = redScore.toString();
		}
		
		public function UpdateNextTile(nextColor:String, nextType:String):void
		{
			nextTileImage.texture = AE.assetManager.getTexture("next" + nextColor + nextType);
		}
		
		public function UpdateTurns(turns:int):void
		{
			turnsValueText.text = turns.toString();
		}
		
		private function RestartGame():void
		{
			clickSfx.Play();
			AE.game.ActiveWorld = new GameplayWorld();
		}
		
		private function GoToMainMenu():void
		{
			clickSfx.Play();
			AE.game.ActiveWorld = new MainMenuWorld(false);
		}
	}

}