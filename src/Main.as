package 
{
	import flash.display.MovieClip
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	[SWF(width='960',height='640',backgroundColor='0xffffff',frameRate='40')]
	public class Main extends Sprite {
		
		[Embed(source="Libs/FondIntro.png")]
		var FondIntro:Class;
		private var monFondIntro:Bitmap = new FondIntro();
		private var presentText:TexteScore = new TexteScore("Present", 40, 0x000000, true, true, false);
		
		private var conteneurMask:Bitmap = new Bitmap(new BitmapData(1088, 1088, false, 0xffffff));
		
		private var monTest:Test = new Test();
		
		private var monAPIfacebook:APIfacebook = new APIfacebook();
		public var monJoueur:Joueur = new Joueur();
		private var monGame:Game = new Game();
		
		private var bddBlockEnd:Boolean = false;
		private var tempoBDD:int = 0;
		
		private var startTimer:int = 0;
		
		public function Main() {
			addEventListener(Event.ENTER_FRAME, startInitTimer);
			initLogo();
			init();
			//consoleTest();
			//addChild(monTest);
			monGame.addEventListener("NEW_SCORE", newScore);
			monGame.addEventListener("CHECK_FRIENDS", checkFriends);
			monGame.addEventListener("GET_SCORE", getScore);
			monGame.addEventListener("DEMANDE_LISTE_FB", demandeListe);
			monGame.addEventListener("ENVOI_MESSAGE_FB", envoiMessage);
			monGame.addEventListener("REMOVE_REQUEST_FB", removeRequest);
			monGame.addEventListener("VALEUR_DICE_COIN_FB", valeurDiceCoin);
			monGame.addEventListener("ACHAT_DICE_COIN_FB", achatDiceCoin);
			monGame.addEventListener("SET_VIE", setVie);
			monGame.addEventListener("GET_VIES", getVies);
			monGame.addEventListener("SET_COIN", setCoin);
			monGame.addEventListener("GET_COIN", getCoin);
			//startInit();
		}
		private function startInit() {
			addEventListener(Event.ENTER_FRAME, startGame);	
		}
		private function startInitTimer(e:Event) { startTimer++; }
		private function startGame(e:Event) {
			if (startTimer >= 80) {
				monGame.langue = monAPIfacebook.langue;
				monGame.joueurObj = monJoueur.joueurObj;
				monGame.friendList = monJoueur.friends;
				monGame.playerList = monJoueur.playerList;
				monGame.messageList = monAPIfacebook.messageList;
				monGame.invitableFriendList = monAPIfacebook.invitableFriendList;
				monGame.bestScoreWorld = monJoueur.bestScoreWorld;
				addChildAt(monGame, 0);
				monGame.gameStart();
				removeChild(monFondIntro);BitmapData(monFondIntro.bitmapData).dispose();
				removeChild(presentText); presentText = null;
				removeEventListener(Event.ENTER_FRAME, startInitTimer);
				removeEventListener(Event.ENTER_FRAME, startGame);
				startTimer = 0;
			}
		}
//INIT LOGO FOND========================================================================
		private function initLogo() {
			monFondIntro.x = - 8;
			monFondIntro.y = - 8;
			addChild(monFondIntro);
			presentText.x = this.width / 2 - presentText.width / 2;
			presentText.y = this.height / 2 + 70;
			addChild(presentText);
		}
//INIT  ================================================================================
		private function init() { 
			var bdd_start:Boolean = false;
			monAPIfacebook.initFB(); 
			addEventListener(Event.ENTER_FRAME, initFB_ok);
			function initFB_ok(e:Event) {
		//CONNEXION OK============================================
				if (monAPIfacebook.initMe_OK == true && monAPIfacebook.initFriends_OK == true && bdd_start == false) {
					monJoueur.facebookConnect = true;
					monJoueur.setJoueur(monAPIfacebook.user, monAPIfacebook.friendList);
					bdd_start = true;
				}
		//UNCONNECTED=============================================
				if (monAPIfacebook.init_false == true && bdd_start==false) {
					monJoueur.setJoueur(monAPIfacebook.user, monAPIfacebook.friendList);
					bdd_start = true;
				}
	//INIT OK==>START======================================================
				if (monJoueur.init_OK == true) {
					startInit();
					removeEventListener(Event.ENTER_FRAME, initFB_ok);
				}
			}
		}
//GESTION JOUEUR BASE DE DONNEE=======================================================================
	//set score---------------------------------------------
		private function newScore(e:Event) {
			var scoreMax:int = monGame.scoreTotalFin;
			var comboMax:int = monGame.comboMaxFin;
			monJoueur.setScore(scoreMax, comboMax);
			monGame.joueurObj = monJoueur.joueurObj;
		}
	//check friends----------------------------------------
		private function checkFriends(e:Event) {
			monJoueur.checkFriends();
			addEventListener(Event.ENTER_FRAME, checkFriends_ok);
			function checkFriends_ok(e:Event) {
				if (monJoueur.init_OK == true) {
					monGame.friendList = monJoueur.friends;
					monGame.playerList = monJoueur.playerList;
					monGame.playerList_ok = true;
					removeEventListener(Event.ENTER_FRAME, checkFriends_ok);
					monJoueur.init_OK = false;
				}
			}
		}
	//get score--------------------------------------------
		private function getScore(e:Event) {
			monJoueur.getScore();
			addEventListener(Event.ENTER_FRAME, getScore_ok);
			function getScore_ok(e:Event) {
				if (monJoueur.upScore_OK == true) {
					monGame.friendList = monJoueur.friends;
					removeEventListener(Event.ENTER_FRAME, getScore_ok);
					monJoueur.upScore_OK = false;
				}
			}
		}
	//set vie ------------------------------------------
		private function setVie(e:Event) {
			var dateVie:String = monGame.dateVie;
			monJoueur.setVie(dateVie);
			addEventListener(Event.ENTER_FRAME, setVie_ok);
			function setVie_ok(e:Event) {
				if (monJoueur.setVies_OK == true) {
					monGame.setVie_ok=true;
					removeEventListener(Event.ENTER_FRAME, setVie_ok);
					monJoueur.setVies_OK = false;
				}
			}
		}
	//get vies-------------------------------------------
		private function getVies(e:Event) {
			bddBlockEnd = false;
			bddBlock();
			monJoueur.getVie();
			addEventListener(Event.ENTER_FRAME, getVies_ok);
			function getVies_ok(e:Event) {
				if (monJoueur.getVies_OK == true) {
					bddUnblock();
					monGame.initVies(monJoueur.dateTime);
					removeEventListener(Event.ENTER_FRAME, getVies_ok);
					monJoueur.getVies_OK = false;
				}
			}
		}
	//set coin------------------------------------------
		private function setCoin(e:Event) {
			var diceCoin:int = monGame.nbrCoin;
			monJoueur.setCoin(diceCoin);
			addEventListener(Event.ENTER_FRAME, setCoin_ok);
			function setCoin_ok(e:Event) {
				if (monJoueur.setCoin_OK == true) {
					monGame.setCoin_ok=true;
					removeEventListener(Event.ENTER_FRAME, setCoin_ok);
					monJoueur.setCoin_OK = false;
				}
			}
		}
	//get coin-------------------------------------------
		private function getCoin(e:Event) {
			monJoueur.getCoin();
			addEventListener(Event.ENTER_FRAME, getCoin_ok);
			function getCoin_ok(e:Event) {
				if (monJoueur.getCoin_OK == true) {
					monGame.initCoin(monJoueur.diceCoin);
					removeEventListener(Event.ENTER_FRAME, getCoin_ok);
					monJoueur.getCoin_OK = false;
				}
			}
		}
//GESTION FACEBOOK=====================================================================
	//DEMANDE LISTE----------------------------------------------------------
		private function demandeListe(e:Event) { 
			addEventListener(Event.ENTER_FRAME, askList_ok);
			monAPIfacebook.askListeFriends(monGame.typeDemandeFB);
			block();
		}
		private function askList_ok(e:Event) {
			if (monAPIfacebook.askList_OK==true) {
				monGame.invitableFriendList = monAPIfacebook.invitableFriendList;
				monGame.askList_ok = true;
				removeEventListener(Event.ENTER_FRAME, askList_ok);
				monAPIfacebook.askList_OK = false;
				unblock();
			}
		}
	//ENVOIE MESSAGE----------------------------------------------------------
		private function envoiMessage(e:Event) {
			addEventListener(Event.ENTER_FRAME, sendMessage_ok);
			monAPIfacebook.envoiMessage(monGame.messageFB);
			block();
		}
		private function sendMessage_ok(e:Event) {
			if (monAPIfacebook.sendMessage_OK == true) {
				monGame.sendMessage_ok = true;
				removeEventListener(Event.ENTER_FRAME, sendMessage_ok);
				unblock();
				monAPIfacebook.sendMessage_OK = false;
			}
		}
	//SUPRIMER REQUETTE-------------------------------------------------------
		private function removeRequest(e:Event) {
			monAPIfacebook.removeRequest(monGame.removeRequestList);
		}
	//VALEUR DICE COIN--------------------------------------------------------
		private function valeurDiceCoin(e:Event) {
			addEventListener(Event.ENTER_FRAME, valeur_ok);
			monAPIfacebook.valeurDiceCoin();
			block();
		}
		private function valeur_ok(e:Event) {
			if (monAPIfacebook.dCoinValeur_OK == true) { 
				monGame.dCoinValeur_obj = monAPIfacebook.dCoinValeur_OBJ;
				monGame.dCoinValeur_ok = true;
				removeEventListener(Event.ENTER_FRAME, valeur_ok);
				monAPIfacebook.dCoinValeur_OK = false;
				unblock();
			}
		}
//GESTION PAYMENT======================================================================
		private function achatDiceCoin(e:Event) {
			block();
			var fact:Object = monGame.dCoinAchat_facture;
			monJoueur.createFacture(fact);
			addEventListener(Event.ENTER_FRAME, achat_run);
		}	
		private function achat_run(e:Event) {
			if (monJoueur.createFacture_OK == true) {
				var achatObject:Object = new Object();
				achatObject.id = monJoueur.idFacture;
				achatObject.nbrCoin = monGame.dCoinAchat_facture.nbrCoin;
				monAPIfacebook.achatDiceCoin(achatObject);
				monJoueur.createFacture_OK = false;
			}
			if (monAPIfacebook.dCoinAchat_OK == true) {
				var upFact:Object = new Object();
				upFact = monAPIfacebook.upFacture;
				monJoueur.updateFacture(upFact);
				monAPIfacebook.dCoinAchat_OK = false;
			}
			if (monJoueur.upFacture_ANUL == true) {
				unblock();
				removeEventListener(Event.ENTER_FRAME, achat_run);
				monJoueur.upFacture_ANUL = false;
			}
			if (monJoueur.upFacture_OK == true) {
				monGame.dCoinAchat_nbr = monJoueur.upFacture_dcNBR;
				monGame.dCoinAchat_ok = true;
				unblock();
				removeEventListener(Event.ENTER_FRAME, achat_run);
				monJoueur.upFacture_OK = false;
			}
		}
		/*private function achat_ok(e:Event) {
			if (monAPIfacebook.dCoinAchat_OK == true) {
				monGame.dCoinAchat_nbr = monAPIfacebook.dCoinAchat_NBR;
				monGame.dCoinAchat_ok = true;
				removeEventListener(Event.ENTER_FRAME, achat_ok);
				monAPIfacebook.dCoinAchat_OK = false;
				unblock();
			}
			removeEventListener(Event.ENTER_FRAME, achat_ok);
		}*/
//CONSOLE TEST=========================================================================
		private function consoleTest() {
			addEventListener(Event.ENTER_FRAME, testing);
			function testing(e:Event) {
				if (monAPIfacebook.consoleFB != "") {
					monTest.FBlog(monAPIfacebook.consoleFB);
					monAPIfacebook.consoleFB = "";
				}
				if (monJoueur.console != "") {
					monTest.console(monJoueur.console);
					monJoueur.console = "";
				}
			}
		}
//LOADING==============================================================================
	//facebook----------------------------------------------------------
		private function block() {
			conteneurMask.x = -64;
			conteneurMask.y = -64;
			conteneurMask.alpha = 0.5;
			addChild(conteneurMask);
			monGame.mouseChildren = false;
		}
		private function unblock() {
			removeChild(conteneurMask);
			monGame.mouseChildren = true;
		}
	//base de donnee----------------------------------------------------
		private function bddBlock() {
			var tempoBDD:int = 0;
			addEventListener(Event.ENTER_FRAME, tempo);
			
		}
		private function bddUnblock() {
			bddBlockEnd = true;
			if (this.getChildByName("loading") is DisplayObject == true) { removeChild(this.getChildByName("loading")); }
			tempoBDD = 0;
			removeEventListener(Event.ENTER_FRAME, tempo);
			monGame.mouseChildren = true;
		}
		private function tempo(e:Event) {
			if (tempoBDD < 40) { tempoBDD++; }
			else if (bddBlockEnd == false && MovieClip(getChildByName("loading")) is DisplayObject == false) {
				var monLoading:LoadingCircle = new LoadingCircle();
				monLoading.name = "loading";
				monLoading.x = stage.width / 2 - monLoading.width / 2;
				monLoading.y = stage.height / 2 - monLoading.height / 2;
				monLoading.alpha = 0.7;
				addChild(monLoading);
				monGame.mouseChildren = false;
				tempoBDD = 0;
				removeEventListener(Event.ENTER_FRAME, tempo);
			}
		}
	}
}
