package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.ButtonEntity;
	import flash.geom.Rectangle;
	import RPSwipe.LayerConstants;
	import starling.display.Image;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BackButtonEntity extends ButtonEntity
	{
		public function BackButtonEntity() 
		{
			x = 5;
			y = 5;
			
			var image:Image = new Image(AE.assetManager.getTexture("backButton"));
			image.smoothing = "none";
			image.alignPivot("center", "center");
			
			x += image.width / 2;
			y += image.height / 2;
			
			graphic = image;
			layer = LayerConstants.HUD_LAYER;
			
			hitBox = new Rectangle( -image.pivotX, -image.pivotY, image.width, image.height);
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