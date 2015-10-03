package RPSwipe.World 
{
	import AmidosEngine.World;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Data.TileType;
	import RPSwipe.Entity.GridEntity;
	import RPSwipe.Entity.HUDEntity;
	import RPSwipe.Entity.TileEntity;
	import RPSwipe.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameplayWorld extends BaseWorld
	{
		public function GameplayWorld() 
		{
			var randomColor:String = Global.GetRandomItem([TileColor.RED, TileColor.BLUE]) as String;
			if (Global.currentMode == GameplayTypes.MULTIPLAYER || Global.currentMode == GameplayTypes.VERSUS)
			{
				randomColor = TileColor.RED;
			}
			var randomType:String = Global.GetRandomItem([TileType.ROCK, TileType.PAPER, TileType.SCISSORS]) as String;
			
			Global.currentHUD = new HUDEntity(randomColor, randomType);
			Global.currentGrid = new GridEntity(randomColor, randomType, 1);
			
			AddEntity(Global.currentGrid);
			AddEntity(Global.currentHUD);
		}
		
	}

}