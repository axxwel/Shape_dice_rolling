package{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.utils.getDefinitionByName;
	
	public class Bouton extends Sprite{
		
		private var monBoutonFond:BoutonFond = new BoutonFond();
		private var monBoutonFermerFond:BoutonFermerFond = new BoutonFermerFond();
		
		private var monLangage:Langage=new Langage();
		private var monBoutonTxt:TextField=new TextField();
		private var miseEnFormeBtn:TextFormat=new TextFormat();
		
		private var monGlow:GlowFilter=new GlowFilter(0xffffff,0.8,10,10,4,1,true);
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		public var boutonClick:Boolean = false;
		public var boutonDown:Boolean = false;
		public var forceBoutonIn:Boolean = false;
		private var boutonIn:Boolean = false;
		private var sourisClick:Boolean = false;
		private var sourisUnClick:Boolean = false;
		
		private var tailleTexte:int = 12;
		public var texte:String = "Null";
		
		private var miseEnForme:Boolean = false;
		
		private var petitBouton:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function Bouton(couleurBouton:String, texteTemp:String = "Null") {
			var classBtn:Class=getDefinitionByName("Bouton"+couleurBouton)as Class;
			var monBouton:MovieClip=new classBtn;
			monBouton.name = "bouton";
			
			if (couleurBouton == "Fermer" ||
				couleurBouton == "Reset" ||
				couleurBouton == "UpDownFBAsk" ||
				couleurBouton == "ScrollFBAsk" ||
				couleurBouton == "Son") {
				
				petitBouton = true;
				if (couleurBouton == "Son") {
					monBouton.gotoAndStop(1);
				}
			}
			
			miseEnFormeBtn.font="Cooper Std black";
			miseEnFormeBtn.size=tailleTexte;
			miseEnFormeBtn.bold=true;
			miseEnFormeBtn.color=0xffffff;
			
			monBoutonTxt.embedFonts = true;
			monBoutonTxt.autoSize=TextFieldAutoSize.LEFT;
			monBoutonTxt.text=texteTemp;
			monBoutonTxt.selectable=false;
			
			if(petitBouton==true){addChild(monBoutonFermerFond);}
			else {addChild(monBoutonFond);}
			
			addChild(monBouton);
			if(petitBouton==false){addChild(monBoutonTxt);}
			this.filters=[monOmbre];
			
			addEventListener(MouseEvent.MOUSE_OUT,outBtn);
			addEventListener(MouseEvent.MOUSE_OVER, overBtn);
			addEventListener(MouseEvent.MOUSE_UP,unClickBtn);
			addEventListener(MouseEvent.MOUSE_DOWN,clickBtn);
			addEventListener(Event.ENTER_FRAME,run);
		}
		public function changerImage(couleurBouton:String) {
			var index:int=getChildIndex(getChildByName("bouton"));
			removeChild(getChildByName("bouton"));
			var classBtn:Class=getDefinitionByName("Bouton"+couleurBouton)as Class;
			var monBouton:MovieClip=new classBtn;
			monBouton.name = "bouton";
			addChildAt(monBouton, index);
		}
		private function run(e:Event) {
			var btn:Object=this.getChildByName("bouton");
			if (miseEnForme == false && texte != "Null") { 
				monBoutonTxt.text = texte; 
				while(monBoutonTxt.width<btn.width-32&&monBoutonTxt.height<btn.height-12){donnerTailleTexte();}
				monBoutonTxt.setTextFormat(miseEnFormeBtn);
				miseEnForme = true;
			}
			boutonDown = false;
			if(boutonIn==true||forceBoutonIn){
				if(sourisClick==true){
					btn.scaleX = 0.97;
					btn.scaleY = 0.9;
					boutonDown = true;
					sourisUnClick = true;
				}else {
					btn.alpha=1;
					btn.filters = [monGlow];
					btn.scaleX = 1;
					btn.scaleY = 1;
					if (sourisUnClick == true) { boutonClick = true; sourisUnClick = false;}
				}
			}else{
				btn.scaleY=btn.scaleX=1;
				btn.filters=[];
				btn.alpha = 0.7;
				sourisClick = false;
				sourisUnClick = false;
			}
			if (petitBouton==false) {
				btn.x=monBoutonFond.width/2-btn.width/2;
				btn.y=monBoutonFond.height/2-btn.height/2;
				monBoutonTxt.x=monBoutonFond.width/2-monBoutonTxt.width/2;
				monBoutonTxt.y = monBoutonFond.height / 2 - monBoutonTxt.height / 2;
			}else {
				btn.x=monBoutonFermerFond.width/2-btn.width/2;
				btn.y=monBoutonFermerFond.height/2-btn.height/2;
			}
		}
		private function donnerTailleTexte(){
			tailleTexte++;
			miseEnFormeBtn.size=tailleTexte;
			monBoutonTxt.setTextFormat(miseEnFormeBtn);
		}
		private function outBtn(e:Event){boutonIn=false;}
		private function overBtn(e:Event){boutonIn=true;}
		private function clickBtn(e:Event){sourisClick=true;}
		private function unClickBtn(e:Event){sourisClick=false;}
	}
}