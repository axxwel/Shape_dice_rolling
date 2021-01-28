package 
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.filters.DropShadowFilter;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	public class  FacebookAsk extends MovieClip {
		private var monLangage:Langage = new Langage();
		public var langue:String = "en_US";
		
		private var conteneurMenu:Sprite = new Sprite();
		private var conteneurUsers:Sprite = new Sprite();
		private var conteneurUsersMask:Bitmap = new Bitmap(new BitmapData(464, 288, false, 0xffffff));
		
		private var maScrollBar:Bouton = new Bouton("ScrollFBAsk");
		private var monBoutonUp:Bouton = new Bouton("UpDownFBAsk");
		private var monBoutonDown:Bouton = new Bouton("UpDownFBAsk");
		
		private var monFondMenu:FondMenu = new FondMenu();
		private var monFondFBAsk:FondFBAsk = new FondFBAsk();
		
		private var monBoutonFermer:Bouton=new Bouton("Fermer");
		private var monBoutonSend:Bouton = new Bouton("Bleu");
		private var titre:TexteScore = new TexteScore("", 40, 0x1e7fcb, true, true, true, 0xf7ff3c);
		
		private var selectAll:Sprite = new Sprite();
		private var selectAllBox:CheckBoxFBAsk = new CheckBoxFBAsk();
		private var selectAllText:TexteScore = new TexteScore("", 18, 0x1e7fcb, true, false, true, 0xffffff);
		
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		
		private var friendList:Object = new Object();
		public var retourFriendList:Array = new Array();
		
		private var hauteur:int=640;
		private var largeur:int = 960;
		
		private var sourisDown:Boolean = false;
		private var sourisScroll:Boolean = false;
		
		private var demande:String = "";
		public var messageFB:Object = new Object();
		public var sendMessage:Boolean = false;
		public var notSend:Boolean = false;
		public var removeFini:Boolean = false;
		
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
		
		public function FacebookAsk() {
			
		}
		public function init(friendListTemp:Object,demandeTemp) {
			friendList = friendListTemp;
			monLangage.setLangage(langue);
			
			titre.x = 24;
			titre.y = 142;
			
			demande = demandeTemp;
			if (demande == "invite") { titre.newTexte(monLangage.inviteFriends); }
			if (demande == "lives") { titre.newTexte(monLangage.shareLives); }
			
			monFondFBAsk.x = 24;
			monFondFBAsk.y = 172;
			
			conteneurUsers.x = 32;
			conteneurUsers.y = 180;
			conteneurUsersMask.x = 32;
			conteneurUsersMask.y = 180;
			
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
			
			monBoutonSend.texte = monLangage.btnSend;
			monBoutonSend.x = 84;
			monBoutonSend.y = 484;
			monBoutonSend.scaleX = monBoutonSend.scaleY = 0.5;
			
			monBoutonFermer.scaleX=0.3;
			monBoutonFermer.scaleY=0.3;
			monBoutonFermer.x=508;
			monBoutonFermer.y=84;
			
			
			selectAll.x = 270;
			selectAll.y = 492;
			
			conteneurMenu.addChild(monFondMenu);
			conteneurMenu.addChild(monFondFBAsk);
			conteneurMenu.addChild(conteneurUsers);
			conteneurMenu.addChild(conteneurUsersMask);
			conteneurUsers.mask = conteneurUsersMask;
			conteneurMenu.addChild(maScrollBar);
			conteneurMenu.addChild(monBoutonUp);
			conteneurMenu.addChild(monBoutonDown);
			conteneurMenu.addChild(monBoutonSend);
			conteneurMenu.addChild(monBoutonFermer);
			conteneurMenu.addChild(titre);
			conteneurMenu.addChild(selectAll);
			
			createUsersBox();
			createSelectAll();
			addMenu();
		}
		private function addMenu() {
			conteneurMenu.x = largeur / 2 - conteneurMenu.width / 2;
			addChild(conteneurMenu);
			TweenLite.from(conteneurMenu, 0.3, { y:-560} );
			TweenLite.to(conteneurMenu, 0.8, { y:40, ease:Elastic.easeOut, easeParams:[0.8, 0.6], onComplete:startAsk } );
			sonMenuIn = true;
		}
//USER BOX=======================================================================================
		private function createUsersBox() {
			var l:int = 0;
			var c:int = 0;
			var lg:int = friendList.length ;
			if (friendList.length > 50) { lg = 50; } else { lg = friendList.length;}
			for (var u:int = 0; u < lg; u++) {
				var monUserTemp:FacebookAskBox = new FacebookAskBox(friendList[u]);
				monUserTemp.x = 8 + c * 112;
				monUserTemp.y =  l * 96;
				if (c < 3) { c++; } else { c = 0; l++; }
				conteneurUsers.addChild(monUserTemp);
			}
		}
//SELECT ALL=====================================================================================
		private function createSelectAll() {
			selectAllBox.gotoAndStop(0);
			selectAllBox.filters = [monOmbre];
			
			selectAllText.x = 35;
			selectAllText.y = 4;
			selectAllText.newTexte(monLangage.selectAll);
			
			selectAll.addChild(selectAllBox);
			selectAll.addChild(selectAllText);
			selectAll.addEventListener(MouseEvent.CLICK, toutSelectioner);
			selectAll.addEventListener(MouseEvent.MOUSE_OVER, selectAllOver);
			selectAll.addEventListener(MouseEvent.MOUSE_OUT, selectAllOut);
		}
		private function selectAllOut(e:Event) {selectAllText.setCouleur(0x1e7fcb);}
		private function selectAllOver(e:Event) {selectAllText.setCouleur(0x1e7fcb,0xf7ff3c);}
		private function toutSelectioner(e:Event) {
			if(selectAllBox.currentFrame==1){
				selectAllBox.gotoAndStop(2);
				for (var s:int = 0; s < conteneurUsers.numChildren ; s++) { FacebookAskBox(conteneurUsers.getChildAt(s)).selectBox();}
			}
			else{
				selectAllBox.gotoAndStop(1);
				for (var u:int = 0; u < conteneurUsers.numChildren ; u++) { FacebookAskBox(conteneurUsers.getChildAt(u)).unSelectBox();}
			}
		}
//GESTION SOURIS=============================================================================
		private function upSouris(e:MouseEvent){sourisDown=false;}
		private function downSouris(e:MouseEvent){sourisDown=true;}
//RUN============================================================================================
		private function startAsk() {
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
			conteneurUsers.y = ((conteneurUsers.height-264)* -posBar)  + 188;
	//gestion send-------------------------------------------------------------------
			if (monBoutonSend.boutonClick == true) {
				retourFriendList = [];
				for (var c:int = 0; c < conteneurUsers.numChildren ; c++) {
					if (FacebookAskBox(conteneurUsers.getChildAt(c)).checked == true) {
						retourFriendList.push(FacebookAskBox(conteneurUsers.getChildAt(c)).idBox);
					}
				}
				messageFB=writeMessage();
				sendMessage = true;
				
				maScrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, downSouris);
				parent.removeEventListener(MouseEvent.MOUSE_UP, upSouris);
				removeEventListener(Event.ENTER_FRAME, run);
				
				monBoutonSend.boutonClick = false;
			}
	//gestion fermer-----------------------------------------------------------------
			if (monBoutonFermer.boutonClick == true) {
				notSend = true;
				maScrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, downSouris);
				parent.removeEventListener(MouseEvent.MOUSE_UP, upSouris);
				removeEventListener(Event.ENTER_FRAME, run);
				monBoutonFermer.boutonClick = false;
			}
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
//ECRIRE MESSAGE=============================================================================
		private function writeMessage():Object {
			var retourMessage:Object = new Object ();
			var retourFLT:String = "";
			for (var f:int = 0; f < retourFriendList.length; f++) {
				retourFLT += retourFriendList[f]+",";
			}
			retourMessage.method = "apprequests";
			if(demande=="invite"){
				retourMessage.message = monLangage.sendMessage_invit;
			}
			if (demande == "lives") {
				var objData:String = "type=needLife";
				
				retourMessage.message = monLangage.sendMessage_needLife;
				retourMessage.data = objData;
			}
			retourMessage.friend_ids = retourFLT;
			
			return(retourMessage);
		}
//REMOVE=====================================================================================
		public function removeMenu() {
			sonMenuOut = true;
			TweenLite.from(conteneurMenu, 0.3, {y:40} );
			TweenLite.to(conteneurMenu, 0.8, { y: -560, ease:Elastic.easeIn, easeParams:[0.7, 0.6], onComplete:cleanMenu } );
			function cleanMenu() {
				selectAll.removeEventListener(MouseEvent.CLICK, toutSelectioner);
				selectAll.removeEventListener(MouseEvent.MOUSE_OVER, selectAllOver);
				selectAll.removeEventListener(MouseEvent.MOUSE_OUT, selectAllOut);
				while (selectAll.numChildren > 0) { selectAll.removeChildAt(0);}
				while (conteneurUsers.numChildren > 0) { conteneurUsers.removeChildAt(0);}
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