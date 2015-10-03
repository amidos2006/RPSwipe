package RPSwipe.World 
{
	import RPSwipe.Data.TileColor;
	import RPSwipe.Data.TileType;
	import RPSwipe.Entity.HUDEntity;
	import RPSwipe.Entity.TutorialGridEntity;
	import RPSwipe.Entity.TutorialTextEntity;
	import RPSwipe.Global;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TutorialWorld extends BaseWorld
	{
		
		public function TutorialWorld() 
		{
			Global.EnableTutorialShift();
			
			var tutorialText:TutorialTextEntity = new TutorialTextEntity();
			Global.currentGrid = new TutorialGridEntity(tutorialText);
			Global.currentHUD = new HUDEntity(TileColor.BLUE, TileType.SCISSORS);
			
			AddEntity(Global.currentGrid);
			AddEntity(tutorialText);
		}
		
		override public function end():void 
		{
			super.end();
			
			Global.DisableTutorialShift();
			Global.firstTime = false;
			Global.SaveData();
		}
	}

}