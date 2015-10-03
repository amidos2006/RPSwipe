package RPSwipe.World 
{
	import AmidosEngine.World;
	import RPSwipe.Entity.BackgroundEntity;
	import RPSwipe.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseWorld extends World
	{
		
		public function BaseWorld() 
		{
			super(15);
			
			AddEntity(new BackgroundEntity());
		}
	}

}