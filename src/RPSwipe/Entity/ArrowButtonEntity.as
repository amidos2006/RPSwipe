package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.ButtonEntity;
	import AmidosEngine.Sfx;
	import flash.geom.Rectangle;
	import RPSwipe.LayerConstants;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ArrowButtonEntity extends ButtonEntity
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		public function ArrowButtonEntity(x:Number, y:Number, direction:String) 
		{
			this.x = x;
			this.y = y;
			
			var image:Image = new Image(AE.assetManager.getTexture(direction + "Button"));
			image.smoothing = "none";
			image.alignPivot("center", "center");
			
			graphic = image;
			layer = LayerConstants.HUD_LAYER;
			
			hitBox = new Rectangle(-image.pivotX, -image.pivotY, image.width, image.height);
		}
		
		override protected function ButtonIn():void 
		{
			super.ButtonIn();
			
			scaleX = 1.25;
			scaleY = 1.25;
		}
		
		override protected function ButtonOut():void 
		{
			super.ButtonOut();
			
			scaleX = 1;
			scaleY = 1;
		}
	}

}