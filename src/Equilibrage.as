package{
	
	public class Equilibrage {
			
			public var carteNiveau:Array=new Array();
			public var nbLigne:int=0;
			
			private var tauxFC:int=5;
			public var tauxChance:int = 100;
			public var chanceBlock:Boolean = false;
			
			public var test:Boolean = false;
			
		public function Equilibrage(){
			
		}
		public function creerNiveau(chanceTemp:int){
			tauxChance = chanceTemp;
			chanceBlock = false;
			for(var l:int=0;l<nbLigne;l++){
				var carteColonne:Array=new Array();
				for(var c:int=0;c<nbLigne;c++){
					carteColonne[c]=creerDice();
				}
				carteNiveau[l]=carteColonne;
			}
			for(var L:int=0;L<nbLigne;L++){
				for(var C:int=0;C<nbLigne;C++){
					var diceTemp:Array = [L, C, carteNiveau[L][C][0], carteNiveau[L][C][1]];
					carteNiveau[L][C]=changerDice(L,C,diceTemp);
				}
			}
		}
//CHANGER DICE============================================================
		public function changerDice(sourisColoneTemp:int,sourisLigneTemp:int,diceSelectedTemp:Array):Array{
			
			var Cnow:int=sourisColoneTemp;
			var Lnow:int=sourisLigneTemp;
			var L:int=diceSelectedTemp[0];
			var C:int=diceSelectedTemp[1];
			var oldForme=diceSelectedTemp[2];
			var oldCouleur=diceSelectedTemp[3];
			
			var chance:Boolean=roulette();
			var securite:int=0;
			var formeDiff:Boolean=false;
			if (test == true) { diceTypeCouleur = [1, 1]; }
			else{
				while(formeDiff==false){
					var diceTypeCouleur:Array=new Array();
				
					if(chance==true){diceTypeCouleur=tcChance(L,C);}
					if(chance==false){diceTypeCouleur=tcMalChance(L,C);}
				
					var nowDiff:Boolean=false;
					if((diceTypeCouleur[0]!=carteNiveau[Lnow][Cnow][0]
					&&diceTypeCouleur[1]!=carteNiveau[Lnow][Cnow][1])
					||(L==Lnow&&C==Cnow)){nowDiff=true;}
					
					var optim:Boolean=false;
					if(optimiserDice(diceTypeCouleur)==true){optim=true;}else{optim=false;}
					
					var secur:Boolean=false;
					if(securite>360){secur=true;}
					
					if(nowDiff==true){
						if(secur==false&&optim==true){formeDiff=true;}
						if(secur==true){
							formeDiff=true;
							//trace("probleme_Equilibrage:"+L+","+C);
						}
					}
					securite++;
					if(securite>=10000){formeDiff=true;trace("probleme_ChangerDice:"+L+","+C);}
				}
			}
			var retour:Array = diceTypeCouleur;
			return(retour);
		}
		
//======================================================================PRIVATE==========================================================================

		

//CHANCE TYPE COULEUR============================================================
		private function roulette():Boolean{
			var taux:int=tauxChance;
			var reponse:Boolean = false;
			var nbrPossibilite:int = testerCase();
			var roulette:int=(Math.ceil(Math.random()*100));
			if(roulette<taux){reponse=true;}
			if (nbrPossibilite < nbLigne * nbLigne && chanceBlock == false) { reponse = true; }
			return(reponse);
		}
	//CREER DICE ALEATOIRE=============================================================
		private function creerDice():Array{
			var forme:int=Math.round(1+Math.random()*tauxFC);
			var couleur:int=Math.round(1+Math.random()*tauxFC);
			var typeCase:Array=[forme,couleur];
			return(typeCase)
		}
	//CREER DICE CHANCE================================================================
		private function tcChance(Ltemp,Ctemp):Array{
			var reponse:Array=new Array();
			var typeCase:Array=new Array();
			var L:int=Ltemp;
			var C:int=Ctemp;
			
			var formeDice:Boolean=false;
			var securite:int=0;
			
			while(formeDice==false){
				var TouC:int=Math.round(Math.random()*1);
				
				var HouB:int=Math.round(Math.random()*1);if(HouB==0){HouB=-1;}
				var DouG:int=Math.round(Math.random()*1);if(DouG==0){DouG=-1;}
				var HBouDG:int=Math.round(Math.random()*1);
				if(L+HouB>=0&&L+HouB<nbLigne&&C+DouG>=0&&C+DouG<nbLigne){
					if(HBouDG==1){typeCase[TouC]=carteNiveau[L][C+DouG][TouC];}
					if(HBouDG==0){typeCase[TouC]=carteNiveau[L+HouB][C][TouC];}
					if(TouC==0){typeCase[1]=Math.round(1+Math.random()*tauxFC);}
					if(TouC==1){typeCase[0]=Math.round(1+Math.random()*tauxFC);}
					formeDice=true;
				}
				securite++;
				if(securite>1000){formeDice=true;trace("securite_tcChance:"+L+","+C);}
			}
			return(typeCase)
		}
	//CREER DICE MALCHANCE================================================================
		private function tcMalChance(Ltemp,Ctemp):Array{
			var reponse:Array=new Array();
			var typeCase:Array=new Array();
			var L:int=Ltemp;
			var C:int=Ctemp;
			
			var formeDice:Boolean=false;
			var securite:int=0;
			
			while(formeDice==false){
				var forme:int=Math.round(1+Math.random()*tauxFC);
				var couleur:int=Math.round(1+Math.random()*tauxFC);
				
				var diceTest1:Boolean=false;
				var diceTest2:Boolean=false;
				var diceTest3:Boolean=false;
				var diceTest4:Boolean=false;
				
				if(L+1>nbLigne-1){diceTest1=true;}
				else if(forme!=carteNiveau[L+1][C][0]&&couleur!=carteNiveau[L+1][C][1]){diceTest1=true;}
				if(L-1<0){diceTest2=true;}
				else if(forme!=carteNiveau[L-1][C][0]&&couleur!=carteNiveau[L-1][C][1]){diceTest2=true;}
				if(C+1>nbLigne-1){diceTest3=true;}
				else if(forme!=carteNiveau[L][C+1][0]&&couleur!=carteNiveau[L][C+1][1]){diceTest3=true;}
				if(C-1<0){diceTest4=true;}
				else if(forme!=carteNiveau[L][C-1][0]&&couleur!=carteNiveau[L][C-1][1]){diceTest4=true;}
				
				if(diceTest1==true&&diceTest2==true&&diceTest3==true&&diceTest4==true){formeDice=true;}
				
				securite++;
				if(securite>100){formeDice=true;trace("securite_tcMalChance:"+L+","+C);}
				
			}
			typeCase=[forme,couleur];
			return(typeCase);
		}
// OPTIMISER TYPE COULEUR==========================================================
		private function optimiserDice(diceTemp:Array):Boolean{
			var compterType=compterTypeCouleur()[0];
			var compterCouleur=compterTypeCouleur()[1];
			var acceptType:Boolean=false;
			var acceptCouleur:Boolean=false;
			var retour:Boolean=false;
			for(var n:int=0;n<6;n++){
				if(diceTemp[0]==compterType[n][0]&&compterType[n][1]<=6){acceptType=true;}
				if(diceTemp[1]==compterCouleur[n][0]&&compterCouleur[n][1]<=6){acceptCouleur=true;}			
			}
			if(acceptType==true&&acceptCouleur==true){retour=true;}
			return(retour);
		}
	//Compter=================================================
		private function compterTypeCouleur():Array{
			var typeTab:Array=[0,0,0,0,0,0];
			var couleurTab:Array=[0,0,0,0,0,0];
			var typeListe:Array=new Array();
			var couleurListe:Array=new Array();
			
			for(var L:int=0;L<nbLigne;L++){
				for(var C:int=0;C<nbLigne;C++){
					typeTab[carteNiveau[L][C][0]-1]++;
					couleurTab[carteNiveau[L][C][1]-1]++;
				}
			}
			for(var n:int=0;n<6;n++){typeTab[n]=[n,typeTab[n]];}
			typeTab.sortOn(typeTab[1],Array.NUMERIC);
			for(var i:int=0;i<6;i++){typeListe[i]=[typeTab[i][0]+1,typeTab[i][1]];}
			
			for(var m:int=0;m<6;m++){couleurTab[m]=[m,couleurTab[m]];}
			couleurTab.sortOn(couleurTab[1],Array.NUMERIC);
			for(var j:int=0;j<6;j++){couleurListe[j]=[couleurTab[j][0]+1,couleurTab[j][1]];}
			
			var retour:Array=[typeListe,couleurListe];
			return(retour);
		}
	//tester case================================================
		private function testerCase():int{
			var nbTrue:int=0;
			for(var L:int=0;L<nbLigne;L++){
				for(var C:int=0;C<nbLigne;C++){
					tester(L,C);
				}
			}
			return(nbTrue);
			function tester(Ltemp,Ctemp){
				for(var HB:int=-1;HB<=1;HB++){
					for(var DG:int=-1;DG<=1;DG++){
						for(var n:int=0;n<=1;n++){
							if(Ltemp+HB>=0&&Ltemp+HB<nbLigne&&Ctemp+DG>=0&&Ctemp+DG<nbLigne){
								if((HB!=0&&DG==0)||(HB==0&&DG!=0)){
									if(carteNiveau[Ltemp][Ctemp][n]==carteNiveau[Ltemp+HB][Ctemp+DG][n]){
										nbTrue+=1;
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
			