package {
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class  GestionVie extends MovieClip {
		
		public var tRetourVie:int = 9;
		
		public var bddUpdate:Boolean = false;
		
		public var nbrVie:int = 0;
		public var dateTime:Date = new Date();
		public var dateTimeRV:Date = new Date();
		public var dateTimeBDD:String = new String();
		
		public var finVie:Boolean = false;
		
		public function GestionVie() {
			
		}
//INIT=============================================================================
		public function init(dateTimeTemp:Date) { 
			var dv:Date = dateTimeTemp;
			
			while (numChildren > 0) {
				removeChildAt(0);
			}
			var vtTab:Array = ajoutVieTemps();
			nbrVie = vtTab[0];
			dateTimeRV = vtTab[1];
			dateTime = dv;
			for (var v:int = 0; v < nbrVie; v++) { ajouterVieImage(); }
			function ajoutVieTemps():Array {
				var retour:Array = new Array();
				var vReste:int = 0;
				var tReste:int = 0;
				var dReste:Date = new Date();
				var dNow:Date = new Date();
				var dTime:Date = new Date(dv.fullYear, dv.month, dv.date, dv.hours, dv.minutes, dv.seconds, dv.milliseconds);
				
				for (var t:int = 0; t < 7;  t++) {
					var dTest:Date = new Date();
					dTest.minutes += tRetourVie * t;
					if (dTest.valueOf() > dTime.valueOf()) {
						vReste ++;
					}
				}
				if (vReste < 7) { tReste = (dTime.valueOf() - dNow.valueOf())-((6-vReste)*(tRetourVie*60000)); } else { tReste = 0;}
				dReste.milliseconds += tReste;
				retour = [vReste, dReste];
				return(retour);
			}
		}
//AJOUTER VIE========================================================================
		public function ajouterVie() {
			if (nbrVie < 7) {
				ajouterVieImage();
				nbrVie += 1;			
				dateTime.minutes -= tRetourVie;
				updateBDD(dateTime);
			}
		}
		private function ajouterVieImage() {
			if (this.numChildren < 7) {
				var  maVie:Bitmap = new Bitmap(new DiceLife);
				maVie.scaleX = maVie.scaleY = 0.5;
				maVie.y = 16;
				maVie.x = 160 - this.numChildren * 24;
				addChildAt(maVie, 0);
			}
		}
//SUPRIMER VIE======================================================================
		public function suprimerVie() {
			if (numChildren > 0) {
				addEventListener(Event.ENTER_FRAME, suppVie);
				nbrVie -= 1;
				var dNow:Date = new Date();
				if (dateTime.valueOf() < dNow.valueOf()) { dateTime = new Date();}
				dateTime.minutes += tRetourVie;
				updateBDD(dateTime);
			}else { finVie = true; }
			
			function suppVie(e:Event) {
				var vieTemp:Object = getChildAt(0);
				vieTemp.y -= 2;
				vieTemp.alpha -= 0.1;
				if(vieTemp.alpha<=0){
					removeChildAt(0);
					removeEventListener(Event.ENTER_FRAME, suppVie);
				}
			}
		}
//UPDATE BASE DE DONNEE===============================================================
		private function updateBDD(dtTemp:Date) {
			var dt:String=dtTemp.fullYear + "-" + (dtTemp.month+1) + "-" + dtTemp.date+" " + dtTemp.hours + ":" + dtTemp.minutes + ":" + dtTemp.seconds;
			dateTimeBDD = dt;
			bddUpdate = true;
		}
	}
}