package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	import flash.events.MouseEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class  LivesStore extends Sprite {
		
		private var monLangage:Langage = new Langage();
		public var langue:String = "en_US";
		
		private var conteneur:Sprite = new Sprite();
		private var conteneurPrix:Sprite = new Sprite();
		
		private var monFondMenu:FondMenu = new FondMenu();
		
		private var monFondConfirm:FondStart = new FondStart();
		private var monBoutonConfirm:Bouton = new Bouton("Vert");
		private var monTextConfirm:TextField = new TextField();
		private var monFormatConfirm:TextFormat = new TextFormat("Cooper Std black", 20, 0x1e7fcb, true, false, false, null, null, "center");
		private var nbrCoinConfirm:int = 0;
		
		private var monBoutonFermer:Bouton=new Bouton("Fermer");
		private var titre:TexteScore = new TexteScore("", 40, 0xf7ff3c, true, true, true, 0x1e7fcb);
		
		private var dCoinTab:Array = [10, 20, 50, 100, 200, 500, 1000];
		
		private var diceCoinObj:Object = new Object();
		private var monaieTab:Object = {
			"EUR":"€",
			"USD":"$",
			"CAD":"$",
			"GBP":"£",
			"SEK":"kr",
			"MXN":"$",
			"BRL":"R$"
		};
		private var prixPays:Array = new Array();
		
		public var nbrDiceCoin:int = 0;
		public var factureDCoin:Object = new Object();
		public var achatDiceCoin:Boolean = false;
		
		private var monOmbre:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 0.5);
		private var monGlow:GlowFilter=new GlowFilter(0xf7ff3c,1,5,5,10);
		
		private var hauteur:int=640;
		private var largeur:int = 960;
		
		public var fermer:Boolean = false;
		private var finStore:Boolean = false;
		public var removeFini:Boolean = false;
		
		public var sonMenuIn:Boolean = false;
		public var sonMenuOut:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontCooper:Class;
		
		public function LivesStore() {
			
		}
		public function init(dCoinObjTemp:Object) {
			monLangage.setLangage(langue);
			diceCoinObj = dCoinObjTemp;
			
			monBoutonFermer.scaleX=0.3;
			monBoutonFermer.scaleY=0.3;
			monBoutonFermer.x=508;
			monBoutonFermer.y = 84;
			
			titre.x = 24;
			titre.y = 120;
			
			titre.newTexte(monLangage.bank);
			
			conteneur.addChild(monFondMenu);
			conteneur.addChild(monBoutonFermer);
			for (var b:int = 0; b < 7; b++) {
				creationBouton(b);
			}
			conteneur.addChild(conteneurPrix);
			conteneur.addChild(titre);
			addMenu();
		}
		private function addMenu() {
			conteneur.x = largeur / 2 - conteneur.width / 2;
			addChild(conteneur);
			TweenLite.from(conteneur, 0.3, { y:-560} );
			TweenLite.to(conteneur, 0.8, { y:40, ease:Elastic.easeOut, easeParams:[0.8, 0.6], onComplete:startSell } );
			sonMenuIn = true;
		}
		private function startSell() {
			addEventListener(Event.ENTER_FRAME, run);
		}
		private function run(e:Event) {
			if (monBoutonFermer.boutonClick == true) {
				fermer = true;
				monBoutonFermer.boutonClick = false;
			}
			if(monBoutonConfirm.boutonClick==true){
				fermer = true;
				monBoutonConfirm.boutonClick = false;
			}
			for (var b:int = 0; b < conteneurPrix.numChildren;b++ ) {
				var btn:Object = Object(Sprite(conteneurPrix.getChildAt(b)).getChildByName("boutonAchat"));
				if (btn.boutonClick == true) {
					factureDCoin = creerFacture(dCoinTab[b]);
					achatDiceCoin = true;
					btn.boutonClick = false;
				}
			}
		}
		private function creationBouton(numero:int) {
			var conteneurBouton:Sprite = new Sprite();
		//fond---------------------------------------------------------------------------
			var fond:Bitmap = new Bitmap(new BitmapData(448, 48, false, 0xffffff));
			fond.alpha = 0.4;
			conteneurBouton.addChild(fond);
		//bouton-------------------------------------------------------------------------
			var boutonAchat:Bouton = new Bouton("Vert");
			boutonAchat.name = "boutonAchat";
			boutonAchat.x = 352;
			boutonAchat.y = 8;
			boutonAchat.scaleX = boutonAchat.scaleY = 0.3;
			boutonAchat.texte = monLangage.btnBuy;
			conteneurBouton.addChild(boutonAchat);
		//images-------------------------------------------------------------------------
			for (var nv:int = 0; nv < numero + 1; nv++) {
				var  monDiceCoin:DiceCoin = new DiceCoin();
				if (nv < 3) { monDiceCoin.x = 24 * nv+8; monDiceCoin.y = 0;  } 
				else { monDiceCoin.x = 24 * (nv-3)+8; monDiceCoin.y = 16;}
				monDiceCoin.scaleX = monDiceCoin.scaleY = 0.5;
				conteneurBouton.addChild(monDiceCoin);
			}
		//texte--------------------------------------------------------------------------
			var monNbrDCoin:TexteScore = new TexteScore("0", 32, 0x1e7fcb, true, true, true, 0xf7ff3c);
			var t:String = (dCoinTab[numero]).toString() + " " + "§";
			monNbrDCoin.newTexte(t);
			monNbrDCoin.x = 16;
			conteneurBouton.addChild(monNbrDCoin);
		//prix---------------------------------------------------------------------------
			var monPrix:TextField = new TextField();
			var monPrixFormat:TextFormat = new TextFormat("Arial", 20, 0xa4bbd1);
			monPrix.text = traiterPrix(numero);
			monPrixFormat.align = "right";
			monPrix.x = 240;
			monPrix.y = 12;
			monPrix.setTextFormat(monPrixFormat);
			conteneurBouton.addChild(monPrix);
			
		//-------------------------------------------------------------------------------
			conteneurBouton.x = 56;
			conteneurBouton.y = 168+52*numero;
			conteneurPrix.addChild(conteneurBouton);
		}
