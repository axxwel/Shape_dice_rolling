package{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class TexteScore extends Sprite{
		
		private var monTexte:TextField=new TextField();
		private var monFormat:TextFormat=new TextFormat();
		
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		private var monGlow:GlowFilter=new GlowFilter(0xf400a1,1,5,5,10);
		private var filtres:Array = new Array();
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function TexteScore(texte:String,taille:int,couleur:Number,gras:Boolean=true,ombre:Boolean=false,glow:Boolean=false,glowCouleur:Number=0xffffff,align:String="left"){
			
			monFormat.font="Cooper Std black";
			
			monFormat.bold=gras;
			monFormat.size=taille;
			monFormat.color=couleur;
			monFormat.align=align;
			if(glow==true){
				monGlow.color=glowCouleur;
				filtres.push(monGlow);
			}
			if (ombre == true) { filtres.push(monOmbre); }
			monTexte.embedFonts = true;
			monTexte.selectable = false;
			monTexte.autoSize=TextFieldAutoSize.LEFT;
			monTexte.filters=filtres;
			monTexte.text=texte;
			monTexte.setTextFormat(monFormat);
			
			addChild(monTexte);
		}
		public function setCouleur(couleur:Number,glowCouleur:Number=0xffffff,glowAffiche:Boolean=true,ombreAffiche:Boolean=true) {
			monFormat.color = couleur;
			monGlow.color = glowCouleur;
			monTexte.setTextFormat(monFormat);
			if (glowAffiche == true && ombreAffiche == true) { monTexte.filters = [monGlow, monOmbre]; }
			if (glowAffiche == true && ombreAffiche == false) { monTexte.filters = [monGlow]; }
			if (glowAffiche == false && ombreAffiche == true) { monTexte.filters = [monOmbre]; }
			if (glowAffiche == false && ombreAffiche == false) { monTexte.filters = [];}
		}
		public function newTexte(texte:String){
			monTexte.text=texte;
			monTexte.setTextFormat(monFormat);
		}
		public function setFormat(couleur:Number,size:int,sIndex:int=-1,eIndex:int=-1) {
			monFormat.color = couleur;
			monFormat.size = size;
			monTexte.setTextFormat(monFormat,sIndex,eIndex);
		}
		public function justifier(W:int) {
			monTexte.width = W;
			monTexte.wordWrap = true;
		}
		public function remove() {
			removeChild(monTexte);
			monTexte = null;
		}
	}
}