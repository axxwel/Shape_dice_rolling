package{
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	public class DecorCombo extends MovieClip{
		
		public var conteneur:Sprite=new Sprite();
		private var conteneurTextTotal:Sprite=new Sprite();
		private var decorUP:DecorScoreUp=new DecorScoreUp();
		private var ombreDecorUp:DropShadowFilter=new DropShadowFilter(10,45,0x000000,0.2);
		
		private var monGlow:GlowFilter=new GlowFilter(0xf400a1,1,5,5,10);
		private var monOmbre:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 0.5);
		
		private var miseEnForme:TextFormat=new TextFormat();
		
		private var suppTextTimer:int=0;
		
		private var nLigneC:int = 1;
		
		private var maVieBitmap:Bitmap = new Bitmap(new OneUp);
		private var maVie:Sprite = new Sprite();
		
		public var ajoutTemps:Boolean=false;
		public var nAjoutTemps:int = 0;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
//FUNCTION=============================================================================================================================================
		public function DecorCombo(){
			miseEnForme.color=0xf7ff3c;
			miseEnForme.font="Cooper Std black";
			miseEnForme.align="right";
			miseEnForme.bold=true;
			
			decorUP.gotoAndStop(1);
			decorUP.filters=[ombreDecorUp];
			conteneur.addChild(decorUP);
			
			conteneur.addChild(conteneurTextTotal);
			
			addChild(conteneur);
		}
		public function ajouterVie() {
			maVieBitmap.x = -maVieBitmap.width / 2;
			maVieBitmap.y = -maVieBitmap.height / 2;
			maVie.x = 104;
			maVie.y = 72;
			maVie.scaleX=0;
			maVie.scaleY = 0;
			maVie.addChild(maVieBitmap);
			conteneur.addChild(maVie);
			tweenIn_Vie();
		}
		private function tweenIn_Vie() {
			TweenLite.from(maVie, 0.5, { scaleX:0,scaleY:0 } );
			TweenLite.to(maVie, 0.5, { scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:tweenOut_Vie } );
		}
		private function tweenOut_Vie() {
			TweenLite.from(maVie, 0.5, { scaleX:1,scaleY:1 } );
			TweenLite.to(maVie, 0.5, { scaleX:0, scaleY:0, ease:Elastic.easeIn, onComplete:removeMaVie } );
		}
		private function removeMaVie() { 
			conteneur.removeChild(maVie);
		}
		public function ajouterTemps(tAjt:int, nAff:int) {
			var conteneurText:MovieClip=new MovieClip();
			var txt:int=tAjt
			var taille:int=14+nAff*2;
			var nLigneC:int=nAff
			var textSecond:TextField=new TextField();
			miseEnForme.size=taille;
			
			conteneurText.name = txt.toString();
			textSecond.embedFonts = true;
			textSecond.height=taille*2;
			textSecond.y=4+nLigneC*20+nLigneC*4-textSecond.height/2;
			textSecond.x=208-textSecond.width;
			textSecond.text="+"+txt+"s";
			textSecond.setTextFormat(miseEnForme);
			textSecond.filters=[monGlow,monOmbre];
			conteneurText.addChild(textSecond);
			conteneurTextTotal.addChild(conteneurText);
		}
		public function suprimerTemps(nFormes:int) { 
			var nbrTexte:int = conteneurTextTotal.numChildren;
			if(nFormes+1<=nbrTexte*7&&nFormes>0){
				addEventListener(Event.ENTER_FRAME,suprimerTexte);
			}
		}
		private function suprimerTexte(e:Event){
			ajoutTemps=false;
			nAjoutTemps=0;
			if(conteneurTextTotal.numChildren>0){
				var texte:Object=MovieClip(conteneurTextTotal.getChildAt(conteneurTextTotal.numChildren-1));
				var vitesse:int=2;
				if(suppTextTimer>-texte.height/2){
					texte.y-=vitesse;
					texte.alpha-=1/((texte.height/2)/vitesse);
					suppTextTimer-=vitesse;
				}else{
					nAjoutTemps=texte.name;
					ajoutTemps=true;
					removeEventListener(Event.ENTER_FRAME,suprimerTexte);
					conteneurTextTotal.removeChildAt(conteneurTextTotal.numChildren-1);suppTextTimer=0;
				}
			}
		}
	}
}