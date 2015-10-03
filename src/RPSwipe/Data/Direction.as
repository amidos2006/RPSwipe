package RPSwipe.Data 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Direction 
	{
		public static var MOVE_UP:Point = new Point(0, -1);
		public static var MOVE_DOWN:Point = new Point(0, 1);
		public static var MOVE_LEFT:Point = new Point( -1, 0);
		public static var MOVE_RIGHT:Point = new Point(1, 0);
		public static var NONE:Point = new Point(0, 0);
		
		public static var directionArray:Vector.<Point>;
	}

}