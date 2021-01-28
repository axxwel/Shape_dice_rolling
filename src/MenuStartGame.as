package 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	public class MenuStartGame extends MovieClip{
		
		private var conteneurVie:Sprite = new Sprite();
		private var conteneurNV:Sprite = new Sprite();
		
		private var monLangage:Langage = new Langage();
		public var langue:String = "en_US"; 
		
		var  imageVie:Bitmap = new Bitmap(new DiceLife);
		
		private var monNbrVie:TexteScore = new TexteScore("0", 70, 0x1e7fcb, true, true, true, 0xf7ff3c);
		
		private var signeX:TextField = new TextField();
		private var signeXFormat:TextFormat = new TextFormat("Arial", 60, 0x1e7fcb, true);
		
		private var textNV:TextField = new TextField();
		private var textNVFormat:TextFormat = new TextFormat("Cooper Std black", 12, 0x1e7fcb, true);
		
		private var textFV:TextField = new TextField();
		private var textFVFormat:TextFormat = new TextFormat("Cooper Std black", 12, 0x1e7fcb, true);
		
		private var textTemps:TextField = new TextField();
		private var textTempsFormat:TextFormat = new TextFormat("Cooper Std black", 32, 0xf7ff3c, true,null,null,null,null,"center");
		private var monGlowTemps:GlowFilter=new GlowFilter(0xf400a1,1,5,5,10);
		
		private var monFondStart:FondStart = new FondStart();
		
		private var monBoutonStart:Bouton = new Bouton("Vert");
		private var monBoutonBuyVie:Bouton = new Bouton("Vert");
		private var monBoutonFB:Bouton = new Bouton("Bleu");
		private var monBoutonBuy:Bouton = new Bouton("Jaune");
		
		private var monGlow:GlowFilter=new GlowFilter(0xf7ff3c,1,5,5,10);
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		public var prixVie:int = 12;
		public var viePlus:Boolean = false;
		public var startGame:Boolean = false;
		public var vieBuy:Boolean = false;
		public var vieAsk:Boolean = false;
		public var coinBuy:Boolean = false;
		
		
		private var nbrVie:int = 0;
		private var dateTime:Date = new Date();
		private var secondeReste:int = 0;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var CooperFont:Class;
		
		public function MenuStartGame() {			
			
		}
		public function init(vieTabTemp:Object) {
			dateTime = vieTabTemp.dateTime;
			nbrVie = vieTabTemp.nbrVie;
			prixVie = vieTabTemp.prixVie;
			initMenu();
			
			viePlus = false;
			startGame = false;
			vieAsk = false;
			coinBuy = false;
			
			addEventListener(Event.ENTER_FRAME,run);
		}
		private function initMenu() {
			monLangage.setLangage(langue);
			
			if (nbrVie >= 7) {
				monFondStart.gotoAndStop(2);
				initBtnStart();
			}
			if (nbrVie < 7 ) {
				if (nbrVie <= 0) {
					initNoVie();
					initBtnBuyVie();
				}else {
					initBtnStart();
				}
				monFondStart.gotoAndStop(1);
				initNextVie();
			}	
			
			initVie();
			
			addChildAt(monFondStart,0);
		}
		public function remove() {
			while (this.numChildren > 0) { removeChildAt(0); }
			while (conteneurVie.numChildren > 0) { conteneurVie.removeChildAt(0); }
			while (conteneurNV.numChildren > 0) { conteneurNV.removeChildAt(0);}
		}
		private function run(e:Event) {
			if (nbrVie < 7 ) { animerTemps(); }
			if (monBoutonStart.boutonClick == true) { startGame = true; monBoutonStart.boutonClick = false; }
			if (monBoutonBuyVie.boutonClick == true) { vieBuy = true; monBoutonBuyVie.boutonClick = false; }
			if (monBoutonFB.boutonClick == true) { vieAsk = true; monBoutonFB.boutonClick = false; }
			if (monBoutonBuy.boutonClick == true) { coinBuy = true; monBoutonBuy.boutonClick = false; }
			
			if (viePlus == true || startGame == true || vieAsk == true || coinBuy == true ) { removeEventListener(Event.ENTER_FRAME, run); }
		}
		
		private function initBtnStart() {
			monBoutonStart.texte = monLangage.btnYes;
			monBoutonStart.scaleX = 0.5;
			monBoutonStart.scaleY = 0.5;
			monBoutonStart.x = 280-monBoutonStart.width/2;
			monBoutonStart.y = 240;
			addChild(monBoutonStart);
		}
		private function initBtnBuyVie() {
			monBoutonBuyVie.texte = monLangage.btnBuy +" " + prixVie+"§";
			monBoutonBuyVie.scaleX = 0.5;
			monBoutonBuyVie.scaleY = 0.5;
			monBoutonBuyVie.x = 280-monBoutonBuyVie.width/2;
			monBoutonBuyVie.y = 260;
			addChild(monBoutonBuyVie);
		}
//INIT VIE======================================================================================================
		private function initVie() {
			imageVie.scaleX = imageVie.scaleY = 1.4;
			imageVie.smoothing = true;
			imageVie.y = 10;
			imageVie.filters = [monGlow,monOmbre];
			
			signeX.text = "x";
			signeX.setTextFormat(signeXFormat);
			signeX.x = 95;
			signeX.y = 15;
			signeX.filters = [monGlow,monOmbre];
			
			monNbrVie.x = 140;
			monNbrVie.newTexte("" + nbrVie);
			
			
			conteneurVie.addChild(imageVie);
			conteneurVie.addChild(signeX);
			conteneurVie.addChild(monNbrVie);
			
			conteneurVie.x = 560 / 2 - conteneurVie.width/2;
			conteneurVie.y = 130;
			
			addChild(conteneurVie);
		}
//NO VIE============================================================================================
		private function initNoVie() {
			
			textFVFormat.font="Cooper Std black";
			textFVFormat.align="center";
			textFVFormat.bold=true;
			textFVFormat.color = 0xf400a1;
			textFVFormat.size = 12;
			textFV.embedFonts = true;
			textFV.text = monLangage.endLife;
			textFV.y = 226;
			textFV.x = 144;
			textFV.width = 272;
			textFV.height = 20;
			var texteHeight:int=34;
			var tailleTexte:int = 12;
			while (textFV.height < texteHeight) {
				tailleTexte++;
				textFVFormat.size = tailleTexte;
				textFV.autoSize = TextFieldAutoSize.CENTER;
				textFV.wordWrap = true;
				textFV.setTextFormat(textFVFormat);
			}
			addChild(textFV)
		}
//NEXT VIE==========================================================================================
		private function initNextVie() {			
			textNVFormat.font="Cooper Std black";
			textNVFormat.align="center";
			textNVFormat.bold=true;
			textNVFormat.color = 0x1e7fcb;
			textNVFormat.size = 12;
			textNV.embedFonts = true;
			textNV.text=monLangage.newLife;
			textNV.width = 272;
			textNV.height = 20;
			var texteHeight:int=30;
			var tailleTexte:int = 12;
			while (textNV.height < texteHeight) {
				tailleTexte++;
				textNVFormat.size = tailleTexte;
				textNV.autoSize = TextFieldAutoSize.CENTER;
				textNV.wordWrap = true;
				textNV.setTextFormat(textNVFormat);
			}
			
			var  monCadreTemps:Bitmap = new Bitmap(new CadreTempsVie);
			monCadreTemps.x = textNV.width / 2 - monCadreTemps.width / 2;
			monCadreTemps.y = 32;
			
			textTemps.embedFonts = true;
			textTemps.text = "0:00";
			textTemps.x =monCadreTemps.x;
			textTemps.y = 40;
			textTemps.width = monCadreTemps.width;
			textTemps.setTextFormat(textTempsFormat);
			textTemps.filters = [monGlowTemps, monOmbre];
			
			monBoutonFB.texte = monLangage.btnAsk;
			monBoutonFB.scaleX = 0.5;
			monBoutonFB.scaleY = 0.5;
			monBoutonFB.x = monCadreTemps.width / 2;
			monBoutonFB.y = 105;
			
			monBoutonBuy.texte = monLangage.btnBank;
			monBoutonBuy.scaleX = 0.5;
			monBoutonBuy.scaleY = 0.5;
			monBoutonBuy.x = monCadreTemps.width / 2;
			monBoutonBuy.y = 160;
			
			conteneurNV.addChild(textNV);
			conteneurNV.addChild(monCadreTemps);
			conteneurNV.addChild(textTemps);
			conteneurNV.addChild(monBoutonFB);
			conteneurNV.addChild(monBoutonBuy);
			
			conteneurNV.x = 560 / 2 - conteneurNV.width/2;
			conteneurNV.y = 320;
			
			addChild(conteneurNV);
		}
//ANIMER TEMPS-----------------------------------------------------------------------
		private function animerTemps() {
			var nowDate:Date = new Date();
			var newVieDate:Date = dateTime;
			var tUTC:int = newVieDate.valueOf() - nowDate.valueOf();
			
			
			if (tUTC > 0) {
				var minute:int = tUTC / 60000;
				var seconde:int = (tUTC / 1000) - (minute * 60);
				var zero:String = "";
			}
			if (minute <= 0 && seconde <= 0) { viePlus = true; }
			if (seconde < 10) { zero = "0";}
			textTemps.text = minute + ":"+zero+seconde;
			textTemps.setTextFormat(textTempsFormat);
			textTemps.filters = [monGlowTemps, monOmbre];
		}
	}
}