package 
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.system.Security;
	
	public class MessageAmisBox extends MovieClip{
		private var monLangage:Langage = new Langage();
		public var langue:String = "en_US";
		
		public var requestBox:String = "";
		public var idBox:String = "";
		public var typeBox:String = "";
		private var dataBox:String = "";
		private var nomBox:String = "";
		private var pictureURL:String = "";
		
		private var monBouton:Bouton = new Bouton("Vert");
		public var envoieMessage:Boolean = false;
		
		[Embed(source = "Libs/Lucida Grande.ttf",
			fontName = "Lucida Grande",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontLucida:Class;
		
		public function MessageAmisBox(message:Object, langueTemp:String) { 
			monLangage.setLangage(langueTemp);
			
			requestBox = message.idRequest;
			idBox = message.id;
			nomBox = message.name;
			typeBox = message.type;
			dataBox = message.data;
			
			if (message.picture == undefined) {
				pictureURL = "https://graph.facebook.com/" + idBox +"/picture";
			}else {
				pictureURL = message.picture.data.url;
			}
			
	//FOND--------------------------------------------------------------------
			var fond:Bitmap = new Bitmap(new BitmapData(448, 80, false, 0xffffff));
			fond.alpha = 0.4;
			fond.y = 6;
			addChild(fond);
	//USER NAME----------------------------------------------------------------
			var nom:TextField=new TextField();
			var nomFormat:TextFormat = new TextFormat();
			nom.text = nomBox;
			
			nomFormat.font="Lucida Grande";
			nomFormat.bold=true;
			nomFormat.size=14;
			nomFormat.color=0x3b5998;
			nomFormat.align = "left";
			nom.embedFonts = true;
			nom.selectable = false;
			nom.setTextFormat(nomFormat);
			
			nom.x = 8;
			nom.y = 4;
			nom.height = 32;
			nom.width = 232;
			
			addChild(nom);
	//USER IMAGE---------------------------------------------------------------
			var image_donnee:BitmapData = new BitmapData(50, 50);
			var imageVierge:FB_anonyme = new FB_anonyme();
			image_donnee.draw(imageVierge);
			
			var image:Bitmap = new Bitmap(image_donnee);
			var rqt:String = pictureURL;
			var imageURL:URLRequest = new URLRequest(rqt);
			var chargeur:Loader = new Loader();
			
			Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			chargeur.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			chargeur.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, erreurChargement);
			chargeur.load(imageURL); 
			
			function imageLoaded(e:Event) { 
				image = e.target.content;
				image.x = 8;
				image.y = 30;
				image.height = 50;
				image.width = 50;
				
				addChild(image);
				chargeur.removeEventListener(Event.COMPLETE, imageLoaded);
			}
			function erreurChargement(e:IOErrorEvent) {
				trace("erreurChargement_imageFB");
			}
	//IMAGE VIE--------------------------------------------------------------
			var imageVie:OneUpMessage = new OneUpMessage();
			imageVie.x = 354;
			imageVie.y = 4;		
	//BOUTON MESSAGE---------------------------------------------------------
			var messageText:TexteScore = new TexteScore("", 20, 0x1e7fcb, true, true, true, 0xf7ff3c);
			messageText.x = 68;
			messageText.y = 24;
			messageText.justifier(250);
			
			monBouton.x = 352;
			monBouton.y = 48;
			monBouton.scaleX = monBouton.scaleY = 0.3;
	
			switch(typeBox) {
				case "needLife":
					messageText.setCouleur(0x8cc63e, 0xf7ff3c, true, true);
					messageText.newTexte(monLangage.sendMessage_needLife);
					monBouton.texte = monLangage.btnSend;
					imageVie.gotoAndStop(1);
					addChild(imageVie);
					addChild(monBouton);
				;break;
				case "giveLife":
					messageText.setCouleur(0xed1c24, 0xf7ff3c, true, true);
					messageText.newTexte(monLangage.sendMessage_giveLife);
					monBouton.changerImage("Rouge");
					monBouton.texte = monLangage.btnOK;
					imageVie.gotoAndStop(2);
					addChild(imageVie);
					addChild(monBouton);
				;break;
			case "score":
					messageText.justifier(380);
					messageText.setCouleur(0x9060a8, 0xf7ff3c, true, true);
					var sI:int = String(monLangage.sendMessage_Score).length;
					var eI:int = String(dataBox).length+sI+1;
					messageText.newTexte(monLangage.sendMessage_Score+" " + dataBox);
					messageText.setFormat(0x1e7fcb, 28, sI, eI);
				;break;
			}
			
			addChild(messageText);
			
			addEventListener(Event.ENTER_FRAME, checkBouton);
		}
		public function checkBouton(e:Event) {
			if (monBouton.boutonClick == true) {
				envoieMessage = true;
				monBouton.boutonClick = false;
				removeEventListener(Event.ENTER_FRAME, checkBouton);
			}
		}
	}
}