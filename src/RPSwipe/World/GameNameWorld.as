package RPSwipe.World 
{
	import RPSwipe.Entity.GameNameEntity;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameNameWorld extends BaseWorld
	{
		private static var firstTime:Boolean = true;
		
		public function GameNameWorld() 
		{
			
		}
		
		override public function begin():void 
		{
			AddEntity(new GameNameEntity());
			super.begin();
			
			if (firstTime)
			{
				firstTime = false;
				Starling.current.nativeStage.removeChild(Main.currentLoadingScreen);
			}
		}
	}

}