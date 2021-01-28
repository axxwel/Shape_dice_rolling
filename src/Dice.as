package{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	
	import flash.filters.GlowFilter;
	
	public class Dice extends Sprite{
		public var conteneur:Sprite = new Sprite();
		private var conteneurDice:Sprite = new Sprite();
		
		public var taille:int=96;
		private var unHuitieme:Number = 12;
		private var defInt:int = 0;
		private var defSens:int = 1;
		public var type:int=1;
		public var couleur:int=1;
		
		private var sensRotation:int=0;
		private var typeNew:int=1;
		private var couleurNew:int=1;
		
		public var aideActive:Boolean=false;
		public var aideTempo:Number=0;
		
		public var tourneEnCours:Boolean=false;
		public var nomDice:String = "";
		
		public function Dice(tailleTemp:int,typeCouleurTemp:Array,nomDiceTemp:String){
			nomDice=nomDiceTemp;
			taille=tailleTemp;
			type=typeCouleurTemp[0]-1;
			couleur=typeCouleurTemp[1]-1;
			unHuitieme=taille/8;
			
			var rotationDice:int=Math.round(3-Math.random()*6);
			conteneur.x=taille/2;
			conteneur.y=taille/2;
			conteneur.rotation=rotationDice;
			conteneurDice.x=-taille/2;
			conteneurDice.y=-taille/2;
			conteneur.addChild(conteneurDice);
			addChild(conteneur);
			creer();
		}
	//CREER=========================================================================================
		public function creer(){
		//Ajout dice-------------------------
			var classDice:Class = getDefinitionByName("DiceImage_"+couleur+"_"+type) as Class;
			var ClassDataDice:BitmapData = new classDice();
			var imageDice:BitmapDice =new BitmapDice(ClassDataDice);
			
			imageDice.name="Dice";
			imageDice.height=taille;
			imageDice.width = taille;
			
			conteneurDice.addChild(imageDice);
			
		//Ajout rainbow------------------------
			var conteneurRS:Sprite=new Sprite();
			conteneurRS.name="RainbowStars";
			conteneurDice.addChild(conteneurRS);
		}
	//TOURNER========================================================================================
		public function tourner(sensTemp:int, typeCouleurTemp:Array) {
			tourneEnCours=true;
			sensRotation=sensTemp;
			typeNew=typeCouleurTemp[0]-1;
			couleurNew=typeCouleurTemp[1]-1;
		//init old forme----------------------------------
			var imageDiceOld:BitmapDice=BitmapDice(conteneurDice.getChildByName("Dice"));
			imageDiceOld.name="DiceOld";
			
		//Ajout nouvelle forme----------------------------
			var classDice:Class = getDefinitionByName("DiceImage_"+couleurNew+"_"+typeNew) as Class;
			var ClassDataDice:BitmapData = new classDice();
			var imageDiceNew:BitmapDice =new BitmapDice(ClassDataDice);
			
			imageDiceNew.name = "DiceNew";
			imageDiceNew.height=taille;
			imageDiceNew.width=taille;
			
			conteneurDice.addChildAt(imageDiceNew, 0); 
		//Gestion sens----------------------------------------
			if(sensRotation!=0){
				switch(sensRotation){
					case 1: imageDiceNew.height=0;imageDiceNew.y=taille;break;
					case 2: imageDiceNew.width=0;imageDiceNew.x=0;break;
					case 3: imageDiceNew.width=0;imageDiceNew.x=taille;break;
					case 4: imageDiceNew.height=0;imageDiceNew.y=0;break;
				}
			}
		//lance touner-------------------------------------
			addEventListener(Event.ENTER_FRAME, diceTourne);
		}
	//TOURNER DICE====================================================================================
		public function diceTourne(e:Event){
			var imageDiceOld:BitmapDice=BitmapDice(conteneurDice.getChildByName("DiceOld"));
			var imageDiceNew:BitmapDice=BitmapDice(conteneurDice.getChildByName("DiceNew"));
			var initNewForme = false;
			
			var ligne1:Number = 0;
			var ligne2:Number = 0;
			var ligne3:Number = 0;
			var ligne4:Number = 0;
			
			var eff:int = 3;
			
			if (sensRotation != 0 && (imageDiceNew.height < taille || imageDiceNew.width < taille)) {
				defInt += defSens;
				if (defSens == 1 && defInt > 4) { defSens = -1 ; }
				if (defSens == -1 && defInt < 1) { defSens = 1; }
				if (defInt >= 5) { defInt = 4; }
				
				switch(sensRotation){
					case 1: 
						imageDiceOld.height-=unHuitieme;
						imageDiceNew.height += unHuitieme; imageDiceNew.y -= unHuitieme; 
						ligne4 = defInt * eff;
						break;
					case 2: // >
						imageDiceOld.width-=unHuitieme;imageDiceOld.x+=unHuitieme;
						imageDiceNew.width += unHuitieme; 
						ligne1 = defInt * eff;
						break;
					case 3:// <
						imageDiceOld.width-=unHuitieme;
						imageDiceNew.x -= unHuitieme; imageDiceNew.width += unHuitieme; 
						ligne2 = defInt * eff;
						break;
					case 4: 
						imageDiceOld.height-=unHuitieme;imageDiceOld.y+=unHuitieme;
						imageDiceNew.height += unHuitieme; 
						ligne3 = defInt * eff;
						break;
				}
				imageDiceNew.animer(ligne1, ligne2, ligne3, ligne4, false);
				imageDiceOld.animer(ligne2, ligne1, ligne4, ligne3, false);
				conteneur.scaleX=1.15;
				conteneur.scaleY=1.15;
			}
			//Fin tourne------------------------------------
			else {
				imageDiceNew.animer(0,0,0,0,false);
				imageDiceOld.animer(0,0,0,0,false);
				conteneur.scaleX=1;
				conteneur.scaleY = 1;
				
				BitmapDice(conteneurDice.getChildByName("DiceOld")).remove();
				conteneurDice.removeChild(Sprite(conteneurDice.getChildByName("DiceOld")));
				
				imageDiceNew.x=0;
				imageDiceNew.y=0;
				imageDiceNew.height=taille;
				imageDiceNew.width=taille;
				couleur=couleurNew;
				type = typeNew;
				defSens = 1;
				defInt = 0;initNewForme=true;
			}
			if(initNewForme==true){
				imageDiceNew.name = "Dice";
				imageDiceNew.animer();
				tourneEnCours=false;
				removeEventListener(Event.ENTER_FRAME,diceTourne);
			}
		}
	//BOUGER================================================================================================
		public function bouger(sourisX:int,sourisY:int,sourisClic:Boolean){
			var decalageX:int=sourisX-(this.x+taille/2);
			var decalageY:int=sourisY-(this.y+taille/2);
			var rotationRadian:Number=Math.atan2(decalageY,decalageX);
			var clickFactor:int=90;
			if(sourisClic==true){clickFactor=30;}
			var rotationDegrees:Number=(rotationRadian*180/Math.PI)/45;
			conteneur.rotation=rotationDegrees;
		}
	//SELECTION DICE=========================================================================================
		public function selectione(){
			conteneur.scaleX=0.97;
			conteneur.scaleY = 0.97;
			
			var rainbowStar:Object=Sprite(conteneurDice.getChildByName("RainbowStars"));
			if(rainbowStar.numChildren<1){
				for(var i:uint=0;i<3;i++){
					var stars:RainbowStars = new RainbowStars(taille , taille);
					rainbowStar.addChild(stars);
				}
			}
		}
	//DESELECTIONE DICE=======================================================================================
		public function unSelectione(){
			suprimerRainbow();
			conteneur.scaleX=1;
			conteneur.scaleY=1;
		}
	//RAINBOW=================================================================================================
		//gestion rainbow------------------------------------------------------------
		public function gestionRainbow(image:int) {
			if (conteneurDice.getChildByName("Rainbow") is DisplayObject) {
				BitmapData(Bitmap(conteneurDice.getChildByName("Rainbow")).bitmapData).dispose;
				conteneurDice.removeChild(conteneurDice.getChildByName("Rainbow"));
			}
			if (image >= 2) {
				var classRainbow:Class = getDefinitionByName("Rainbow_"+(image-1)) as Class;
				var ClassDataRainbow:BitmapData = new classRainbow();
				var monRainbow:Bitmap=new Bitmap(ClassDataRainbow);
				monRainbow.name = "Rainbow";
				monRainbow.height=taille;
				monRainbow.width = taille;
				conteneurDice.addChild(monRainbow);
			}
			var rainbowStar:Object=Sprite(conteneurDice.getChildByName("RainbowStars"));
			if (image > 2) {
				while (rainbowStar.numChildren > 1) {
					RainbowStars(rainbowStar.getChildAt(0)).remove();
					rainbowStar.removeChildAt(0);
				}
			}
		}
		//suprimer rainbow------------------------------------------------------------
		public function suprimerRainbow() {
			if (conteneurDice.getChildByName("Rainbow") is DisplayObject) {
				BitmapData(Bitmap(conteneurDice.getChildByName("Rainbow")).bitmapData).dispose;
				conteneurDice.removeChild(conteneurDice.getChildByName("Rainbow"));
			}
			var rainbowStar:Object=Sprite(conteneurDice.getChildByName("RainbowStars"));
			while (rainbowStar.numChildren > 0) {
				RainbowStars(rainbowStar.getChildAt(0)).remove();
				rainbowStar.removeChildAt(0);
			}
		}
	//AIDE====================================================================================================
		public function aide(){
			var aideTaille:Number=0;
			var vitesse:Number=1/6;
			var bitmapDice:BitmapDice=BitmapDice(conteneurDice.getChildByName("Dice"));
			var monGlowDice:GlowFilter=new GlowFilter();
			
			if(aideActive==true){
				if(aideTempo<10){aideTempo+=6*vitesse;}else{aideActive=false;}
			}
			if(aideActive==false){aideTempo-=1*vitesse;}
			aideTaille=aideTempo*(taille/100);
			
			monGlowDice.color=donneCouleur(type);
			monGlowDice.alpha=(aideTaille*5)/100;
			monGlowDice.blurX=(aideTaille*10)/2;
			monGlowDice.blurY=(aideTaille*10)/2;
			monGlowDice.inner = true;
			
			
			bitmapDice.filters=[monGlowDice];
			
			
			conteneurDice.height=taille+aideTaille;
			conteneurDice.width=taille+aideTaille;
			
			
			function donneCouleur(ndTemp:int):String{
				var cd:int=ndTemp;
				var retour:String="";
				switch(cd) {
					case 0: retour = "0x9060A8"; break;//violet
					case 1: retour = "0xF7931D"; break;//orange
					case 2: retour = "0xFFDD17"; break;//jaune
					case 3: retour = "0xED1C24"; break;//rouge
					case 4: retour = "0x8CC63E"; break;//vert
					case 5: retour = "0x27A9E1"; break;//bleu
				}
				return(retour);
			}
		}
		public function annuleAide(){
			var bitmapDice:BitmapDice=BitmapDice(conteneurDice.getChildByName("Dice"));
			bitmapDice.filters=[];
			aideActive=false;
			conteneurDice.height=taille;
			conteneurDice.width=taille;
			aideTempo=0;
		}
	}
}