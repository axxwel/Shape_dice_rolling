package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.URLVariables;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.geom.Rectangle;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class  MessageAmis extends MovieClip{
		
		private var monLangage:Langage = new Langage();
		public var langue:String = "en_US";
		
		private var conteneurMenu:Sprite = new Sprite();
		private var conteneurMessage:Sprite = new Sprite();
		private var conteneurMessageMask:Bitmap = new Bitmap(new BitmapData(464, 288, false, 0xffffff));
		
		private var maScrollBar:Bouton = new Bouton("ScrollFBAsk");
		private var monBoutonUp:Bouton = new Bouton("UpDownFBAsk");
		private var monBoutonDown:Bouton = new Bouton("UpDownFBAsk");
		
		private var monFondMenu:FondMenu = new FondMenu();
		private var monFondFBAsk:FondFBAsk = new FondFBAsk();
		
		private var monBoutonFermer:Bouton = new Bouton("Fermer");
		private var monBoutonAccept:Bouton = new Bouton("Bleu");
		
		private var titre:TexteScore = new TexteScore("", 40, 0x1e7fcb, true, true, true, 0xf7ff3c);
		
		private var sourisDown:Boolean = false;
		private var sourisScroll:Boolean = false;
		
		public var fermer:Boolean = false;
		public var removeFini:Boolean = false;
		
		private var allMessageClicked:Boolean = false;
		
		private var hauteur:int=640;
		private var largeur:int = 960;
		
		private var messageList:Array = new Array();
		public var requestList:Array = new Array();
		
		public var messageFB:Object = new Object();
		public var sendMessage:Boolean = false;
		public var donneVie:Boolean = false;
		
		public var sonMenuIn:Boolean = false;
		public var sonMenuOut:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontCooper:Class;
		
		public function MessageAmis()  {
			
		}
		public function init(messageListTemp:Object) {
			monLangage.setLangage(langue);
			for (var d:int = 0; d < messageListTemp.length; d++) {
				messageListTemp[d].data=decodeType(messageListTemp[d].data);
			}
			traiterMessage(messageListTemp);
			traiterRequette(messageListTemp);
			
			if (messageList.length >= 1) { 
				initMenu();
				createMessageBox();
			}
			else { removeFini = true;}
		}
		private function initMenu() {
			titre.newTexte(monLangage.messageBoard)
			titre.x = 24;
			titre.y = 142;
			
			monFondFBAsk.x = 24;
			monFondFBAsk.y = 172;
			
			conteneurMessage.x = 32;
			conteneurMessage.y = 180;
			conteneurMessageMask.x = 32;
			conteneurMessageMask.y = 180;
			
			maScrollBar.x = 504;
			maScrollBar.y = 180;
			maScrollBar.width = 32;
			maScrollBar.height = 48;
			
			monBoutonUp.x = 504;
			monBoutonUp.y = 140;
			monBoutonUp.width = 32;
			monBoutonUp.height = 32;
			
			monBoutonDown.x = 504;
			monBoutonDown.y = 504;
			monBoutonDown.scaleX = 0.3125;
			monBoutonDown.scaleY = -0.3125;
			
			monBoutonAccept.texte = monLangage.btnAccept;
			monBoutonAccept.scaleX = monBoutonAccept.scaleY = 0.5;
			monBoutonAccept.x = 280-monBoutonAccept.width/2;
			monBoutonAccept.y = 484;
			
			
			monBoutonFermer.scaleX=0.3;
			monBoutonFermer.scaleY=0.3;
			monBoutonFermer.x=508;
			monBoutonFermer.y=84;
			
			conteneurMenu.addChild(monFondMenu);
			conteneurMenu.addChild(monFondFBAsk);
			conteneurMenu.addChild(conteneurMessage);
			conteneurMenu.addChild(conteneurMessageMask);
			conteneurMessage.mask = conteneurMessageMask;
			conteneurMenu.addChild(maScrollBar);
			conteneurMenu.addChild(monBoutonUp);
			conteneurMenu.addChild(monBoutonDown);
			conteneurMenu.addChild(monBoutonFermer);
			conteneurMenu.addChild(monBoutonAccept);
			conteneurMenu.addChild(titre);
			
			addMenu();
		}
		private function addMenu() {
			conteneurMenu.x = largeur / 2 - conteneurMenu.width / 2;
			addChild(conteneurMenu);
			TweenLite.from(conteneurMenu, 0.3, { y:-560} );
			TweenLite.to(conteneurMenu, 0.8, { y:40, ease:Elastic.easeOut, easeParams:[0.8, 0.6], onComplete:startMessage } );
			sonMenuIn = true;
		}
	//MESSAGE BOX=======================================================================================
		private function createMessageBox() {
			var l:int = 0;
			for (var u:int = 0; u < messageList.length; u++) {
				var monMessageTemp:MessageAmisBox = new MessageAmisBox(messageList[u], langue);
				monMessageTemp.y =  l * 96;
				monMessageTemp.x = 8;
				l++;
				conteneurMessage.addChild(monMessageTemp);
			}
		}
	//GESTION SOURIS=============================================================================
		private function upSouris(e:MouseEvent){sourisDown=false;}
		private function downSouris(e:MouseEvent){sourisDown=true;}
	//RUN============================================================================================
		private function startMessage() {
			maScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, downSouris);
			parent.addEventListener(MouseEvent.MOUSE_UP, upSouris);
			addEventListener(Event.ENTER_FRAME, run);
		}
		private function run(e:Event) {
	//gestion bar--------------------------------------------------------------------
			if (mouseX <= 0 || mouseX >= largeur || mouseY <= 0 || mouseY >= hauteur) { sourisDown = false;}
			if (sourisDown == true && sourisScroll == false) { barStartDrag(); }
			if (sourisDown == false) { barStopDrag();}
			if (monBoutonUp.boutonDown == true) { if (maScrollBar.y > 180) { maScrollBar.y -= 2; };  }
			if (monBoutonDown.boutonDown == true) { if (maScrollBar.y < 420) { maScrollBar.y += 2;}; }
			var posBar:Number = (maScrollBar.y - 180) / 240; 
			conteneurMessage.y = ((conteneurMessage.height-264)* -posBar)  + 188;
	//gestion fermer-----------------------------------------------------------------
			if (monBoutonFermer.boutonClick == true || conteneurMessage.numChildren <= 0 || allMessageClicked == true) { 
				fermer = true;
				maScrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, downSouris);
				parent.removeEventListener(MouseEvent.MOUSE_UP, upSouris);
				removeEventListener(Event.ENTER_FRAME, run);
				monBoutonFermer.boutonClick = false;
			}
	//gestion accepter tout----------------------------------------------------------
			if (monBoutonAccept.boutonClick == true) {
				for (var a:int = 0; a < messageList.length; a++) { 
					var messTemp:MessageAmisBox = MessageAmisBox(conteneurMessage.getChildAt(a));
					if (messTemp.typeBox == "giveLife") { donneVie = true; }
					if (messTemp.typeBox == "needLife") { messageFB = writeMessage(a); sendMessage = true; }
					requestList.push(messTemp.requestBox);
				}
				messageList=[];
				while (conteneurMessage.numChildren > 0) { conteneurMessage.removeChildAt(0); }
				monBoutonAccept.boutonClick = false;
			}
			 
	//gestion bouton message---------------------------------------------------------
			for (var mb:int = 0; mb < messageList.length; mb++) {
				var messTemp:MessageAmisBox = MessageAmisBox(conteneurMessage.getChildAt(mb));
				if (messTemp.envoieMessage == true) {
					if (messTemp.typeBox == "giveLife") { donneVie = true; }
					if (messTemp.typeBox == "needLife") { messageFB = writeMessage(mb); sendMessage = true; }
					requestList.push(messTemp.requestBox);
					messageList.splice(mb, 1);
					while (conteneurMessage.numChildren > 0) { conteneurMessage.removeChildAt(0); }
					createMessageBox();
					messTemp.envoieMessage = false;
				}
			}
			if (allMessageClicked == false) {
				var amc:Boolean = true;
				for (var mi:int = 0; mi < messageList.length; mi++) {
					var messTemp:MessageAmisBox = MessageAmisBox(conteneurMessage.getChildAt(mi));
					if (messTemp.typeBox == "giveLife" || messTemp.typeBox == "needLife") { amc = false; }
				}
				if (amc == true) { allMessageClicked = true;}
			}
	//drag---------------------------------------------------------------------------
			function barStartDrag() {
				maScrollBar.startDrag(false, new Rectangle(504, 180, 0, 240));
				maScrollBar.forceBoutonIn = true;
				sourisScroll = true;
			}
			function barStopDrag(){
				maScrollBar.stopDrag();
				maScrollBar.forceBoutonIn = false;
				sourisScroll = false;
			}
		}
	//TRAITER REQUETTE LISTE========================================================================================
		private function traiterRequette(mlistObj:Object) {
			for (var m:int = 0; m < mlistObj.length; m++) { 
				if (traiterTemps(mlistObj[m].created_time) == false) {
					requestList.push(mlistObj[m].id);
				}
				if (mlistObj[m].data.type != "needLife" || mlistObj[m].data.type != "giveLife"){
					requestList.push(mlistObj[m].id);
				}
			}
		}
	//TRAITER LISTE MESSAGE=========================================================================================
		private function traiterMessage(mlistObj:Object) {
			for (var m:int = 0; m < mlistObj.length; m++) {
				if (mlistObj[m].data.type == "needLife" || mlistObj[m].data.type == "giveLife"||mlistObj[m].data.type == "score") {
					var messageObj:Object = new Object();
					var ajout:Boolean = true;
					messageObj.id = mlistObj[m].from.id;
					messageObj.name = mlistObj[m].from.name;
					messageObj.type = mlistObj[m].data.type;
					messageObj.data = mlistObj[m].data.data;
					messageObj.idRequest = mlistObj[m].id;
					for (var ml:int = 0; ml < messageList.length; ml++) {
						if (messageList[ml].id == messageObj.id && messageList[ml].type == messageObj.type && messageList[ml].type != "score") { 
							ajout = false;
							requestList.push(mlistObj[m].id);
						}
					}
					if(ajout==true){messageList.push(messageObj);}
				}
			}
		}
	//DECODE TYPE MESSAGE====================================================================
		private function decodeType(dataString:String):Object {
			var retour:Object = new Object();
			var dataTab:URLVariables = new URLVariables();
			if (dataString != null && dataString != "" && dataString!=undefined) { 
				dataTab.decode(dataString);
				retour.type = dataTab.type;
				retour.data = dataTab.data;
			}
			return(retour);
		}
	//TRAITER TEMPS===================================================================================================
		private function traiterTemps(tempsText:String):Boolean {
			var tempsOK:Boolean = true;
			
			var transformDate:ISO8601Util = new ISO8601Util();
			var maDate:Date = transformDate.parseDateTimeString(tempsText);
			var dNow:Date = new Date();
			
			maDate.hours += 24;
			if (maDate.valueOf() > dNow.valueOf()) { tempsOK = false; }
			
			return(tempsOK);
		}
	//ENVOYER MESSAGE====================================================================================
		private function writeMessage(nMessage:int):Object {
			
			var retourMessage:Object = new Object ();
			
			var objData:String = "type=giveLife";
			
			retourMessage.method = "apprequests";
			retourMessage.message = monLangage.sendMessage_giveLife;
			retourMessage.data = objData;
			retourMessage.friend_ids = messageList[nMessage].id;
			
			return(retourMessage);
		}
	//REMOVE=============================================================================================
		public function removeMenu() {
			sonMenuOut = true;
			TweenLite.from(conteneurMenu, 0.3, {y:40} );
			TweenLite.to(conteneurMenu, 0.8, { y: -560, ease:Elastic.easeIn, easeParams:[0.7, 0.6], onComplete:cleanMenu } );
			function cleanMenu() {
				while (conteneurMessage.numChildren > 0) { conteneurMessage.removeChildAt(0);}
				while (conteneurMenu.numChildren > 0) { conteneurMenu.removeChildAt(0); }
				removeFini = true;
			}
		}
		public function portraitPaysage() {
			this.rotation=-90;
			this.y = 960;
			
			hauteur=640;
			largeur=960;
		}
	}
}