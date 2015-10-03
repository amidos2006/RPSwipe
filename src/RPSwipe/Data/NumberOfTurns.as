package RPSwipe.Data 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class NumberOfTurns 
	{
		public static const TURNS_40:String = "40 Turns";
		public static const TURNS_80:String = "80 Turns";
		public static const TURNS_160:String = "160 Turns";
		public static const TURNS_INF:String = "No Turns";
		
		public static function GetNumberTurns(value:String):int
		{
			switch (value) 
			{
				case TURNS_40:
					return 40;
					break;
				case TURNS_80:
					return 80;
					break;
				case TURNS_160:
					return 160;
					break;
			}
			
			return -1;
		}
	}

}