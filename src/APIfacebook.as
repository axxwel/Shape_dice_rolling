package 
{
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	public class APIfacebook{
		
		public var consoleFB:String = "";
		
		public var init_false:Boolean = false;
		public var initMe_OK:Boolean = false;
		public var initFriends_OK:Boolean = false;
		public var initMessage_OK:Boolean = false;
		
		public var askList_OK:Boolean = false;
		public var sendMessage_OK:Boolean = false;
		
		public var dCoinAchat_NBR:int = 0;
		public var upFacture:Object = new Object();
		public var dCoinAchat_OK:Boolean = false;
		public var dCoinAchat_NOT:Boolean = false;
		
		public var dCoinValeur_OBJ:Object = new Object();
		public var dCoinValeur_OK:Boolean = false;
		
		public var user:Object = new Object();
		public var friendList:Object = new Object();
		public var messageList:Object = new Object();
		public var invitableFriendList:Object = new Object();
		public var langue:String = "en_US";
		private var monLangage:Langage = new Langage();
		
		public function APIfacebook() {
			
		}
//INIT FACEBOOK==============================================================================
		public function initFB(){
			if(ExternalInterface.available){
				if (init_false == false || (initMe_OK == false && initFriends_OK == false && initMessage_OK == false)) {
					ExternalInterface.addCallback("retourFBme", retourFBme);
					ExternalInterface.addCallback("retourFBfriends", retourFBfriends);
					ExternalInterface.addCallback("retourFBrequests", retourFBmessages);
					ExternalInterface.call("checkFB");
				}
				if (initMe_OK == true && initFriends_OK == true && initMessage_OK == true) {
					ExternalInterface.addCallback("retourFBme", null);
					ExternalInterface.addCallback("retourFBfriends", null);
					ExternalInterface.addCallback("retourFBrequests", null);
				}
			}
			else {
				consoleFB = "Not connected";
				init_false = true;
				testObjects();
			}
			Security.allowDomain("www.blackmountainstudio.fr/ShapeDiceRolling/");
		}
	//RETOUR------------------------------------------------------------
		private function retourFBme(obj:Object):void {
			user = obj;
			langue = obj.locale;
			consoleFB = obj.name;
			initMe_OK = true;
		}
		private function retourFBfriends(obj:Object):void {
			friendList = obj.data;
			initFriends_OK = true;
		}
		private function retourFBmessages(obj:Object):void {
			messageList = obj.data;
			initMessage_OK = true;
		}
//ASK INVITABLE FRIEND====================================================================================
		public function askListeFriends(typeDemande:String) {
			if (typeDemande == "invite") { listeFriends_invite(); }	
		}
	//ASK LISTE INVITE======================================================================
		private function listeFriends_invite() {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("retourFBinvitableFriends", retourFBlist);
				ExternalInterface.call("getFBinvitableFriendList");
			}
			else {
				consoleFB = "Not connected";
				askList_OK = true;
			}
			Security.allowDomain("www.blackmountainstudio.fr/ShapeDiceRolling/");
		}
	//RETOUR--------------------------------------------------------------------
		private function retourFBlist(obj:Object) {
			invitableFriendList = obj.data;
			askList_OK = true;
		}
//ENVOI MESSAGE============================================================================================
		public function envoiMessage(objMessage:Object) {	
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("retourFBmessage", retourFBmessage);
				ExternalInterface.call("sendFBmessage",objMessage);
			}
			else {
				consoleFB = "Not connected";
				sendMessage_OK = true;
			}
			Security.allowDomain("www.blackmountainstudio.fr/ShapeDiceRolling/");
		}
	//RETOUR--------------------------------------------------------------------
		private function retourFBmessage(obj:Object) {
			sendMessage_OK = true;
		}
//SUPRIMER REQUETTES========================================================================================
		public function removeRequest(objRequest:Array) {
			if (ExternalInterface.available) {
				ExternalInterface.call("deleteRequest",objRequest);
			}
			Security.allowDomain("www.blackmountainstudio.fr/ShapeDiceRolling/");
		}