//GESTION FACTURE=============================================================================================
		private function traiterPrix(n:int):String { 
			var retour:String = "";
			var monnaie:String = "";
			var prix:Number = diceCoinObj.price * dCoinTab[n];
			monnaie = monaieTab[diceCoinObj.currency];
			if (monnaie == undefined) { monnaie = String(diceCoinObj.currency); }
			retour = prix.toFixed(2)+" "+monnaie;
			return(retour);
		}
		private function creerFacture(nbrCoinTemp:int):Object {
			var retour:Object = new Object();
			var dNow:Date = new Date();
			var dNowString:String=dNow.fullYear + "-" + (dNow.month+1) + "-" + dNow.date+" " + dNow.hours + ":" + dNow.minutes + ":" + dNow.seconds;
			
			retour.date = dNowString;
			retour.monnaie = diceCoinObj.currency;
			retour.montant = nbrCoinTemp * diceCoinObj.price;
			retour.nbrCoin = nbrCoinTemp;
			
			return(retour);
		}
//CONFIRMATION PAYMENT===========================================================================================
		public function achatDiceCoinConfirm(ncTemp:int) {
			nbrCoinConfirm = ncTemp;
			removeMenuStore();
			addEventListener(Event.ENTER_FRAME, runConfirm);
		}
		private function runConfirm(e:Event) {
			if (conteneur.numChildren <= 0) {
				createMenuConfirm();
				removeEventListener(Event.ENTER_FRAME, runConfirm);
			}
		}
		private function createMenuConfirm() {
			monFondConfirm.gotoAndStop(2);
			
			monTextConfirm.embedFonts = true;
			monTextConfirm.text=nbrCoinConfirm+"§ "+monLangage.bought+"!";
			monTextConfirm.x=152;
			monTextConfirm.y = 140;
			monTextConfirm.width = 256;
			monTextConfirm.height = 80;
			var texteHeight:int=100;
			var tailleTexte:int = 12;
			while (monTextConfirm.height < texteHeight) {
				tailleTexte++;
				monFormatConfirm.size = tailleTexte;
				monTextConfirm.autoSize = TextFieldAutoSize.CENTER;
				monTextConfirm.wordWrap = true;
				monTextConfirm.setTextFormat(monFormatConfirm);
			}
			monTextConfirm.filters = [monGlow];
			
			monBoutonConfirm.texte = monLangage.btnOK;
			monBoutonConfirm.scaleX = 0.5;
			monBoutonConfirm.scaleY = 0.5;
			monBoutonConfirm.x = 280-monBoutonConfirm.width/2;
			monBoutonConfirm.y = 240;
			
			conteneur.addChild(monFondConfirm);
			
			conteneur.addChild(monBoutonConfirm);
			conteneur.addChild(monTextConfirm);
			
			addMenu();
		}
//REMOVE==========================================================================================================
		public function removeMenu() {
			finStore = true;
			removeMenuStore();
		}
		private function removeMenuStore() {
			sonMenuOut = true;
			TweenLite.from(conteneur, 0.3, {y:40} );
			TweenLite.to(conteneur, 0.8, { y: -560, ease:Elastic.easeIn, easeParams:[0.7, 0.6], onComplete:stopSell } );
		}
		private function stopSell() {
			while (conteneur.numChildren > 0) { conteneur.removeChildAt(0); }
			if (finStore == true) { 
				removeChild(conteneur);
				removeFini = true;
				finStore = false;
			}
		}
//PORTRAIT PAYSAGE================================================================================================
		public function portraitPaysage() {
			this.rotation=-90;
			this.y = 960;
			
			hauteur=640;
			largeur=960;
		}
	}
}