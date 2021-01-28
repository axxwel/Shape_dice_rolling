package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author BMS_aXXwel
	 */
	public class BitmapDice extends Sprite{ 
		
		public var taille:int = 96;
		private var texture:BitmapData = new BitmapData(taille,taille,false);
		
		private var point1:Point = new Point(0, 0);
		private var point2:Point = new Point(96, 0);
		private var point3:Point = new Point(0, 96);
		private var point4:Point = new Point(96, 96);
			
		private var uvPoint1:Point = new Point(0, 0);
		private var uvPoint2:Point = new Point(1, 0);
		private var uvPoint3:Point = new Point(0, 1);
		private var uvPoint4:Point = new Point(1, 1);
			
		private var index:Vector.<int> = Vector.<int>([0, 1, 2, 1, 3, 2]);
		private var sommets:Vector.<Number> = Vector.<Number>([point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, point4.x, point4.y]);
		private var donneesUV:Vector.<Number> = Vector.<Number>([uvPoint1.x, uvPoint1.y, uvPoint2.x, uvPoint2.y, uvPoint3.x, uvPoint3.y, uvPoint4.x, uvPoint4.y]);
		
		public function BitmapDice(textureTemp:BitmapData) {
			texture = textureTemp;
			animer();
		}
		public function animer(ligne1:Number=0,ligne2:Number=0,ligne3:Number=0,ligne4:Number=0,smooth:Boolean=true) {
			
			point1.x = 0-ligne4;
			point1.y = 0-ligne2;
			
			point2.x = taille+ligne4;
			point2.y = 0-ligne1;
			
			point3.x = 0-ligne3;
			point3.y = taille+ligne2;
			
			point4.x = taille+ligne3;
			point4.y = taille+ligne1;
			
			sommets=Vector.<Number>([point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, point4.x, point4.y]);
			donneesUV = Vector.<Number>([uvPoint1.x, uvPoint1.y, uvPoint2.x, uvPoint2.y, uvPoint3.x, uvPoint3.y, uvPoint4.x, uvPoint4.y]);
			
			this.graphics.clear();
			this.graphics.beginBitmapFill(texture,null,false,smooth);
			this.graphics.drawTriangles(sommets, index, donneesUV);
			
			ligne1 = 0; ligne2 = 0; ligne3 = 0; ligne4 = 0;
		}
		public function remove() {
			texture.dispose();
		}
	}
}