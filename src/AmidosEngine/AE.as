package AmidosEngine 
{
	import adobe.utils.CustomActions;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import starling.utils.AssetManager;
	/**
	 * ...
	 * @author Amidos
	 */
	public class AE 
	{
		internal static var pressFunction:Vector.<Function>;
		internal static var moveFunction:Vector.<Function>;
		internal static var releaseFunction:Vector.<Function>;
		
		public static var game:Game;
		public static var assetManager:AssetManager;
		
		public static function get currentOS():int
		{
			var os:String = Capabilities.os.toLowerCase();
			var man:String = Capabilities.manufacturer.toLowerCase();
			if (os.search("windows"))
			{
				return OS.WINDOWS;
			}
			
			if (os.search("mac"))
			{
				return OS.MAC;
			}
			
			if (man.search("android"))
			{
				return OS.ANDROID;
			}
			
			if (man.search("ios"))
			{
				return OS.IOS;
			}
			
			return OS.LINUX;
		}
		
		public static function Intialize():void
		{
			pressFunction = new Vector.<Function>();
			moveFunction = new Vector.<Function>();
			releaseFunction = new Vector.<Function>();
			
			assetManager = new AssetManager();
		}
		
		public static function GetIntRandom(max:int):int
		{
			return Math.floor(max * Math.random());
		}
		
		public static function GetRandom():Number
		{
			return Math.random();
		}
		
		public static function ShuffleArray(array:Array):void
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				var index1:int = GetIntRandom(array.length);
				var index2:int = GetIntRandom(array.length);
				
				var temp:Object = array[index1];
				array[index1] = array[index2];
				array[index2] = temp;
			}
		}
		
		public static function AddPressFunction(f:Function):void
		{
			pressFunction.push(f);
		}
		
		public static function RemovePressFunction(f:Function):void
		{
			var index:int = pressFunction.indexOf(f);
			pressFunction.splice(index, 1);
		}
		
		public static function RemoveAllPressFunction():void
		{
			pressFunction.length = 0;
		}
		
		public static function AddMoveFunction(f:Function):void
		{
			moveFunction.push(f);
		}
		
		public static function RemoveMoveFunction(f:Function):void
		{
			var index:int = moveFunction.indexOf(f);
			moveFunction.splice(index, 1);
		}
		
		public static function RemoveAllMoveFunction():void
		{
			moveFunction.length = 0;
		}
		
		public static function AddReleaseFunction(f:Function):void
		{
			releaseFunction.push(f);
		}
		
		public static function RemoveReleaseFunction(f:Function):void
		{
			var index:int = releaseFunction.indexOf(f);
			releaseFunction.splice(index, 1);
		}
		
		public static function RemoveAllReleaseFunction():void
		{
			releaseFunction.length = 0;
		}
		
		public static function GetKeyStatus(key:int):int
		{
			return game.keyboardKeys[key];
		}
		
		public static function get NumberOfTouches():int
		{
			return game.numberOfTouches;
		}
	}

}