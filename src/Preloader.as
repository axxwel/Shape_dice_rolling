package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author BMS_aXXwel
	 */
	public class Preloader extends MovieClip {
		
		[Embed(source="Libs/FondIntro.png")]
		var FondIntro:Class;
		private var monFondIntro:Bitmap = new FondIntro();
		
		[Embed(source = "Libs/LoaderBar.png")]
		var LoaderBar:Class;
		private var maLoaderBar:Bitmap = new LoaderBar();
		
		private var chargement:Boolean = false;
		
		[SWF(width = '960', height = '640', backgroundColor = '0xffffff', frameRate = '40')]
		public function Preloader() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event = null){
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener(Event.ENTER_FRAME, progress);
			monFondIntro.x = - 8;
			monFondIntro.y= - 8;
			addChild(monFondIntro);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgres);
			loaderInfo.addEventListener(Event.COMPLETE,complet);
		}
		private function progress(e:Event) {
			if (currentFrame == totalFrames&&chargement==true) {
				removeEventListener(Event.ENTER_FRAME, progress);
				startUP();
			}
		}
		private function startUP() {
			stop();
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
			removeChild(monFondIntro); monFondIntro = null;
			removeChild(maLoaderBar); maLoaderBar = null;
		}
		private function onProgres(pEvt:ProgressEvent) {
			maLoaderBar.x = 352;
			maLoaderBar.y = 448;
			maLoaderBar.height = 4;
			addChild(maLoaderBar);
   			var charge:Number = pEvt.bytesLoaded / pEvt.bytesTotal;
			maLoaderBar.scaleX = charge;
		}
		protected function complet(pEvt:Event) {
			chargement = true;			
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgres);
			loaderInfo.removeEventListener(Event.COMPLETE,complet);
		}
	}
	
}