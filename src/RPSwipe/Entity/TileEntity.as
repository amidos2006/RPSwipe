package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import AmidosEngine.Sfx;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import RPSwipe.Data.GameplayTypes;
	import RPSwipe.Data.ResolveSolution;
	import RPSwipe.Data.TileColor;
	import RPSwipe.Data.TileType;
	import RPSwipe.Global;
	import RPSwipe.LayerConstants;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TileEntity extends Entity
	{
		public static const TILE_SIZE:Number = 48;
		
		private var localTilePower:int;
		public var tileType:String;
		public var tileColor:String;
		public var xTile:int;
		public var yTile:int;
		public var isMoving:Boolean;
		public var isAnimating:Boolean;
		
		private var tileImage:Image;
		private var powerText:Image;
		
		private var rockSfx:Sfx;
		private var paperSfx:Sfx;
		private var scissorsSfx:Sfx;
		private var powerupSfx:Sfx;
		
		public var endPositionX:Number;
		public var endPositionY:Number;
		public var moveDirection:Point;
		public var moveSpeed:Number;
		
		public function set tilePower(value:int):void
		{
			localTilePower = value;
			powerText.texture = AE.assetManager.getTexture(tileColor + localTilePower.toString());
		}
		
		public function get tilePower():int
		{
			return localTilePower;
		}
		
		public function TileEntity(xTile:int, yTile:int, tileColor:String, tileType:String, tilePower:int) 
		{
			this.tileColor = tileColor;
			this.tileType = tileType;
			if (tilePower > 9)
			{
				tilePower = 9;
			}
			this.localTilePower = tilePower;
			this.xTile = xTile;
			this.yTile = yTile;
			this.isMoving = false;
			
			this.endPositionX = -1;
			this.endPositionY = -1;
			this.moveSpeed = 450;
			
			rockSfx = new Sfx(AE.assetManager.getSound("rockSound"));
			paperSfx = new Sfx(AE.assetManager.getSound("paperSound"));
			scissorsSfx = new Sfx(AE.assetManager.getSound("scissorsSound"));
			powerupSfx = new Sfx(AE.assetManager.getSound("powerupSound"));
			
			var worldPoint:Point = Global.GetFromTile(this.xTile, this.yTile);
			this.x = worldPoint.x;
			this.y = worldPoint.y;
			
			tileImage = new Image(AE.assetManager.getTexture(this.tileColor + this.tileType));
			tileImage.smoothing = "none";
			tileImage.pivotX = TILE_SIZE / 2;
			tileImage.pivotY = TILE_SIZE / 2;
			
			powerText = new Image(AE.assetManager.getTexture(this.tileColor + this.tilePower.toString()));
			powerText.smoothing = "none";
			powerText.scaleX = 0.8;
			powerText.scaleY = 0.8;
			powerText.alignPivot("center", "bottom");
			powerText.y += TILE_SIZE / 2 - 6;
			
			var sprite:Sprite = new Sprite();
			sprite.addChild(tileImage);
			sprite.addChild(powerText);
			sprite.scaleX = 0;
			sprite.scaleY = 0;
			
			graphic = sprite;
			layer = LayerConstants.TILE_LAYER;
			useCamera = false;
		}
		
		override public function add():void 
		{
			super.add();
			
			var tween:Tween = new Tween(graphic, 1, Transitions.EASE_OUT_ELASTIC);
			tween.scaleTo(1);
			Starling.current.juggler.add(tween);
		}
		
		public function CheckMovableTile(t:TileEntity):Boolean
		{
			if (tileColor == t.tileColor && tileType == t.tileType)
			{
				if (tilePower < 9 && t.tilePower < 9)
				{
					return true;
				}
				return false;
			}
			
			if (tileColor != t.tileColor && tileType != t.tileType)
			{
				switch (tileType) 
				{
					case TileType.ROCK:
						if (t.tileType == TileType.SCISSORS)
						{
							if (tilePower >= t.tilePower)
							{
								return true;
							}
						}
						else
						{
							if (tilePower <= t.tilePower)
							{
								return true;
							}
						}
						break;
					case TileType.PAPER:
						if (t.tileType == TileType.ROCK)
						{
							if (tilePower >= t.tilePower)
							{
								return true;
							}
						}
						else
						{
							if (tilePower <= t.tilePower)
							{
								return true;
							}
						}
						break;
					case TileType.SCISSORS:
						if (t.tileType == TileType.PAPER)
						{
							if (tilePower >= t.tilePower)
							{
								return true;
							}
						}
						else
						{
							if (tilePower <= t.tilePower)
							{
								return true;
							}
						}
						break;
				}
			}
			
			return false;
		}
		
		public function CheckMovable(xTile:int, yTile:int):Boolean
		{
			if (xTile < 0 || xTile >= GridEntity.X_TILES)
			{
				return false;
			}
			
			if (yTile < 0 || yTile >= GridEntity.Y_TILES)
			{
				return false;
			}
			
			var t:TileEntity = Global.currentGrid.GetTile(xTile, yTile);
			if (t == null)
			{
				return true;
			}
			
			return CheckMovableTile(t);
		}
		
		public function MoveTile(direction:Point):void
		{
			if (!CheckMovable(xTile + direction.x, yTile + direction.y))
			{
				if (isAnimating)
				{
					x = endPositionX;
					y = endPositionY;
				}
				isAnimating = false;
				return;
			}
			
			xTile = xTile + direction.x;
			yTile = yTile + direction.y;
			isMoving = true;
			isAnimating = true;
			
			var nextPosition:Point = Global.GetFromTile(xTile, yTile);
			endPositionX = nextPosition.x;
			endPositionY = nextPosition.y;
			
			moveDirection = direction;
		}
		
		private function OneMoveEnds():void
		{
			isMoving = false;
		}
		
		public function ChangeAnimation():void
		{
			var scaleTweenUp:Tween = new Tween(graphic, 0.125, Transitions.EASE_OUT);
			scaleTweenUp.scaleTo(1.25);
			var scaleTweenDown:Tween = new Tween(graphic, 0.125, Transitions.EASE_IN);
			scaleTweenDown.scaleTo(1);
			scaleTweenUp.nextTween = scaleTweenDown;
			
			Starling.current.juggler.add(scaleTweenUp);
		}
		
		public static function ResolveTiles(tiles:Array):ResolveSolution
		{
			var resolve:ResolveSolution = new ResolveSolution();
			
			if (tiles[0].tileColor == tiles[1].tileColor)
			{
				if (tiles[0].tileType == tiles[1].tileType)
				{
					resolve.tileNumber = 1;
					resolve.action = ResolveSolution.ADDED;
					return resolve;
				}
			}
			else if(tiles[0].tileColor != tiles[1].tileColor && tiles[0].tileType != tiles[1].tileType)
			{
				switch (tiles[0].tileType) 
				{
					case TileType.ROCK:
						if (tiles[1].tileType == TileType.SCISSORS)
						{
							if (tiles[0].tilePower >= tiles[1].tilePower)
							{
								resolve.action = ResolveSolution.DESTROY;
								resolve.tileNumber = 1;
							}
						}
						else
						{
							if (tiles[1].tilePower >= tiles[0].tilePower)
							{
								resolve.action = ResolveSolution.DESTROY;
								resolve.tileNumber = 0;
							}
						}
						break;
					case TileType.PAPER:
						if (tiles[1].tileType == TileType.ROCK)
						{
							if (tiles[0].tilePower >= tiles[1].tilePower)
							{
								resolve.action = ResolveSolution.DESTROY;
								resolve.tileNumber = 1;
							}
						}
						else
						{
							if (tiles[1].tilePower >= tiles[0].tilePower)
							{
								resolve.action = ResolveSolution.DESTROY;
								resolve.tileNumber = 0;
							}
						}
						break;
					case TileType.SCISSORS:
						if (tiles[1].tileType == TileType.PAPER)
						{
							if (tiles[0].tilePower >= tiles[1].tilePower)
							{
								resolve.action = ResolveSolution.DESTROY;
								resolve.tileNumber = 1;
							}
						}
						else
						{
							if (tiles[1].tilePower >= tiles[0].tilePower)
							{
								resolve.action = ResolveSolution.DESTROY;
								resolve.tileNumber = 0;
							}
						}
						break;
				}
			}
			
			return resolve;
		}
		
		public function ResolvePosition():void
		{
			if (Global.currentGrid.GetTiles(xTile, yTile).length <= 1)
			{
				return;
			}
			
			var tiles:Vector.<TileEntity> = Global.currentGrid.GetTiles(xTile, yTile);
			if (tiles[0].isAnimating)
			{
				tiles[0].x = tiles[0].endPositionX;
				tiles[0].y = tiles[0].endPositionY;
			}
			tiles[0].isAnimating = false;
			
			if (tiles[1].isAnimating)
			{
				tiles[1].x = tiles[1].endPositionX;
				tiles[1].y = tiles[1].endPositionY;
			}
			tiles[1].isAnimating = false;
			
			if (tiles[0].tileColor == tiles[1].tileColor)
			{
				if (tiles[0].tileType == tiles[1].tileType)
				{
					if (tiles[0].tilePower + tiles[1].tilePower > 9)
					{
						tiles[0].tilePower = 9;
					}
					else
					{
						tiles[0].tilePower += tiles[1].tilePower;
					}
					powerupSfx.Play();
					tiles[0].ChangeAnimation();
					Global.currentGrid.RemoveTile(tiles[1]);
					
					return;
				}
			}
			else if(tiles[0].tileColor != tiles[1].tileColor && tiles[0].tileType != tiles[1].tileType)
			{
				switch (tiles[0].tileType) 
				{
					case TileType.ROCK:
						if (tiles[1].tileType == TileType.SCISSORS)
						{
							tiles[0].ChangeAnimation();
							Global.currentGrid.RemoveTile(tiles[1]);
							rockSfx.Play();
							
							if (tiles[0].tileColor == TileColor.BLUE)
							{
								Global.blueScore += tiles[1].tilePower;
							}
							else
							{
								Global.redScore += tiles[1].tilePower;
							}
						}
						else
						{
							tiles[1].ChangeAnimation();
							Global.currentGrid.RemoveTile(tiles[0]);
							paperSfx.Play();
							
							if (tiles[0].tileColor == TileColor.BLUE)
							{
								Global.redScore += tiles[0].tilePower;
							}
							else
							{
								Global.blueScore += tiles[0].tilePower;
							}
						}
						break;
					case TileType.PAPER:
						if (tiles[1].tileType == TileType.ROCK)
						{
							tiles[0].ChangeAnimation();
							Global.currentGrid.RemoveTile(tiles[1]);
							paperSfx.Play();
							
							if (tiles[0].tileColor == TileColor.BLUE)
							{
								Global.blueScore += tiles[1].tilePower;
							}
							else
							{
								Global.redScore += tiles[1].tilePower;
							}
						}
						else
						{
							tiles[1].ChangeAnimation();
							Global.currentGrid.RemoveTile(tiles[0]);
							scissorsSfx.Play();
							
							if (tiles[0].tileColor == TileColor.BLUE)
							{
								Global.redScore += tiles[0].tilePower;
							}
							else
							{
								Global.blueScore += tiles[0].tilePower;
							}
						}
						break;
					case TileType.SCISSORS:
						if (tiles[1].tileType == TileType.PAPER)
						{
							tiles[0].ChangeAnimation();
							Global.currentGrid.RemoveTile(tiles[1]);
							scissorsSfx.Play();
							
							if (tiles[0].tileColor == TileColor.BLUE)
							{
								Global.blueScore += tiles[1].tilePower;
							}
							else
							{
								Global.redScore += tiles[1].tilePower;
							}
						}
						else
						{
							tiles[1].ChangeAnimation();
							Global.currentGrid.RemoveTile(tiles[0]);
							rockSfx.Play();
							
							if (tiles[0].tileColor == TileColor.BLUE)
							{
								Global.redScore += tiles[0].tilePower;
							}
							else
							{
								Global.blueScore += tiles[0].tilePower;
							}
						}
						break;
				}
				
				if (Global.currentMode == GameplayTypes.NORMAL)
				{
					Global.score = Global.blueScore;
					Global.currentHUD.UpdateScore(Global.score);
				}
				else if (Global.currentMode == GameplayTypes.MULTIPLAYER || Global.currentMode == GameplayTypes.VERSUS)
				{
					Global.currentHUD.UpdateMultiplayerScore(Global.blueScore, Global.redScore);
				}
			}
		}
		
		override public function update(dt:Number):void 
		{
			super.update(dt);
			
			if (isAnimating && isMoving)
			{
				x += moveDirection.x * moveSpeed * dt;
				y += moveDirection.y * moveSpeed * dt;
				if (moveDirection.x > 0 || moveDirection.y > 0)
				{
					if (x >= endPositionX && y >= endPositionY)
					{
						OneMoveEnds();
					}
				}
				else
				{
					if (x <= endPositionX && y <= endPositionY)
					{
						OneMoveEnds();
					}
				}
			}
		}
	}

}