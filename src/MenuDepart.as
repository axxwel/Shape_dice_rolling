package{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class MenuDepart extends Sprite{
		
		public var conteneur:Sprite=new Sprite();
		private var monVoile:Voile = new Voile();
		private var monTitre:Bitmap = new Bitmap(new MenuDepartBitmap);
		
		private var maVersionText:TextField=new TextField();
		private var maVersionTextFormat:TextFormat=new TextFormat();
		
		public var langue:String = "en_US"; 
		private var monLangage:Langage = new Langage();
		private var monBouton:Bouton = new Bouton("Vert");
		
		private var monOmbre:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 0.5);
		
		public var finMenu:Boolean = false;
		public var voileOK:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function MenuDepart() {
			maVersionTextFormat.font="Cooper Std black";
			maVersionTextFormat.bold=true;
			maVersionTextFormat.size = 12;
			maVersionText.embedFonts = true;
			maVersionText.text = "1.1";
			maVersionText.x = 490;
			maVersionText.y = 330;
			maVersionText.setTextFormat(maVersionTextFormat);
			maVersionText.filters = [monOmbre];
			
			monVoile.alpha = 0;
			addChild(monVoile);
			
			conteneur.x=40;
			conteneur.y=200;
			addChild(conteneur);
		}
		public function startMenu() {
			tweenTitre();
			addEventListener(Event.ENTER_FRAME,runMenuStart);
		}
		private function tweenTitre() {
			conteneur.addChild(monTitre);
			TweenLite.from(monTitre, 2, { scaleX:0,scaleY:0,x:monTitre.width/2,y:monTitre.height/2} );
			TweenLite.to(monTitre, 2, { scaleX:1, scaleY:1, x:0, y:0, ease:Elastic.easeOut, onComplete:addBouton } );
		}
		private function addBouton() {
			monLangage.setLangage(langue);
			monBouton.texte = monLangage.btnStart;
			monBouton.scaleX=0.5;
			monBouton.scaleY=0.5;
			monBouton.x=560/2-monBouton.width/2;
			monBouton.y = 496;
			conteneur.addChild(monBouton);
			conteneur.addChild(maVersionText);
		}
		private function runMenuStart(e:Event) {
			if (monVoile.alpha >= 1) { voileOK = true; }
			else if(voileOK == false){monVoile.alpha += 0.05;}
			if (monBouton.boutonClick == true) {
				monBouton.boutonClick = false;
				addEventListener(Event.ENTER_FRAME,suprimerMenuStart);
				removeEventListener(Event.ENTER_FRAME,runMenuStart);
			}
		}
		private function suprimerMenuStart(e:Event){
			monBouton.alpha -= 0.1;
			
			if (monBouton.alpha <= 0) { monTitre.y -= 16; monTitre.alpha -= 0.1; maVersionText.alpha -= 0.3; }
			if (monTitre.alpha <= 0.5) { monVoile.alpha -= 0.1; }
			if (monVoile.alpha <= 0) {
				BitmapData(monTitre.bitmapData).dispose();
				conteneur.removeChild(maVersionText); maVersionText = null;
				conteneur.removeChild(monTitre); monTitre = null;
				conteneur.removeChild(monBouton); monBouton = null;
				removeChild(conteneur); conteneur = null;
				finMenu = true;
				removeEventListener(Event.ENTER_FRAME,suprimerMenuStart);
			}
		}
		public function portraitPaysage(){
			conteneur.rotation=-90;
			conteneur.x=40;
			conteneur.y=760;
		}
	}
}