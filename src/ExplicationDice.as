package 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class  ExplicationDice extends Sprite{
		
		private var conteneur:Sprite = new Sprite();
		private var conteneurImage:Sprite = new Sprite();
		
		private var type:int = 0;
		
		private var tauxFC:int=5;
		
		private var monCurseur:Sprite = new Sprite();
		private var imageSC:Bitmap = new Bitmap(new ImageSourisClick);
		private var imageSUC:Bitmap = new Bitmap(new ImageSourisUnClick);
		
		private var timing:int = 30;
		
		private var listDice:Array = new Array();
		private var listRainbow:Array = new Array();
		private var sequence:int = 0;
		private var crsClick:Boolean = false;
		private var crsMove:Boolean = false;
		private var crsIn:Boolean = false;
		private var sensTemp:int = 0;
		private var diceMem:Object = new Object();
		
		private var diceSuivant:Boolean = true;
		private var Ndice:int = 0;
		private var FCtab:Array = [4, 4];
		
		public function ExplicationDice() {
			
		}
	//INIT==============================================================================================
		public function expInit(typeTemp:int) {
			type = typeTemp;
			
			monCurseur.name = "curseur";
			monCurseur.x = 48;
			monCurseur.y = 48;
			monCurseur.addChild(imageSUC);
			
			switch(type) {
				case 0: 
					listDice = [[0, 2], [1, 2,, "fin"]];
					listRainbow = [[2, 1], [4, 3]];
					var monDice0:Dice = new Dice(96, [1, 1], "Dice0");monDice0.name = "Dice0";
					var monDice1:Dice = new Dice(96, [1, 2], "Dice1");monDice1.name = "Dice1";
					conteneurImage.addChild(monDice0);
					conteneurImage.addChild(monDice1); monDice1.x = 96;
					conteneur.y = 358;
					; break;
				case 1: 
					listDice = [[1, 2, [1, 6]], [2, 2, [1, ], "fin"], [1, 3, [1, 6], "reverse"], [0, 3, [, 6], "fin"]];
					listRainbow = [[1, 2, 1], [1, 4, 3], [1, 2, 1], [4, 3, 1]];
					var monDice0:Dice = new Dice(96, [2, 6], "Dice0");monDice0.name = "Dice0";
					var monDice1:Dice = new Dice(96, [1, 6], "Dice1");monDice1.name = "Dice1";
					var monDice2:Dice = new Dice(96, [1, 2], "Dice2");monDice2.name = "Dice2";
					conteneurImage.addChild(monDice0);
					conteneurImage.addChild(monDice1); monDice1.x = 96;
					conteneurImage.addChild(monDice2); monDice2.x = 192;
					conteneur.y = 358;
					; break;
				case 2:
					listDice = [[0, 2], [1, 2], [2, 2], [3, 4,, "down"], [7, 3,,"reverse"], [6, 3,,"reverse"], [5, 3,,"reverse"], [4, 3,,"fin"]];
					listRainbow = [ [2, 1, 1, 1, 1, 1, 1, 1],
									[4, 3, 1, 1, 1, 1, 1, 1], 
									[4, 7, 3, 1, 1, 1, 1, 1],
									[4, 7, 7, 3, 1, 1, 1, 1],
									[4, 7, 7, 10, 1, 1, 1, 6],
									[4, 7, 7, 10, 1, 1, 4, 12],
									[4, 7, 7, 10, 1, 4, 7, 12],
									[4, 7, 7, 10, 4, 7, 7, 12],
									[1, 1, 1, 1, 1, 1, 1, 1] ];
					var monDice0:Dice = new Dice(96, [2, 6], "Dice0"); monDice0.name = "Dice0";
					var monDice1:Dice = new Dice(96, [1, 6], "Dice1"); monDice1.name = "Dice1";
					var monDice2:Dice = new Dice(96, [1, 2], "Dice2"); monDice2.name = "Dice2";
					var monDice3:Dice = new Dice(96, [4, 2], "Dice3"); monDice3.name = "Dice3";
					var monDice4:Dice = new Dice(96, [2, 6], "Dice4"); monDice4.name = "Dice4";
					var monDice5:Dice = new Dice(96, [1, 6], "Dice5"); monDice5.name = "Dice5";
					var monDice6:Dice = new Dice(96, [1, 2], "Dice6"); monDice6.name = "Dice6";
					var monDice7:Dice = new Dice(96, [4, 2], "Dice7"); monDice7.name = "Dice7";
					conteneurImage.addChild(monDice0);
					conteneurImage.addChild(monDice1); monDice1.x = 96;
					conteneurImage.addChild(monDice2); monDice2.x = 192;
					conteneurImage.addChild(monDice3); monDice3.x = 288;
					conteneurImage.addChild(monDice4); monDice4.y = 96;
					conteneurImage.addChild(monDice5); monDice5.x = 96; monDice5.y = 96;
					conteneurImage.addChild(monDice6); monDice6.x = 192; monDice6.y = 96;
					conteneurImage.addChild(monDice7); monDice7.x = 288; monDice7.y = 96;
					conteneur.y = 262;
					; break;
			}
			conteneur.addChild(conteneurImage);
			conteneur.addChild(monCurseur);
			
			
			conteneur.x = 280 - conteneur.width / 2;
			addChild(conteneur);
		}
	//START STOP============================================================================================
		public function start() {
			addEventListener(Event.ENTER_FRAME, animate);
		}
		public function stop() {
			sequence = 0;
			timing = 30;
			listDice = [];
			listRainbow = [];
			crsClick = crsMove = crsIn = false;
			while (conteneurImage.numChildren > 0) { conteneurImage.removeChildAt(0); }
			conteneur.removeChild(conteneurImage);
			conteneur.removeChild(monCurseur);
			removeEventListener(Event.ENTER_FRAME, animate);
		}
		private function animate(e:Event) { 
			animateDice();
		}
	//ANIMER DICE===================================================================
		private function animateDice() {		
			var vitesse:int = 4;
			var curseurTemp:Sprite = Sprite(conteneur.getChildByName("curseur"));
			var diceTemp:Dice = Dice(conteneurImage.getChildByName("Dice" + listDice[sequence][0]));			
			
			if (curseurTemp.x == diceTemp.x + 48 && curseurTemp.y == diceTemp.y + 48) {
				if (timing <= 0) {
					FCtab = diceTC();
					sensTemp = listDice[sequence][1];
					if (sequence < listDice.length - 1) { sequence++; } else { sequence = 0; }
					if (listDice[sequence][3] == "fin") { timing = 60; } else { timing = 30; }
				}else { 
					if (timing == 20 && listDice[sequence][3] != "fin") {
						curseurTemp.removeChildAt(0);
						curseurTemp.addChild(imageSC);
						gestionRainbow(sequence);
						crsClick = true;
					}
					if (timing == 40 && listDice[sequence][3] == "fin") {
						curseurTemp.removeChildAt(0);
						curseurTemp.addChild(imageSUC);
						crsClick = false;
					}
					timing--;
				}
				crsMove = false;
			}else { crsMove = true; }
			
			if (curseurTemp.x > diceTemp.x + 48) { curseurTemp.x -= vitesse; }
			if (curseurTemp.x < diceTemp.x + 48) { curseurTemp.x += vitesse; }
			if (curseurTemp.y > diceTemp.y + 48) { curseurTemp.y -= vitesse; }
			if (curseurTemp.y < diceTemp.y + 48) { curseurTemp.y += vitesse; }
			
			if (curseurTemp.x > diceTemp.x &&
				curseurTemp.x < diceTemp.x + 96 &&
				curseurTemp.y > diceTemp.y && 
				curseurTemp.y < diceTemp.y + 96) { crsIn = true; } else { crsIn = false;}
			
			if (crsClick == true && crsIn == true) {
				diceTemp.selectione();
				if (crsMove == false) { diceMem = diceTemp; }
			}
			if (crsClick == true && crsMove == true && crsIn == true) { tDice();}
			if (crsClick == false) {
				FCtab = diceTC();
				sensTemp = 1+Math.random()*3;
				tDice();
				for (var nd:int = 0; nd < conteneurImage.numChildren; nd++) { Dice(conteneurImage.getChildByName("Dice" + nd)).unSelectione(); }
			}
			
			if (crsClick == true && crsIn == true && crsMove == true) {
				gestionRainbow(sequence);
			}
			function tDice() {
				if (diceMem is Dice) {
					if (diceMem.tourneEnCours == false) { 
						diceMem.tourner(sensTemp, FCtab);
						diceMem = new Object();
					}
				}
			}
		}
	//GESTION RAINBOW========================================================================================
		private function gestionRainbow(seq:int) {
			for (var nd:int = 0; nd < conteneurImage.numChildren; nd++) {
				var diceTemp:Dice = Dice(conteneurImage.getChildByName("Dice" + nd)); 
				diceTemp.gestionRainbow(listRainbow[seq][nd]);
			}
		}
	//DONNER TYPE COULEUR======================================================================================
		private function diceTC():Array {
			var retour:Array = new Array();
			if (listDice[sequence][2] != undefined) {
				if (listDice[sequence][2][0] == undefined) { retour = typeDice(0, listDice[sequence][2][1], 1); }
				else if (listDice[sequence][2][1] == undefined) {retour = typeDice(listDice[sequence][2][0], 0,2); }
				else { retour = [listDice[sequence][2][0], listDice[sequence][2][1]]; }
			}else { 	
				retour = typeDice(FCtab[0], FCtab[1]);
			}
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
				if (oldF == F || oldC == C) { 
					formeDice = true;
					retour = [F, C];
				}
			}
			return(retour);
		}
	}
}