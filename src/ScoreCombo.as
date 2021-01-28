package{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	
	public class ScoreCombo extends MovieClip{
		
		public var conteneur:Sprite=new Sprite();
		
		private var decor:DecorScore=new DecorScore();
		public var decorUP:DecorCombo = new DecorCombo();
		
		public var monCoinText:TexteScore = new TexteScore("", 30, 0xfff100, true, false, true, 0x1e7fcb);
		public var monBoutonSon:Bouton = new Bouton("Son");
		
		private var conteneurFormes:Sprite=new Sprite(); 
		
		public var suppFormes:Boolean=false;
		private var suppFormeTimer:int=0;
		
		public var scoreCount:Boolean = false;
		
		private var ligneSupp:Boolean = false;
		private var nFormePlus:int = 0;
		
		private var nForme:int = 0;
		
		public function ScoreCombo(only:Boolean=false){
			decor.gotoAndStop(1);
			
			conteneur.addChild(decor);
			
			conteneurFormes.x=16;
			conteneurFormes.y=16;
			
			conteneur.addChild(conteneurFormes);
			
			decorUP.name="decor";
			conteneur.addChild(decorUP);
			
			
			monCoinText.newTexte("0§");
			monCoinText.x = 123-monCoinText.width;
			monCoinText.y = 154;
			conteneur.addChild(monCoinText);
			
			monBoutonSon.x = 148;
			monBoutonSon.y = 144;
			monBoutonSon.scaleX=0.5;
			monBoutonSon.scaleY = 0.5;
			monBoutonSon.name = "btnSon";
			conteneur.addChild(monBoutonSon);
			
			addChild(conteneur);
		}
		public function ajouterForme(diceTemp:Array) {
			var typeForme:int=diceTemp[0];
			var couleurForme:int=diceTemp[1];
			var maForme:FormeScoreImage=new FormeScoreImage();
			
			var ligne:int= nForme/7;
			var colone:int= nForme-ligne*7;
			
			var monGlow:GlowFilter=new GlowFilter(0xF400A1);
			
			var monOmbre:DropShadowFilter=new DropShadowFilter();
			maForme.filters=[monOmbre,monGlow];
			
			maForme.x=22*colone;
			maForme.y=22*ligne;
			
			maForme.scaleX=0.75;
			maForme.scaleY=0.75;
			maForme.gotoAndStop(typeForme+(couleurForme-1)*6);
			conteneurFormes.addChild(maForme);
			nForme++;
			if (ligneSupp == true) { nFormePlus++;}
			if (conteneurFormes.numChildren >= 28 && ligneSupp == false) {
				addEventListener(Event.ENTER_FRAME, suprimerLigne);
				ligneSupp = true;
				nForme = 0;
			}
		}
		public function suprimerForme(){
			if(conteneurFormes.numChildren>0){
				var forme:Object=FormeScoreImage(conteneurFormes.getChildAt(conteneurFormes.numChildren-1));
				var vitesse:int=16;
				if(suppFormeTimer>-forme.height/2){
					forme.y-=vitesse;
					forme.alpha-=1/((forme.height/2)/vitesse);
					suppFormeTimer-=vitesse;
				}else{
					decorUP.suprimerTemps(conteneurFormes.numChildren);
					conteneurFormes.removeChildAt(conteneurFormes.numChildren-1);suppFormeTimer=0;
				}
			}
			if (conteneurFormes.numChildren <= 0) { nForme = 0; suppFormes = false; scoreCount = false; }
		}
		private function suprimerLigne(e:Event) {
			if(conteneurFormes.numChildren>nFormePlus){
				var forme:Object=FormeScoreImage(conteneurFormes.getChildAt(0));
				var vitesse:int=16;
				if(suppFormeTimer>-forme.height/2){
					forme.y-=vitesse;
					forme.alpha-=1/((forme.height/2)/vitesse);
					suppFormeTimer-=vitesse;
				}else{
					decorUP.suprimerTemps(conteneurFormes.numChildren);
					conteneurFormes.removeChildAt(0);suppFormeTimer=0;
				}
			}
			if (conteneurFormes.numChildren <= nFormePlus) {
				ligneSupp = false;
				nFormePlus = 0;
				removeEventListener(Event.ENTER_FRAME, suprimerLigne);
			}
		}
		public function afficherCoin(nCoin:int) {
			monCoinText.newTexte(nCoin.toString() + "§");
			monCoinText.x = 123-monCoinText.width;
		}
	}
}