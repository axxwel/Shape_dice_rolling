package{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class Annonce extends Sprite{
		
		public var monMenuStart:MenuStartGame = new MenuStartGame();
		public var langue:String = "en_US"; 
		
		private var time_depart:Number = 0.17;
		
		public var finAnnonce_depart:Boolean = false;
		public var departGame:Boolean = false;
		public var viePlus:Boolean = false;
		
		private var nAnnDep:int = 0;
		
		private var gameStart:Boolean = false;
		private var vieBuy:Boolean = false;
		private var vieAsk:Boolean = false;
		private var coinBuy:Boolean = false;
		public var acheterVie:Boolean = false;
		public var demanderVie:Boolean = false;
		public var acheterCoin:Boolean = false;
		
		public var finAnnonce_bonus:Boolean=false;
		
		private var hauteur:int=640;
		private var largeur:int = 960;
		
		public var sonMenuIn:Boolean = false;
		public var sonMenuOut:Boolean = false;
		public var bipDepart:Boolean = false;
		public var bipDepart_nbr:int = 0;
		public var sonRoll:Boolean = false;
		public var sonRolling:Boolean = false;
		
		public function Annonce(){
			
		}
//ANNONCE DEPART====================================================================================================================
		public function annonceDepart(vieTab:Object) {
			if (this.numChildren <= 0) {
				finAnnonce_depart = false;
				monMenuStart.langue = langue;
				monMenuStart.init(vieTab);
				addMenuStart();
			}
		}
		private function addMenuStart() {
			monMenuStart.x = largeur / 2 - monMenuStart.height / 2;
			addChild(monMenuStart);
			TweenLite.from(monMenuStart, 0.3, { y:-200} );
			TweenLite.to(monMenuStart, 0.8, { y:40, ease:Elastic.easeOut, easeParams:[0.8, 0.6], onComplete:runMS } );
			sonMenuIn = true;
			function runMS() { 
				addEventListener(Event.ENTER_FRAME, runMenuStart);
			}
		}
		private function runMenuStart(e:Event) { 
			if (monMenuStart.viePlus == true) {
				changeMenuStart();
				removeEventListener(Event.ENTER_FRAME, runMenuStart);
			}
			if (monMenuStart.startGame == true) {
				removeMenuStart();
				gameStart = true;
				monMenuStart.startGame = false;
				removeEventListener(Event.ENTER_FRAME, runMenuStart);
			}
			if (monMenuStart.vieBuy == true) {
				removeMenuStart();
				vieBuy = true;
				monMenuStart.vieBuy = false;
				removeEventListener(Event.ENTER_FRAME, runMenuStart);
			}
			if (monMenuStart.vieAsk == true) {
				removeMenuStart();
				vieAsk = true;
				monMenuStart.vieAsk = false;
				removeEventListener(Event.ENTER_FRAME, runMenuStart);
			}
			if (monMenuStart.coinBuy == true) {
				removeMenuStart();
				coinBuy = true;
				monMenuStart.coinBuy = false;
				removeEventListener(Event.ENTER_FRAME, runMenuStart);
			}
		}
		private function changeMenuStart() {
			TweenLite.from(monMenuStart, 0.3, { y:40} );
			TweenLite.to(monMenuStart, 0.8, { y: -300, ease:Elastic.easeIn, easeParams:[0.7, 0.6], onComplete:changeMS } );
			function changeMS() {
				sonMenuOut = true;
				viePlus = true;
				monMenuStart.viePlus = false;
				monMenuStart.remove();
				removeChild(monMenuStart);
			}
		}
		private function removeMenuStart() {
			TweenLite.from(monMenuStart, 0.3, { y:40} );
			TweenLite.to(monMenuStart, 0.8, { y: -300, ease:Elastic.easeIn, easeParams:[0.7, 0.6], onComplete:removeMS } );
			function removeMS() {
				if (gameStart == true) { departGame = true; gameStart = false;}
				if (vieBuy == true) { acheterVie = true; vieBuy = false; }
				if (vieAsk == true) { demanderVie = true; vieAsk = false; }
				if (coinBuy == true) { acheterCoin = true; coinBuy = false; }
				sonMenuOut = true;
				monMenuStart.remove();
				removeChild(monMenuStart);
			}
		}
		public function addAnimation_depart() {
			var classAnnDepart:Class = getDefinitionByName("AnnonceDemarage_1") as Class;
			var ClassDataAnnDepart:BitmapData = new classAnnDepart();
			var monAnnonceStart:Bitmap = new Bitmap(ClassDataAnnDepart);
			monAnnonceStart.name = "AnnonceDemarage";
			nAnnDep = 1;
			
			monAnnonceStart.y = hauteur / 2 - monAnnonceStart.height / 2;
			monAnnonceStart.x = -monAnnonceStart.width / 2;
			addChild(monAnnonceStart);
			startAnimation_depart();
		}
		private function startAnimation_depart() {
			var monAnnonceStart:Bitmap = Bitmap(this.getChildByName("AnnonceDemarage"));
			TweenLite.from(monAnnonceStart, 0.2, { x:largeur } );
			TweenLite.to(monAnnonceStart, time_depart, { x:largeur / 2 - monAnnonceStart.width / 2, ease:Back.easeOut, onComplete:finTweenOut_depart } );
			bipDepart = true;
			bipDepart_nbr += 1;
		}
		private function finTweenOut_depart() {
			var monAnnonceStart:Bitmap = Bitmap(this.getChildByName("AnnonceDemarage"));
			TweenLite.from(monAnnonceStart, time_depart, { x:largeur / 2 -monAnnonceStart.width / 2 } );
			TweenLite.to(monAnnonceStart, time_depart, { x:0, ease:Back.easeIn,onComplete:changerImage_depart} );
		}
		private function changerImage_depart() {
			if (this.getChildByName("AnnonceDemarage") is DisplayObject) {
				BitmapData(Bitmap(this.getChildByName("AnnonceDemarage")).bitmapData).dispose;
				removeChild(this.getChildByName("AnnonceDemarage"));
				time_depart+=0.05;
				nAnnDep++;
			}
			if (nAnnDep <= 4) {
				var classAnnDepart:Class = getDefinitionByName("AnnonceDemarage_"+nAnnDep) as Class;
				var ClassDataAnnDepart:BitmapData = new classAnnDepart();
				var monAnnonceStart:Bitmap=new Bitmap(ClassDataAnnDepart);
				monAnnonceStart.name = "AnnonceDemarage";
				
				monAnnonceStart.y = hauteur / 2 - monAnnonceStart.height / 2;
				monAnnonceStart.x = -monAnnonceStart.width / 2;
				addChild(monAnnonceStart);
				startAnimation_depart();
			}else {
				time_depart=0.1;
				finAnnonce_depart=true;
			}
		}
//ANNONCE BONUS==========================================================================================================================
		public function annonceBonus(imageBonus:int) {
			if (this.numChildren <= 0) {
				var monAnnonceBonusSprite:Sprite = new Sprite();
				monAnnonceBonusSprite.name = "AnnonceBonusSprite";
				var classAnnBonus:Class = getDefinitionByName("AnnonceBonus_"+imageBonus) as Class;
				var ClassDataAnnBonus:BitmapData = new classAnnBonus();
				var monAnnonceBonus:Bitmap = new Bitmap(ClassDataAnnBonus);
				monAnnonceBonus.name = "AnnonceBonus";
				
				finAnnonce_bonus=false;
				monAnnonceBonus.x = - monAnnonceBonus.width/2;
				monAnnonceBonus.y = - monAnnonceBonus.height / 2;
				monAnnonceBonusSprite.x = largeur / 2;
				monAnnonceBonusSprite.y = hauteur / 2;
				monAnnonceBonusSprite.addChild(monAnnonceBonus);
				addChild(monAnnonceBonusSprite);
				
				tweenIn_bonus();
				switch(imageBonus) {
					case 1: sonRoll = true; break;
					case 2: sonRolling = true; break;
					default: ; break;
				}
			}
		}
		private function tweenIn_bonus() {
			var monAnnonceBonus:Sprite = Sprite(this.getChildByName("AnnonceBonusSprite"));
			TweenLite.from(monAnnonceBonus, 0.5, { scaleX:0,scaleY:0 } );
			TweenLite.to(monAnnonceBonus, 0.5, { scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:tweenOut_bonus } );
		}
		private function tweenOut_bonus() {
			var monAnnonceBonus:Sprite = Sprite(this.getChildByName("AnnonceBonusSprite"));
			TweenLite.from(monAnnonceBonus, 0.5, { scaleX:1,scaleY:1 } );
			TweenLite.to(monAnnonceBonus, 0.5, { scaleX:0, scaleY:0, ease:Elastic.easeIn, onComplete:suprimerAnnonce } );
		}
		private function suprimerAnnonce() {
			if (this.getChildByName("AnnonceBonusSprite") is DisplayObject) {
				var monAnnonceBonus:Sprite = Sprite(this.getChildByName("AnnonceBonusSprite"));
				if (monAnnonceBonus.getChildByName("AnnonceBonus") is DisplayObject) {
					BitmapData(Bitmap(monAnnonceBonus.getChildByName("AnnonceBonus")).bitmapData).dispose;
					monAnnonceBonus.removeChild(monAnnonceBonus.getChildByName("AnnonceBonus"));
				}
				removeChild(monAnnonceBonus);
				monAnnonceBonus = null;
			}
			finAnnonce_bonus = true;
		}
		public function portraitPaysage() {
			this.rotation=-90;
			this.y = 960;
			
			hauteur=640;
			largeur=960;
		}
	}
}