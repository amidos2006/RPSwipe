package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import flash.geom.Point;
	import RPSwipe.Data.Direction;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.NumberOfTurns;
	import RPSwipe.Data.ResolveSolution;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Data.TileType;
	import RPSwipe.Global;
	import RPSwipe.LayerConstants;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GridEntity extends Entity
	{
		public static const X_TILES:int = 4;
		public static const Y_TILES:int = 4;
		
		protected static const ADDED_ENEMY_FACTOR:Number = 1;
		protected static const DESTROY_ENEMY_FACTOR:Number = 1;
		protected static const ADDING_FACTOR:Number = 0.5;
		
		protected var tiles:Vector.<TileEntity>;
		
		protected var pressX:Number;
		protected var pressY:Number;
		protected var pressID:int;
		protected var notGenerate:Boolean;
		protected var currentDirection:Point;
		
		protected var nextColor:String;
		protected var nextType:String;
		protected var nextPower:int;
		protected var gameOverEntity:GameOverEntity;
		protected var numberOfRemainingTurns:int;
		protected var swipeSounds:Array;
		protected var noswipeSfx:Sfx;
		
		protected var timerForTurn:DelayedCall;
		
		public function GridEntity(tileColor:String, tileType:String, tilePower:int) 
		{
			pressID = -1;
			pressX = 0;
			pressY = 0;
			
			Global.score = 0;
			Global.blueScore = 0;
			Global.redScore = 0;
			nextColor = tileColor;
			nextType = tileType;
			nextPower = tilePower;
			gameOverEntity = null;
			notGenerate = false;
			timerForTurn = null;
			
			swipeSounds = new Array();
			swipeSounds.push(new Sfx(AE.assetManager.getSound("swipe1Sound")));
			swipeSounds.push(new Sfx(AE.assetManager.getSound("swipe2Sound")));
			
			noswipeSfx = new Sfx(AE.assetManager.getSound("noswipeSound"));
			
			tiles = new Vector.<TileEntity>();
			
			var quadBatch:QuadBatch = new QuadBatch();
			var image:Image;
			
			for (var i:int = 0; i < Y_TILES; i++) 
			{
				for (var j:int = 0; j < X_TILES; j++) 
				{
					image = new Image(AE.assetManager.getTexture("backTile"));
					image.smoothing = "none";
					image.pivotX = TileEntity.TILE_SIZE / 2;
					image.pivotY = TileEntity.TILE_SIZE / 2;
					image.x = Global.GetFromTile(j, i).x;
					image.y = Global.GetFromTile(j, i).y;
					
					quadBatch.addImage(image);
				}
			}
			
			graphic = quadBatch;
			layer = LayerConstants.GRID_LAYER;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			if (!notGenerate)
			{
				var randomPositions:Array = [];
				var randomPowers:Array = [1, 2];
				var randomTypes:Array = [TileType.ROCK, TileType.PAPER, TileType.SCISSORS];
				var randomColors:Array = [TileColor.BLUE, TileColor.RED];
				Global.ShuffleArray(randomColors);
				var randomIndex:int, randomPos:int;
				for (var i:int = 0; i < Y_TILES * X_TILES; i++) 
				{
					randomPositions.push(i);
				}
			
				var randomAmount:int = Global.GetRandomItem([Math.floor(X_TILES * Y_TILES / 3), Math.floor(X_TILES * Y_TILES / 3) + 1]) as int;
				if (Global.currentMode == GameplayTypes.MULTIPLAYER || Global.currentMode == GameplayTypes.VERSUS)
				{
					if (randomAmount % 2 == 1)
					{
						randomAmount += 1;
					}
				}
				
				var randomP:int = 1;
				var randomC:String = TileColor.BLUE;
				for (i = 0; i < randomAmount; i++) 
				{
					randomIndex = Global.Rand(randomPositions.length);
					randomPos = randomPositions[randomIndex];
					randomPositions.splice(randomIndex, 1);
					
					if (Global.currentMode == GameplayTypes.MULTIPLAYER || Global.currentMode == GameplayTypes.VERSUS)
					{
						randomC = randomColors[i % 2] as String;
						if (i % 2 == 0)
						{
							randomP = Global.GetRandomItem(randomPowers) as int;
						}
						AddTile(new TileEntity(randomPos % X_TILES, Math.floor(randomPos / Y_TILES), randomC, Global.GetRandomItem(randomTypes) as String, randomP));
					}
					else
					{
						AddTile(new TileEntity(randomPos % X_TILES, Math.floor(randomPos / Y_TILES), randomColors[Math.floor(i/(randomAmount / 2))] as String, Global.GetRandomItem(randomTypes) as String, Global.GetRandomItem(randomPowers) as int));
					}
				}
			}
			
			numberOfRemainingTurns = NumberOfTurns.GetNumberTurns(Global.currentTurns);
			
			AE.AddPressFunction(TouchPress);
			AE.AddReleaseFunction(TouchRelease);
		}
		
		override public function remove():void 
		{
			super.remove();
			
			AE.RemovePressFunction(TouchPress);
			AE.RemoveReleaseFunction(TouchRelease);
		}
		
		public function GetTiles(xTile:int, yTile:int):Vector.<TileEntity>
		{
			var returnTiles:Vector.<TileEntity> = new Vector.<TileEntity>();
			for each (var tile:TileEntity in tiles) 
			{
				if (tile.xTile == xTile && tile.yTile == yTile)
				{
					returnTiles.push(tile);
				}
			}
			
			return returnTiles;
		}
		
		public function GetTile(xTile:int, yTile:int):TileEntity
		{
			for each (var tile:TileEntity in tiles) 
			{
				if (tile.xTile == xTile && tile.yTile == yTile)
				{
					return tile;
				}
			}
			
			return null;
		}
		
		public function RemoveTile(tile:TileEntity):void
		{
			for (var i:int = 0; i < tiles.length; i++) 
			{
				if (tile == tiles[i])
				{
					tiles.splice(i, 1);
					world.RemoveEntity(tile);
					return;
				}
			}
		}
		
		public function AddTile(tile:TileEntity):void
		{
			tiles.push(tile);
			world.AddEntity(tile);
		}
		
		protected function TouchPress(tX:Number, tY:Number, tID:int):void
		{
			if (AE.NumberOfTouches > Global.MAX_TOUCHES)
			{
				return;
			}
			
			if (pressID == -1)
			{
				pressID = tID;
				pressX = tX;
				pressY = tY;
			}
		}
		
		protected function MoveGrid(direction:Point):void
		{
			swipeSounds[Global.Rand(swipeSounds.length)].Play();
			
			var i:int, j:int;
			var tile:TileEntity;
			if (direction == Direction.MOVE_UP)
			{
				for (i = 0; i < Y_TILES; i++) 
				{
					for (j = 0; j < X_TILES; j++) 
					{
						tile = GetTile(j, i);
						if (tile != null)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
			
			if (direction == Direction.MOVE_DOWN)
			{
				for (i = Y_TILES - 1; i >= 0; i--) 
				{
					for (j = 0; j < X_TILES; j++) 
					{
						tile = GetTile(j, i);
						if (tile != null)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
			
			if (direction == Direction.MOVE_LEFT)
			{
				for (j = 0; j < X_TILES; j++) 
				{
					for (i = 0; i < Y_TILES; i++) 
					{
						tile = GetTile(j, i);
						if (tile != null)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
			
			if (direction == Direction.MOVE_RIGHT)
			{
				for (j = X_TILES - 1; j >= 0; j--) 
				{
					for (i = 0; i < Y_TILES; i++) 
					{
						tile = GetTile(j, i);
						if (tile != null)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
		}
		
		protected function ContinueMoveGrid(direction:Point):void
		{
			var i:int, j:int;
			var tile:TileEntity;
			if (direction == Direction.MOVE_UP)
			{
				for (i = 0; i < Y_TILES; i++) 
				{
					for (j = 0; j < X_TILES; j++) 
					{
						tile = GetTile(j, i);
						if (tile != null && tile.isAnimating)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
			
			if (direction == Direction.MOVE_DOWN)
			{
				for (i = Y_TILES - 1; i >= 0; i--) 
				{
					for (j = 0; j < X_TILES; j++) 
					{
						tile = GetTile(j, i);
						if (tile != null && tile.isAnimating)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
			
			if (direction == Direction.MOVE_LEFT)
			{
				for (j = 0; j < X_TILES; j++) 
				{
					for (i = 0; i < Y_TILES; i++) 
					{
						tile = GetTile(j, i);
						if (tile != null && tile.isAnimating)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
			
			if (direction == Direction.MOVE_RIGHT)
			{
				for (j = X_TILES - 1; j >= 0; j--) 
				{
					for (i = 0; i < Y_TILES; i++) 
					{
						tile = GetTile(j, i);
						if (tile != null && tile.isAnimating)
						{
							tile.MoveTile(direction);
						}
					}
				}
			}
		}
		
		protected function InsertNewTile(direction:Point):void
		{
			var i:int;
			var emptySlots:Vector.<Point> = new Vector.<Point>();
			
			if (direction == Direction.MOVE_UP)
			{
				for (i = 0; i < X_TILES; i++) 
				{
					if (GetTile(i, Y_TILES - 1) == null)
					{
						emptySlots.push(new Point(i, Y_TILES - 1));
					}
				}
			}
			
			if (direction == Direction.MOVE_DOWN)
			{
				for (i = 0; i < X_TILES; i++) 
				{
					if (GetTile(i, 0) == null)
					{
						emptySlots.push(new Point(i, 0));
					}
				}
			}
			
			if (direction == Direction.MOVE_RIGHT)
			{
				for (i = 0; i < Y_TILES; i++) 
				{
					if (GetTile(0, i) == null)
					{
						emptySlots.push(new Point(0, i));
					}
				}
			}
			
			if (direction == Direction.MOVE_LEFT)
			{
				for (i = 0; i < Y_TILES; i++) 
				{
					if (GetTile(X_TILES - 1, i) == null)
					{
						emptySlots.push(new Point(X_TILES - 1, i));
					}
				}
			}
			
			var randomSlot:Point = emptySlots[Global.Rand(emptySlots.length)];
			var tileEntity:TileEntity = new TileEntity(randomSlot.x, randomSlot.y, nextColor, nextType, nextPower);
			AddTile(tileEntity);
		}
		
		protected function ChangeNextTile():void
		{
			var numberOfBlueTiles:Number = 0;
			var numberOfRedTiles:Number = 0;
			var maxPower:Number = 0;
			var minPower:Number = int.MAX_VALUE;
			var numberOfScissors:Number = 0;
			var numberOfPaper:Number = 0;
			var numberOfRock:Number = 0;
			
			for (var i:int = 0; i < tiles.length; i++) 
			{
				if (tiles[i].tileColor == TileColor.BLUE)
				{
					numberOfBlueTiles += 1;
				}
				else
				{
					numberOfRedTiles += 1;
				}
				
				if (tiles[i].tileType == TileType.ROCK)
				{
					numberOfRock += 1;
				}
				else if (tiles[i].tileType == TileType.PAPER)
				{
					numberOfPaper += 1;
				}
				else
				{
					numberOfScissors += 1;
				}
				
				if (tiles[i].tilePower > maxPower)
				{
					maxPower = tiles[i].tilePower;
				}
				
				if (tiles[i].tilePower < minPower)
				{
					minPower = tiles[i].tilePower;
				}
			}
			
			var bluePercentage:Number = numberOfBlueTiles / (numberOfBlueTiles + numberOfRedTiles);
			if (Global.currentMode == GameplayTypes.MULTIPLAYER || Global.currentMode == GameplayTypes.VERSUS)
			{
				Global.currentHUD.ChangePlayerTurn(nextColor);
				if (nextColor == TileColor.BLUE)
				{
					nextColor = TileColor.RED;
				}
				else
				{
					nextColor = TileColor.BLUE;
				}
			}
			else
			{
				nextColor = TileColor.RED;
				if (Math.random() < 1 - bluePercentage)
				{
					nextColor = TileColor.BLUE;
				}
			}
			
			var rockPercentage:Number = numberOfRock / (numberOfRock + numberOfPaper + numberOfScissors);
			var paperPercentage:Number = numberOfPaper / (numberOfRock + numberOfPaper + numberOfScissors);
			var randomValue:Number = Math.random();
			nextType = TileType.SCISSORS;
			if (randomValue < 1 - rockPercentage - paperPercentage)
			{
				nextType = TileType.ROCK;
			}
			else if (randomValue < 1 - paperPercentage)
			{
				nextType = TileType.PAPER; 
			}
			
			var differencePower:int = maxPower - minPower;
			if (differencePower == 0 && maxPower > 3 && Math.random() < 0.5)
			{
				differencePower = 2;
			}
			nextPower = Math.floor((minPower + maxPower) / 2 - differencePower / 2 + Global.Rand(differencePower));
			if (Math.random() < 0.3)
			{
				nextPower = 1;
			}
			
			Global.currentHUD.UpdateNextTile(nextColor, nextType);
		}
		
		protected function PlayTurn(direction:Point):void
		{
			if (numberOfRemainingTurns > 0)
			{
				numberOfRemainingTurns -= 1;
				Global.currentHUD.UpdateTurns(numberOfRemainingTurns);
			}
			else if(numberOfRemainingTurns == 0)
			{
				return;
			}
			
			currentDirection = direction;
			MoveGrid(currentDirection);
			if (Global.currentMode != GameplayTypes.PUZZLE)
			{
				InsertNewTile(direction);
				ChangeNextTile();
			}
		}
		
		protected function PlayComputerTurn():void
		{
			PlayTurn(GetBestMovement());
			timerForTurn = null;
		}
		
		protected function TouchRelease(tX:Number, tY:Number, tID:int):void
		{
			if (pressID == tID)
			{
				pressID = -1;
				var direction:Point = Global.GetSwipeDirection(new Point(pressX, pressY), new Point(tX, tY));
				if (direction.length > 0)
				{
					if (Global.currentMode == GameplayTypes.PUZZLE && CheckWinPuzzle())
					{
						return;
					}
					
					if (CheckMoveDirection(direction))
					{
						if (!CheckAnimation())
						{
							if (Global.currentMode == GameplayTypes.VERSUS && nextColor == TileColor.BLUE)
							{
								return;
							}
							
							PlayTurn(direction);
						}
					}
					else
					{
						noswipeSfx.Play();
					}
				}
			}
		}
		
		
		protected function GetBestMovement():Point
		{
			var i:int, j:int;
			var tile1:TileEntity, tile2:TileEntity;
			var tempArray:Array;
			var sol:ResolveSolution;
			var scores:Array = [0.0, 0.0, 0.0, 0.0];
			var directions:Array = [Direction.MOVE_UP, Direction.MOVE_DOWN, Direction.MOVE_LEFT, Direction.MOVE_RIGHT];
			
			//up direction
			for (j = 0; j < X_TILES; j++) 
			{
				tile1 = GetTile(j, 0);
				for (i = 1; i < Y_TILES; i++)
				{
					if (tile1 == null)
					{
						tile1 = GetTile(j, i);
						continue;
					}
					tile2 = GetTile(j, i);
					if (tile2 != null)
					{
						tempArray = [tile1, tile2];
						sol = TileEntity.ResolveTiles(tempArray);
						if (sol.action == ResolveSolution.DESTROY)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.BLUE)
							{
								scores[0] += tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[0] -= DESTROY_ENEMY_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = tempArray[(sol.tileNumber + 1) % 2];
						}
						else if (sol.action == ResolveSolution.ADDED)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.RED)
							{
								scores[0] += ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[0] -= ADDED_ENEMY_FACTOR * ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = new TileEntity(tile1.x, tile1.y, tile1.tileColor, tile1.tileType, tile1.tilePower + tile2.tilePower);
						}
						else
						{
							tile1 = tile2;
						}
					}
				}
			}
			
			//down direction
			for (j = 0; j < X_TILES; j++) 
			{
				tile1 = GetTile(j, Y_TILES - 1);
				for (i = Y_TILES - 2; i >= 0; i--)
				{
					if (tile1 == null)
					{
						tile1 = GetTile(j, i);
						continue;
					}
					tile2 = GetTile(j, i);
					if (tile2 != null)
					{
						tempArray = [tile1, tile2];
						sol = TileEntity.ResolveTiles(tempArray);
						if (sol.action == ResolveSolution.DESTROY)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.BLUE)
							{
								scores[1] += tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[1] -= DESTROY_ENEMY_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = tempArray[(sol.tileNumber + 1) % 2];
						}
						else if (sol.action == ResolveSolution.ADDED)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.RED)
							{
								scores[1] += ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[1] -= ADDED_ENEMY_FACTOR * ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = new TileEntity(tile1.x, tile1.y, tile1.tileColor, tile1.tileType, tile1.tilePower + tile2.tilePower);
						}
						else
						{
							tile1 = tile2;
						}
					}
				}
			}
			
			//left direction
			for (i = 0; i < Y_TILES; i++) 
			{
				tile1 = GetTile(0, i);
				for (j = 1; j < X_TILES; j++)
				{
					if (tile1 == null)
					{
						tile1 = GetTile(j, i);
						continue;
					}
					tile2 = GetTile(j, i);
					if (tile2 != null)
					{
						tempArray = [tile1, tile2];
						sol = TileEntity.ResolveTiles(tempArray);
						if (sol.action == ResolveSolution.DESTROY)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.BLUE)
							{
								scores[2] += tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[2] -= DESTROY_ENEMY_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = tempArray[(sol.tileNumber + 1) % 2];
						}
						else if (sol.action == ResolveSolution.ADDED)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.RED)
							{
								scores[2] += ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[2] -= ADDED_ENEMY_FACTOR * ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = new TileEntity(tile1.x, tile1.y, tile1.tileColor, tile1.tileType, tile1.tilePower + tile2.tilePower);
						}
						else
						{
							tile1 = tile2;
						}
					}
				}
			}
			
			//right direction
			for (i = 0; i < Y_TILES; i++) 
			{
				tile1 = GetTile(X_TILES - 1, i);
				for (j = X_TILES - 2; j >= 0; j--)
				{
					if (tile1 == null)
					{
						tile1 = GetTile(j, i);
						continue;
					}
					tile2 = GetTile(j, i);
					if (tile2 != null)
					{
						tempArray = [tile1, tile2];
						sol = TileEntity.ResolveTiles(tempArray);
						if (sol.action == ResolveSolution.DESTROY)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.BLUE)
							{
								scores[3] += tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[3] -= DESTROY_ENEMY_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = tempArray[(sol.tileNumber + 1) % 2];
						}
						else if (sol.action == ResolveSolution.ADDED)
						{
							if (tempArray[sol.tileNumber].tileColor == TileColor.RED)
							{
								scores[3] += ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							else
							{
								scores[3] -= ADDED_ENEMY_FACTOR * ADDING_FACTOR * tempArray[sol.tileNumber].tilePower;
							}
							tile1 = new TileEntity(tile1.x, tile1.y, tile1.tileColor, tile1.tileType, tile1.tilePower + tile2.tilePower);
						}
						else
						{
							tile1 = tile2;
						}
					}
				}
			}
			
			//Get the best score
			var bestScoreIndex:int = -1;
			var bestScore:Number = int.MIN_VALUE;
			
			for (i = 0; i < scores.length; i++) 
			{
				if (scores[i] > bestScore && CheckMoveDirection(directions[i]))
				{
					bestScoreIndex = i;
					bestScore = scores[i];
				}
			}
			
			return directions[bestScoreIndex];
		}
		
		protected function CheckAnimation():Boolean
		{
			for each (var tile:TileEntity in tiles) 
			{
				if (tile.isAnimating)
				{
					return true;
				}
			}
			
			return false;
		}
		
		protected function CheckOneMove():Boolean
		{
			for each (var tile:TileEntity in tiles) 
			{
				if (tile.isMoving)
				{
					return true;
				}
			}
			
			return false;
		}
		
		protected function CheckMoveDirection(direction:Point):Boolean
		{
			for (var j:int = 0; j < X_TILES; j++) 
			{
				for (var i:int = 0; i < Y_TILES; i++) 
				{
					if (GetTile(j, i) != null && GetTile(j, i).CheckMovable(j + direction.x, i + direction.y))
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		protected function CheckGameOver():Boolean
		{
			var noMoreMoves:Boolean = true;
			for each (var direction:Point in Direction.directionArray) 
			{
				if (CheckMoveDirection(direction))
				{
					noMoreMoves = false;
					break;
				}
			}
			
			return noMoreMoves || numberOfRemainingTurns == 0;
		}
		
		protected function CheckWinPuzzle():Boolean
		{
			if (tiles.length == 1)
			{
				if (tiles[0].tileColor == TileColor.BLUE)
				{
					return true;
				}
			}
			
			return false;
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			
			if (!CheckAnimation())
			{
				if (Global.currentMode != GameplayTypes.PUZZLE && CheckGameOver())
				{
					if (gameOverEntity == null)
					{
						gameOverEntity = new GameOverEntity();
						world.AddEntity(gameOverEntity);
					}
				}
				else if (Global.currentMode == GameplayTypes.PUZZLE && CheckWinPuzzle())
				{
					if (gameOverEntity == null)
					{
						gameOverEntity = new GameOverEntity();
						world.AddEntity(gameOverEntity);
					}
				}
				else if (Global.currentMode == GameplayTypes.VERSUS && nextColor == TileColor.BLUE && timerForTurn == null)
				{
					timerForTurn = new DelayedCall(PlayComputerTurn, 0.5);
					Starling.current.juggler.add(timerForTurn);
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