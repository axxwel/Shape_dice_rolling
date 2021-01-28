package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class  ExplicationBonus extends Sprite{
		
		private var conteneur:Sprite = new Sprite();
		
		private var type:int = 0;
		private var timing:int = 0;
		
		private var tauxFC:int=5;
		private var nFormes:int = 0;
		private var forme:Array = [1, 1];
		
		public function ExplicationBonus() {
			
		}
	//INIT==============================================================================================
		public function expInit(typeTemp:int) { 
			type = typeTemp-3;
			
			switch(type) {
				case 0: 
					var mesCombo:ScoreCombo = new ScoreCombo();
					var conteneurMask:Bitmap = new Bitmap(new BitmapData(216, 134, false, 0xffffff));
					mesCombo.name = "combo";
					mesCombo.x = conteneurMask.x = 560 / 2 - mesCombo.width / 2;
					mesCombo.y = conteneurMask.y =325;
					
					conteneur.addChild(mesCombo);
				;break;
				case 1:
					var mesMulti:ScoreMultiBonus = new ScoreMultiBonus();
					var conteneurMask:Bitmap = new Bitmap(new BitmapData(123, 240, false, 0xffffff)); 
					mesMulti.name = "bonus";
					conteneurMask.x = 78;
					conteneurMask.y =144;
					mesMulti.x = 88  ;
					mesMulti.y = 180;
					
					conteneur.addChild(mesMulti);
				;break;
				case 2:
					var mesMulti:ScoreMultiBonus = new ScoreMultiBonus();
					var conteneurMask:Bitmap = new Bitmap(new BitmapData(134, 240, false, 0xffffff)); 
					
					mesMulti.name = "bonus";
					conteneurMask.x = 372;
					conteneurMask.y = 144;
					mesMulti.x = 277;
					mesMulti.y = 180
					
					conteneur.addChild(mesMulti);
				;break;
			}
			conteneurMask.name = "mask";
			addChild(conteneur);
			addChild(conteneurMask);
			conteneur.mask = conteneurMask;
		}
	//START STOP============================================================================================
		public function start() {
			addEventListener(Event.ENTER_FRAME, animate);
		}
		public function stop() {
			timing = 0;
			nFormes = 0;
			forme = [1, 1];
			BitmapData(Bitmap(this.getChildByName("mask")).bitmapData).dispose;
			removeChild(this.getChildByName("mask"));
			while (conteneur.numChildren > 0) { conteneur.removeChildAt(0); }
			removeChild(conteneur);
			removeEventListener(Event.ENTER_FRAME, animate);
		}
		private function animate(e:Event) { 
			animateDice();
		}
	//ANIMER===================================================================
		private function animateDice() {
					switch(type) {
						case 0: 
							if (timing >= 24) {
								if (nFormes <= 28) {
									forme = typeDice(forme[0], forme[1]);
									ScoreCombo(conteneur.getChildByName("combo")).ajouterForme(forme);
									var bt:Array = bonusTemps(nFormes);
									if (bt[0] != 0) {DecorCombo(ScoreCombo(conteneur.getChildByName("combo")).conteneur.getChildByName("decor")).ajouterTemps(bt[0], bt[1]); }
									if (bt[1] == -1) { DecorCombo(ScoreCombo(conteneur.getChildByName("combo")).conteneur.getChildByName("decor")).ajouterVie(); }
									nFormes++;
								}else { nFormes = 1; }
								timing = 0;
							}else { timing++;}
						;break;
						case 1:
							if (timing >= 24) {
								if (nFormes < 6 && ScoreMultiBonus(conteneur.getChildByName("bonus")).suppCouleur == false) {
									nFormes++;
									forme = [1, nFormes];
									ScoreMultiBonus(conteneur.getChildByName("bonus")).ajouterCouleur(forme);
									timing = 0;
								}
								if (nFormes >= 6) {
									timing = 24;
									forme = [1, 1];
									ScoreMultiBonus(conteneur.getChildByName("bonus")).suppCouleur = true;
									ScoreMultiBonus(conteneur.getChildByName("bonus")).viderJaugeCouleur();
									if (ScoreMultiBonus(conteneur.getChildByName("bonus")).suppCouleur == false) { nFormes = 0; timing = 0; }
								}
							}else { timing++;}
						;break;
						case 2:
						if (timing >= 24) {
								if (nFormes < 6 && ScoreMultiBonus(conteneur.getChildByName("bonus")).suppType == false) {
									nFormes++;
									forme = [nFormes, 1];
									ScoreMultiBonus(conteneur.getChildByName("bonus")).ajouterType(forme);
									timing = 0;
								}
								if (nFormes >= 6) {
									timing = 24;
									forme = [1, 1];
									ScoreMultiBonus(conteneur.getChildByName("bonus")).suppType = true;
									ScoreMultiBonus(conteneur.getChildByName("bonus")).suprimerType();
									if (ScoreMultiBonus(conteneur.getChildByName("bonus")).suppType == false) { nFormes = 0; timing = 0; }
								}
							}else { timing++; }
						;break;
					}			
		}
		private function bonusTemps(nombreDice:int):Array { 
			var retour:Array = [0,0];
			if (nombreDice == 7) { retour = [2,1]; }
			if (nombreDice == 14) { retour=[5,2]; }
			if (nombreDice == 21) { retour=[10,3]; }
			if (nombreDice == 28) { retour=[0,-1]; }
			return(retour);
		}
		private function typeDice(oldF:int, oldC:int, force:int = 0 ):Array {
			var retour:Array = new Array();
			
			var F:int = oldF;
			var C:int = oldC;
			
			var formeDice:Boolean = false;
			while (formeDice == false) {
				if (force == 0) {
					F = Math.round(1 + Math.random() * tauxFC);
					C = Math.round(1 + Math.random() * tauxFC);
				}
				else if (force == 1) { F = Math.round(1 + Math.random() * tauxFC); }
				else if (force == 2) { C = Math.round(1 + Math.random() * tauxFC); }
				if ((oldF == F || oldC == C) && (oldF != F || oldC != C)) { 
					formeDice = true;
					retour = [F, C];
				}
			}
			return(retour);
		}
	}
}