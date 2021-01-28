package 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.filters.DropShadowFilter;
	
	public class AmisBattu extends Sprite{
		
		private var monLangage:Langage = new Langage();
		
		private var fond:AmisBattuFond = new AmisBattuFond();
		
		private var conteneurUsers:Sprite = new Sprite();
		private var conteneurUsersMask:Bitmap = new Bitmap(new BitmapData(256, 184, false, 0xffffff));
		
		private var maScrollBar:Bouton = new Bouton("ScrollFBAsk");
		private var monBoutonUp:Bouton = new Bouton("UpDownFBAsk");
		private var monBoutonDown:Bouton = new Bouton("UpDownFBAsk");

		private var titre:TexteScore = new TexteScore("", 32, 0x1e7fcb, true, true, true, 0xf7ff3c);
		
		private var monBoutonSend:Bouton = new Bouton("Bleu");
		
		private var selectAll:Sprite = new Sprite();
		private var selectAllBox:CheckBoxFBAsk = new CheckBoxFBAsk();
		private var selectAllText:TexteScore = new TexteScore("", 18, 0x1e7fcb, true, false, true, 0xffffff);
		
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		public var langue:String = "en_US";
		
		public var messageFB:Object = new Object();
		public var sendMessage:Boolean = false;
		private var retourFriendList:Array = new Array();
		
		private var score:int = 0;
		
		public var listeVide:Boolean = false;
		
		public var hauteur:int=640;
		public var largeur:int = 960;
		
		private var listeJoueurBattu:Array = new Array();
		
		private var sourisDown:Boolean = false;
		private var sourisScroll:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontCooper:Class;
		
		public function AmisBattu() {
	
		}
//INIT===========================================================================================
		private function initDecor(){
			fond.y = 172;
			
			monLangage.setLangage(langue);
			titre.newTexte(monLangage.friendBeat)
			titre.y = 148;
			
			conteneurUsers.x = 8;
			conteneurUsers.y = 180;
			conteneurUsersMask.x = 8;
			conteneurUsersMask.y = 180;
			
			maScrollBar.x = 272;
			maScrollBar.y = 180;
			maScrollBar.width = 32;
			maScrollBar.height = 48;
			
			monBoutonUp.x = 272;
			monBoutonUp.y = 140;
			monBoutonUp.width = 32;
			monBoutonUp.height = 32;
			
			monBoutonDown.x = 272;
			monBoutonDown.y = 400;
			monBoutonDown.scaleX = 0.3125;
			monBoutonDown.scaleY = -0.3125;
			
			monBoutonSend.texte = monLangage.btnSend;
			monBoutonSend.x = 134;
			monBoutonSend.y = 428;
			monBoutonSend.scaleX = monBoutonSend.scaleY = 0.4;
			
			selectAll.x = 26;
			selectAll.y = 380;
			
			addChild(fond);
			addChild(conteneurUsers);
			addChild(conteneurUsersMask);
			conteneurUsers.mask = conteneurUsersMask;
			addChild(titre);
			addChild(maScrollBar);
			addChild(monBoutonUp);
			addChild(monBoutonDown);
		}
	//init liste------------------------------------------------------------------
		public function init(friendListTemp:Array, oldScoreTemp:int, newScoreTemp:int) {
			score = newScoreTemp;
			initDecor();
			
			for (var j:int = 0; j < friendListTemp.length; j++) {
				var joueurBattu:Array = new Array();
				var dejaBattu:Boolean = false;
				if (friendListTemp[j].score < oldScoreTemp) {
					dejaBattu = true;
				}
				if ( friendListTemp[j].score < newScoreTemp ) { 
					joueurBattu = [friendListTemp[j], dejaBattu];
					listeJoueurBattu.push(joueurBattu);
				}
			}
			createUserList(listeJoueurBattu);
		}
	//creer liste-------------------------------------------------------------------
		private function createUserList(liste:Array) {
			var l:int = 0;
			var b:int = 0;
			while (conteneurUsers.numChildren > 0) { conteneurUsers.removeChildAt(0); }
			
			for (var u:int = 0; u < liste.length; u++) {
				var monUserTemp:AmisBattuBox = new AmisBattuBox(liste[u], langue);
				monUserTemp.name = "joueurBattu_" + u;
				monUserTemp.x = 8 ;
				monUserTemp.y =  l * 96 +b;
				l++;
				conteneurUsers.addChild(monUserTemp);
			}
			if (conteneurUsers.numChildren >= 1) { createSelectAll(); listeVide = false } else { listeVide = true;}
		}
//SELECT ALL=====================================================================================
		private function createSelectAll() {
			addChild(monBoutonSend);
			addChild(selectAll);
			
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
				for (var s:int = 0; s < conteneurUsers.numChildren ; s++) { AmisBattuBox(conteneurUsers.getChildAt(s)).selectBox();}
			}
			else{
				selectAllBox.gotoAndStop(1);
				for (var u:int = 0; u < conteneurUsers.numChildren ; u++) { AmisBattuBox(conteneurUsers.getChildAt(u)).unSelectBox();}
			}
		}
