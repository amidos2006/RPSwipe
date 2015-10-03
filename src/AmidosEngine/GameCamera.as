package AmidosEngine 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameCamera 
	{
		public var x:Number;
		public var y:Number;
		public var width:Number;
		public var height:Number;
		
		public function GameCamera(w:Number, h:Number) 
		{
			x = 0;
			y = 0;
			
			width = w;
			height = h;
		}
		
		public function GetWorldPoint(x:Number, y:Number):Point
		{
			return new Point(x + this.x, y + this.y);
		}
		
		public function GetLocalPoint(x:Number, y:Number):Point
		{
			return new Point(x - this.x, y - this.y)
		}
		
		public function PointInsideCamera(x:Number, y:Number):Boolean
		{
			var rectangle:Rectangle = new Rectangle(this.x, this.y, this.width, this.height);
			return rectangle.contains(x, y);
		}
		
		public function RectInsideCamera(x:Number , y:Number, width:Number, height:Number):Boolean
		{
			var rectangle:Rectangle = new Rectangle(this.x, this.y, this.width, this.height);
			return rectangle.intersects(new Rectangle(x, y, width, height));
		}
	}

}