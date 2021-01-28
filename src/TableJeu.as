package{
	
	import flash.display.Sprite;	
	import flash.events.Event;
	
	public class TableJeu extends Sprite{
		
		public var conteneur:Sprite=new Sprite();
		public var monFondNiveau:FondNiveau = new FondNiveau();
		private var monEquilibrage:Equilibrage=new Equilibrage();
		public var monAide:Aide = new Aide();
		
		public var test:Boolean = false;
		
		private var conteneurDice:Sprite=new Sprite();
		private var conteneurScore:Sprite=new Sprite();
		
		private var tailleDice:int=96;
		private var tailleZone:int=576;
		private var nbDiceLigne:int=2;
		public var tauxChance:int = 0;
		private var tauxChanceBlock:Boolean = false;
		
		private var DEC_X:int=32;
		private var DEC_Y:int=336;
		private var TAILLE:int=572;
		
		public var jeuBloque:Boolean=false;
		
		public var carteNiveau:Array=new Array();
		
		private var sourisXY:Array=new Array();
		private var sourisClick:Boolean=false;
		private var sourisOut:Boolean=false;
		
		private var sourisColone:int=0;
		private var sourisLigne:int=0;
		
		private var diceSelected:Array=[0,0,0,0,false];
		
		public var diceSelect:Array=new Array();
		public var diceSelectFin:Boolean=true;
		public var diceSelectTic:Boolean = false;
		private var nbrDiceSelected:int = 0;
		
		private var listeDiceMB:Array=new Array();
		private var diceAffMB:Array=new Array();
		private var megaBonusStart:Boolean=false;
		public var diceSelectMB:Array=new Array();
		public var diceSelectMBTic:Boolean=false;
		
		private var tabDiceSelect:Array=new Array();
		
		private var aideTimer:int=0;
		private var aideCombo:Array=new Array();
		private var aideLongCombo:int=0;
		
		public var scoreCount:Boolean=false; 
		
		public var initFin:Boolean=false;
		public var raZero:Boolean = false;
		
		public var sonDice:Boolean = false;
		public var sonDice_nbr:int = 0;
		
		public function TableJeu() {
			monFondNiveau.init();
			monFondNiveau.x = -16;
			monFondNiveau.y = 860 - monFondNiveau.height;
			addChild(monFondNiveau);
		}
		public function creer(nbLigneTemp:int,tauxChanceTemp:int){
			if (nbLigneTemp >= 5) { 
				if (nbLigneTemp <= 7) { nbDiceLigne = nbLigneTemp; } else { nbDiceLigne = 7; }
			} else { nbDiceLigne = 5; }
			
			tailleDice=tailleZone/nbDiceLigne;
			conteneur.x=32;
			conteneur.y=112+960-monFondNiveau.height;
			
			conteneur.addChild(conteneurDice);
			conteneur.addChild(conteneurScore);
			addChild(conteneur);
			
			tauxChanceBlock = false;
			monEquilibrage.chanceBlock = false;
			tauxChance=tauxChanceTemp;
			monEquilibrage.nbLigne=nbDiceLigne;
			monAide.nbLigne=nbDiceLigne;
			creerCarteNiveau();
		}
//MISE EN PLACE DICE=========================================================================================
		private function creerCarteNiveau(){
			monEquilibrage.creerNiveau(tauxChance);
			carteNiveau=monEquilibrage.carteNiveau;
			
			monAide.carteNiveau=carteNiveau;
			creerNiveau();
		}
		private function creerNiveau(){
			for(var L:Number=0;L<nbDiceLigne;L++){
				for(var C:Number=0;C<nbDiceLigne;C++){
					var monDice:Dice=new Dice(tailleDice,[carteNiveau[L][C][0],carteNiveau[L][C][1]],String(L+","+C));
					monDice.name="forme_"+L+"_"+C;
					monDice.x=(tailleDice*C);
					monDice.y=(tailleDice*L);
					monDice.height=tailleDice;
					monDice.width=tailleDice;
					conteneurDice.addChild(monDice);
				}
			}
		}
//RUN=================================================================================================================
		public function run(sourisTemp:Array){
			sourisXY[0]=sourisTemp[0];
			sourisXY[1]=sourisTemp[1];			
			sourisClick=sourisTemp[2];
			
			sourisColone=-1;
			sourisLigne=-1;
			sourisOut=true;
			
			if(sourisXY[0]>DEC_X
			 &&sourisXY[0]<DEC_X+TAILLE
			 &&sourisXY[1]>DEC_Y
			 &&sourisXY[1]<DEC_Y+TAILLE){
				sourisColone=(sourisXY[0]-DEC_X)/tailleDice;
				sourisLigne=(sourisXY[1]-DEC_Y)/tailleDice;
				bougerDice();
				sourisOut=false;
			}
			if (tauxChanceBlock == false) { 
				monEquilibrage.tauxChance = tauxChance;
				monEquilibrage.chanceBlock = false;
			} else { 
				monEquilibrage.tauxChance = 0;
				monEquilibrage.chanceBlock = true;
			}
			
			selectionDice();
			if (test == false) { gestionAide(); }
			gestionMegaBonus();
			gestionScore();
		}
//INIT=======================================================================================================================
		public function init(){
			initFin = false;
			
			monEquilibrage.test = test;
			
			var lcTab:Array=new Array();
			monEquilibrage.creerNiveau(0);
			carteNiveau=monEquilibrage.carteNiveau;
			
			monAide.desactiver();
			monAide.carteNiveau=carteNiveau;
			
			for(var L:Number=0;L<nbDiceLigne;L++){
				for(var C:Number=0;C<nbDiceLigne;C++){
					var tab:Array=[L,C];
					lcTab.push(tab);
				}
			}
			var totalIteration:int=0;
			lcTab.forEach(melanger);
			function melanger(element:*,index:int,arr:Array){
				var tmpId:int = Math.round(Math.random()*(arr.length - 1));
				var tmp:* = arr[tmpId];
				arr[tmpId] = arr[index];
				arr[index] = tmp;
				totalIteration++;
			}
			var lcTabLength=lcTab.length;
			addEventListener(Event.ENTER_FRAME,tournerDiceInit);
			function tournerDiceInit(e:Event){
				if(lcTabLength>0){lcTabLength--;
					var D:int=lcTabLength;
					var sens:int=Math.round(1+Math.random()*3);
					var typeCouleur:Array=carteNiveau[lcTab[D][0]][lcTab[D][1]];
					Dice(conteneurDice.getChildByName("forme_" + lcTab[D][0] + "_" + lcTab[D][1])).tourner(sens, typeCouleur); 
				}
				else{initFin=true;removeEventListener(Event.ENTER_FRAME,tournerDiceInit);}
			}
		}
//BOUGER DICE SOURIS============================================================================================================
		private function bougerDice(){
			var C = sourisColone;
			var L = sourisLigne;
			Dice(conteneurDice.getChildByName("forme_"+L+"_"+C)).bouger(sourisXY[0]-DEC_X,sourisXY[1]-DEC_Y,sourisClick);
		}
//SCORE DICE=====================================================================================================================
		public function gestionScore(){
			if(conteneurScore.numChildren>0){
				for(var n:int=0;n<conteneurScore.numChildren;n++){
					if(ChiffreScore(conteneurScore.getChildAt(n)).finAnim==true){conteneurScore.removeChild(ChiffreScore(conteneurScore.getChildAt(n)));}
				}	
			}
		}
//SELECTION DICE=================================================================================================================
		private function selectionDice(){
			var C:int=sourisColone;
			var L:int=sourisLigne;
			diceSelectTic=false;
			
			var td:Boolean = false;
			if (sourisClick == true && sourisOut == false) { startSelect();td = true; }
			if (sourisClick == false || sourisOut == true || testDice() == false) { stopSelect();td = false; }
			if(td==true){startSelect();}else{stopSelect();}
			
			function startSelect() {
				if(diceSelected[4]==false&&Dice(conteneurDice.getChildByName("forme_"+L+"_"+C)).tourneEnCours==false&&scoreCount==false){
					diceSelectFin=false;
					diceSelected=[L,C,carteNiveau[L][C][0],carteNiveau[L][C][1],true];
					//diceSelect = [carteNiveau[L][C][0], carteNiveau[L][C][1]];
					nbrDiceSelected += 1;
					ajoutMB(diceSelected);
					gestionRainbow(L,C);
					Dice(conteneurDice.getChildByName("forme_"+L+"_"+C)).selectione();
					//diceSelectTic=true;
				}
			}
			function stopSelect(){
				unSelectione();
				diceSelectFin=true;
				//if (nbrDiceSelected > 1 && diceSelected[4] == true) { diceChange(diceSelected); }//<====DERNIER DICE TOURNE
				nbrDiceSelected = 0;
				diceSelected[4]=false;
			}
			function testDice():Boolean{
				var diceOK:Boolean=true;
				var diceSuivant:Array=[carteNiveau[L][C][0],carteNiveau[L][C][1]];
				
				if ((diceSelected[0] == L && (diceSelected[1]-1 == C || diceSelected[1]+1 == C)) ||
					(diceSelected[1] == C && (diceSelected[0]-1 == L || diceSelected[0]+1 == L))) { 
					if (diceSelected[2] == diceSuivant[0] || diceSelected[3] == diceSuivant[1]) {
						diceChange(diceSelected);
						diceSelected[4]=false;
					}else{
						diceOK=false;
					}
				}
				if(diceSelected[0]!=L&&diceSelected[1]!=C){diceOK=false;}
				return(diceOK);
			}
		}
//DESELECTIONER DICE==================================================================================
		private function unSelectione(){
			for(var l:Number=0;l<nbDiceLigne;l++){
				for(var c:Number=0;c<nbDiceLigne;c++){
					Dice(conteneurDice.getChildByName("forme_"+l+"_"+c)).unSelectione();
					tabDiceSelect=[];
				}
			}
			sonDice_nbr = 0;
		}
//CHANGER DICE========================================================================================
		private function diceChange(diceTemp:Array,megaCombo:Boolean=false){
			
			var L:int=diceTemp[0];
			var C:int=diceTemp[1];
			var Cnew:int=sourisColone;
			var Lnew:int=sourisLigne;
			
			var sens:int=0;
			
			if(megaCombo==true){Cnew=C;Lnew=L;sens=0;}
			
			if(sourisOut==true){Lnew=diceTemp[0];Cnew=diceTemp[1];}
			
			var typeCouleur:Array=monEquilibrage.changerDice(Cnew,Lnew,diceTemp);
			
			if(Lnew>L){sens=4;}
			if(Lnew<L){sens=1;}
			if(Cnew>C){sens=2;}
			if(Cnew<C){sens=3;}
			if(Dice(conteneurDice.getChildByName("forme_"+L+"_"+C)).tourneEnCours==false){
				if(sens!=0){Dice(conteneurDice.getChildByName("forme_"+L+"_"+C)).tourner(sens,typeCouleur);}
				if (sens == 0) { Dice(conteneurDice.getChildByName("forme_" + L + "_" + C)).tourner(Math.round(1 + Math.random() * 3), typeCouleur); }
				//==========================================================
				diceSelect = [carteNiveau[L][C][0], carteNiveau[L][C][1]];
				diceSelectTic = true;
				//==========================================================
				sonDice_nbr += 1;
				sonDice = true;
			}
			carteNiveau[L][C][0]=typeCouleur[0];
			carteNiveau[L][C][1]=typeCouleur[1];
			monAide.carteNiveau=carteNiveau;
		}
//GESTION RAINBOW===========================================================================================
		private function gestionRainbow(l:int,c:int){
			var image0:int=1;
			var image1:int=1;
			var pointe:int=0;
			
			var dicePos:Array=[l,c];
			tabDiceSelect.push(dicePos);
			
			var diceS0:Array=tabDiceSelect[tabDiceSelect.length-1]
			var diceS1:Array=tabDiceSelect[tabDiceSelect.length-2]
			var diceS2:Array=tabDiceSelect[tabDiceSelect.length-3]
			
			if(tabDiceSelect.length<=1){image0=1;}
			if(tabDiceSelect.length>1){
				if(diceS0[0]==diceS1[0]){
					if(diceS0[1]>diceS1[1]){image0=2;}
					else{image0=3;}
				}
				if(diceS0[1]==diceS1[1]){
					if(diceS0[0]>diceS1[0]){image0=5;}
					else{image0=4;}
				}
				if(diceS2==null){
					switch(image0){
						case 2:image1=3;break;
						case 3:image1=2;break;
						case 4:image1=5;break;
						case 5:image1=4;break;
					}
				}else{
					if(diceS0[0]==diceS2[0]){image1=6;}
					if(diceS0[1]==diceS2[1]){image1=7;}
					if(diceS0[0]>diceS2[0]){
						if(diceS0[1]>diceS2[1]){
							if(image0==5){image1=9;}
							if(image0==2){image1=10;}
						}
						if(diceS0[1]<diceS2[1]){
							if(image0==3){image1=11;}
							if(image0==5){image1=8;}
						}
					}
					if(diceS0[0]<diceS2[0]){
						if(diceS0[1]>diceS2[1]){
							if(image0==4){image1=11;}
							if(image0==2){image1=8;}
						}
						if(diceS0[1]<diceS2[1]){
							if(image0==3){image1=9;}
							if(image0==4){image1=10;}
						}
					}
				}
			}
			if(tabDiceSelect.length>=1){Dice(conteneurDice.getChildByName("forme_"+diceS0[0]+"_"+diceS0[1])).gestionRainbow(image0+1);}
			if(tabDiceSelect.length>=2){Dice(conteneurDice.getChildByName("forme_"+diceS1[0]+"_"+diceS1[1])).gestionRainbow(image1+1);}
		}
//AIDE===============================================================================================
		private function gestionAide(){
			var vitesseAide:int=40;
			if(sourisClick==false){monAide.activer(carteNiveau);}
			if(sourisClick==true){monAide.desactiver();aideLongCombo=0;}
			if(monAide.aideCombo[0]!="empty"&&monAide.retourAide==true){
				aideCombo=monAide.aideCombo;
				aideLongCombo=aideCombo.length;
				aideTimer=aideLongCombo*vitesseAide;
			}
			aideTimer--;
			if(aideLongCombo>0){
				if(aideTimer<aideLongCombo*vitesseAide){
					var nDice:Array=aideCombo[aideLongCombo-1];
					var diceObj:Object=Dice(conteneurDice.getChildByName("forme_"+nDice[0]+"_"+nDice[1]));
					conteneurDice.setChildIndex(Sprite(conteneurDice.getChildByName("forme_"+nDice[0]+"_"+nDice[1])),conteneurDice.numChildren-1);
					diceObj.aideActive=true;
					aideLongCombo--;
					if(aideLongCombo<=0){monAide.desactiver();}
				}
			}
			for(var L:Number=0;L<nbDiceLigne;L++){
				for(var C:Number=0;C<nbDiceLigne;C++){
					var diceObjAide:Object=Dice(conteneurDice.getChildByName("forme_"+L+"_"+C));
					if(sourisClick==true&&diceObjAide.aideTempo>0){diceObjAide.annuleAide();}
					if(diceObjAide.aideActive==true||diceObjAide.aideTempo>0){diceObjAide.aide();}
				}
			}
		}
//SCORE DICE================================================================================================================
		public function afficheScore(scoreAfficheTemp:int) {
			var diceLC:Array=new Array();
			if (megaBonusStart == true) { 
				diceLC[0]=diceAffMB[0];
				diceLC[1]=diceAffMB[1];
			}
			if(megaBonusStart==false){
				diceLC[0]=diceSelected[0];
				diceLC[1]=diceSelected[1];
			}
			var scAff:String=String(scoreAfficheTemp);
			var monChiffreScore:ChiffreScore=new ChiffreScore(scAff,diceLC[0]*tailleDice+tailleDice/6,diceLC[1]*tailleDice,24,tailleDice,diceSelected[3]); 
			conteneurScore.addChild(monChiffreScore);		
		}
//MULTI BONUS==================================================================================================
		private function ajoutMB(lastDiceTemp:Array) {
			var lastDice:Array = lastDiceTemp;
			listeDiceMB.unshift(lastDice);
			for (var n:int = 1; n < listeDiceMB.length; n++) {
				if (lastDice[0] == listeDiceMB[n][0] && lastDice[1] == listeDiceMB[n][1]) {
					listeDiceMB.splice(n,1);
					listeDiceMB.splice(0,1);
					megaBonusStart = true;
				}
			}
		}
		private function gestionMegaBonus() {
			if (sourisClick == false || diceSelectFin == true) {
				tauxChanceBlock = false;
				listeDiceMB = [];
			}
			if (megaBonusStart == true) { 
				diceSelectMBTic=false;
				if (listeDiceMB.length == 1) { 
					tauxChanceBlock = true;
					unSelectione();
					gestionRainbow(sourisLigne,sourisColone);
				}
				if(listeDiceMB.length<=0){
					diceSelectMBTic=false;
					megaBonusStart = false;
					listeDiceMB.unshift(diceSelected);
				}else {
					executeMB(listeDiceMB[listeDiceMB.length - 1]);
					listeDiceMB.splice(listeDiceMB.length - 1, 1);
				}
			}
			function executeMB(daffTemp:Array) {
				diceAffMB = [daffTemp[0], daffTemp[1]]
				diceSelectMB=[carteNiveau[daffTemp[0]][daffTemp[1]][0],carteNiveau[daffTemp[0]][daffTemp[1]][1]]
				diceSelectMBTic = true;
			}
		}
//PORTRAIT PAYSAGE===================================================================================================================
		public function portraitPaysage(){
			conteneur.rotation=-90;
			conteneur.y=810;
			DEC_X=150;	
			DEC_Y=32;
		}
	}
}