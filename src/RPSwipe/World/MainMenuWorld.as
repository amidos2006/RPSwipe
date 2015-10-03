package RPSwipe.World 
{
	import AmidosEngine.World;
	import RPSwipe.Entity.MainMenuEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuWorld extends BaseWorld
	{
		
		public function MainMenuWorld(moveUp:Boolean) 
		{
			AddEntity(new MainMenuEntity(moveUp));
		}
		
	}

}