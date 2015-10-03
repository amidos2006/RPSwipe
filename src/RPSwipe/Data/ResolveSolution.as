package RPSwipe.Data 
{
	/**
	 * ...
	 * @author Amidos
	 */
	public class ResolveSolution 
	{
		public static const NONE:int = 0;
		public static const DESTROY:int = 1;
		public static const ADDED:int = 2;
		
		public var tileNumber:int;
		public var action:int;
		
		public function ResolveSolution(tn:int = 0, a:int = NONE) 
		{
			tileNumber = tn;
			action = a;
		}
		
	}

}