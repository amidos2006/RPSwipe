package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import com.milkmangames.nativeextensions.events.GoogleGamesEvent;
	import com.milkmangames.nativeextensions.GoogleGames;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.NumberOfTurns;
	import RPSwipe.Global;
	import RPSwipe.LayerConstants;
	import RPSwipe.World.GameNameWorld;
	import RPSwipe.World.GameplayWorld;
	import RPSwipe.World.TutorialWorld;
	import starling.animation.DelayedCall;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuEntity extends Entity
	{
		private var moveUp:Boolean;
		private var backButton:BackButtonEntity;
		private var musicButton:MusicButtonEntity;
		private var helpButton:HelpButtonEntity;
		private var gameCenterButton:GameCenterButtonEntity;
		private var googleGamesButton:GoogleGamesButtonEntity;
		private var gameplayModesText:TextField;
		private var numberOfTurnsText:TextField;
		private var currentModeText:TextField;
		private var currentTurnsText:TextField;
		private var gamebyText:TextField;
		private var touchText:TextField;
		private var rightModeButton:ArrowButtonEntity;
		private var leftModeButton:ArrowButtonEntity;
		private var rightTurnsButton:ArrowButtonEntity;
		private var leftTurnsButton:ArrowButtonEntity;
		private var gameNameImage:Image;
		private var moveTween:Tween;
		private var gameModes:Array;
		private var gameTurns:Array;
		private var currentMode:int;
		private var currentTurn:int;
		private var flikerAlarm:DelayedCall;
		private var id:int;
		
		private var clickSfx:Sfx;
		
		public function MainMenuEntity(moveUp:Boolean) 
		{
			this.moveUp = moveUp;
			this.id = -1;
			
			clickSfx = new Sfx(AE.assetManager.getSound("clickSound"));
			
			gameModes = [GameplayTypes.NORMAL, GameplayTypes.VERSUS, GameplayTypes.MULTIPLAYER];
			currentMode = 0;
			for (var i:int = 0; i < gameModes.length; i++) 
			{
				if (gameModes[i] == Global.currentMode)
				{
					currentMode = i;
					break;
				}
			}
			
			gameTurns = [NumberOfTurns.TURNS_INF, NumberOfTurns.TURNS_40, NumberOfTurns.TURNS_80, NumberOfTurns.TURNS_160];
			currentTurn = 0;
			for (i = 0; i < gameTurns.length; i++) 
			{
				if (gameTurns[i] == Global.currentTurns)
				{
					currentTurn = i;
					break;
				}
			}
			
			backButton = new BackButtonEntity();
			backButton.releaseFunction = HideMainMenu;
			
			musicButton = new MusicButtonEntity();
			musicButton.releaseFunction = GoToMusic;
			
			helpButton = new HelpButtonEntity();
			helpButton.releaseFunction = GoToTutorial;
			
			gameCenterButton = new GameCenterButtonEntity();
			gameCenterButton.releaseFunction = ShowHighScores;
			
			googleGamesButton = new GoogleGamesButtonEntity();
			googleGamesButton.releaseFunction = ShowHighScoresGoogle;
			
			gameNameImage = new Image(AE.assetManager.getTexture("gameLogo"));
			gameNameImage.smoothing = "none";
			gameNameImage.alignPivot();
			gameNameImage.x = AE.game.width / 2;
			gameNameImage.y = AE.game.height / 2 - 10;
			
			gameplayModesText = new TextField(AE.game.width, 12, "Gameplay Mode", "gameFont", 12, 0x555555);
			gameplayModesText.alignPivot("center", "center");
			gameplayModesText.x = AE.game.width / 2;
			gameplayModesText.y = AE.game.height / 2 - 20;
			
			numberOfTurnsText = new TextField(AE.game.width, 12, "Number of Turns", "gameFont", 12, 0x555555);
			numberOfTurnsText.alignPivot("center", "center");
			numberOfTurnsText.x = AE.game.width / 2;
			numberOfTurnsText.y = gameplayModesText.y + 50;
			
			currentModeText = new TextField(AE.game.width, 24, Global.currentMode, "gameFont", 24, 0x777777);
			currentModeText.alignPivot("center", "center");
			currentModeText.x = AE.game.width / 2;
			currentModeText.y = gameplayModesText.y + 20;
			
			currentTurnsText = new TextField(AE.game.width, 24, Global.currentTurns, "gameFont", 24, 0x777777);
			currentTurnsText.alignPivot("center", "center");
			currentTurnsText.x = AE.game.width / 2;
			currentTurnsText.y = numberOfTurnsText.y + 20;
			
			gamebyText = new TextField(AE.game.width, 32, "Game by Amidos\nMusic by Tom Snively", "gameFont", 12, 0x555555);
			gamebyText.alignPivot("center", "bottom");
			gamebyText.x = AE.game.width / 2;
			gamebyText.y = AE.game.height;
			
			touchText = new TextField(AE.game.width, 12, "Touch to Start", "gameFont", 12, 0x555555);
			touchText.alignPivot("center", "center");
			touchText.x = currentModeText.x;
			touchText.y = currentTurnsText.y + currentTurnsText.height / 2 + 20;
			
			flikerAlarm = new DelayedCall(ChangeAlpha, 0.5);
			flikerAlarm.repeatCount = 0;
			
			leftModeButton = new ArrowButtonEntity(AE.game.width / 2 - 90, currentModeText.y, ArrowButtonEntity.LEFT);
			leftModeButton.releaseFunction = LeftArrowModeFunction;
			
			rightModeButton = new ArrowButtonEntity(AE.game.width / 2 + 90, currentModeText.y, ArrowButtonEntity.RIGHT);
			rightModeButton.releaseFunction = RightArrowModeFunction;
			
			leftTurnsButton = new ArrowButtonEntity(AE.game.width / 2 - 90, currentTurnsText.y, ArrowButtonEntity.LEFT);
			leftTurnsButton.releaseFunction = LeftArrowTurnsFunction;
			
			rightTurnsButton = new ArrowButtonEntity(AE.game.width / 2 + 90, currentTurnsText.y, ArrowButtonEntity.RIGHT);
			rightTurnsButton.releaseFunction = RightArrowTurnsFunction;
			
			graphic = gameNameImage;
			layer = LayerConstants.HUD_LAYER;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			if (moveUp)
			{
				ShowMainMenu();
			}
			else
			{
				ShowGameplayModes();
			}
			
			Global.backFunction = HideMainMenu;
			
			world.AddEntity(backButton);
			world.AddEntity(musicButton);
			world.AddEntity(helpButton);
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				world.AddEntity(gameCenterButton);
			}
			if (GoogleGames.isSupported())
			{
				world.AddEntity(googleGamesButton);
			}
			addChild(gamebyText);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			world.RemoveEntity(backButton);
			world.RemoveEntity(musicButton);
			world.RemoveEntity(helpButton);
			if (GameCenter.isSupported() && GameCenter.gameCenter.isGameCenterAvailable())
			{
				world.RemoveEntity(gameCenterButton);
			}
			if (GoogleGames.isSupported())
			{
				world.RemoveEntity(googleGamesButton);
			}
			removeChild(gamebyText);
		}
		
		private function ChangeAlpha():void
		{
			touchText.alpha = 1 - touchText.alpha;
		}
		
		private function LeftArrowModeFunction():void
		{
			clickSfx.Play();
			currentMode -= 1;
			if (currentMode < 0)
			{
				currentMode = gameModes.length - 1;
			}
			Global.currentMode = gameModes[currentMode];
			currentModeText.text = Global.currentMode;
		}
		
		private function RightArrowModeFunction():void
		{
			clickSfx.Play();
			currentMode += 1;
			if (currentMode > gameModes.length - 1)
			{
				currentMode = 0;
			}
			Global.currentMode = gameModes[currentMode];
			currentModeText.text = Global.currentMode;
		}
		
		private function LeftArrowTurnsFunction():void
		{
			clickSfx.Play();
			currentTurn -= 1;
			if (currentTurn < 0)
			{
				currentTurn = gameTurns.length - 1;
			}
			Global.currentTurns = gameTurns[currentTurn];
			currentTurnsText.text = Global.currentTurns;
		}
		
		private function RightArrowTurnsFunction():void
		{
			clickSfx.Play();
			currentTurn += 1;
			if (currentTurn > gameTurns.length - 1)
			{
				currentTurn = 0;
			}
			Global.currentTurns = gameTurns[currentTurn];
			currentTurnsText.text = Global.currentTurns;
		}
		
		private function ShowMainMenu():void
		{
			moveTween = new Tween(gameNameImage, 0.2, "linear");
			moveTween.moveTo(gameNameImage.x, AE.game.height / 2 - 80);
			moveTween.onComplete = ShowGameplayModes;
			
			Starling.current.juggler.add(moveTween);
		}
		
		private function ViewHighScoresBoard():void
		{
			GameCenter.gameCenter.showLeaderboardForCategory(Global.GetHighScoreNames());
		}
		
		private function ViewHighScoresBoardGoogle():void
		{
			GoogleGames.games.showLeaderboard(Global.GetHighScoreNamesGoogle());
		}
		
		private function AuthSucceeded(e:GameCenterEvent):void
		{
			GameCenter.gameCenter.removeEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceeded);
			ViewHighScoresBoard();
		}
		
		private function AuthSucceededGoogle(e:GoogleGamesEvent):void
		{
			GoogleGames.games.removeEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, AuthSucceededGoogle);
			ViewHighScoresBoardGoogle();
		}
		
		private function ShowHighScores():void
		{
			clickSfx.Play();
			if (GameCenter.gameCenter.isUserAuthenticated())
			{
				ViewHighScoresBoard();
			}
			else
			{
				GameCenter.gameCenter.addEventListener(GameCenterEvent.AUTH_SUCCEEDED, AuthSucceeded);
				GameCenter.gameCenter.authenticateLocalUser();
			}
		}
		
		private function ShowHighScoresGoogle():void
		{
			clickSfx.Play();
			if (GoogleGames.games.isSignedIn())
			{
				ViewHighScoresBoardGoogle();
			}
			else
			{
				GoogleGames.games.addEventListener(GoogleGamesEvent.SIGN_IN_SUCCEEDED, AuthSucceededGoogle);
				GoogleGames.games.signIn();
			}
		}
		
		private function HideMainMenu():void
		{
			Starling.current.juggler.remove(moveTween);
			Starling.current.juggler.remove(flikerAlarm);
			
			AE.RemovePressFunction(PressCheck);
			AE.RemoveReleaseFunction(StartGame);
			
			clickSfx.Play();
			
			backButton.active = false;
			musicButton.active = false;
			helpButton.active = false;
			gameCenterButton.active = false;
			googleGamesButton.active = false;
			
			Global.backFunction = null;
			
			moveTween = new Tween(gameNameImage, 0.2, "linear");
			moveTween.moveTo(gameNameImage.x, AE.game.height / 2 - 10);
			moveTween.onComplete = GoToGameName;
			
			world.RemoveEntity(leftModeButton);
			world.RemoveEntity(rightModeButton);
			
			world.RemoveEntity(leftTurnsButton);
			world.RemoveEntity(rightTurnsButton);
			
			removeChild(gameplayModesText);
			removeChild(currentModeText);
			
			removeChild(touchText);
			
			removeChild(numberOfTurnsText);
			removeChild(currentTurnsText);
			
			Starling.current.juggler.add(moveTween);
		}
		
		private function GoToMusic():void
		{
			clickSfx.Play();
			navigateToURL(new URLRequest(Global.OST_LINK), "_blank");
		}
		
		private function GoToTutorial():void
		{
			clickSfx.Play();
			AE.game.ActiveWorld = new TutorialWorld();
		}
		
		private function ShowGameplayModes():void
		{
			gameNameImage.y = AE.game.height / 2 - 80;
			
			AE.AddPressFunction(PressCheck);
			AE.AddReleaseFunction(StartGame);
			
			world.AddEntity(leftModeButton);
			world.AddEntity(rightModeButton);
			
			world.AddEntity(leftTurnsButton);
			world.AddEntity(rightTurnsButton);
			
			addChild(gameplayModesText);
			addChild(currentModeText);
			
			addChild(touchText);
			
			addChild(numberOfTurnsText);
			addChild(currentTurnsText);
			
			Starling.current.juggler.add(flikerAlarm);
		}
		
		private function GoToGameName():void
		{
			AE.game.ActiveWorld = new GameNameWorld();
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
		
		private function StartGame(tX:Number, tY:Number, tID:int):void
		{
			if (id != tID)
			{
				return;
			}
			
			id = -1;
			
			if (leftModeButton.collidePoint(tX, tY, leftModeButton.x, leftModeButton.y) ||
				rightModeButton.collidePoint(tX, tY, rightModeButton.x, rightModeButton.y) ||
				backButton.collidePoint(tX, tY, backButton.x, backButton.y) ||
				musicButton.collidePoint(tX, tY, musicButton.x, musicButton.y) ||
				gameCenterButton.collidePoint(tX, tY, gameCenterButton.x, gameCenterButton.y) ||
				googleGamesButton.collidePoint(tX, tY,googleGamesButton.x, googleGamesButton.y) ||
				helpButton.collidePoint(tX, tY, helpButton.x, helpButton.y) ||
				leftTurnsButton.collidePoint(tX, tY, leftTurnsButton.x, leftTurnsButton.y) ||
				rightTurnsButton.collidePoint(tX, tY, rightTurnsButton.x, rightTurnsButton.y))
			{
				return;
			}
			
			clickSfx.Play();
			AE.game.ActiveWorld = new GameplayWorld();
		}
	}

}