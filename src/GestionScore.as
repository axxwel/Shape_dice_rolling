package{
	
	import flash.display.*;
	import flash.text.*;
	import flash.filters.*;
	import flash.events.Event;
	
	public class GestionScore extends MovieClip {
		
		public var conteneur:Sprite=new Sprite();
		
		private var miseEnFormeFont:TextFormat=new TextFormat();
		private var miseEnFormeDyn:TextFormat=new TextFormat();
		private var startDyn:int=0;
		private var endDyn:int=1;
		
		public var afficheScore:TextField=new TextField;
		public var miseEnFormeScore:TextFormat=new TextFormat();
		
		public var afficheScoreCombo:TextField=new TextField;
		public var miseEnFormeScoreCombo:TextFormat=new TextFormat();
		
		private var monGlowCombo:GlowFilter=new GlowFilter(0xf7ff3c,1,5,5,10);
		private var monGlow:GlowFilter=new GlowFilter(0xf400a1,1,5,5,10);
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		private var pointTab:Array=new Array();
		public var multiTab:Array=[1,1,1,2,4,8,16];
		public var bonusTab:Array=[0,0,0,100,500,1000,10000];
		
		public var scoreAffiche:int=0;
		
		public var scoreCombo:int=0;
		public var scoreTotal:Number=0;
		
		public var scoreTotalFin:int=0;
		public var comboMaxFin:int=0;
		
		private var nDice:int=0;
		private var multi:int=0;
		
		public var scoreCount:Boolean = false;
		
		public var sonCtS:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function GestionScore(){
			miseEnFormeFont.font="Cooper Std black";
			miseEnFormeFont.align="right";
			miseEnFormeFont.bold=true;
			
	//ScoreCombo=================================================================
			miseEnFormeScoreCombo.size=32;
			miseEnFormeScoreCombo.color=0x1e7fcb;
			
			afficheScoreCombo.embedFonts = true;
			afficheScoreCombo.name="ScoreCombo";
			afficheScoreCombo.y=100;
			afficheScoreCombo.width=192;
			afficheScoreCombo.filters=[monGlowCombo,monOmbre];
			
			conteneur.addChild(afficheScoreCombo);
			
	//scoreTotal===============================================================
			miseEnFormeScore.size=38;
			miseEnFormeScore.color=0xf7ff3c;
			
			afficheScore.embedFonts = true;
			afficheScore.name="ScoreTotal";
			afficheScore.y=144;
			afficheScore.width=192;
			afficheScore.filters=[monGlow,monOmbre];
			
			conteneur.addChild(afficheScore);
			
	//===============================
			affiche();
			addChild(conteneur);
		}
		public function run(nDiceTemp:int=0,multiTemp:int=0,bonusTemp:int=0){
			nDice=nDiceTemp;
			multi=multiTab[multiTemp];
			pointTab[nDice]=nDice;
			var pTabpTt:int=0;
			for(var s:int=0;s<pointTab.length;s++){pTabpTt+=pointTab[s];}
			var scoreDice:int=pTabpTt+nDice-1;
			if(scoreDice>10){
				while(scoreDice%5!=0){scoreDice-=1;}
			}
			if(scoreDice>100){
				while(scoreDice%10!=0){scoreDice-=1;}
			}
			if(scoreDice>1000){
				while(scoreDice%100!=0){scoreDice-=1;}
			}
			scoreAffiche=scoreDice*multi+bonusTab[bonusTemp];
			scoreCombo+=scoreAffiche;
			affiche();
		}
		public function doneResultat(){
			var lScore:int=String(scoreCombo.toString()).length;
			var sortieTab:Array=new Array()
			for(var n:int=0;n<lScore;n++){
				var sortie:int=0;
				var incr:int=0;
				sortie=Math.floor(scoreCombo/(Math.pow(10,n)))*Math.pow(10,n);
				sortie-=Math.floor(scoreCombo/(Math.pow(10,n+1)))*Math.pow(10,n+1);
				incr=Math.pow(10,n);
				var si:Array=[sortie,incr]
				sortieTab.push(si);
				
			}
			addEventListener(Event.ENTER_FRAME,runScore);
			var s:int=sortieTab.length-1;
			var sTemp:int=sortieTab[s][0];
			var iTemp:int=sortieTab[s][1];
			function runScore(e:Event) {
				if(scoreCombo>0){
					if (sTemp > 0) {
						scoreTotal += iTemp;
						scoreCombo -= iTemp;
						sTemp -= iTemp;
						if (sTemp%(5*iTemp) == 0) { sonCtS = true; }
						affiche();
					}
					else {
						s-=1;
						sTemp=sortieTab[s][0];
						iTemp=sortieTab[s][1];
					}
				}else{
					scoreCount=false;
					pointTab=[];
					removeEventListener(Event.ENTER_FRAME,runScore);
					scoreCombo=0;
				}
			}
		}
		public function affiche(){
	//ScoreCombo=================================================================
			afficheScoreCombo.text=String(scoreCombo);
			
			afficheScoreCombo.setTextFormat(miseEnFormeFont);
			afficheScoreCombo.setTextFormat(miseEnFormeScoreCombo);
			
			formatText(afficheScoreCombo,44,0);
			if(afficheScoreCombo.length>1){formatText(afficheScoreCombo,32,1);}
			if(afficheScoreCombo.length>2){formatText(afficheScoreCombo,32,2);}
			
	//scoreTotal===============================================================
			afficheScore.text=String(scoreTotal);
			
			afficheScore.setTextFormat(miseEnFormeFont);
			afficheScore.setTextFormat(miseEnFormeScore);
			
			var c:int=0;
			for(var n:int=1;n<afficheScore.length;n++){
				var t:int=0;
				if(n%3==0){t=5;c+=5}else{t=0;}
				formatText(afficheScore,28+t+c,afficheScore.length-n);
			}
			var textTemp:TextFormat=afficheScore.getTextFormat(0,1);
			var tailleText:int=int(textTemp.size);
			if(afficheScore.length>1){formatText(afficheScore,tailleText+c,0);}
			
			scoreTotalFin=scoreTotal+scoreCombo;
			if(scoreCombo>comboMaxFin){comboMaxFin=scoreCombo;}
		}
		private function formatText(texte:TextField,taille:int,place:int){
			var tFormat:TextFormat=new TextFormat();
			var sFormat:int=place;
			var eFormat:int=sFormat+1;
			
			tFormat.size=taille;
			
			texte.setTextFormat(tFormat,sFormat,eFormat);
		}
	}
}