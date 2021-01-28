package{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import flash.media.Sound;
	
	public class Explication extends Sprite{
		
		public var conteneur:Sprite=new Sprite();
		
		public var langue:String = "en_US"; 
		private var monLangage:Langage = new Langage();
		
		private var monBoutonFermer:Bouton = new Bouton("Fermer");
		private var monBoutonNext:Bouton = new Bouton("Vert");
		private var monBoutonPrevious:Bouton = new Bouton("Vert");
		private var monBoutonTermine:Bouton = new Bouton("Vert");
		
		private var monFondMenu:FondMenu = new FondMenu();
		private var monExpDice:ExplicationDice = new ExplicationDice();
		private var monExpBonus:ExplicationBonus = new ExplicationBonus();
		
		private var monTexteExp:TextField=new TextField();
		private var miseEnFormeTexteExp:TextFormat = new TextFormat();
		private var tailleText:Array = [[376, 170, 88, 152],
										[376, 170, 88, 152],
										[376, 100, 88, 152],
										[376, 160, 88, 152],
										[294, 250, 190, 152],
										[294, 230, 88, 152]];
		private var explicationFin:Boolean = false;
		
		private var numeroExp:int = 0;
		
		private var monOmbre:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 0.5);
		
		public var finMenu:Boolean = false;
		
		private var hauteur:int=640;
		private var largeur:int = 960;
		
		public var sonMenuIn:Boolean = false;
		public var sonMenuOut:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function Explication() {
			this.x = 40;
		}
		public function initExp() {
			monLangage.setLangage(langue);
			
			conteneur.addChild(monFondMenu);
			
			monBoutonFermer.scaleY = 0.3;
			monBoutonFermer.scaleX = 0.3;
			monBoutonFermer.x = 508;
			monBoutonFermer.y = 84;
			
			monBoutonNext.texte = monLangage.btnNext;
			monBoutonNext.scaleX=0.5;
			monBoutonNext.scaleY=0.5;
			monBoutonNext.name = "bNext";
			
			monBoutonPrevious.texte = monLangage.btnPrevious;
			monBoutonPrevious.scaleX=0.5;
			monBoutonPrevious.scaleY=0.5;
			monBoutonPrevious.name = "bPrevious";
			
			monBoutonTermine.texte = monLangage.btnEnd;
			monBoutonTermine.scaleX=0.5;
			monBoutonTermine.scaleY=0.5;
			monBoutonTermine.name = "bTermine";
			
			monExpDice.name = "eDice";
			monExpBonus.name = "eBonus";
			
			conteneur.addChild(monBoutonFermer);
			
			changeExp(0);
			addExplication();
		}
		private function addExplication() {
			conteneur.x = largeur / 2 - conteneur.width / 2;
			addChild(conteneur);
			TweenLite.from(conteneur, 0.3, { y:-560} );
			TweenLite.to(conteneur, 0.8, { y:0, ease:Elastic.easeOut, easeParams:[0.8, 0.6], onComplete:startRunExplication } );
			sonMenuIn = true;
		}
		private function startRunExplication() {
			addEventListener(Event.ENTER_FRAME,runExplication);
		}
		private function runExplication(e:Event) {
			if (monBoutonFermer.boutonClick == true || monBoutonTermine.boutonClick == true) {
				removeExplication();
				removeEventListener(Event.ENTER_FRAME, runExplication);
				monBoutonFermer.boutonClick = false;
				monBoutonTermine.boutonClick = false;
			}
			if (monBoutonNext.boutonClick == true) {
				numeroExp += 1;
				changeExp(numeroExp);
				monBoutonNext.boutonClick = false;
			}
			if (monBoutonPrevious.boutonClick == true) {
				numeroExp -= 1;
				changeExp(numeroExp);
				monBoutonPrevious.boutonClick = false;
			}
		}
		private function changeExp(nExpTemp:int, nExpTotal:int = 5) {
			
			if (conteneur.getChildByName("eDice") is DisplayObject) { monExpDice.stop(); conteneur.removeChild(monExpDice); }
			if (conteneur.getChildByName("eBonus") is DisplayObject) { monExpBonus.stop(); conteneur.removeChild(monExpBonus); }
			if (nExpTemp <= 2) { monExpDice.expInit(nExpTemp); conteneur.addChild(monExpDice); }
			if (nExpTemp >= 3) { monExpBonus.expInit(nExpTemp); conteneur.addChild(monExpBonus); }
			
			var textLang:String = "explication_" + nExpTemp;
			changeText(monLangage[textLang], tailleText[nExpTemp][0], tailleText[nExpTemp][1], tailleText[nExpTemp][2], tailleText[nExpTemp][3]);
			
			if (nExpTemp >= 1) {
				monBoutonNext.x = (560 / 3) * 2 - monBoutonNext.width / 2;
				monBoutonNext.y = 480;
				monBoutonPrevious.x=560/3-monBoutonPrevious.width/2;
				monBoutonPrevious.y = 480;
				conteneur.addChild(monBoutonPrevious);
				if (conteneur.getChildByName("bNext") is DisplayObject) { conteneur.removeChild(monBoutonNext);}
				conteneur.addChild(monBoutonNext);
				if (conteneur.getChildByName("bTermine") is DisplayObject) { conteneur.removeChild(monBoutonTermine);}
			}
			if (nExpTemp >= nExpTotal) { 
				monBoutonTermine.x = (560 / 3) * 2 - monBoutonNext.width / 2;
				monBoutonTermine.y = 480;
				conteneur.addChild(monBoutonTermine);
				if (conteneur.getChildByName("bNext") is DisplayObject) { conteneur.removeChild(monBoutonNext);}
			}
			if(nExpTemp<=0){
				monBoutonNext.x = 560 / 2 - monBoutonNext.width / 2;
				monBoutonNext.y = 480;
				conteneur.addChild(monBoutonNext);
				if (conteneur.getChildByName("bPrevious") is DisplayObject) { conteneur.removeChild(monBoutonPrevious); }
				if (conteneur.getChildByName("bTermine") is DisplayObject) { conteneur.removeChild(monBoutonTermine);}
			}
			if (nExpTemp <= 2) { monExpDice.start(); }
			if (nExpTemp >= 3) { monExpBonus.start(); }
		}
		private function changeText(texteTemp:String,textL:int,textH:int,textX:int,textY:int) {
			
			miseEnFormeTexteExp.font="Cooper Std black";
			miseEnFormeTexteExp.align="center";
			miseEnFormeTexteExp.bold=true;
			miseEnFormeTexteExp.color = 0x1e7fcb;
			miseEnFormeTexteExp.size = 12;
			monTexteExp.embedFonts = true;
			monTexteExp.text = texteTemp;
			monTexteExp.x = textX;
			monTexteExp.y = textY;
			monTexteExp.width = textL;
			monTexteExp.height = 50;
			var texteHeight:int = textH;
			var tailleTexte:int = 12;
			while (monTexteExp.height < texteHeight) {
				tailleTexte++;
				miseEnFormeTexteExp.size = tailleTexte;
				monTexteExp.autoSize = TextFieldAutoSize.CENTER;
				monTexteExp.wordWrap = true;
				monTexteExp.setTextFormat(miseEnFormeTexteExp);
			}
			conteneur.addChild(monTexteExp);
		}
		private function removeExplication() {
			TweenLite.from(conteneur, 0.3, {y:0} );
			TweenLite.to(conteneur, 0.8, { y: -560, ease:Elastic.easeIn, easeParams:[0.7, 0.6], onComplete:menuFin } );
			sonMenuOut = true;
		}
		private function menuFin() {
			if (conteneur.getChildByName("eDice") is DisplayObject) { monExpDice.stop(); }
			if (conteneur.getChildByName("eBonus") is DisplayObject) { monExpBonus.stop(); }
			while (conteneur.numChildren > 0) { conteneur.removeChildAt(0);	}
			monTexteExp = null;
			monBoutonFermer = null;
			monBoutonNext = null;
			monBoutonPrevious = null;
			monFondMenu = null;
			monExpBonus = null;
			monExpDice = null;
			
			finMenu = true;
		}
		public function portraitPaysage() {
			this.rotation=-90;
			this.y = 960;
			
			hauteur=640;
			largeur=960;
		}
	}
}