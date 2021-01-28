package{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class MenuGameOver extends MovieClip{
		
		private var conteneur:Sprite = new Sprite();
		private var conteneurClass:Sprite=new Sprite();
		private var monFondMenu:FondMenu=new FondMenu();
		private var monGameOver:GameOver=new GameOver();
		private var monLangage:Langage = new Langage();
		private var monAmisBattu:AmisBattu = new AmisBattu();
		
		public var monComboEver_old:int = 0;
		public var monScoreEver_old:int = 0;
		
		private var monBoutonFermer:Bouton=new Bouton("Fermer");
		private var monBoutonPartager:Bouton = new Bouton("Vert", monLangage.btnShare);
		private var monBoutonInvite:Bouton=new Bouton("Rouge",monLangage.btnInvite);
		
		private var posCentreScore:int=200;
		
		public var maNote:int = 0;
		private var maNoteNbr:TexteScore=new TexteScore("0",80,0xf7ff3c,true,true,true,0xf400a1);
		
		public var monScore:int=0;
		private var monScoreTxt:TexteScore=new TexteScore(monLangage.score,28,0x000000,false);
		private var monScoreNbr:TexteScore=new TexteScore("0",50,0xf7ff3c,true,false,true,0xf400a1);
		
		public var monCombo:int=0;
		private var monComboTxt:TexteScore=new TexteScore(monLangage.bestCombo,24,0x000000,false);
		private var monComboNbr:TexteScore=new TexteScore("0",40,0x1e7fcb,true,false,true,0xf7ff3c);
		
		public var monScoreEver:int=0;
		private var monBestScoreTxt:TexteScore=new TexteScore(monLangage.scoreEver,18,0x000000,false);
		private var monBestScoreNbr:TexteScore=new TexteScore("0",30,0xf7ff3c,true,false,true,0xf400a1);
		
		public var monComboEver:int=0;
		private var monBestComboTxt:TexteScore=new TexteScore(monLangage.bestComboEver,16,0x000000,false);
		private var monBestComboNbr:TexteScore=new TexteScore("0",20,0x1e7fcb,true,false,true,0xf7ff3c);
		
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		private var finTime:int=0;
		public var removeFini:Boolean=false;
		
		private var startGO:Boolean = true;
		
		public var langue:String = "en_US";
		public var joueurObj:Object = new Object();
		public var friendList:Array = new Array();
		public var bestScoreWorld:int = 0;
		
		private var autorizeClick:Boolean = false;
		
		public var envoiNot:Boolean = false;
		public var envoiPartageFB:Boolean = false;
		public var envoiInviteFB:Boolean = false;
		
		public var messageFB:Object = new Object();
		
		public var sonMenuIn:Boolean = false;
		public var sonMenuOut:Boolean = false;
		public var sonGameOver:Boolean = false;
		
		public function MenuGameOver() {
			conteneur.x=40;
			conteneur.y=200;
			addChild(conteneur);
			
			conteneur.filters=[monOmbre];
		}
		public function run(){
			if (startGO == true) {
				tweenGameOver();
				sonGameOver = true;
				startGO=false;
			}
			if(autorizeClick==true){
				if(monBoutonFermer.boutonClick==true){
					envoiNot = true;
					monBoutonFermer.boutonClick = false;
					autorizeClick = false;
				}
				if (monBoutonPartager.boutonClick == true) {
					messageFB = writeMessage();
					envoiPartageFB = true;
					monBoutonPartager.boutonClick = false;
					autorizeClick = false;
				}
				if (monBoutonInvite.boutonClick == true) {
					envoiInviteFB = true;
					monBoutonInvite.boutonClick = false;
					autorizeClick = false;
				}
				if (monAmisBattu.sendMessage == true) {
					messageFB = monAmisBattu.messageFB;
					envoiPartageFB = true;
					monAmisBattu.sendMessage = false;
					autorizeClick = false;
				}
			}
		}
		private function tweenGameOver() {
			monGameOver.height=0;
			monGameOver.width=0;
			monGameOver.x=560/2;
			monGameOver.y = 560 / 2;
			conteneur.addChild(monGameOver);
			
			TweenLite.from(monGameOver, 0.5, { scaleX:0,scaleY:0 } );
			TweenLite.to(monGameOver, 1.5, { scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:finTweenGO } );
		}
		private function finTweenGO(){
			afficheScoreFond();
			conteneur.addChild(conteneurClass);
			sonMenuIn = true;
			TweenLite.from(conteneurClass, 0.3, { y:-560} );
			TweenLite.to(conteneurClass, 0.8, { y:0, ease:Elastic.easeOut, easeParams:[0.8, 0.6], onComplete:clickAutorize } );
			
			TweenLite.from(monGameOver, 0, { scaleX:1,scaleY:1 } );
			TweenLite.to(monGameOver, 0.7, { scaleX:0, scaleY:0, onComplete:suppGO } );
			function suppGO(){conteneur.removeChild(monGameOver);}
			
			function clickAutorize() {
				var nx = maNoteNbr.width / 2;
				var ny = maNoteNbr.height / 2;
				TweenLite.from(maNoteNbr, 1, { scaleX:0,scaleY:0, x:140,y:100+ny} );
				TweenLite.to(maNoteNbr, 2, { scaleX:1, scaleY:1, x:140 - nx, y:100, ease:Elastic.easeOut } );
				autorizeClick = true;
			}
		}
		private function afficheScoreFond(){
			conteneurClass.addChild(monFondMenu);
			
			monAmisBattu.langue = langue;
			monLangage.setLangage(langue);
			
			monBoutonPartager.texte = monLangage.btnShare;
			monBoutonPartager.scaleX=0.4;
			monBoutonPartager.scaleY=0.4;
			monBoutonPartager.x=140-monBoutonPartager.width/2;
			monBoutonPartager.y=488;
			conteneurClass.addChild(monBoutonPartager);
			
			monBoutonInvite.texte = monLangage.btnInvite;
			monBoutonInvite.scaleX=0.4;
			monBoutonInvite.scaleY=0.4;
			monBoutonInvite.x=420-monBoutonInvite.width/2;
			monBoutonInvite.y=488;
			conteneurClass.addChild(monBoutonInvite);
			
			monBoutonFermer.scaleX=0.3;
			monBoutonFermer.scaleY=0.3;
			monBoutonFermer.x=508;
			monBoutonFermer.y=84;
			conteneurClass.addChild(monBoutonFermer);
			
			afficherScoreTxt();
		}
		private function afficherScoreTxt() {
	//NOTE=========================================================
			var maNoteReel:Number= (( monScore/bestScoreWorld ) * 100)/5;
			maNote = maNoteReel;
			var maNoteLtr:String = "";
			switch(maNote) {
				case 20: maNoteLtr = "S"; maNoteNbr.setCouleur(0xec008b, 0xfff100); break; //violet,jaune
				case 19: maNoteLtr = "S-"; maNoteNbr.setCouleur(0xec008b, 0xfff100);break; 
				case 18: maNoteLtr = "AAA"; maNoteNbr.setCouleur(0xed1c24, 0x27a9e1);break; //rouge,bleu
				case 17: maNoteLtr = "AA+"; maNoteNbr.setCouleur(0xed1c24, 0x27a9e1);break;
				case 16: maNoteLtr = "AA"; maNoteNbr.setCouleur(0xed1c24, 0x27a9e1);break;
				case 15: maNoteLtr = "A+"; maNoteNbr.setCouleur(0xed1c24, 0x27a9e1);break;
				case 14: maNoteLtr = "A"; maNoteNbr.setCouleur(0xed1c24, 0x27a9e1);break;
				case 13: maNoteLtr = "A-"; maNoteNbr.setCouleur(0xed1c24, 0x27a9e1);break;
				case 12: maNoteLtr = "BB"; maNoteNbr.setCouleur(0xfff100, 0xed1c24);break;//jaune,rouge
				case 11: maNoteLtr = "B"; maNoteNbr.setCouleur(0xfff100, 0xed1c24);break;
				case 10: maNoteLtr = "B-"; maNoteNbr.setCouleur(0xfff100, 0xed1c24);break;
				case 9: maNoteLtr = "C+"; maNoteNbr.setCouleur(0x00ff00, 0xec008b);break;//vert,violet
				case 8: maNoteLtr = "C"; maNoteNbr.setCouleur(0x00ff00, 0xec008b);break;
				case 7: maNoteLtr = "C-"; maNoteNbr.setCouleur(0x00ff00, 0xec008b);break;
				case 6: maNoteLtr = "D"; maNoteNbr.setCouleur(0x27a9e1, 0xf16521);break;//bleu,orange
				case 5: maNoteLtr = "D-"; maNoteNbr.setCouleur(0x27a9e1, 0xf16521);break;
				case 4: maNoteLtr = "E"; maNoteNbr.setCouleur(0xf16521, 0x00ff00);break;//orange,vert
				case 3: maNoteLtr = "E-"; maNoteNbr.setCouleur(0xf16521, 0x00ff00);break;
				case 2: maNoteLtr = "F"; maNoteNbr.setCouleur(0xec008b, 0xf16521);break;//violet,orange
				case 1: maNoteLtr = "F-"; maNoteNbr.setCouleur(0xec008b, 0xf16521);break;
				case 0: maNoteLtr = "G"; maNoteNbr.setCouleur(0xec008b, 0xf16521);break;	
			}
			if(maNote>20){maNoteLtr = "S"; maNoteNbr.setCouleur(0xec008b, 0xfff100);}
			maNoteNbr.newTexte(maNoteLtr);
			maNoteNbr.x=140-(maNoteNbr.width/2);
			maNoteNbr.y = 100;
			conteneurClass.addChild(maNoteNbr);
	//TEXTE SCORE==================================================
			monScoreTxt.newTexte(monLangage.score);
			monScoreTxt.x=140-(monScoreTxt.width/2);
			monScoreTxt.y=200;
			conteneurClass.addChild(monScoreTxt);
			monScoreNbr.newTexte(String(monScore));
			monScoreNbr.x=140-(monScoreNbr.width/2);
			monScoreNbr.y = 216;
			conteneurClass.addChild(monScoreNbr);
	//TEXTE COMBO==================================================
			monComboTxt.newTexte(monLangage.bestCombo);
			monComboTxt.x=140-(monComboTxt.width/2);
			monComboTxt.y=270;
			conteneurClass.addChild(monComboTxt);
			monComboNbr.newTexte(String(monCombo));
			monComboNbr.x = 140 - (monComboNbr.width / 2);
			monComboNbr.y=286;
			conteneurClass.addChild(monComboNbr);
	//TEXTE BEST SCORE==============================================
			monBestScoreTxt.newTexte(monLangage.scoreEver);
			monBestScoreTxt.x=140-(monBestScoreTxt.width/2);
			monBestScoreTxt.y=350;
			conteneurClass.addChild(monBestScoreTxt);
			monBestScoreNbr.newTexte(String(monScoreEver));
			monBestScoreNbr.x=140-(monBestScoreNbr.width/2);
			monBestScoreNbr.y=366;
			conteneurClass.addChild(monBestScoreNbr);
	//TEXTE BEST COMBO==============================================
			monBestComboTxt.newTexte(monLangage.bestComboEver);
			monBestComboTxt.x=140-(monBestComboTxt.width/2);
			monBestComboTxt.y = 400;
			conteneurClass.addChild(monBestComboTxt);
			monBestComboNbr.newTexte(String(monComboEver));
			monBestComboNbr.x=140-(monBestComboNbr.width/2);
			monBestComboNbr.y = 416;
			conteneurClass.addChild(monBestComboNbr);
	//AMIS BATTU=====================================================
			monAmisBattu.x = 232;
			monAmisBattu.init(friendList, monScoreEver_old, monScore);
			conteneurClass.addChild(monAmisBattu);
			monAmisBattu.startAmis();
			if (monAmisBattu.listeVide == true) {
				monBoutonInvite.scaleX=0.8;
				monBoutonInvite.scaleY=0.8;
				monBoutonInvite.x=378-monBoutonInvite.width/2;
				monBoutonInvite.y=450;
			}
		}
//ECRIRE MESSAGE=============================================================================
		private function writeMessage():Object { 
			var retourMessage:Object = new Object ();
			retourMessage.method = "feed";
			retourMessage.picture = "https://www.blackmountainstudio.fr/ShapeDiceRolling/imagesFB/FB_gotNewScore.png";
			if ( joueurObj.score > monScoreEver_old) {
				retourMessage.description = monLangage.sendMessageMe_Score +(joueurObj.score).toString() + monLangage.sendMessage_SDR;
				retourMessage.caption = monLangage.sendMessageMe_titleNew+"High Score! "+monScore;
			}
			else if (joueurObj.combo > monComboEver_old) {
				retourMessage.description = monLangage.sendMessageMe_Combo +(joueurObj.combo).toString() + monLangage.sendMessage_SDR;
				retourMessage.caption = monLangage.sendMessageMe_titleNew+"High Combo! "+monCombo;
			}
			else {
				retourMessage.description =joueurObj.nom + monLangage.sendMessageMe_new + (monScore).toString() + monLangage.sendMessage_SDR;
				retourMessage.caption = monLangage.sendMessageMe_titleNew+"Score! "+monScore;
			}
			return(retourMessage);
		}
//REMOVE GAME OVER=============================================================================
		public function finGameOver() {
			sonMenuOut = true;
			TweenLite.from(conteneurClass, 0.3, {y:0} );
			TweenLite.to(conteneurClass, 0.8, { y:-640, ease:Elastic.easeIn, easeParams:[0.7,0.6], onComplete:menuFin } );
			function menuFin() {
				monScore = 0;
				monCombo = 0;
				monAmisBattu.remove();
				removeFini = true;
				removeEventListener(Event.ENTER_FRAME,finGameOver);
			}
		}
		public function portraitPaysage(){
			conteneur.rotation=-90;
			conteneur.y = 760;
			monAmisBattu.hauteur = 640;
			monAmisBattu.largeur = 960;
		}
	}
}