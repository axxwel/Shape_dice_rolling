package{
	
	import flash.display.Sprite;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;
	
	public class Aide extends Sprite{
		
		private var monTimer:Timer=new Timer(1000);
		public var carteNiveau:Array=new Array();
		public var nbLigne:int=0;
		
		private var listeCombo:Array=new Array();
		private var maxCombo:Array=new Array();
		private var minCombo:Array=new Array();
		
		private var seconde:int=0;
		private var niveau:int=0;
		
		public var aideActive:Boolean=false;
		public var aideCombo:Array=["empty"];
		
		public var retourAide:Boolean=false;
		
		public function Aide(){
			monTimer.addEventListener(TimerEvent.TIMER,timerTic);
		}
		public function activer(carteNiveauTemp:Array){
			if(monTimer.running==false){
				niveau=4;
				carteNiveau=carteNiveauTemp;
				aideActive=true;
				monTimer.start();
			}
			if(aideActive==false){retourAide=false;}
			if(retourAide==true){aideActive=false;}
		}
		public function desactiver(){
			aideActive=false;
			aideCombo=["empty"]
			seconde=0;
			monTimer.reset();
			monTimer.stop();
		}
		private function timerTic(e:Event){
			var mc:Array=["empty"];
			if(aideActive==true){seconde++;}
			if(seconde>niveau&&aideActive==true){mc=donnerMaxCombo();aideCombo=mc;retourAide=true;}	
		}
		public function donnerMaxCombo():Array{
			creerListe();
			creerListeCombo();
			var mcRetour:Array=maxCombo;
			listeCombo=[];
			maxCombo=[];
			return(mcRetour);
		}
		private function creerListe(){
			var n:int=0;
			for(var L:int=0;L<nbLigne;L++){
				for(var C:int=0;C<nbLigne;C++){
					listeCombo[n]=[[L,C]];
					n++;
				}
			}
		}
		private function creerListeCombo(){
			for(var lCt:int=0;lCt<listeCombo.length;lCt++){
				var diceCombo:Array=listeCombo[lCt];
				var comboTemp:Array=creerCombo(diceCombo);
				for(var ct:int=0;ct<comboTemp.length;ct++){
					listeCombo.push(comboTemp[ct]);
				}
			}
			var mCombo:int=0;
			for(var mC:int=0;mC<listeCombo.length;mC++){
				var lCombo:int=listeCombo[mC].length;
				if(mCombo<lCombo){mCombo=lCombo;}
			}
			if(lCombo<=1){stage.dispatchEvent(new Event("AUCUNE_POSSIBILITE"));}
			
			var rcBon:Boolean=false;
			var securite:int=0;
			while(rcBon==false&&lCombo>1){
				var randomCombo:int=Math.ceil(Math.random()*listeCombo.length-1);
				if(listeCombo[randomCombo].length>1){rcBon=true;}
				
			}
			maxCombo=listeCombo[randomCombo];
		}
		private function creerCombo(diceComboTemp:Array):Array{
			var dicePlace:Array=diceComboTemp;
			var tableauRetour:Array=new Array();
			var Lc:int=dicePlace[dicePlace.length-1][0];
			var Cc:int=dicePlace[dicePlace.length-1][1];
			var testCase:Array=testerCaseAutour(Lc,Cc,dicePlace);
			for(var tC:int=0;tC<testCase.length;tC++){
				var combo:Array=new Array;
				for(var dp:int=0;dp<dicePlace.length;dp++){combo.push(dicePlace[dp]);}
				combo.push(testCase[tC]);
				tableauRetour.push(combo);
			}
			return(tableauRetour);
		}
		private function testerCaseAutour(Ltemp:int,Ctemp:int,listeComboTemp:Array):Array{
			var L:int=Ltemp;
			var C:int=Ctemp;
			var combo:Array=listeComboTemp;
			var tableauRetour:Array=new Array();
			for(var HB:int=-1;HB<=1;HB++){
				for(var DG:int=-1;DG<=1;DG++){
					for(var n:int=0;n<=1;n++){
						if(L+HB>=0&&L+HB<nbLigne&&C+DG>=0&&C+DG<nbLigne){
							if((HB!=0&&DG==0)||(HB==0&&DG!=0)){
								if(carteNiveau[L][C][n]==carteNiveau[L+HB][C+DG][n]){
									var coordonee:Array=[L+HB,C+DG];
									var cok:Boolean=true;
									for(var lc:int=0;lc<combo.length;lc++){
										if(coordonee[0]==combo[lc][0]&&coordonee[1]==combo[lc][1]){cok=false;}
									}
									for(var tc:int=0;tc<tableauRetour.length;tc++){
										if(tableauRetour[tc][0]==L+HB&&tableauRetour[tc][1]==C+DG){cok=false;}
									}
									if(cok==true){tableauRetour.push(coordonee);}
								}
							}
						}
					}
				}
			}
			var retour:Array=tableauRetour;
			return(retour);
		}
	}
}