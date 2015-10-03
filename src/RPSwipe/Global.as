package RPSwipe 
{
	import AmidosEngine.AE;
	import AmidosEngine.Data;
	import AmidosEngine.Sfx;
	import flash.geom.Point;
	import RPSwipe.Data.Direction;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.NumberOfTurns;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Data.TileType;
	import RPSwipe.Entity.GridEntity;
	import RPSwipe.Entity.HUDEntity;
	import RPSwipe.Entity.TileEntity;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Global 
	{
		[Embed(source = "../../assets/pixelFont.ttf", embedAsCFF = "false", fontName = 'gameFont')]public static const gameFontClass:Class;
		
		public static const MIN_SWIPE_DISTANCE:Number = 10;
		public static const MAX_MUSIC_VOLUME:Number = 0.4;
		public static const MIN_MUSIC_VOLUME:Number = 0.1;
		public static const OST_LINK:String = "http://tomsnively.bandcamp.com/track/rpswipe-ost";
		public static const SAVE_FILE_NAME:String = "RPSwipeSaveFile";
		public static const MAX_TOUCHES:int = 1;
		
		public static var xShift:Number;
		public static var yShift:Number;
		
		public static var gameMusicSfx:Sfx;
		
		public static var currentGrid:GridEntity;
		public static var currentHUD:HUDEntity;
		public static var firstTime:Boolean;
		
		public static var blueScore:int;
		public static var redScore:int;
		public static var score:int;
		public static var currentMode:String;
		public static var currentTurns:String;
		public static var currentMusicVolume:Number;
		private static var currentMusicPosition:Number;
		
		public static var backFunction:Function;
		
		public static function Initialize():void
		{
			xShift = (AE.game.width - TileEntity.TILE_SIZE * GridEntity.X_TILES) / 2;
			yShift = (AE.game.height - TileEntity.TILE_SIZE * GridEntity.Y_TILES) / 2 + 5;
			score = 0;
			blueScore = 0;
			redScore = 0;
			firstTime = true;
			currentMode = GameplayTypes.NORMAL;
			currentTurns = NumberOfTurns.TURNS_INF;
			currentMusicVolume = MAX_MUSIC_VOLUME;
			backFunction = null;
			currentMusicPosition = 0;
			
			gameMusicSfx = new Sfx(AE.assetManager.getSound("gameMusic"));
			
			Direction.directionArray = new Vector.<Point>();
			Direction.directionArray.push(Direction.MOVE_UP);
			Direction.directionArray.push(Direction.MOVE_DOWN);
			Direction.directionArray.push(Direction.MOVE_LEFT);
			Direction.directionArray.push(Direction.MOVE_RIGHT);
			
			LoadData();
		}
		
		public static function EnableTutorialShift():void
		{
			yShift = (AE.game.height - TileEntity.TILE_SIZE * GridEntity.Y_TILES) * 0.85;
		}
		
		public static function DisableTutorialShift():void
		{
			yShift = (AE.game.height - TileEntity.TILE_SIZE * GridEntity.Y_TILES) / 2 + 5;
		}
		
		public static function GetFromTile(xTile:int, yTile:int):Point
		{
			var returnValue:Point = new Point();
			returnValue.x = (xTile + 0.5) * TileEntity.TILE_SIZE + xShift;
			returnValue.y = (yTile + 0.5) * TileEntity.TILE_SIZE + yShift;
			
			return returnValue;
		}
		
		public static function GetFromWorld(x:Number, y:Number):Point
		{
			var returnValue:Point = new Point();
			returnValue.x = Math.floor((x - xShift) / TileEntity.TILE_SIZE);
			returnValue.y = Math.floor((y - yShift) / TileEntity.TILE_SIZE);
			
			return returnValue;
		}
		
		public static function GetSwipeDirection(p1:Point, p2:Point):Point
		{
			if (p2.subtract(p1).length < MIN_SWIPE_DISTANCE)
			{
				return Direction.NONE;
			}
			
			var angle:Number = Math.atan2(p2.subtract(p1).y, p2.subtract(p1).x) * 180 / Math.PI;
			
			if (angle > -45 && angle <= 45)
			{
				return Direction.MOVE_RIGHT;
			}
			
			if (angle > 45 && angle <= 135)
			{
				return Direction.MOVE_DOWN;
			}
			
			if (angle > -135 && angle <= -45)
			{
				return Direction.MOVE_UP;
			}
			
			return Direction.MOVE_LEFT;
		}
		
		public static function Rand(maxInt:int):int
		{
			return Math.floor(Math.random() * maxInt);
		}
		
		public static function GetRandomItem(a:Array):Object
		{
			return a[Rand(a.length)];
		}
		
		public static function ShuffleArray(a:Array):void
		{
			var index1:int, index2:int;
			for (var i:int = 0; i < 4 * a.length; i++) 
			{
				index1 = Rand(a.length);
				index2 = Rand(a.length);
				var temp:Object = a[index1];
				a[index1] = a[index2];
				a[index2] = temp;
			}
		}
		
		public static function SaveData():void
		{
			Data.writeBool("firstTime", firstTime);
			
			Data.save(SAVE_FILE_NAME);
		}
		
		public static function LoadData():void
		{
			Data.load(SAVE_FILE_NAME);
			
			firstTime = Data.readBool("firstTime", true);
		}
		
		public static function PlayMusic(position:Number = 0):void
		{
			if (gameMusicSfx != null && !gameMusicSfx.playing)
			{
				gameMusicSfx.Loop(currentMusicVolume, 0, position);
			}
		}
		
		public static function PauseMusic():void
		{
			if (gameMusicSfx.playing)
			{
				currentMusicPosition = gameMusicSfx.position;
				gameMusicSfx.Stop();
			}
		}
		
		public static function ResumeMusic():void
		{
			PlayMusic(currentMusicPosition);
		}
		
		public static function SetMusicVolume(vol:Number):void
		{
			if (gameMusicSfx != null)
			{
				var tween:Tween = new Tween(gameMusicSfx, 0.5);
				tween.animate("volume", vol);
				Starling.current.juggler.add(tween);
			}
		}
		
		public static function SetMusicVolumeNow(vol:Number):void
		{
			if (gameMusicSfx != null)
			{
				gameMusicSfx.volume = vol;
			}
		}
		
		public static function GetHighScoreNames():String
		{
			var id:String = "Single";
			switch (currentTurns) 
			{
				case NumberOfTurns.TURNS_INF:
					id += "NoTurns";
					break;
				case NumberOfTurns.TURNS_40:
					id += "40Turns";
					break;
				case NumberOfTurns.TURNS_80:
					id += "80Turns";
					break;
				case NumberOfTurns.TURNS_160:
					id += "160Turns";
					break;
			}
			
			return id;
		}
		
		public static function GetHighScoreNamesGoogle():String
		{
			var id:String = "";
			switch (currentTurns) 
			{
				case NumberOfTurns.TURNS_INF:
					id += "CgkIx7r0kN4OEAIQBg";
					break;
				case NumberOfTurns.TURNS_40:
					id += "CgkIx7r0kN4OEAIQBw";
					break;
				case NumberOfTurns.TURNS_80:
					id += "CgkIx7r0kN4OEAIQCA";
					break;
				case NumberOfTurns.TURNS_160:
					id += "CgkIx7r0kN4OEAIQCQ";
					break;
			}
			
			return id;
		}
	}

}