//RUN============================================================================================
		public function startAmis() {
			maScrollBar.addEventListener(MouseEvent.MOUSE_DOWN, downSouris);
			parent.addEventListener(MouseEvent.MOUSE_UP, upSouris);
			addEventListener(Event.ENTER_FRAME, run);
		}
	//getion souris-----------------------------------------------------------------
		private function upSouris(e:MouseEvent){sourisDown=false;}
		private function downSouris(e:MouseEvent){sourisDown=true;}
		private function run(e:Event) {
	//gestion bar--------------------------------------------------------------------
			if (stage.mouseX <= 0 || stage.mouseX >= largeur || stage.mouseY <= 0 || stage.mouseY >= hauteur) { sourisDown = false;}
			if (sourisDown == true && sourisScroll == false) { barStartDrag(); }
			if (sourisDown == false) { barStopDrag();}
			if (monBoutonUp.boutonDown == true) { if (maScrollBar.y > 180) { maScrollBar.y -= 2; };  }
			if (monBoutonDown.boutonDown == true) { if (maScrollBar.y < 316) { maScrollBar.y += 2;}; }
			var posBar:Number = (maScrollBar.y - 180) / 136; 
			conteneurUsers.y = ((conteneurUsers.height - 164) * -posBar)  + 188; 
	//gestion send-------------------------------------------------------------------
			if (monBoutonSend.boutonClick == true) {
				retourFriendList = [];
				for (var c:int = 0; c < conteneurUsers.numChildren ; c++) {
					if (AmisBattuBox(conteneurUsers.getChildAt(c)).checked == true) {
						retourFriendList.push(AmisBattuBox(conteneurUsers.getChildAt(c)).idBox);
					}
				}
				messageFB=writeMessage();
				sendMessage = true;
				
				maScrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, downSouris);
				parent.removeEventListener(MouseEvent.MOUSE_UP, upSouris);
				removeEventListener(Event.ENTER_FRAME, run);
				
				monBoutonSend.boutonClick = false;
			}
	//drag--------------------------------------------------------------------------
			function barStartDrag() {
				maScrollBar.startDrag(false, new Rectangle(272, 180, 0, 136));
				maScrollBar.forceBoutonIn = true;
				sourisScroll = true;
			}
			function barStopDrag(){
				maScrollBar.stopDrag();
				maScrollBar.forceBoutonIn = false;
				sourisScroll = false;
			}
		}
//ECRIRE MESSAGE FB=======================================================================================
		private function writeMessage():Object {
			var retourMessage:Object = new Object ();
			
			var retourFLT:String = "";
			for (var f:int = 0; f < retourFriendList.length; f++) {
				retourFLT += retourFriendList[f]+",";
			}
			var objData:String = "type=score&data="+score;
			
			retourMessage.method = "apprequests";
			retourMessage.message = monLangage.sendMessage_Score+ score.toString() + monLangage.sendMessage_SDR;
			retourMessage.data = objData;
			retourMessage.friend_ids = retourFLT;
			
			return(retourMessage);
		}
//REMOVE==================================================================================================
		public function remove() {
			maScrollBar.removeEventListener(MouseEvent.MOUSE_DOWN, downSouris);
			parent.removeEventListener(MouseEvent.MOUSE_UP, upSouris);
			removeEventListener(Event.ENTER_FRAME, run);
		}
	}
}