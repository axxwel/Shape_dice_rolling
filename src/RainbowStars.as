package {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.filters.BlurFilter;

	public class RainbowStars extends MovieClip{
		public var taille:int=96;
		public var tailleObjet:int=96;
		private var hightSpeed:uint=4;
		private var speed:int=1+Math.round(Math.random()*Math.random()*hightSpeed);
		private var incrementer:int = Math.round(Math.random()*100);
		private var color:Array = [ 0xFF00FF,0x00FFFF,0x00FF00,0xFFFF00,0xFBB03B,0xFF0000];

		public function RainbowStars(tailleTemp:int,tailleObjetTemp:int) {
			taille=tailleTemp*2;
			tailleObjet = tailleObjetTemp;
			
			var color:int = Math.ceil(Math.random() * 24);
			var zero:String = "";
			if (color < 10) { zero = "0"; } else { zero = ""; }
			
			var classStar:Class = getDefinitionByName("Star_"+zero+color) as Class;
			var ClassDataStar:BitmapData = new classStar();
			var maStar:Bitmap=new Bitmap(ClassDataStar);
			maStar.name="Star";
			
			maStar.filters = [ new BlurFilter(speed,speed,speed*4) ];
			addChild(maStar);
			addEventListener(Event.ENTER_FRAME,update); 
			reset();
		}
		private function reset():void {
			this.y =Math.random()*(tailleObjet-tailleObjet/4);
			this.x =Math.random()*tailleObjet;
			
			scaleX = scaleY =0.5+(Math.random()*Math.random()*0.95);
		}
		private function update(e:Event):void {
			speed=0.25+Math.round(Math.random()*Math.random()*hightSpeed);
			this.y -=speed*1.1;
			this.x +=Math.sin(incrementer/10);
			if (y<-taille/8){reset();}
			incrementer++;
		}
		public function remove() {
			BitmapData(Bitmap(this.getChildByName("Star")).bitmapData).dispose();
			removeEventListener(Event.ENTER_FRAME,update); 
		}
	}
}