package 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class Joueur	{
		
		public var console:String=""
		
		private const serveur:String = "db398444655.db.1and1.com";
		private const utilisateur:String = "dbo398444655";
		private const motDePasse:String = "270rt81master";
		private const base:String = "db398444655";
		
		private var idFB_fb:int = 0;
		private var nom_fb:String = "";
		private var friendList_fb:Object = new Object();
		
		public var idFB:int = 0;
		public var nom:String = "";
		public var friends:Array = new Array();
		public var playerList:Array = new Array();
		
		private var friendID:int = 0;
		
		public var bestScore:int = 0;
		public var bestCombo:int = 0;
		
		public var bestScoreWorld:int = 0;
		
		public var joueurObj:Object = new Object();
		public var facebookConnect:Boolean = false;
		
		private var date:String = "";
		public var dateTime:Date = new Date();
		
		private var objFacture:Object = new Object();
		private var objUpFacture:Object = new Object();
		private var listCheckFacture:Array = new Array();
		private var listDelFacture:Array = new Array();
		public var idFacture:int = 0;
		
		public var diceCoin:int = 0;
		
		private var demande:String = "";
		
		public var init_OK:Boolean = false;
		public var getVies_OK:Boolean = false;
		public var setVies_OK:Boolean = false;
		public var getCoin_OK:Boolean = false;
		public var setCoin_OK:Boolean = false;
		public var checkFacture_OK:Boolean = false;
		public var createFacture_OK:Boolean = false;
		public var upFacture_dcNBR:int = 0;
		public var upFacture_OK:Boolean = false;
		public var upFacture_ANUL:Boolean = false;
		public var upScore_OK:Boolean = false;
		
		public function Joueur() {
			
		}
		public function setJoueur(joueurFB:Object,friendListFB:Object) {
			idFB_fb = joueurFB.id;
			nom_fb = joueurFB.name; 
			friendList_fb = friendListFB;
			connect_bdd("checkUser");
		}
		public function checkFriends() {
			connect_bdd("checkFriends");
		}
		public function setScore(scoreTemp:int, comboTemp:int) { 
			if(scoreTemp>bestScore){bestScore = scoreTemp;connect_bdd("updateScore");}
			if (comboTemp > bestCombo) { bestCombo = comboTemp; connect_bdd("updateCombo"); }
			doneJoueurObj();
		}
		public function getScore() {
			for (var f:int = 0; f < friends.length; f++) {
				friendID = friends[f].id;
				connect_bdd("getScore");
			}
		}
		public function setVie(dateTemp:String) {
			date = dateTemp;
			connect_bdd("setVie");
		}
		public function getVie() {
			connect_bdd("getVie");
		}
		public function setCoin(coinTemp:int) {
			diceCoin = coinTemp;
			connect_bdd("setCoin");
		}
		public function getCoin() {
			connect_bdd("getCoin");
		}
		public function createFacture(objFactureTemp:Object) {
			objFacture = objFactureTemp;
			connect_bdd("createFacture");
		}
		public function updateFacture(objUpFactTemp:Object) {
			objUpFacture = objUpFactTemp;
			connect_bdd("updateFacture");
		}
		private function connect_bdd(demande:String){
			var chargeur:URLLoader = new URLLoader();
			var urlString:String = "";
			if (facebookConnect == false) {
				urlString="https://www.blackmountainstudio.fr/ShapeDiceRolling/GestionJoueur.php";
			}else {
				urlString="GestionJoueur.php";
			}
			var urlRq:URLRequest = new URLRequest(urlString);
			
			var connect_donnee:URLVariables = new URLVariables();
			connect_donnee.serveur = serveur;
			connect_donnee.utilisateur = utilisateur;
			connect_donnee.motDePasse = motDePasse;
			connect_donnee.base = base;
			
			switch(demande) {
				case "checkUser":
					connect_donnee.method = "checkUser";
					connect_donnee.idFB = idFB_fb;
					connect_donnee.nom = nom_fb;
				;break;
				case "checkFriends":
					connect_donnee.method = "checkFriends";
				;break;
				case "updateScore":
					connect_donnee.method = "updateScore";
					connect_donnee.idFB = idFB; 
					connect_donnee.nom = nom; 
					connect_donnee.score = bestScore; 
				;break;
				case "updateCombo":
					connect_donnee.method = "updateCombo";
					connect_donnee.idFB = idFB; 
					connect_donnee.nom = nom; 
					connect_donnee.combo = bestCombo; 
				;break;
				case "getScore":
					connect_donnee.method = "getScore";
					connect_donnee.idFB = friendID;
				;break;
				case "setVie":
					connect_donnee.method = "setVie";
					connect_donnee.idFB = idFB; 
					connect_donnee.date = date;
				;break;
				case "getVie":
					connect_donnee.method = "getVie";
					connect_donnee.idFB = idFB; 
				;break;
				case "setCoin":
					connect_donnee.method = "setCoin";
					connect_donnee.idFB = idFB; 
					connect_donnee.diceCoin = diceCoin;
				;break;
				case "getCoin":
					connect_donnee.method = "getCoin";
					connect_donnee.idFB = idFB; 
				;break;
				case "checkFacture":
					connect_donnee.idFB = idFB;
					connect_donnee.nom = nom;
				;break;
				case "createFacture":
					connect_donnee.method = "createFacture";
					connect_donnee.idFB = idFB;
					connect_donnee.nom = nom;
					connect_donnee.date = objFacture.date;
					connect_donnee.monnaie = objFacture.monnaie;
					connect_donnee.montant = objFacture.montant;
					connect_donnee.nbrCoin = objFacture.nbrCoin;
				;break;
				case "updateFacture":
					connect_donnee.method = "updateFacture";
					connect_donnee.idRequest = objUpFacture.idRequest;
					connect_donnee.statut = objUpFacture.statut;
					connect_donnee.idPayment = objUpFacture.idPayment;
					connect_donnee.signedRequest = objUpFacture.signedRequest;
				;break;
			}
			urlRq.method = URLRequestMethod.POST;
			urlRq.data = connect_donnee;
			
			chargeur.addEventListener(Event.COMPLETE, finChargement);
			chargeur.addEventListener(IOErrorEvent.IO_ERROR, erreurChargement);
			chargeur.load(urlRq);
			
			function finChargement(e:Event) {
				
				//trace("Ask: " + demande, "retourPHP: " + e.target.data);
				
				switch(demande) {
					case "checkUser": 
						var joueur_bdd:URLVariables = new URLVariables( e.target.data );
						idFB = joueur_bdd.idFB;
						nom = joueur_bdd.nom;
						bestScore = joueur_bdd.score;
						bestCombo = joueur_bdd.combo;
						connect_bdd("checkFriends");
					;break;
					case "checkFriends":
						playerList = [];
						friends = [];
						var friendsTemp:Array = new Array();
						var ftTab:Array = e.target.data.split("##");
						for (var f:int = 0; f < ftTab.length;f++){
							var ft:URLVariables = new URLVariables( ftTab[f] );
							friendsTemp[f] = ft;
							var listObjTemp:Object = {
								"id":friendsTemp[f].idFB,
								"nom":friendsTemp[f].nom,
								"score":friendsTemp[f].score,
								"combo":friendsTemp[f].combo
							}
							playerList.push(listObjTemp);
							if (friendsTemp[f].score > bestScoreWorld) {bestScoreWorld = friendsTemp[f].score;}
							for (var F:int = 0; F < friendList_fb.length; F++ ) {
								if (friendsTemp[f].idFB == friendList_fb[F].id &&
									idFB_fb != friendList_fb[F].id) {
									var friendObjTemp:Object = {
										"id":friendList_fb[F].id,
										"nom":friendList_fb[F].name,
										"score":friendsTemp[f].score,
										"combo":friendsTemp[f].combo
									}
									friends.push(friendObjTemp);
								}
							}
						}
			//TRACE---------------------------------------------------------------------------------------
						/*for (var c:int; c < playerList.length; c++) {
							if(c==0){trace("me", idFB, nom, bestScore, bestCombo);}
							trace("player",playerList[c].id,playerList[c].nom,playerList[c].score,playerList[c].combo);
						}*/
			//--------------------------------------------------------------------------------------------
						init_OK=true;
					;break;
					case "getScore":
						var upFriend:URLVariables = new URLVariables( e.target.data );
						for (var uf:int = 0; uf < friends.length; uf++) {
							if (upFriend.idFB == friends[uf].id) {
								friends[uf].nom = upFriend.nom;
								friends[uf].score = upFriend.score;
								friends[uf].combo = upFriend.combo;
							}
						}
						upScore_OK;
					;break;
					case "setVie":
						setVies_OK = true;
					;break;
					case "getVie":
						var vtTab:URLVariables = new URLVariables( e.target.data );
						if (vtTab.time_vie == "") { 
							var dNow:Date=new Date();
							dateTime = dNow;
							var dNowString:String=dNow.fullYear + "-" + (dNow.month+1) + "-" + dNow.date+" " + dNow.hours + ":" + dNow.minutes + ":" + dNow.seconds;
							setVie(dNowString);
						}else{dateTime = TransformEnDate(vtTab.time_vie);}
						getVies_OK = true;
					;break;
					case "setCoin":
						setCoin_OK = true;
					;break;
					case "getCoin":
						var diceCoinTab:URLVariables = new URLVariables( e.target.data );
						if (diceCoinTab.dice_coin == "") {
							diceCoin = 0;
						}else{diceCoin = diceCoinTab.dice_coin;}
						getCoin_OK = true;
					;break;
					case "checkFacture":
						var cfTab:Array = e.target.data.split("##");
						/*for ( var c:int = 0; c < cfTab.length; c++) {
							var cf:URLVariables = new URLVariables( cfTab[c] );
							var fact:Object = new Object();
							fact.idRequest = cf.idRequest;
							fact.idfb = cf.idfb;
							fact.nom = cf.nom;
							fact.datePayment = cf.datePayment;
							fact.monnaie = cf.monnaie;
							fact.nbrCoin = cf.nbrCoin;
							fact.statut = cf.statut;
							fact.idPayment = cf.idPayment;
							fact.signedRequest = cf.signedRequest;
							listCheckFacture.push(fact);
						}*/
						checkFacture_OK = true;
					;break;
					case "createFacture":
						var idRequestTab:URLVariables = new URLVariables( e.target.data );
						idFacture = idRequestTab.id_request;
						createFacture_OK = true;
					;break;
					case "updateFacture":
						var factTab:URLVariables = new URLVariables( e.target.data );
						var statutTemp:String=factTab.statut;
						if (statutTemp == "completed") {
							upFacture_dcNBR = factTab.nbr_dice_coin;
							upFacture_OK = true;
						}
						if (statutTemp == "failed") {
							upFacture_ANUL = true;
						}
					;break;
				}
			}
			doneJoueurObj();
	//=======================================================================================================
			function TransformEnDate(date:String):Date {
				var split:Array = date.split(" ");
				var splitDate:Array = split[0].split("-");
				var splitTime:Array = split[1].split(":");
							
				return new Date(splitDate[0],splitDate[1] - 1,splitDate[2],splitTime[0],splitTime[1],splitTime[2]);
			}
			function erreurChargement(e:IOErrorEvent) {
				trace("erreurChargement");
				console = "erreurChargement";
				init_OK = true;
				getVies_OK = true;
			}
		}
		private function doneJoueurObj() {
			joueurObj.nom = nom;
			joueurObj.id = idFB;
			joueurObj.score = bestScore;
			joueurObj.combo = bestCombo;
		}
	}
}