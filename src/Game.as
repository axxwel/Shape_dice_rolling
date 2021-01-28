package{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.System;
	
	public class Game extends MovieClip {
		
//CONSTANTES===================================================================
		private const TEMPS:Array=[1,0];
		private const NBR_LIGNE:int = 5;
		private const T_RETOUR_VIE:int = 20;//<==temps en Minute
		private const PRIX_VIE:int = 12;
		private const TEST:Boolean = false;
//=============================================================================

		private var conteneur:Sprite = new Sprite();
		private var conteneurMask:Bitmap = new Bitmap(new BitmapData(640, 960, false, 0xffffff));
		
		private var souris:Array = new Array();
		private var monFond:Voile = new Voile();
		private var maTableJeu:TableJeu=new TableJeu();
		private var maTableScore:TableScore = new TableScore();
		private var maTableClassement:WorldClassement = new WorldClassement();
		private var monMenuDepart:MenuDepart = new MenuDepart();
		private var monExplication:Explication = new Explication();
		private var monAnnonce:Annonce = new Annonce();
		private var monFacebookAsk:FacebookAsk = new FacebookAsk();
		private var monMessageBoard:MessageAmis = new MessageAmis();
		private var monLivesStore:LivesStore = new LivesStore();
		private var maGestionSon:GestionSound = new GestionSound();
		
	//================================================
		private var paysage:Boolean=true;
		
		private var depart_run:Boolean = false;
		private var exp_run:Boolean = false;
		private var init_run:Boolean=false;
		private var jeu_run:Boolean=false;
		private var gameOver_run:Boolean = false;
		private var reset_run:Boolean = false;
		private var fbAsk_run:Boolean = false;
		private var store_run:Boolean = false;
		private var message_run:Boolean = false;
		private var classement_run:Boolean = false;
		
		private var depart_start:Boolean = false;
		private var exp_start:Boolean = false;
		private var init_start:Boolean=false;
		private var jeu_start:Boolean=false;
		private var gameOver_start:Boolean = false;
		private var reset_start:Boolean = false;
		private var fbAsk_start:Boolean = false;
		private var store_start:Boolean = false;
		private var message_start:Boolean = false;
		
		private var init_vie:Boolean = false;
		private var init_vieStart:Boolean = false;
		private var actionFin:String = "";
		
		private var resetClassement:Boolean = false;
		private var checkScores:Boolean = false;
		
		private var departGame:Boolean = false;
		private var openStore:Boolean = false;
	//DONNEE FACEBOOK BDD==================================
		public var langue:String = "en_US";
		public var joueurObj:Object = new Object();
		public var friendList:Array = new Array();
		public var playerList:Array = new Array();
		public var messageList:Object = new Object();
		public var invitableFriendList:Object = new Object();
		public var comboMaxFin:int = 0;
		public var scoreTotalFin:int = 0;
		public var bestScoreWorld:int = 0;
		
		public var nbrCoin:int = 0;
		public var nbrVie:int = 0;
		public var dateVie:String = "";
		
		public var typeDemandeFB:String = "";
		public var messageFB:Object = new Object();
		public var removeRequestList:Array = new Array();
		
		public var askList_ok:Boolean = false;
		public var sendMessage_ok:Boolean = false;
		private var envoiFB_ok:Boolean = false;
		
		public var dCoinValeur_obj:Object=new Object();
		public var dCoinValeur_ok:Boolean;
		public var nbrAchatCoin:int = 0;
		public var dCoinAchat_ok:Boolean = false;
		public var dCoinAchat_nbr:int = 0;
		public var dCoinAchat_facture:Object = new Object();
		
		public var playerList_ok:Boolean = false;
		
		public var setVie_ok:Boolean = true;
		public var setCoin_ok:Boolean = true;
		private var coin_OK:Boolean = false;
	//=================================================
		public function Game () {
			addEventListener(MouseEvent.MOUSE_MOVE,moveSouris);
			addEventListener(MouseEvent.MOUSE_UP,upSouris);
			addEventListener(MouseEvent.MOUSE_DOWN, downSouris);
			
			addChild(conteneur);
			conteneur.addChild(conteneurMask);
			depart_start=true;
		}
		public function gameStart(){
			addEventListener(Event.ENTER_FRAME, run);
		}
//FUNCTION RUN TOTAL==========================================================================================================================
		private function run(e:Event){
			if (depart_run == true || depart_start == true) { runDepart(); }
			if (exp_run == true || exp_start == true) { runExplication();}
			if (init_run == true || init_start == true) { runInit(); }
			if (init_vie == true) { runVie(); }
			if(jeu_run==true||jeu_start==true){runJeu();}
			if (gameOver_run == true || gameOver_start == true) { runGameOver(); }
			if (reset_run == true || reset_start == true) { runReset(); }
			if (fbAsk_run == true || fbAsk_start == true) { runFacebookAsk(); }
			if (store_run == true || store_start == true) { runLifeStore(); }
			if (message_run == true || message_start == true) { runMessageBoard(); }
			if (classement_run == true) { runClassement();}
			runUpdateBdd();
			runGestionSon();
		}
//FUNCTION RUN JEU=============================================================================================================================
	//RUN START===========================================================================================
		private function runDepart(){
			if (depart_start == true) {
				
				monFond.alpha = 0;
				conteneur.addChildAt(monFond,0);
			
				maTableJeu.creer(NBR_LIGNE,0);
				
				maTableJeu.alpha = 0;
				conteneur.addChild(maTableJeu);
				maTableJeu.name = "tableJeu";
				
				maTableScore.alpha = 0;
				conteneur.addChild(maTableScore);
				maTableScore.name = "tableScore";
				
				maTableClassement.alpha = 0;
				conteneur.addChild(maTableClassement);
				resetClassement = true;
				maTableClassement.name = "tableClassement";
				
				conteneur.addChild(monMenuDepart);
				monMenuDepart.mask = conteneurMask;
				monMenuDepart.name = "menuStart";
				
				portraitPaysage();
				monFacebookAsk.langue = langue;
				monMenuDepart.langue = langue;
				monAnnonce.langue = langue;
				
				depart_start=false;
				depart_run = true;
				
				getDiceCoin();
				monMenuDepart.startMenu();
			}
			if (conteneur.getChildByName("menuStart").visible == true) {
				if (monMenuDepart.voileOK == true &&
					monFond.alpha == 0&&
					maTableJeu.alpha == 0 &&
					maTableClassement.alpha == 0 &&
					maTableScore.alpha == 0 ) {
						
					monFond.alpha = 1;
					maTableJeu.alpha = 1;
					maTableScore.alpha = 1;	
					maTableClassement.alpha = 1;
				}
				if (monMenuDepart.finMenu == true) {
					classement_run = true;
					exp_start = true;
					depart_run = false;
					conteneur.removeChild(monMenuDepart);
					monMenuDepart = null;
				}
			}
		}
	//RUN CLASSEMENT======================================================================================
		private function runClassement() {
			maTableClassement.run();
			if ( resetClassement == true) {
				dispatchEvent(new Event("CHECK_FRIENDS"));
				resetClassement = false;
			}
			if (playerList_ok == true) {
				maTableClassement.init(joueurObj, friendList, playerList, langue);
				playerList_ok = false;
			}
			if (jeu_run == true) {
				var monScore:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("score"));
				maTableClassement.scoreJoueur = monScore.scoreTotal;
			}
		}
	//RUN EXPLICATION=====================================================================================
		private function runExplication() {
			if (exp_start == true) {
				conteneur.addChild(monExplication);
				monExplication.langue = langue;
				monExplication.initExp();
				exp_run = true;
				exp_start = false;
			}
			if (monExplication.finMenu == true) {
				init_vieStart = true;
				init_vie = true; 
				exp_run = false;
				monExplication.finMenu = false;
			}
		}
	//RUN VIE=============================================================================================
		private function runVie() {
			if (setVie_ok == true) {
				dispatchEvent(new Event("GET_VIES"));
				dispatchEvent(new Event("GET_SCORE"));
				init_vie = false;
			}
		}
		public function initVies(dateTime:Date) { 
			var mesVies:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("vies"));
			mesVies.tRetourVie = T_RETOUR_VIE;
			mesVies.init(dateTime);
			if(init_vieStart==false){init_start = true;}
			else { message_start = true; init_vieStart = false;}
		}
	//RUN INIT============================================================================================
		private function runInit() {
			var monTimer:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("timer"));
			var monScore:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("score"));
			var mesVies:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("vies"));
			
			if (init_start == true) {
				monAnnonce.mask = conteneurMask;
				monAnnonce.name = "annonce";
				conteneur.addChild(monAnnonce);
				monAnnonce.annonceDepart({nbrVie:mesVies.nbrVie,dateTime:mesVies.dateTimeRV,prixVie:PRIX_VIE});
				maTableScore.init();
				init_run = true;
				init_start=false;
			}
			if (monAnnonce.viePlus == true) {
				init_vie = true;
				init_run = false;
				monAnnonce.viePlus = false;
			}
			if (monAnnonce.departGame == true) {
				departGame = true;
				monAnnonce.departGame = false;
			}
			if (monAnnonce.acheterVie == true) {
				achatVie();
				monAnnonce.acheterVie = false;
			}
			if (monAnnonce.demanderVie == true) {
				typeDemandeFB = "lives";
				fbAsk_start = true;
				init_run=false;
				monAnnonce.demanderVie = false;
			}
			if (monAnnonce.acheterCoin == true) {
				store_start = true;
				init_run=false;
				monAnnonce.acheterCoin = false;
			}
			if (departGame == true) {
				monAnnonce.addAnimation_depart();
				mesVies.suprimerVie();
				maTableJeu.test = TEST;
				maTableJeu.init();
				monTimer.miseZero(TEMPS);
				departGame = false;
			}
			if(maTableJeu.initFin==true){
				if(monAnnonce.finAnnonce_depart==true&&
				   maTableJeu.initFin==true&&
				   maTableScore.initFin==true&&
				   monTimer.miseZeroFin == true) {
					   
					conteneur.removeChild(monAnnonce);
					monTimer.timerStart();
					jeu_start=true;
					init_run=false;
				}
			}
		}
	//RUN JEU=============================================================================================
		private function runJeu(){
			var monTimer:MovieClip=MovieClip(maTableScore.conteneurTimeScore.getChildByName("timer"));
			var monScore:MovieClip=MovieClip(maTableScore.conteneurTimeScore.getChildByName("score"));
			if(jeu_start==true){
				jeu_run=true;
				jeu_start=false;
			}
			maTableJeu.run(souris);
			maTableScore.run();
			maTableJeu.tauxChance=maTableScore.tauxChance;
			if(maTableJeu.diceSelectTic==true){maTableScore.ajouterDice(maTableJeu.diceSelect);}
			if (maTableJeu.diceSelectMBTic == true) { maTableScore.ajouterDice(maTableJeu.diceSelectMB); maTableJeu.diceSelectMBTic = false; }
			if(maTableJeu.diceSelectFin==true&&maTableScore.finCombo==false){
				maTableScore.suprimerDice();
			}
			if(maTableScore.scoreCount==true){maTableJeu.scoreCount=true;}else{maTableJeu.scoreCount=false;}
			if(maTableScore.scoreAffiche!=0){
				maTableJeu.afficheScore(maTableScore.scoreAffiche);
				maTableScore.scoreAffiche=0;
			}
			if (maTableScore.annonceBonus > 0) { 
				conteneur.addChild(monAnnonce);
				monAnnonce.annonceBonus(maTableScore.annonceBonus);
				maTableScore.annonceBonus=0;
			}
			if (monAnnonce.finAnnonce_bonus == true) {
				conteneur.removeChild(monAnnonce);
				monAnnonce.finAnnonce_bonus = false;
			}
		//GAMEOVER=============================================
			if (monTimer.finTemps == true) {
				resetClassement = true;
				gameOver_start=true;
				jeu_run=false;
				var monGO:MenuGameOver=new MenuGameOver();
				monGO.name="menuGameOver";
				conteneur.addChild(monGO);
				monGO.mask = conteneurMask;
				monGO.portraitPaysage();
				monGO.langue = langue;
			}
		}
	//RUN RESET============================================================================================
		private function runReset() {
			var monTimer:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("timer"));
			var monScore:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("score"));
			
			if (reset_start == true) {
				maTableJeu.run([[mouseX,mouseY],false]);
				maTableScore.suprimerDice();
				monTimer.timerStop();
				maTableJeu.init();
				reset_start = false;
				reset_run = true;
			}
			if (maTableScore.scoreCount == true) {
				maTableScore.suprimerDice();
				maTableScore.finCount(true);
			}
			if (reset_run == true) {
				if (maTableScore.scoreCount == false) {
					init_vie = true;
					reset_run = false;
				}
			}
		}
	//RUN GAME-OVER========================================================================================
		private function runGameOver(){
			var monTimer:MovieClip=MovieClip(maTableScore.conteneurTimeScore.getChildByName("timer"));
			var monScore:MovieClip=MovieClip(maTableScore.conteneurTimeScore.getChildByName("score"));
			var monGameOver:MovieClip=MovieClip(conteneur.getChildByName("menuGameOver"));
			
			if (gameOver_start == true) { 
				
				monGameOver.monComboEver_old = joueurObj.combo;
				monGameOver.monScoreEver_old = joueurObj.score;
				
				comboMaxFin = monScore.comboMaxFin;
				scoreTotalFin = monScore.scoreTotalFin;
				
				dispatchEvent(new Event("NEW_SCORE"));
				checkScores = true;
				
				monGameOver.joueurObj = joueurObj;
				monGameOver.friendList = friendList;
				monGameOver.monCombo = monScore.comboMaxFin;
				monGameOver.monScore = monScore.scoreTotalFin;
				monGameOver.monComboEver = joueurObj.combo;
				monGameOver.monScoreEver = joueurObj.score;
				monGameOver.bestScoreWorld = bestScoreWorld;
				
				maTableJeu.run([[mouseX,mouseY],false]);
				maTableScore.suprimerDice();
				gameOver_start=false;
				gameOver_run=true;
			}
			if(maTableScore.scoreCount==true){
				maTableScore.suprimerDice();
				maTableScore.finCount(true);
			}
			if(conteneur.getChildByName("menuGameOver").visible==true){
				monGameOver.run();
				
				if (monGameOver.envoiNot == true) {
					actionFin= "vie";
					monGameOver.envoiNot = false;
					removeGO();
				}
				if(monGameOver.envoiPartageFB==true){
					envoiMessage(monGameOver.messageFB);
					monGameOver.envoiPartageFB = false;
				}
				if(monGameOver.envoiInviteFB==true){
					actionFin = "FBask";
					monGameOver.envoiInviteFB = false;
					removeGO();
				}
				if (envoiFB_ok == true) {
					actionFin= "vie";
					envoiFB_ok = false;
					removeGO();
				}
				if (monGameOver.removeFini == true) {
					conteneur.removeChild(monGameOver);
					monTimer.finTemps = false;
					if(actionFin=="vie"){init_vie = true;actionFin=""}
					if (actionFin == "FBask") { typeDemandeFB = "invite"; fbAsk_start = true; actionFin = "";}
					gameOver_run = false;
					monGameOver.removeFini = false;
				}
				function removeGO() {
					monGameOver.finGameOver();
				}
			}
		}
	//FACEBOOK ASK======================================================================================================
		private function runFacebookAsk() {
			if (fbAsk_start == true) {
				invitableFriendList = [];
				if (typeDemandeFB == "invite") { dispatchEvent(new Event("DEMANDE_LISTE_FB")); }
				if (typeDemandeFB == "lives") {
					for (var f:int = 0; f < friendList.length; f++) {
						var friend:Object = { id:friendList[f].id, name:friendList[f].nom };
						invitableFriendList.push(friend);
						
					}
					askList_ok = true;
				}
				fbAsk_start = false;
				fbAsk_run = true;
			}
			if (askList_ok == true) {
				conteneur.addChild(monFacebookAsk);
				monFacebookAsk.mask = conteneurMask;
				monFacebookAsk.name = "facebookAsk";
				monFacebookAsk.init(invitableFriendList, typeDemandeFB);
				askList_ok = false;
			}
			if (monFacebookAsk.sendMessage == true) {
				envoiMessage(monFacebookAsk.messageFB);
				monFacebookAsk.sendMessage = false;
			}
			if (monFacebookAsk.notSend == true) {
				monFacebookAsk.removeMenu();
				monFacebookAsk.notSend = false;
			}
			if (envoiFB_ok == true) {
				monFacebookAsk.removeMenu();
				envoiFB_ok = false;
			}
			if (monFacebookAsk.removeFini == true) {
				conteneur.removeChild(monFacebookAsk);
				init_vie = true;
				fbAsk_run = false;
				monFacebookAsk.removeFini = false;
			}
		}
	//LIVES STORE=======================================================================================================
		private function runLifeStore() {
			
			if (store_start == true) {
				monLivesStore.langue = langue;
				dispatchEvent(new Event("VALEUR_DICE_COIN_FB"));
				store_start = false;
				store_run = true;
			}
			if (dCoinValeur_ok == true) {
				conteneur.addChild(monLivesStore);
				monLivesStore.mask = conteneurMask;
				monLivesStore.name = "livesStore";
				monLivesStore.init(dCoinValeur_obj);
				dCoinValeur_ok = false;
			}
			if (monLivesStore.fermer == true) {
				monLivesStore.removeMenu();
				monLivesStore.fermer = false;
			}
			if (monLivesStore.achatDiceCoin == true) {
				dCoinAchat_facture = monLivesStore.factureDCoin;
				dispatchEvent(new Event("ACHAT_DICE_COIN_FB"));
				monLivesStore.achatDiceCoin = false;
			}
			if (dCoinAchat_ok == true) {
				monLivesStore.achatDiceCoinConfirm(dCoinAchat_nbr)
				achatCoin(dCoinAchat_nbr);
				dCoinAchat_nbr = 0;
				dCoinAchat_ok = false;
			}
			if (monLivesStore.removeFini == true) {
				conteneur.removeChild(monLivesStore);
				init_vie = true;
				store_run = false;
				monLivesStore.removeFini = false;
			}
		}
	//MESSAGES AMIS=====================================================================================================
		private function runMessageBoard() {
			var mesVies:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("vies"));
			
			if (message_start == true) {
				conteneur.addChild(monMessageBoard);
				monMessageBoard.mask = conteneurMask;
				monMessageBoard.name = "messageBoard";
				monMessageBoard.langue = langue;
				monMessageBoard.init(messageList);
				message_run = true;
				message_start = false;
			}
			if (monMessageBoard.donneVie == true) {
				mesVies.ajouterVie();
				monMessageBoard.donneVie = false;
			}
			if (monMessageBoard.sendMessage == true) {
				envoiMessage(monMessageBoard.messageFB);
				monMessageBoard.sendMessage = false;
			}
			if (envoiFB_ok == true) {
				
				envoiFB_ok = false;
			}
			if (monMessageBoard.fermer == true) {
				monMessageBoard.removeMenu();
				monMessageBoard.fermer = false;
			}
			if (monMessageBoard.removeFini == true) {
				conteneur.removeChild(monMessageBoard);
				removeRequestList = [];
				removeRequestList = monMessageBoard.requestList;
				dispatchEvent(new Event("REMOVE_REQUEST_FB"));
				
				init_vie = true;
				message_run = false;
				monMessageBoard.removeFini = false;
			}
		}
	//GESTION COIN======================================================================================================
		private function achatVie() {
			getDiceCoin();
			addEventListener(Event.ENTER_FRAME, getDiceCoin_ok);
			function getDiceCoin_ok(e:Event) {
				if (coin_OK == true) {
					var resultat:int = nbrCoin -PRIX_VIE;
					if(resultat>=0){
						setDiceCoin(resultat);
						departGame = true;
					}else {
						store_start = true;
						init_run=false;
					}
					coin_OK = false;
					removeEventListener(Event.ENTER_FRAME, getDiceCoin_ok);
				}
			}
		}
		private function achatCoin(nbrCoinAchat:int) {
			var resultat:int = nbrCoin + nbrCoinAchat;
			setDiceCoin(resultat);
		}
		private function getDiceCoin() { 
			coin_OK = false;
			dispatchEvent(new Event("GET_COIN"));
		}
		private function setDiceCoin(nbrCoinTemp:int) {
			nbrCoin = nbrCoinTemp;
			dispatchEvent(new Event("SET_COIN"));
			afficherCoin(nbrCoin);
		}
		public function initCoin(nbrCoinTemp:int) {
			nbrCoin = nbrCoinTemp;
			afficherCoin(nbrCoinTemp);
			coin_OK = true;
		}
		private function afficherCoin(nbrCoinTemp:int) {
			var monScoreCombo:MovieClip = MovieClip(maTableScore.conteneur.getChildByName("scoreCombo"));
			monScoreCombo.afficherCoin(nbrCoinTemp);
		}
	//UPDATE VIE BDD========================================================================================================
		private function runUpdateBdd() {
			var mesVies:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("vies"));
			if (mesVies.bddUpdate == true) {
				if (TEST == false) {
					dateVie = mesVies.dateTimeBDD;
				}else {
					var dNow:Date = new Date();
					dateVie = dNow.fullYear + "-" + (dNow.month+1) + "-" + dNow.date+" " + dNow.hours + ":" + dNow.minutes + ":" + dNow.seconds;
				}
				dispatchEvent(new Event("SET_VIE"));
				setVie_ok = false;
				mesVies.bddUpdate = false;
			}
		}
	//ENVOI FB MESSAGE==================================================================================================
		private function envoiMessage(objMessage:Object) {
			messageFB = objMessage;
			dispatchEvent(new Event("ENVOI_MESSAGE_FB"));
			addEventListener(Event.ENTER_FRAME, envoiFB);
		}
		private function envoiFB(e:Event) {
			if (sendMessage_ok == true) {
				envoiFB_ok = true;
				sendMessage_ok = false;
				removeEventListener(Event.ENTER_FRAME, envoiFB);
			}
		}
	//RUN SOUNDS========================================================================================================
		private function runGestionSon() {
		//SON ON OFF-------------------------------------------------------------
			var monScoreCombo:MovieClip = MovieClip(maTableScore.conteneur.getChildByName("scoreCombo"));
			var btnSon:Object = Bouton(monScoreCombo.conteneur.getChildByName("btnSon"));
			if (btnSon.boutonClick == true) {
				maGestionSon.onOff();
				if (maGestionSon.soundOn == true) { btnSon.changerImage(1); } else { btnSon.changerImage(2); }
				btnSon.boutonClick = false;
			}
		//menu depart------------------------------------------------------------
			if (monExplication.sonMenuIn == true) { maGestionSon.menuIn(); monExplication.sonMenuIn = false; }
			if (monExplication.sonMenuOut == true) { maGestionSon.menuOut(); monExplication.sonMenuOut = false; }
		//annonce----------------------------------------------------------------
			if (monAnnonce.sonMenuIn == true) { maGestionSon.menuIn(); monAnnonce.sonMenuIn = false; }
			if (monAnnonce.sonMenuOut == true) { maGestionSon.menuOut(); monAnnonce.sonMenuOut = false; }
			if (monAnnonce.sonRoll == true) { maGestionSon.anonceRoll(); monAnnonce.sonRoll = false; }
			if (monAnnonce.sonRolling == true) { maGestionSon.anonceRolling(); monAnnonce.sonRolling = false;}
			if (monAnnonce.bipDepart == true) { 
				if (monAnnonce.bipDepart_nbr < 4) { maGestionSon.bipDepart(); }
				else { maGestionSon.bipDepart(true); monAnnonce.bipDepart_nbr = 0; }
				monAnnonce.bipDepart = false;
			}
		//dice--------------------------------------------------------------------
			if (maTableJeu.sonDice == true) { maGestionSon.diceTourne(maTableJeu.sonDice_nbr); maTableJeu.sonDice = false; }
		//multiBonus---------------------------------------------------------------
			var monMultiBonus:Object = Sprite(maTableScore.conteneur.getChildByName("multiBonus"));
			if (monMultiBonus.sonCouleur == true) { maGestionSon.couleurPlus(); monMultiBonus.sonCouleur = false; }
			if (monMultiBonus.sonForme == true) { maGestionSon.formePlus(); monMultiBonus.sonForme = false;}
		//score--------------------------------------------------------------------
			var monScore:MovieClip = MovieClip(maTableScore.conteneurTimeScore.getChildByName("score"));
			if (monScore.sonCtS == true) { maGestionSon.combScor(); monScore.sonCtS = false;}
		//game over----------------------------------------------------------------
			if(gameOver_run==true){
				var monGameOver:MovieClip = MovieClip(conteneur.getChildByName("menuGameOver"));
				if (monGameOver.sonMenuIn == true) { maGestionSon.menuIn(); monGameOver.sonMenuIn = false; }
				if (monGameOver.sonMenuOut == true) { maGestionSon.menuOut(); monGameOver.sonMenuOut = false; }
				if (monGameOver.sonGameOver == true) { maGestionSon.timesUp(); monGameOver.sonGameOver = false; }
			}
		//facebook ask--------------------------------------------------------------
			if (monFacebookAsk.sonMenuIn == true) { maGestionSon.menuIn(); monFacebookAsk.sonMenuIn = false; }
			if (monFacebookAsk.sonMenuOut == true) { maGestionSon.menuOut(); monFacebookAsk.sonMenuOut = false; }
		//message board-------------------------------------------------------------
			if (monMessageBoard.sonMenuIn == true) { maGestionSon.menuIn(); monMessageBoard.sonMenuIn = false; }
			if (monMessageBoard.sonMenuOut == true) { maGestionSon.menuOut(); monMessageBoard.sonMenuOut = false; }
		//store---------------------------------------------------------------------
			if (monLivesStore.sonMenuIn == true) { maGestionSon.menuIn(); monLivesStore.sonMenuIn = false; }
			if (monLivesStore.sonMenuOut == true) { maGestionSon.menuOut(); monLivesStore.sonMenuOut = false; }
		}
//FUNCTION GESTION SOURIS==================================================================================================================
		private function moveSouris(e:Event){souris[0]=mouseX;souris[1]=mouseY;}
		private function upSouris(e:Event){souris[2]=false;}
		private function downSouris(e:Event){souris[2]=true;}
//PORTRAIT PAYSAGE=================================================================================================
		private function portraitPaysage(){
			if(paysage==true){
				conteneur.rotation=90;
				conteneur.x = 960;
				
				maTableJeu.portraitPaysage();
				maTableScore.portraitPaysage();
				maTableClassement.portraitPaysage();
				monAnnonce.portraitPaysage();
				monMenuDepart.portraitPaysage();
				monExplication.portraitPaysage();
				monFacebookAsk.portraitPaysage();
				monMessageBoard.portraitPaysage();
				monLivesStore.portraitPaysage();
			}
		}
	}
}