package{
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	
	public class ScoreMultiBonus extends Sprite{
		
		public var conteneur:Sprite=new Sprite();
		
		private var decor:DecorScore=new DecorScore();
		public var decorUP:DecorMultiBonus=new DecorMultiBonus();
		
		private const longueurBarreTotal:int=176;
//couleur==================================================================
		private var conteneurCouleur:Sprite=new Sprite(); 
		private var couleurBarre:Sprite=new Sprite(); 
		public var couleurUtilise:Array=new Array();
		
//type====================================================================
		private var conteneurType:Sprite=new Sprite(); 
		public var typeUtilise:Array=new Array();
		public var suppCouleur:Boolean=false;
		public var suppType:Boolean=false;
		
		private var suppTypeTimer:int=0;
		private var typeColorTimer:int=0;
		
		public var scoreCountCouleur:Boolean=false;
		public var scoreCountType:Boolean = false;
		
		public var sonCouleur:Boolean = false;
		public var sonForme:Boolean = false;
		
		public function ScoreMultiBonus(){
			decor.gotoAndStop(2);
			conteneur.addChild(decor);
			
			conteneurCouleur.x=24;
			conteneurCouleur.y=16;
			conteneurCouleur.addChild(couleurBarre);
			conteneur.addChild(conteneurCouleur);
			
			conteneurType.x=120;
			conteneurType.y=16;
			conteneur.addChild(conteneurType);
			
			decorUP.name="decor";
			conteneur.addChild(decorUP);
			
			addChild(conteneur);
		}
//couleur====================================================================================================================
		public function ajouterCouleur(diceTemp:Array){
			var couleurForme:int=diceTemp[1];
			var couleurPrise:Boolean=false;
			for(var i:int=0;i<couleurUtilise.length;i++){
				if(couleurUtilise[i]==couleurForme){couleurPrise=true;}
			}
			if (couleurPrise == false) {
				couleurUtilise.push(couleurForme);
				decorUP.ajouterColor();
				if(couleurUtilise.length>=3){sonCouleur = true;}
			}
			
			var tableauCouleur:Array=new Array();
			var tableauAlpha:Array=new Array();
			var tableaupostion:Array=new Array();
			var longueurBarre:int=0;
			for(var c:int=0;c<couleurUtilise.length;c++){
				tableauAlpha[c]=1;
				switch(couleurUtilise[c]){
					case 1 : tableauCouleur[c]="0x91268f";break;//violet
					case 2 : tableauCouleur[c]="0xf7931e";break;//orange
					case 3 : tableauCouleur[c]="0xffff00";break;//jaune
					case 4 : tableauCouleur[c]="0xff0000";break;//rouge
					case 5 : tableauCouleur[c]="0x00ff00";break;//vert
					case 6 : tableauCouleur[c]="0x0000ff";break;//bleu
				}
			}
			tableaupostion[0]=0;
			tableauAlpha[0]=1;
			switch(tableauCouleur.length-1){
				case 1:tableaupostion[1]=255;break;
				case 2:tableaupostion[1]=127;tableaupostion[2]=255;break;
				case 3:tableaupostion[1]=85;tableaupostion[2]=170;tableaupostion[3]=255;break;
				case 4:tableaupostion[1]=64;tableaupostion[2]=128;tableaupostion[3]=192;tableaupostion[4]=255;break;
				case 5:tableaupostion[1]=51;tableaupostion[2]=102;tableaupostion[3]=153;tableaupostion[4]=204;tableaupostion[5]=255;break;
				case 6:tableaupostion[1]=42;tableaupostion[2]=84;tableaupostion[3]=126;tableaupostion[4]=168;tableaupostion[5]=210;tableaupostion[6]=255;break;
			}
			longueurBarre=(longueurBarreTotal/6)*tableauCouleur.length;
			
			tracejaugeCouleur(tableauCouleur,longueurBarre,tableauAlpha,tableaupostion);
		}
		private function tracejaugeCouleur(tableauCouleur,longueurBarre,tableauAlpha,tableaupostion){
			if (couleurBarre.numChildren > 0) {
				var contStar:Sprite = Sprite(couleurBarre.getChildByName("Stars"));
				while (contStar.numChildren > 0) {
					RainbowStars(contStar.getChildAt(0)).remove();
					contStar.removeChildAt(0);
				}
				couleurBarre.removeChild(couleurBarre.getChildByName("Stars"));
				couleurBarre.removeChild(couleurBarre.getChildByName("rectangle_couleur"));
				conteneurCouleur.removeChild(conteneurCouleur.getChildByName("MaskBar"));				
			}
			var rectangleCouleur:Shape = new Shape();
			rectangleCouleur.name="rectangle_couleur";
			var matrice:Matrix = new Matrix();
			matrice.createGradientBox(longueurBarre/tableauCouleur.length,longueurBarre,-(Math.PI/2));
			rectangleCouleur.graphics.beginGradientFill(GradientType.LINEAR,tableauCouleur,tableauAlpha,tableaupostion,matrice);
			rectangleCouleur.graphics.drawRect(0,0,64,longueurBarre);
			
			var maskBar:MaskBarreCouleur=new MaskBarreCouleur();
			maskBar.name="MaskBar";
			rectangleCouleur.y=longueurBarreTotal-longueurBarre;
			
			conteneurCouleur.addChild(maskBar);
			couleurBarre.addChild(rectangleCouleur);
			couleurBarre.mask=maskBar
			
			var monGlow:GlowFilter=new GlowFilter(0xF400A1);
			var monInerGlow:GlowFilter=new GlowFilter(0x000000,0.5,50,0,2,1,true)
			
			couleurBarre.filters=[monGlow];
			rectangleCouleur.filters = [monInerGlow];
			
			var stars:MovieClip = new MovieClip();
			stars.y=longueurBarreTotal-longueurBarre;
			stars.name="Stars";
			rainbow(64, stars);
			rainbow(64,stars);
			couleurBarre.addChild(stars);
		}
		public function viderJaugeCouleur(){
			if(couleurBarre.numChildren>0){
				if(Shape(couleurBarre.getChildByName("rectangle_couleur")).height<=12){
					while(couleurBarre.numChildren>0){couleurBarre.removeChildAt(0);}
					conteneurCouleur.removeChild(conteneurCouleur.getChildByName("MaskBar"));
					decorUP.fin();
					suppCouleur=false;
					scoreCountCouleur=false;
				}else{
					Shape(couleurBarre.getChildByName("rectangle_couleur")).height-=12;
					Shape(couleurBarre.getChildByName("rectangle_couleur")).y+=12;
				}
			}
			couleurUtilise=[];
		}
// type===========================================================================================================
		public function ajouterType(diceTemp:Array){
			var typeForme:int=diceTemp[0];
			var typePrise:Boolean=false;
			for(var i:int=0;i<typeUtilise.length;i++){
				if(typeUtilise[i]==typeForme){typePrise=true;}
			}
			if (typePrise == false) {
				typeUtilise.push(typeForme);
				decorUP.ajouterType();
				if(typeUtilise.length>=3){sonForme = true;}
			}
			
			if(conteneurType.numChildren-1<typeUtilise.length){
				var monType:FormeScoreImage=new FormeScoreImage();
				
				var monGlow:GlowFilter=new GlowFilter(0xF400A1);
				var monOmbre:DropShadowFilter=new DropShadowFilter();
				
				monType.filters=[monOmbre,monGlow];
			
				monType.x=4;
				monType.y=(longueurBarreTotal-45)-((longueurBarreTotal-16)/6)*(typeUtilise.length-1);
				
				monType.scaleX=1;
				monType.scaleY=0.8;
				
				monType.gotoAndStop(typeUtilise[typeUtilise.length-1]+36);
				
				conteneurType.addChild(monType);
			}
			if (conteneurType.numChildren == 1) {
				var stars:Sprite = new Sprite();
				stars.name = "Stars";
				rainbow(monType.height, stars);
				rainbow(monType.height, stars);
				conteneurType.addChildAt(stars, conteneurType.numChildren);
			}
			if (conteneurType.getChildByName("Stars") is DisplayObject) {
				var starsTemp:Sprite = Sprite(conteneurType.getChildByName("Stars"));
				starsTemp.y=(longueurBarreTotal-45)-((longueurBarreTotal-16)/6)*(typeUtilise.length-1);
			}
		}
		public function suprimerType(){
			if (conteneurType.numChildren > 0) {
				if (conteneurType.getChildByName("Stars") is DisplayObject) {
					var contStar:Sprite = Sprite(conteneurType.getChildByName("Stars"));
					while (contStar.numChildren > 0) {
						RainbowStars(contStar.getChildAt(0)).remove();
						contStar.removeChildAt(0);
					}
					conteneurType.removeChild(conteneurType.getChildByName("Stars"));
				}
				var Type:Object=FormeScoreImage(conteneurType.getChildAt(conteneurType.numChildren-1));
				var vitesse:int=16;
				if(suppTypeTimer>-Type.height){
					Type.y-=vitesse;
					Type.alpha-=1/((Type.height)/vitesse);
					suppTypeTimer-=vitesse;
				}else{
					conteneurType.removeChildAt(conteneurType.numChildren-1);suppTypeTimer=0;
				}
			}
			if (conteneurType.numChildren <= 0) {
				typeUtilise = [];
				decorUP.fin();
				suppType = false;
				scoreCountType = false;
			}
		}
//rainbow stars===================================================================================================
		private function rainbow(tailleTemp:int,objetClipTemp:Object){
			var objetClip:Object=objetClipTemp
			var tailleStars:int=tailleTemp;
			var stars:RainbowStars=new RainbowStars(tailleStars,tailleStars);
			objetClip.addChild(stars);
		}
	}
}