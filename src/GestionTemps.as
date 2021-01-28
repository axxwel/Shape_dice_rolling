package{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	
	public class GestionTemps extends MovieClip{
		
		public var conteneur:Sprite=new Sprite();
		
		private var monTimer:Timer=new Timer(100);
		public var afficheChrono:TextField=new TextField;
		public var miseEnFormeChrono:TextFormat=new TextFormat();
		public var miseEnFormeMinute:TextFormat=new TextFormat();
		public var miseEnFormeSeconde:TextFormat=new TextFormat();
		public var miseEnFormeCent:TextFormat=new TextFormat();
		
		private var monGlow:GlowFilter=new GlowFilter(0xf400a1,1,5,5,10);
		private var monOmbre:DropShadowFilter=new DropShadowFilter(3,45,0x000000,0.5);
		
		private var minute:int=0;
		private var seconde:int=1;
		private var dixiemeS:int=0;
		private var zero:String="";
		private var zeroC:String = "";
		private var tempsTotalS:int = 0;
		
		public var tauxChance:int = 0;
		private var tauxChanceReal:Number = 0;
		private var tempsAjoute:int = 0;
		private var tauxChanceMax:Boolean=false;
		
		public var finTemps:Boolean=false;
		
		public var miseZeroFin:Boolean = false;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFont:Class;
		
		public function GestionTemps(){
			addChild(conteneur);
			
			miseEnFormeChrono.size=28;
			miseEnFormeMinute.size=48;
			miseEnFormeSeconde.size=64;
			miseEnFormeChrono.font="Cooper Std black";
			miseEnFormeChrono.color=0xf7ff3c;
			miseEnFormeChrono.align="right";
			
			miseEnFormeChrono.bold=true;
			
			afficheChrono.embedFonts = true;
			afficheChrono.selectable=false;
			afficheChrono.name="Score";
			afficheChrono.y=32;
			afficheChrono.width=192;
			afficheChrono.filters=[monGlow,monOmbre];
			
			conteneur.addChild(afficheChrono);
		}
		public function run(){
			if(seconde<0){minute-=1;seconde=59;}
			if(seconde<10){zero="0";}else{zero="";}
			if(minute>0){afficheChrono.text=minute+":"+zero+seconde+zeroC+dixiemeS;}else{afficheChrono.text=":"+zero+seconde+" "+dixiemeS;}
			if(minute<=0&&seconde<=0&&dixiemeS<=0){
				finTemps=true;
				monTimer.stop();
			}
			afficheChrono.setTextFormat(miseEnFormeChrono);
			if(minute>0){
				afficheChrono.setTextFormat(miseEnFormeMinute,0,2);
				afficheChrono.setTextFormat(miseEnFormeSeconde,2,4);
			}else{
				afficheChrono.setTextFormat(miseEnFormeMinute,0,1);
				afficheChrono.setTextFormat(miseEnFormeSeconde,1,3);
			}
		}
		public function miseZero(tempsTemp:Array){
			miseZeroFin=false;
			minute = tempsTemp[0];
			seconde = tempsTemp[1];
			dixiemeS = 0;
			tempsTotalS = tempsTemp[0] * 60 + tempsTemp[1];
			tempsAjoute = 0;
			tauxChance=0;
			tauxChanceMax=false;
			run();
			miseZeroFin=true;
		}
		public function timerStart(){
			monTimer.addEventListener(TimerEvent.TIMER,timerTic);
			monTimer.start();
		}
		public function timerStop() {
			monTimer.stop();
			monTimer.removeEventListener(TimerEvent.TIMER,timerTic);
		}
		private function timerTic(e:Event){
			dixiemeS-=1;
			if(dixiemeS<0){
				gestionTauxChance();
				seconde-=1;
				dixiemeS=9;
			}
			run();
		}
		public function ajouterTemps(t:int) {
			var bonusTemps:int=t;
			var ajoutS:int=0;
			var ajoutM:int=0;
			if(seconde+bonusTemps>59){
				ajoutM+=1;
				ajoutS=bonusTemps-60;
			}else{ajoutS=bonusTemps;}
			minute+=ajoutM;
			seconde+= ajoutS;
			tempsAjoute+= t;
		}
		private function gestionTauxChance() { 
			var tc:Number = 100 / (tempsTotalS+tempsAjoute);
			tauxChanceReal = tc*((tempsTotalS+tempsAjoute)-(minute*60+seconde));
			tauxChance = tauxChanceReal;
		}
	}
}