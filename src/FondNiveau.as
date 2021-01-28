package{
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	
	public class FondNiveau extends Sprite{
		
		public var taille:int = 96;
		public var niveauTab:Array = [[1, 1, 1, 1, 1, 1],
									  [1, 1, 1, 1, 1, 1],
									  [1, 1, 1, 1, 1, 1],
									  [1, 1, 1, 1, 1, 1],
									  [1, 1, 1, 1, 1, 1],
									  [1, 1, 1, 1, 1, 1]];
		
		public var niveauFondTab:Array = new Array();
		
		public function FondNiveau() {
	
		}
		public function init() {
	//Creer niveauTabTemp---------------------------------------------------------
			var tailleFondTab:int = niveauTab.length+1;
			for ( var L:int = 0; L < tailleFondTab; L++) {
				var niveauFondTabL:Array = new Array();
				for ( var C:int = 0; C < tailleFondTab; C++) {
					var bordBit:Array = new Array();
					
					if ( L - 1 >= 0 && C - 1 >= 0) {
						if (niveauTab[L - 1][C - 1] > 0) { bordBit[0] = 1; } else { bordBit[0] = 0; }
					} else { bordBit[0] = 0; }
					
					if ( L - 1 >= 0 ) {
						if (niveauTab[L - 1][C] > 0) { bordBit[1] = 1; } else { bordBit[1] = 0; }
					} else { bordBit[1] = 0; }
					
					if ( L < niveauTab.length && C - 1 >= 0) {
						if (niveauTab[L][C - 1] > 0) { bordBit[2] = 1; } else { bordBit[2] = 0; }
					} else { bordBit[2] = 0; }
					
					if ( L < niveauTab.length ) {
						if (niveauTab[L][C] > 0) { bordBit[3] = 1; } else { bordBit[3] = 0; }
					} else { bordBit[3] = 0; }
					if (bordBit[0] == 0 && bordBit[1] == 0 && bordBit[2] == 0 && bordBit[3] == 0) { niveauFondTabL[C] = null; }
					if (bordBit[0] == 0 && bordBit[1] == 0 && bordBit[2] == 0 && bordBit[3] == 1) { niveauFondTabL[C] = 0; }
					if (bordBit[0] == 0 && bordBit[1] == 0 && bordBit[2] == 1 && bordBit[3] == 0) { niveauFondTabL[C] = 1; }
					if (bordBit[0] == 0 && bordBit[1] == 0 && bordBit[2] == 1 && bordBit[3] == 1) { niveauFondTabL[C] = 2; }
					if (bordBit[0] == 0 && bordBit[1] == 1 && bordBit[2] == 0 && bordBit[3] == 0) { niveauFondTabL[C] = 3; }
					if (bordBit[0] == 0 && bordBit[1] == 1 && bordBit[2] == 0 && bordBit[3] == 1) { niveauFondTabL[C] = 4; }
					if (bordBit[0] == 0 && bordBit[1] == 1 && bordBit[2] == 1 && bordBit[3] == 0) { niveauFondTabL[C] = 5; }
					if (bordBit[0] == 0 && bordBit[1] == 1 && bordBit[2] == 1 && bordBit[3] == 1) { niveauFondTabL[C] = 6; }
					if (bordBit[0] == 1 && bordBit[1] == 0 && bordBit[2] == 0 && bordBit[3] == 0) { niveauFondTabL[C] = 7; }
					if (bordBit[0] == 1 && bordBit[1] == 0 && bordBit[2] == 0 && bordBit[3] == 1) { niveauFondTabL[C] = 8; }
					if (bordBit[0] == 1 && bordBit[1] == 0 && bordBit[2] == 1 && bordBit[3] == 0) { niveauFondTabL[C] = 9; }
					if (bordBit[0] == 1 && bordBit[1] == 0 && bordBit[2] == 1 && bordBit[3] == 1) { niveauFondTabL[C] = 10; }
					if (bordBit[0] == 1 && bordBit[1] == 1 && bordBit[2] == 0 && bordBit[3] == 0) { niveauFondTabL[C] = 11; }
					if (bordBit[0] == 1 && bordBit[1] == 1 && bordBit[2] == 0 && bordBit[3] == 1) { niveauFondTabL[C] = 12; }
					if (bordBit[0] == 1 && bordBit[1] == 1 && bordBit[2] == 1 && bordBit[3] == 0) { niveauFondTabL[C] = 13; }
					if (bordBit[0] == 1 && bordBit[1] == 1 && bordBit[2] == 1 && bordBit[3] == 1) { niveauFondTabL[C] = 14; }
				}
				niveauFondTab[L] = niveauFondTabL;
			}
			creerFond();
		}
		private function creerFond() {
			for (var L:int = 0; L < niveauFondTab.length; L++ ) {
				for (var C:int = 0; C < niveauFondTab[L].length; C++) {
					if (niveauFondTab[L][C] != null) {
						var classBordNiveau:Class = getDefinitionByName("BordNiveau_"+niveauFondTab[L][C]) as Class;
						var ClassDataBordNiveau:BitmapData = new classBordNiveau();
						var monBordNiveau:Bitmap=new Bitmap(ClassDataBordNiveau);
						monBordNiveau.name = "BordNiveau";
						monBordNiveau.x = C * taille;
						monBordNiveau.y = L * taille;
						addChild(monBordNiveau); 
					}
				}
			}
		}
	}
}