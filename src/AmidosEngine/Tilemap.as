package AmidosEngine 
{
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Tilemap extends Sprite
	{
		private var quadBatch:QuadBatch;
		private var tileTexture:Texture;
		private var xTile:Number;
		private var yTile:Number;
		private var numberOfXTiles:int;
		private var numberOfYTiles:int;
		private var smoothing:String;
		private var tiles:Array;
		
		public function Tilemap(tileTexture:Texture, xTileSize:Number, yTileSize:Number, smoothing:String = "none") 
		{
			this.xTile = xTileSize;
			this.yTile = yTileSize;
			this.smoothing = smoothing;
			this.tileTexture = tileTexture;
			this.quadBatch = new QuadBatch();
			
			this.numberOfXTiles = Math.floor(tileTexture.nativeWidth / xTileSize);
			this.numberOfYTiles = Math.floor(tileTexture.nativeHeight / yTileSize);
			
			this.tiles = new Array();
			
			addChild(quadBatch);
		}
		
		public function AddTile(yIndex:Number, xIndex:Number, tileID:int):void
		{
			var image:Image = new Image(tileTexture);
			image.x  = xIndex * xTile;
			image.y = yIndex * yTile;
			image.width = xTile;
			image.height = yTile;
			image.smoothing = smoothing;
			
			var xTileIndex:int = tileID % numberOfXTiles;
			var yTileIndex:int = tileID / numberOfXTiles;
			
			image.setTexCoords(0, new Point((0 + xTileIndex) * xTile / tileTexture.nativeWidth, (0 + yTileIndex) * yTile / tileTexture.nativeHeight));
			image.setTexCoords(1, new Point((1 + xTileIndex) * xTile / tileTexture.nativeWidth, (0 + yTileIndex) * yTile / tileTexture.nativeHeight));
			image.setTexCoords(2, new Point((0 + xTileIndex) * xTile / tileTexture.nativeWidth, (1 + yTileIndex) * yTile / tileTexture.nativeHeight));
			image.setTexCoords(3, new Point((1 + xTileIndex) * xTile / tileTexture.nativeWidth, (1 + yTileIndex) * yTile / tileTexture.nativeHeight));
			
			tiles[xIndex.toString() + "," + yIndex.toString()] = image;
			
			quadBatch.addImage(image);
		}
		
		public function ChangeTile(yIndex:Number, xIndex:Number, tileID:int):void
		{
			var image:Image = tiles[xIndex.toString() + "," + yIndex.toString()];
			
			var xTileIndex:int = tileID % numberOfXTiles;
			var yTileIndex:int = tileID / numberOfXTiles;
			
			image.setTexCoords(0, new Point((0 + xTileIndex) * xTile / tileTexture.nativeWidth, (0 + yTileIndex) * yTile / tileTexture.nativeHeight));
			image.setTexCoords(1, new Point((1 + xTileIndex) * xTile / tileTexture.nativeWidth, (0 + yTileIndex) * yTile / tileTexture.nativeHeight));
			image.setTexCoords(2, new Point((0 + xTileIndex) * xTile / tileTexture.nativeWidth, (1 + yTileIndex) * yTile / tileTexture.nativeHeight));
			image.setTexCoords(3, new Point((1 + xTileIndex) * xTile / tileTexture.nativeWidth, (1 + yTileIndex) * yTile / tileTexture.nativeHeight));
			
			removeChild(quadBatch);
			quadBatch = new QuadBatch();
			for each (var i:Image in tiles) 
			{
				quadBatch.addImage(i);
			}
			addChild(quadBatch);
		}
	}

}