package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import flash.geom.Point;
	import RPSwipe.Data.Direction;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Data.TileType;
	import RPSwipe.Global;
	import RPSwipe.LayerConstants;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TutorialGridEntity extends GridEntity
	{
		protected var tutorialEntity:TutorialTextEntity;
		
		public function TutorialGridEntity(t:TutorialTextEntity) 
		{
			super(TileColor.BLUE, TileType.SCISSORS, 1);
			notGenerate = true;
			
			tutorialEntity = t;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
		}
		
		override protected function TouchRelease(tX:Number, tY:Number, tID:int):void 
		{
			if (pressID == tID)
			{
				pressID = -1;
				var direction:Point = Global.GetSwipeDirection(new Point(pressX, pressY), new Point(tX, tY));
				if (direction.length > 0)
				{
					if (!CheckAnimation())
					{
						var directionCorrect:Boolean = false;
						if (tutorialEntity.GetNumber() == 0 || tutorialEntity.GetNumber() == 1 || tutorialEntity.GetNumber() == 6 ||
							tutorialEntity.GetNumber() == 7 || tutorialEntity.GetNumber() == 10 || tutorialEntity.GetNumber() == 11 ||
							tutorialEntity.GetNumber() == 13 || tutorialEntity.GetNumber() == 15 || tutorialEntity.GetNumber() == 18 || 
							tutorialEntity.GetNumber() == 21 || tutorialEntity.GetNumber() == 24 || tutorialEntity.GetNumber() == 25 || 
							tutorialEntity.GetNumber() == 26 || tutorialEntity.GetNumber() == 29 || tutorialEntity.GetNumber() == 30)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
							}
						}
						else if (tutorialEntity.GetNumber() == 2)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(0, 2, TileColor.BLUE, TileType.ROCK, 1));
								AddTile(new TileEntity(3, 2, TileColor.RED, TileType.SCISSORS, 1));
							}
						}
						else if (tutorialEntity.GetNumber() == 3)
						{
							if (direction == Direction.MOVE_RIGHT)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
								AddTile(new TileEntity(3, 0, TileColor.RED, TileType.PAPER, 1));
							}
						}
						else if (tutorialEntity.GetNumber() == 4)
						{
							if (direction == Direction.MOVE_UP)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
								AddTile(new TileEntity(1, 0, TileColor.BLUE, TileType.SCISSORS, 1));
								
							}
						}
						else if (tutorialEntity.GetNumber() == 5)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
							}
						}
						else if (tutorialEntity.GetNumber() == 8)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(0, 3, TileColor.BLUE, TileType.PAPER, 1));
							}
						}
						else if (tutorialEntity.GetNumber() == 9)
						{
							if (direction == Direction.MOVE_DOWN)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
							}
						}
						else if (tutorialEntity.GetNumber() == 12)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(3, 3, TileColor.RED, TileType.ROCK, 3));
								AddTile(new TileEntity(3, 2, TileColor.RED, TileType.PAPER, 2));
							}
						}
						else if (tutorialEntity.GetNumber() == 14)
						{
							if (direction == Direction.MOVE_RIGHT)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
							}
						}
						else if (tutorialEntity.GetNumber() == 16)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(0, 3, TileColor.BLUE, TileType.PAPER, 2));
								AddTile(new TileEntity(0, 2, TileColor.BLUE, TileType.SCISSORS, 3));
							}
						}
						else if (tutorialEntity.GetNumber() == 17)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
							}
						}
						else if (tutorialEntity.GetNumber() == 19)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(3, 3, TileColor.BLUE, TileType.PAPER, 6));
								AddTile(new TileEntity(3, 2, TileColor.BLUE, TileType.SCISSORS, 7));
							}
						}
						else if(tutorialEntity.GetNumber() == 20)
						{
							if (direction == Direction.MOVE_RIGHT)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
							}
						}
						else if (tutorialEntity.GetNumber() == 22)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(3, 0, TileColor.BLUE, TileType.SCISSORS, 2));
							}
						}
						else if(tutorialEntity.GetNumber() == 23)
						{
							if (direction == Direction.MOVE_UP)
							{
								directionCorrect = true;
								currentDirection = direction;
								MoveGrid(direction);
							}
						}
						else if (tutorialEntity.GetNumber() == 27)
						{
							if (direction == Direction.MOVE_LEFT)
							{
								directionCorrect = true;
								AddTile(new TileEntity(0, 1, TileColor.RED, TileType.ROCK, 9));
								tutorialEntity.ShowRestart();
							}
						}
						else if (tutorialEntity.GetNumber() == 28)
						{
							if (CheckMoveDirection(direction))
							{
								currentDirection = direction;
								MoveGrid(direction);
							}
							else
							{
								noswipeSfx.Play();
							}
						}
						
						if (directionCorrect)
						{
							swipeSounds[Global.Rand(swipeSounds.length)].Play();
							tutorialEntity.GetNext();
						}
					}
				}
			}
		}
		
		public function RestartGrid():void
		{
			var length:int = tiles.length;
			for (var i:int = 0; i < length; i++) 
			{
				RemoveTile(tiles[0]);
			}
			
			AddTile(new TileEntity(3, 0, TileColor.BLUE, TileType.SCISSORS, 2));
			AddTile(new TileEntity(3, 1, TileColor.BLUE, TileType.SCISSORS, 9));
			AddTile(new TileEntity(3, 2, TileColor.BLUE, TileType.PAPER, 9));
			AddTile(new TileEntity(0, 1, TileColor.RED, TileType.ROCK, 9));
		}
		
		override public function update(dt:Number):void 
		{
			if (!CheckAnimation())
			{
				if (tutorialEntity.GetNumber() == 28 && CheckWinPuzzle())
				{
					tutorialEntity.GetNext();
					tutorialEntity.HideRestart();
				}
			}
			else if (!CheckOneMove())
			{
				var tempTiles:Vector.<TileEntity>;
				for (var i:int = 0; i < Y_TILES; i++) 
				{
					for (var j:int = 0; j < X_TILES; j++) 
					{
						tempTiles = GetTiles(j, i);
						if (tempTiles.length > 1)
						{
							tempTiles[0].ResolvePosition();
							continue;
						}
					}
				}
				
				ContinueMoveGrid(currentDirection);
			}
		}
	}

}