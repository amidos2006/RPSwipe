package AmidosEngine 
{
	import starling.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Layer extends DisplayObjectContainer
	{
		public function Layer() 
		{
			
		}
		
		public function update(dt:Number):void
		{
			for (var i:int = 0; i < numChildren; i++) 
			{
				var gameEntity:Entity = (getChildAt(i) as Entity);
				gameEntity.update(dt);
			}
		}
	}

}