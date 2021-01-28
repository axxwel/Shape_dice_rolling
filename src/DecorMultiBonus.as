package{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	
	public class DecorMultiBonus extends MovieClip{
		
		public var conteneur:Sprite=new Sprite();
		
		private var conteneurColor:Sprite=new Sprite();
		private var conteneurType:Sprite=new Sprite();
		
		private var colorBow:ColorBowDecorUp=new ColorBowDecorUp();
		private var typeBow:TypeBowDecorUp=new TypeBowDecorUp();
		
		private var colorText:TextField=new TextField();
		private var typeText:TextField=new TextField();
		
		private var miseEnFormeFont:TextFormat=new TextFormat();
		
		private var monGlow:GlowFilter=new GlowFilter(0xf7ff3c,1,5,5,10);
		private var monOmbre:DropShadowFilter=new DropShadowFilter(5,45,0x000000,0.5);
		
		private var nColor:int=0;
		private var nType:int=0;
		
		private var tempoColor:int=0;
		private var tempoType:int=0;
		private const vitesse:int=8;
		private var reset:Boolean=false;
		
		public var scoreCountDecor:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
//FUNCTION=============================================================================================================================================
		public function DecorMultiBonus(){
			
			miseEnFormeFont.size=24;
			miseEnFormeFont.font="Cooper Std black";
			miseEnFormeFont.color=0x1e7fcb;
			miseEnFormeFont.align="center";
			miseEnFormeFont.bold=true;
//color==============================================================
			colorText.embedFonts = true;
			colorText.text="x1";
			colorText.y=16
			colorText.height=44;
			colorText.width=64;
			colorBow.height=44;
			colorBow.width=64;
			conteneurColor.x=22;
			colorText..setTextFormat(miseEnFormeFont);
			
			colorBow.filters=[monOmbre];
			colorText.filters=[monGlow,monOmbre];
			
			conteneurColor.addChild(colorBow);
			conteneurColor.addChild(colorText);
//type==============================================================
			typeText.embedFonts = true;
			typeText.text="0";
			typeText.y=16
			typeText.height=44;
			typeText.width=96;
			typeText.x=-16;
			typeBow.height=44;
			typeBow.width=64;
			conteneurType.x=118;
			typeText.setTextFormat(miseEnFormeFont);
			
			typeBow.filters=[monOmbre];
			typeText.filters=[monGlow,monOmbre];
			
			conteneurType.addChild(typeBow);
			conteneurType.addChild(typeText);
//add=============================================================
			conteneurColor.name="color";
			conteneurType.name="type";
			conteneur.addChild(conteneurColor);
			conteneur.addChild(conteneurType);
			addChild(conteneur);
		}
//color======================================================================================================
		public function ajouterColor(){
			var m:int=0;
			nColor+=1;
			if(nColor>2){
				var t:String="x1";m=8;
				switch(nColor){
					case 3:t="x2";break;
					case 4:t="x4";break;
					case 5:t="x8";break;
					case 6:t="x16";break;
				}
				colorText.text=t;
				colorText.setTextFormat(miseEnFormeFont);
				animerColor(m);
			}
		}
		private function animerColor(nMulti:int=0,reset:Boolean=false){
			var sens:int=1;
			var tempoMax:int=64;
			var resetVal:int=64;
			addEventListener(Event.ENTER_FRAME,runColor);
			function runColor(e:Event){
				if(sens==1&&tempoColor<tempoMax+nMulti||sens==-1&&tempoColor>0+nMulti){anim();}
				if(sens==1&&tempoColor>=tempoMax+nMulti){sens=-1;}
				if((sens==-1&&tempoColor<=0+nMulti)||reset==true){removeEventListener(Event.ENTER_FRAME,runColor);}
				function anim(){
					tempoColor+=sens*vitesse
					conteneurColor.x-=sens*(vitesse/2);
					conteneurColor.y-=sens*(vitesse/2);
					conteneurColor.height+=sens*vitesse;
					conteneurColor.width+=sens*vitesse;
				}
			}
		}
//type=========================================================================================================
		public function ajouterType() { 
			var m:int=0;
			nType+=1;
			if(nType>2){
				var t:String="0";m=8;
				switch(nType){
					case 3:t="100";break;
					case 4:t="500";break;
					case 5:t="1000";break;
					case 6:t="10000";break;
				}
				typeText.text=t;
				typeText.setTextFormat(miseEnFormeFont);
				animerType(m);
			}
		}
		private function animerType(nMulti:int=0,reset:Boolean=false){
			var sens:int=1;
			var tempoMax:int=64;
			var resetVal:int=96;
			addEventListener(Event.ENTER_FRAME,runType);
			function runType(e:Event){
				if(sens==1&&tempoType<tempoMax+nMulti||sens==-1&&tempoType>0+nMulti){anim();}
				if(sens==1&&tempoType>=tempoMax+nMulti){sens=-1;}
				if((sens==-1&&tempoType<=0+nMulti)||reset==true){removeEventListener(Event.ENTER_FRAME,runType);}
				function anim(){
					tempoType+=sens*vitesse
					conteneurType.x-=sens*(vitesse/4);
					conteneurType.y-=sens*(vitesse/2);
					conteneurType.height+=sens*vitesse;
					conteneurType.width+=sens*vitesse;
				}
			}
		}
//fin====================================================================================================
		public function fin(){
			nColor=0;
			colorText.text="x1";
			colorText.setTextFormat(miseEnFormeFont);
			nType=0;
			typeText.text="0";
			typeText.setTextFormat(miseEnFormeFont);
			reset=true;
			addEventListener(Event.ENTER_FRAME,runFin);
			function runFin(e:Event){
				
				if(conteneurColor.width>64){animColorFin();}
				if(conteneurType.width>96){animTypeFin();}
				if(conteneurColor.width<=64&&conteneurType.width<=96){
					scoreCountDecor=false;
					tempoColor=0;
					tempoType=0;
					reset=false;removeEventListener(Event.ENTER_FRAME,runFin);
				}
			}
			function animColorFin(){
				conteneurColor.x+=(vitesse/2);
				conteneurColor.y+=(vitesse/2);
				conteneurColor.height-=vitesse;
				conteneurColor.width-=vitesse;
			}
			function animTypeFin(){
				conteneurType.x+=(vitesse/4);
				conteneurType.y+=(vitesse/2);
				conteneurType.height-=vitesse;
				conteneurType.width-=vitesse;
			}
		}
	}
}