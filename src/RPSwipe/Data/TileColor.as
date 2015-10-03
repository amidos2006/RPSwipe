package RPSwipe.Data 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class TileColor 
	{
		public static const BLUE:String = "blue";
		public static const RED:String = "red";
		
		public static function GetColor(tileColor:String):uint
		{
			if (tileColor == BLUE)
			{
				return 0x7769E2;
			}
			
			return 0xE26969;
		}
	}

}