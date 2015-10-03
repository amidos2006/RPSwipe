package RPSwipe.Entity 
{
	import AmidosEngine.AE;
	import AmidosEngine.Entity;
	import RPSwipe.LayerConstants;
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BackgroundEntity extends Entity
	{
		private const THICKNESS:int = 2;
		private const DARK_COLOR:uint = 0xFFE5E5E5;
		
		public function BackgroundEntity() 
		{
			var quadBatch:QuadBatch = new QuadBatch();
			
			var quad:Quad = new Quad(THICKNESS, THICKNESS, 0xFF000000);
			quad.alignPivot("left", "top");
			quad.x = 0;
			quad.y = 0;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(THICKNESS, THICKNESS, 0xFF000000);
			quad.alignPivot("right", "top");
			quad.x = AE.game.width;
			quad.y = 0;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(THICKNESS, THICKNESS, 0xFF000000);
			quad.alignPivot("left", "bottom");
			quad.x = 0;
			quad.y = AE.game.height;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(THICKNESS, THICKNESS, 0xFF000000);
			quad.alignPivot("right", "bottom");
			quad.x = AE.game.width;
			quad.y = AE.game.height;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(AE.game.width - 2 * THICKNESS, THICKNESS, DARK_COLOR);
			quad.alignPivot("left", "top");
			quad.x = THICKNESS;
			quad.y = 0;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(THICKNESS, AE.game.height - 2 * THICKNESS, DARK_COLOR);
			quad.alignPivot("left", "top");
			quad.x = 0;
			quad.y = THICKNESS;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(THICKNESS, AE.game.height - 2 * THICKNESS, DARK_COLOR);
			quad.alignPivot("right", "top");
			quad.x = AE.game.width;
			quad.y = THICKNESS;
			
			quadBatch.addQuad(quad);
			
			quad = new Quad(AE.game.width - 2 * THICKNESS, THICKNESS, DARK_COLOR);
			quad.alignPivot("left", "bottom");
			quad.x = THICKNESS;
			quad.y = AE.game.height;
			
			quadBatch.addQuad(quad);
			
			graphic = quadBatch;
			layer = LayerConstants.BACKGROUND_LAYER;
			useCamera = false;
		}
	}

}