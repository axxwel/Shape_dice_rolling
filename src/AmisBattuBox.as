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
	
	public class AmisBattuBox extends MovieClip{
		
		public var envoieMessage:Boolean = false;
		
		public var checked:Boolean = false;
		
		public var idBox:String = "";
		private var nomBox:String = "";
		private var pictureURL:String = "";
		private var score:int = 0;
		
		private var dejaBattu:Boolean = false;
		
		private var monLangage:Langage = new Langage();
		
		private var monScoreTxt:TexteScore = new TexteScore(monLangage.score, 18, 0x000000, false);
		private var monScoreNbr:TexteScore=new TexteScore("0",30,0xf7ff3c,true,false,true,0xf400a1);
		
		private var newBeatTxt:TexteScore=new TexteScore(monLangage.neww,18,0xed1c24,true,false,true,0xffdd17);
		
		[Embed(source = "Libs/Lucida Grande.ttf",
			fontName = "Lucida Grande",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontLucida:Class;
		
		public function AmisBattuBox(friend:Object,langueTemp:String) {
			monLangage.setLangage(langueTemp);
			idBox = friend[0].id;
			nomBox = friend[0].nom;
			score = friend[0].score;
			dejaBattu = friend[1];
			
			pictureURL = "https://graph.facebook.com/" + idBox +"/picture";
	//FOND--------------------------------------------------------------------
			var fond:Bitmap = new Bitmap(new BitmapData(240, 80, false, 0xffffff));
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
			nom.width = 222;
			
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
				image.x = 48;
				image.y = 30;
				image.height = 50;
				image.width = 50;
				
				addChild(image);
				chargeur.removeEventListener(Event.COMPLETE, imageLoaded);
			}
			function erreurChargement(e:IOErrorEvent) {
				trace("erreurChargement_imageFB");
			}
	//SCORE----------------------------------------------------------------------
			monScoreTxt.newTexte(monLangage.score);
			monScoreTxt.x = 110;
			monScoreTxt.y = 25;
			addChild(monScoreTxt);
			monScoreNbr.newTexte(String(score));
			monScoreNbr.x = 110;
			monScoreNbr.y = 45;
			addChild(monScoreNbr);
	//DEJA BATTU------------------------------------------------------------------
			if (dejaBattu == false) {
				newBeatTxt.newTexte(monLangage.neww);
				newBeatTxt.x = 245-newBeatTxt.width;
				newBeatTxt.y = -5;
				addChild(newBeatTxt);
			}
	//CHECK BOX------------------------------------------------------------------------------------------
			var maCheckBox:CheckBoxFBAsk = new CheckBoxFBAsk();
			maCheckBox.name = "checkBox";
			maCheckBox.x = 12;
			maCheckBox.y = 40;
			
			maCheckBox.gotoAndStop(1);
			checked = false;
			addChild(maCheckBox); 
			
			addEventListener(MouseEvent.CLICK, boxSelected);
			
		}
		public function boxSelected(e:MouseEvent) {
			if (checked == false) { selectBox(); }
			else { unSelectBox();}
		}
		public function selectBox() { CheckBoxFBAsk(getChildByName("checkBox")).gotoAndStop(2); checked = true; }
		public function unSelectBox() { CheckBoxFBAsk(getChildByName("checkBox")).gotoAndStop(1); checked = false; }
	}
}