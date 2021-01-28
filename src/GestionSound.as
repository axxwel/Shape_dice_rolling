package 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	public class GestionSound {
		
	//SOUNDS--------------------------------------------------------
		
		private var soundDiceTab:Array = new Array();
		
		private var sonMenuIn:Sound = new MenuInMP3();
		private var sonMenuOut:Sound = new MenuOutMP3();
		
		private var sonBipDepart_123:Sound = new BipDepart_123MP3();
		private var sonBipDepart_go:Sound = new BipDepart_goMP3();
		
		private var sonRoll:Sound = new RollMP3();
		private var sonRolling:Sound = new RollingMP3();
		
		private var sonTimesUp:Sound = new TimesUpMP3();
		
		private var sonCouleurPlus:Sound = new CouleurPlusMP3();
		private var sonFormePlus:Sound = new FormePlusMP3();
		
		private var sonComboToScore:Sound = new ComboToScoreMP3();
		
		public var soundOn:Boolean = true;
		
	//CHANNELS--------------------------------------------------------
		private var chanDice:SoundChannel = new SoundChannel();
		private var chanMenu:SoundChannel = new SoundChannel();
		private var chanAnnonce:SoundChannel = new SoundChannel();
		private var chanBonus:SoundChannel = new SoundChannel();
		private var chanScore:SoundChannel = new SoundChannel();
		
		public function GestionSound() {
			createDiceSoundClass();
		}
		public function onOff() {
			if (soundOn == true) { soundOn = false; } else { soundOn = true; }
		}
	//DICE--------------------------------------------------------------
		public function diceTourne(nbrDice:int = 0) {
			if(soundOn==true){
				if (nbrDice <= 24) { chanDice = soundDiceTab[nbrDice].play(); }
				else { chanDice = soundDiceTab[24].play(); }
			}
		}
		private function createDiceSoundClass() {
			for (var s:int = 0; s <= 24; s++) {
				var classSoundDice:Class = getDefinitionByName("DiceMP3_"+s) as Class;
				var soundDice:Sound = new classSoundDice();
				soundDiceTab[s] = soundDice;
			}
		}
	//MENU----------------------------------------------------------------
		public function menuIn() { if (soundOn == true) { chanMenu = sonMenuIn.play(); }}
		public function menuOut() { if (soundOn == true) {chanMenu=sonMenuOut.play();}}
	//ANNONCE-------------------------------------------------------------		
		public function bipDepart(fin:Boolean = false) {
			if (soundOn == true) {
				if (fin == true) { chanAnnonce=sonBipDepart_go.play(); }
				else { chanAnnonce = sonBipDepart_123.play(); }
				chanAnnonce.soundTransform = new SoundTransform(0.4);
			}
		}
		public function anonceRoll() { if (soundOn == true) { chanAnnonce = sonRoll.play(); }}
		public function anonceRolling() {  if (soundOn == true) { chanAnnonce = sonRolling.play(); }}
		public function timesUp() { if (soundOn == true) { chanAnnonce = sonTimesUp.play(); }}
	//BONUS----------------------------------------------------------------
		public function formePlus() { if (soundOn == true) { chanBonus = sonFormePlus.play(); chanBonus.soundTransform = new SoundTransform(0.1); }}
		public function couleurPlus() { if (soundOn == true) { chanBonus = sonCouleurPlus.play(); chanBonus.soundTransform = new SoundTransform(0.1); }}
	//SCORE----------------------------------------------------------------
		public function combScor() { if (soundOn == true) { chanScore = sonComboToScore.play(); }}
	}
}