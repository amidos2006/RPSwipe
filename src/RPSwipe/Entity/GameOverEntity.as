package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import flash.geom.Rectangle;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Global;
	import RPSwipe.LayerConstants;
	import RPSwipe.World.MainMenuWorld;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameOverEntity extends Entity
	{
		private const THIKNESS:int = 4;
		private const HEIGHT:int = 50;
		
		private var gameOverText:TextField;
		private var touchText:TextField;
		
		private var quadBackground:Quad;
		private var quadUpper:Quad;
		private var quadLower:Quad;
		private var gameOverSfx:Sfx;
		private var clickSfx:Sfx;
		private var setMusicTween:DelayedCall;
		
		public function GameOverEntity() 
		{
			y = AE.game.height;
			
			gameOverSfx = new Sfx(AE.assetManager.getSound("gameOverSound"));
			clickSfx = new Sfx(AE.assetManager.getSound("clickSound"));
			
			quadBackground = new Quad(AE.game.width, HEIGHT, 0xFFFFFFFF);
			quadUpper = new Quad(AE.game.width, THIKNESS, 0xFFE5E5E5);
			quadLower = new Quad(AE.game.width, THIKNESS, 0xFFE5E5E5);
			quadLower.y = HEIGHT - THIKNESS;
			
			if (Global.currentMode == GameplayTypes.MULTIPLAYER || Global.currentMode == GameplayTypes.VERSUS)
			{
				if (Global.blueScore > Global.redScore)
				{
					gameOverText = new TextField(AE.game.width, 24, "Blue Player Wins", "gameFont", 24, TileColor.GetColor(TileColor.BLUE));
				}
				else if (Global.redScore > Global.blueScore)
				{
					gameOverText = new TextField(AE.game.width, 24, "Red Player Wins", "gameFont", 24, TileColor.GetColor(TileColor.RED));
				}
				else
				{
					gameOverText = new TextField(AE.game.width, 24, "Draw", "gameFont", 24, 0x777777);
				}
			}
			else if (Global.currentMode == GameplayTypes.NORMAL)
			{
				gameOverText = new TextField(AE.game.width, 24, "Gameover", "gameFont", 24, 0x777777);
			}
			else if (Global.currentMode == GameplayTypes.PUZZLE)
			{
				gameOverText = new TextField(AE.game.width, 24, "Puzzle Complete", "gameFont", 24, 0x777777);
			}
			gameOverText.y = 2 * THIKNESS;
			
			touchText = new TextField(AE.game.width, 12, "Touch to Main Menu", "gameFont", 12, 0x555555);
			touchText.alignPivot("left", "bottom");
			touchText.y = HEIGHT - 2 * THIKNESS + 2;
			
			setMusicTween = new DelayedCall(GameOverSoundEnds, 2);
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(quadBackground);
			sprite.addChild(quadUpper);
			sprite.addChild(quadLower);
			sprite.addChild(gameOverText);
			sprite.addChild(touchText);
			
			graphic = sprite;
			layer = LayerConstants.OVER_HUD_LAYER;
			
			hitBox = new Rectangle(0, 0, AE.game.width, HEIGHT);
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			Global.currentMusicVolume = Global.MIN_MUSIC_VOLUME;
			Global.SetMusicVolume(Global.currentMusicVolume);
			Starling.current.juggler.add(setMusicTween);
			
			gameOverSfx.Play();
			
			var moveTween:Tween = new Tween(this, 0.5, Transitions.EASE_OUT_BACK);
			moveTween.moveTo(0, AE.game.height / 2 - HEIGHT);
			
			trace(Global.currentMode != GameplayTypes.MULTIPLAYER && Global.currentMode != GameplayTypes.VERSUS);
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				if (Global.currentMode != GameplayTypes.MULTIPLAYER && Global.currentMode != GameplayTypes.VERSUS)
				{
					if (GameCenter.gameCenter.isUserAuthenticated())
					{
						SubmitScore();
					}
					else
					{
						GameCenter.gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceeded);
						GameCenter.gameCenter.authenticateLocalUser();
					}
				}
			}
			
			if (GoogleGames.isSupported())
			{
				if (Global.currentMode != GameplayTypes.MULTIPLAYER && Global.currentMode != GameplayTypes.VERSUS)
				{
					if (GoogleGames.games.isSignedIn())
					{
						SubmitScoreGoogle();
					}
					else
					{
						GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, AuthSucceededGoogle);
						GoogleGames.games.signIn();
					}
				}
			}
			
			Starling.current.juggler.add(moveTween);
			
			AE.AddReleaseFunction(Touch);
		}
		
		private function SubmitScore():void
		{
			GameCenter.gameCenter.reportScoreForCategory(Global.score, Global.GetHighScoreNames());
		}
		
		private function SubmitScoreGoogle():void
		{
			GoogleGames.games.submitScore(Global.GetHighScoreNamesGoogle(), Global.score);
		}
		
		private function AuthSucceeded(e:GameCenterEvent):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceeded);
			SubmitScore();
		}
		
		private function AuthSucceededGoogle(e:GoogleGamesEvent):void
		{
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, AuthSucceededGoogle);
			SubmitScoreGoogle();
		}
		
		override public function remove():void 
		{
			super.remove();
			
			AE.RemoveReleaseFunction(Touch);
		}
		
		private function GameOverSoundEnds():void
		{
			Global.currentMusicVolume = Global.MAX_MUSIC_VOLUME;
			Global.SetMusicVolume(Global.currentMusicVolume);
		}
		
		private function Touch(tX:Number, tY:Number, tID:int):void
		{
			if (collidePoint(tX, tY, x, y))
			{
				clickSfx.Play();
				AE.game.ActiveWorld = new MainMenuWorld(false);
			}
		}
	}

}