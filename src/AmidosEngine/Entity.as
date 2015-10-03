package AmidosEngine 
{
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Entity extends Sprite
	{
		private var localX:Number;
		private var localY:Number;
		private var localLayer:int;
		private var transferLayer:int;
		private var transferWorld:World;
		private var localHitBox:Rectangle;
		private var localGraphic:DisplayObject;
		private var localCollisionName:String;
		private var localWorld:World;
		private var localUseCamera:Boolean;
		private var localVisible:Boolean;
		
		override public function set x(value:Number):void 
		{
			localX = value;
		}
		
		override public function get x():Number 
		{
			return localX;
		}
		
		override public function set y(value:Number):void 
		{
			localY = value;
		}
		
		override public function get y():Number 
		{
			return localY;
		}
		
		override public function set visible(value:Boolean):void 
		{
			localVisible = value;
		}
		
		override public function get visible():Boolean 
		{
			return localVisible;
		}
		
		public function set useCamera(value:Boolean):void
		{
			localUseCamera = value;
		}
		
		public function get useCamera():Boolean
		{
			return localUseCamera;
		}
		
		public function set layer(value:int):void
		{
			if (localWorld != null && localLayer != value)
			{
				transferLayer = value;
				transferWorld = localWorld;
				localWorld.RemoveEntity(this);
			}
			else
			{
				localLayer = value;
			}
		}
		
		public function get layer():int
		{
			return localLayer;
		}
		
		public function set hitBox(value:Rectangle):void
		{
			localHitBox = value;
		}
		
		public function get hitBox():Rectangle
		{
			return localHitBox;
		}
		
		public function set graphic(value:DisplayObject):void
		{
			localGraphic = value;
		}
		
		public function get graphic():DisplayObject
		{
			return localGraphic;
		}
		
		public function set collisionName(value:String):void
		{
			localCollisionName = value;
		}
		
		public function get collisionName():String
		{
			return localCollisionName;
		}
		
		public function set world(value:World):void
		{
			localWorld = value;
		}
		
		public function get world():World
		{
			return localWorld;
		}
		
		private function UpdatePosition():void
		{
			if (localUseCamera)
			{
				super.x = localX - AE.game.gameCamera.x;
				super.y = localY - AE.game.gameCamera.y;
			}
			else
			{
				super.x = localX;
				super.y = localY;
			}
		}
		
		public function Entity() 
		{
			localX = 0;
			localY = 0;
			localLayer = 0;
			transferLayer = -1;
			transferWorld = null;
			localHitBox = null;
			localGraphic = null;
			localCollisionName = "";
			localWorld = null;
			localUseCamera = true;
			localVisible = true;
			touchable = false;
		}
		
		public function add():void
		{
			if (graphic != null)
			{
				addChild(graphic);
			}
			
			UpdatePosition();
		}
		
		public function remove():void
		{
			if (graphic != null)
			{
				removeChild(graphic);
			}
			
			if (transferLayer != -1)
			{
				localLayer = transferLayer;
				transferLayer = -1;
				transferWorld.AddEntity(this);
				transferWorld = null;
			}
		}
		
		public function collidePoint(pX:Number, pY:Number, sX:Number, sY:Number):Boolean
		{
			var currentRectangle:Rectangle = new Rectangle(hitBox.x + sX, hitBox.y + sY, hitBox.width, hitBox.height);
			
			return currentRectangle.contains(pX, pY);
		}
		
		public function collideName(otherName:String, sX:Number, sY:Number):Entity
		{
			var entities:Vector.<Entity> = AE.game.ActiveWorld.className(otherName);
			var currentRectangle:Rectangle = new Rectangle(hitBox.x + sX, hitBox.y + sY, hitBox.width, hitBox.height);
			
			for (var i:int = 0; i < entities.length; i++) 
			{
				var otherRectangle:Rectangle = new Rectangle(entities[i].x + entities[i].hitBox.x, entities[i].y + entities[i].hitBox.y, 
					entities[i].hitBox.width, entities[i].hitBox.height);
				if (currentRectangle.intersects(otherRectangle))
				{
					return entities[i];
				}
			}
			
			return null;
		}
		
		public function update(dt:Number):void
		{
			UpdatePosition();
			if (useCamera)
			{
				//super.visible = localVisible && AE.game.gameCamera.RectInsideCamera(x - width, y - height, 2 * width, 2 * height);
			}
		}
	}

}