//VALEUR DICE COIN==========================================================================================
		public function valeurDiceCoin() {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("retourFBvaleur", retourFBvaleur);
				ExternalInterface.call("dCoinFBvaleur");
			}
			else {
				consoleFB = "Not connected";
				dCoinValeur_OK = true;
			}
			Security.allowDomain("www.blackmountainstudio.fr/ShapeDiceRolling/");
		}
	//RETOUR--------------------------------------------------------------------
		private function retourFBvaleur(obj:Object) {
			dCoinValeur_OBJ = obj;
			dCoinValeur_OK = true;
		}
//ACHAT DICE COIN==========================================================================================
		public function achatDiceCoin(objAchat:Object) {
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("retourFBachat", retourFBachat);
				ExternalInterface.call("dCoinFBachat",objAchat);
			}
			else {
				consoleFB = "Not connected";
				upFacture.idRequest = objAchat.id;
				upFacture.statut = "completed";
				upFacture.idPayment = null;
				upFacture.signedRequest = null;
				dCoinAchat_OK = true;
			}
			Security.allowDomain("www.blackmountainstudio.fr/ShapeDiceRolling/");
		}
	//RETOUR--------------------------------------------------------------------
		private function retourFBachat(obj:Object) {
			if (obj.data == undefined) {
				upFacture.idRequest = obj.idRequest;
				upFacture.statut = "failed";
				upFacture.idPayment = null;
				upFacture.signedRequest = null;
			}
			if(obj.data){
				upFacture.idRequest = obj.idRequest;
				upFacture.statut = obj.status;
				upFacture.idPayment = obj.payment_id;
				upFacture.signedRequest = obj.signed_request;
			}
			dCoinAchat_OK = true;
		}

//RENVOIE OBJECTS TEST=====================================================================================
		private function testObjects() {
			user = {
				id:"7357", 
				name: "test Tesssssssssst"
			}
			friendList = [ 
				{"name": "test", "id": "7357" },
				{"name": "test1", "id": "73571" },
				{"name": "test2", "id": "73572" },
				{"name": "test3", "id": "73573" },
				{"name": "test4", "id": "73574" },
				{"name": "test5", "id": "73575" }
			];
			messageList = [
				{ "created_time": "2014-07-03T05:44:22+0000", "from": { "id":"754943149", "name":"invit" } },
				{ "created_time": "2014-07-03T05:44:22+0000", "data":"type=needLife", "from": { "id":"754943149", "name":"MessageNeed" } },
				{ "created_time": "2014-07-03T05:44:22+0000", "data":"type=needLife", "from": { "id":"754943149", "name":"MessageNeed" } },
				{ "created_time": "2014-07-03T05:44:22+0000", "data":"type=giveLife", "from": { "id":"754943149", "name":"MessageGive" } },
				{ "created_time": "2014-07-03T05:44:22+0000", "data":"type=giveLife", "from": { "id":"754943149", "name":"MessageGive" } },
				{ "created_time": "2014-07-03T05:44:22+0000", "data":"type=score&data=12007", "from": { "id":"754943149", "name":"newScore" } },
				{ "created_time": "2014-07-03T05:44:22+0000", "data":"type=score&data=200156574984", "from": { "id":"754943149", "name":"newScore" } }
			];
			invitableFriendList= [
				{ "name": "teeeeeeeeeeeeeeeeeeeest1 teeeeeeeest1", "id": "754943149" }, { "name": "test2", "id": "754943149" }, { "name": "test3", "id": "754943149" }, { "name": "test4", "id": "754943149" }, { "name": "test5", "id": "754943149" },
				{ "name": "test6", "id": "754943149" }, { "name": "test7", "id": "754943149" }, { "name": "test8", "id": "754943149" }, { "name": "test9", "id": "754943149" }, { "name": "test10", "id": "754943149" },
				{ "name": "test11", "id": "754943149" }, { "name": "test12", "id": "754943149" }, { "name": "test13", "id": "754943149" }, { "name": "test14", "id": "754943149" }, { "name": "test15", "id": "754943149" },
				{ "name": "test16", "id": "754943149" }, { "name": "test17", "id": "754943149" }, { "name": "test18", "id": "754943149" }, { "name": "test19", "id": "754943149" }, { "name": "test20", "id": "754943149" },
			];
			langue = "fr_FR";
			dCoinValeur_OBJ = { "currency": "EUR", "price": "0.05" };
		}
	}
}