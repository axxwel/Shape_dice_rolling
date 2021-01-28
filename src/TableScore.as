package{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	
	public class TableScore extends Sprite{
		
		public var conteneur:Sprite=new Sprite();
		
		private var decorTimeScore:DecorScore=new DecorScore();
		private var decorTimeScoreUp:DecorScoreUp=new DecorScoreUp();
		private var ombreDecorUp:DropShadowFilter=new DropShadowFilter(10,45,0x000000,0.2);
	//temps===================================================================
		public var conteneurTimeScore:Sprite=new Sprite();
		public var monTimer:GestionTemps = new GestionTemps();
		public var monScore:GestionScore = new GestionScore();
		
		public var mesVies:GestionVie = new GestionVie();
	//formes==================================================================
		private var monScoreCombo:ScoreCombo=new ScoreCombo(); 
		public var monScoreMultiBonus:ScoreMultiBonus=new ScoreMultiBonus();
		private var bonusAjout:int=0;
		
		public var diceSelect:Array=new Array();
		public var diceComboActive:Array=new Array();
		public var diceMegaBonus:Array=new Array();
		public var finCombo:Boolean=false;
		
		public var scoreAffiche:int=0;
		
		public var scoreCount:Boolean=false;
		
		public var ajoutTemps:Boolean=false;
		
		public var tauxChance:int=0;
		
		public var annonceBonus:int=0;
		
		public var initFin:Boolean=false;
//FUNCTION=============================================================================================================================================
		public function TableScore(){
			monTimer.name="timer";
			monScore.name = "score";
			monScoreMultiBonus.name = "multiBonus";
			mesVies.name = "vies";
			conteneurTimeScore.x=424;
			conteneurTimeScore.y=8;
			decorTimeScore.gotoAndStop(3);
			decorTimeScoreUp.gotoAndStop(3);
			conteneurTimeScore.addChild(decorTimeScore);
			conteneurTimeScore.addChild(monScore);
			conteneurTimeScore.addChild(monTimer);
			conteneurTimeScore.addChild(mesVies);
			conteneur.addChild(conteneurTimeScore);
			
			monScoreCombo.x=8;
			monScoreCombo.y = 8;
			monScoreCombo.name = "scoreCombo";
			conteneur.addChild(monScoreCombo);
			
			monScoreMultiBonus.x=216;
			monScoreMultiBonus.y=8;
			conteneur.addChild(monScoreMultiBonus);
			
			decorTimeScoreUp.filters=[ombreDecorUp];
			conteneurTimeScore.addChild(decorTimeScoreUp);
			
			addChild(conteneur);
		}
		public function run(){
			tauxChance=monTimer.tauxChance;
			if (finCombo == true) {
				if(monScoreCombo.suppFormes==false
				 &&monScoreMultiBonus.suppCouleur==false
				 &&monScoreMultiBonus.suppType==false ){finCombo=false;}
			}
			var bonusTemps:MovieClip=MovieClip(monScoreCombo.conteneur.getChildByName("decor"));
			if (bonusTemps.ajoutTemps == true) { monTimer.ajouterTemps(bonusTemps.nAjoutTemps); bonusTemps.ajoutTemps = false;}
			finCount();
		}
		public function init(){
			initFin=false;
			monScore.scoreAffiche=0;
		
			monScore.scoreCombo=0;
			monScore.scoreTotal=0;
		
			monScore.scoreTotalFin=0;
			monScore.comboMaxFin=0;
			monScore.affiche();
			
			var bonusTemps:MovieClip = MovieClip(monScoreCombo.conteneur.getChildByName("decor"));
			bonusTemps.ajoutTemps = false;
			bonusTemps.nAjoutTemps = 0;
			annonceBonus = 0;
			
			initFin=true;
		}
		public function ajouterDice(diceSelectTemp:Array){
			diceSelect=diceSelectTemp;
			diceComboActive.push(diceSelect);
			monScoreCombo.ajouterForme(diceSelect);
			monScoreMultiBonus.ajouterCouleur(diceSelect);
			monScoreMultiBonus.ajouterType(diceSelect); 
			ajouterScoreCombo();
			ajoutTemps=false;
			scoreAffiche = monScore.scoreAffiche;
			bonusTemps();
		}
		public function suprimerDice(){
			finCombo=true;
			if(diceComboActive.length>0){
				donnerAnnonceBonus();
				scoreCount=true;
				startCount();
				monScore.doneResultat();
				bonusAjout=0;
			}
			diceSelect=[];
			diceComboActive=[];
			monScoreCombo.suprimerForme();
			monScoreMultiBonus.viderJaugeCouleur();
			monScoreMultiBonus.suprimerType();
		}
		private function bonusTemps() { 
			var nTable:int=Math.floor(diceComboActive.length/28);
			var nombreDice:int = diceComboActive.length-28*nTable;
			if(ajoutTemps==false){
				if (nombreDice == 7) { ajouterTemps(2); }
				if (nombreDice == 14) { ajouterTemps(5); }
				if (nombreDice == 21) { ajouterTemps(10); }
				if (diceComboActive.length == 28) { ajouterVie(); }
				ajoutTemps=true;
			}
		}
		private function ajouterVie() { 
			MovieClip(monScoreCombo.conteneur.getChildByName("decor")).ajouterVie();
			mesVies.ajouterVie();
		}
		private function ajouterTemps(t:int) {
			var nTable:int=Math.floor(diceComboActive.length/28);
			var nAff:int=Math.ceil(diceComboActive.length/7)-4*nTable;
			MovieClip(monScoreCombo.conteneur.getChildByName("decor")).ajouterTemps(t,nAff);
		}
		private function ajouterScoreCombo(){
			var nDice:int=diceComboActive.length;
			var multi:int=monScoreMultiBonus.couleurUtilise.length;
			var bonus:int=monScoreMultiBonus.typeUtilise.length;
			var bonusTemp:int=0;
			if(bonusAjout<bonus){bonusTemp=bonus;bonusAjout=bonus;}
			monScore.run(nDice,multi,bonusTemp);
		}
		private function startCount(){
			if(scoreCount==true){
				monScore.scoreCount=true;
				monScoreCombo.scoreCount=true;
				monScoreMultiBonus.scoreCountCouleur=true;
				monScoreMultiBonus.scoreCountType=true;
				MovieClip(monScoreMultiBonus.conteneur.getChildByName("decor")).scoreCountDecor=true;
			}
		}
		public function finCount(finTemps:Boolean=false){
			if(scoreCount==true&&
			   monScore.scoreCount==false&&
			   monScoreCombo.scoreCount==false&&
			   monScoreMultiBonus.scoreCountCouleur==false&&
			   monScoreMultiBonus.scoreCountType==false&&
			   MovieClip(monScoreMultiBonus.conteneur.getChildByName("decor")).scoreCountDecor==false){
				scoreCount=false;
			}  
		}
		public function donnerAnnonceBonus(){
			var multi:int=monScoreMultiBonus.couleurUtilise.length;
			var bonus:int=monScoreMultiBonus.typeUtilise.length;
			if(multi+bonus>=7){
				if (multi + bonus >= 9) { annonceBonus = 2; } else { annonceBonus = 1; }
			}
		}
		public function portraitPaysage(){
			conteneurTimeScore.rotation=-90;
			conteneurTimeScore.x=8;
			conteneurTimeScore.y=210;
			
			monScoreCombo.rotation=-90;
			monScoreCombo.x=432;
			monScoreCombo.y=210;
			
			monScoreMultiBonus.rotation=-90;
			monScoreMultiBonus.x=220;
			monScoreMultiBonus.y=210;
		}
	}
}