package{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
    import flash.events.Event;
    import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;

	
	public class ChiffreScore extends Sprite{
		
		private var chiffreAffiche:TextField=new TextField;
		private var chiffreMiseEnForme:TextFormat=new TextFormat();
		
		private var monGlow:GlowFilter=new GlowFilter(0x000000,1.0,2.0,2.0,10);
		private var monOmbre:DropShadowFilter=new DropShadowFilter(10,45,0x000000,0.2);
		
		private var texte:String="";
		private var posX:int=0;
		private var posY:int=0;
		private var taille:int=0;
		private var sizeT:int=0;
		private var scale:int=1;
		
		public var finAnim:Boolean=false;
		
		private var timer:int = 0;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function ChiffreScore(texteTemp:String,posYTemp:int,posXTemp:int,sizeTTemp:int,tailleTemp:int,couleur:int=0){
			texte=texteTemp;
			posX=posXTemp;
			posY=posYTemp;
			sizeT=sizeTTemp;
			taille=tailleTemp;
			
			this.x=posX;
			this.y=posY;
			
			chiffreMiseEnForme.size=0;
			chiffreMiseEnForme.font="Cooper Std black";
			chiffreMiseEnForme.color=choseColor(couleur)[0];
			chiffreMiseEnForme.align="center";
			
			chiffreAffiche.width =taille;
			
			chiffreMiseEnForme.bold=true;
			chiffreAffiche.name = "Score";
			chiffreAffiche.embedFonts = true;
			chiffreAffiche.selectable=false;
			
			monGlow.color=choseColor(couleur)[1];
			monGlow.alpha=1;
			monGlow.blurX=2;
			monGlow.blurY=2;
			
			chiffreAffiche.filters=[monGlow,monOmbre];
			addChild(chiffreAffiche);
			addEventListener(Event.ENTER_FRAME,run);
		}
		public function run(e:Event){
			if(chiffreMiseEnForme.size<sizeT){chiffreMiseEnForme.size+=4;}
			else{this.alpha-=1/40;}
			this.y-=2;
			
			chiffreAffiche.text=texte;
			chiffreAffiche.setTextFormat(chiffreMiseEnForme);
			if(timer>=40){
				finAnim = true;
				removeChild(chiffreAffiche);
				chiffreAffiche = null;
				removeEventListener(Event.ENTER_FRAME,run);
			}
			timer++;
		}
		private function choseColor(couleurTemp:int):Array{
			var retour:Array=new Array();
			var couleurBase:String="";
			var couleurGlow:String="";
			switch(couleurTemp){
				case 0 : couleurBase="0xffffff";couleurGlow="0x2E3092";break;//blanc
				case 1 : couleurBase="0x91268f";couleurGlow="0xf400a1";break;//violet
				case 2 : couleurBase="0xf7931e";couleurGlow="0xf400a1";break;//orange
				case 3 : couleurBase="0xffff00";couleurGlow="0xf400a1";break;//jaune
				case 4 : couleurBase="0xff0000";couleurGlow="0xf400a1";break;//rouge
				case 5 : couleurBase="0x00ff00";couleurGlow="0xf400a1";break;//vert
				case 6 : couleurBase="0x0000ff";couleurGlow="0xf400a1";break;//bleu
			}
			retour[0]=couleurBase;
			retour[1]=couleurGlow;
			return(retour);
		}
	}
}