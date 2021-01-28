package{
	
	public class Langage{
		
		public var langue:String = "en_US";
		
		public var prix:Array = new Array("0.45€", "0.90€", "2.25€", "4.50€", "9.00€", "22.50€", "45.00€");
		
		public var explication_0:String = "Click on a dice and move the mouse on the closest dice, whitch has the same FORM or the same COLOR.";
		public var explication_1:String = "Example, a BLUE SQUARE can be combined with another SQUARE, whatever the color. OR, whatever BLUE form...";
		public var explication_2:String = "Combine a maximun of dices to create the longest suit. ";
		public var explication_3:String = "the gauge COMBO indicates the number of dices in the suit. Fill in to win more TIME and maybe a LIFE...";
		public var explication_4:String = "the gauge COLOR indicates the number of various COLORS in the suit. Fill in increases the score multiplier...";
		public var explication_5:String = "the gauge FORM indicates the number of various FORMS in the suit. Fill in add score bonus...";
		public var bought:String = "bought";
		public var newLife:String = "New life in";
		public var endLife:String="Need lives!" 
		
		public var btnStart:String = "Start";
		public var btnNext:String = "Next";
		public var btnPrevious:String = "Previous";
		public var btnEnd:String = "End";
		public var btnYes:String="Play";
		public var btnRestart:String="Restart";
		public var btnShare:String = "Share";
		public var btnInvite:String = "Invite friends";
		public var btnSend:String = "Send";
		public var btnAsk:String = "Ask lives";
		public var btnMoreLives:String = "More lives";
		public var btnSendAll:String = "Send All";
		public var btnBuy:String = "Buy";
		public var btnBank:String = "Bank";
		public var btnOK:String = "OK";
		public var btnAccept:String = "Accept All";
		public var btnWorld:String = "World";
		public var btnFriend:String = "Friends";
		
		public var life:String = "live";
		public var lives:String = "lives";
		
		public var neww:String = "New";
		
		public var worldChampion:String = "Record";
		public var worldClassement:String = "Rank";
		public var score:String="Score";
		public var bestCombo:String = "Combo";
		public var scoreEver:String="Best Score";
		public var bestComboEver:String = "Best Combo";
		public var selectAll:String = "Select all";
		public var ranking:String = "Ranking";
		public var inviteFriends:String = "Invite more friends...";
		public var friendBeat:String = "Beaten friends...";
		public var friendBeatNo:String = "None beaten friends...";
		public var shareLives:String = "Ask Lives...";
		public var messageBoard:String = "Messages...";
		public var bank:String = "Bank...";
		
		public var sendMessage_SDR:String = " play Shape Dice Rolling !";
		public var sendMessage_invit:String = "Come play with me to Shape Dice Rolling!";
		public var sendMessage_needLife:String = "help me! I need a life!";
		public var sendMessage_giveLife:String = "I give You a Life!";
		public var sendMessageMe_titleNew:String = "New Shape Dice Rolling ";
		public var sendMessageMe_new:String = "new Score ! Try to beat ";
		public var sendMessageMe_Score:String = "new High Score! Try to beat ";
		public var sendMessageMe_Combo:String = "new High Combo! Try to beat ";
		public var sendMessage_Score:String = "I beat your  best score! Try to beat ";
		
		public function Langage(){
			
		}
		public function setLangage(langueTemp:String="us_US"){
			if (langueTemp == "fr_FR") {
				langue="fr_FR"
				explication_0 = "Cliquez sur un dés puis deplacez la souris vers un dés proche, qui a la même FORME ou la même COULEUR...";
				explication_1 = "Exemple, un CARRÉ BLEU s'associe avec, un autre CARRÉ de n'importe quelle couleur. OU, avec n'importe quelle autre forme, BLEU...";
				explication_2 = "Associez le maximum de dés pour créer la suite la plus longue...";
				explication_3 = "La jauge de COMBO indique le Nombre de dés accumulés. La remplir fait gagner du TEMPS et aussi une VIE...";
				explication_4 = "La jauge MULTIPLICATEUR indique le nombre de COULEURS differentes dans la suite de dés. La remplir augmente le muliplicateur de score...";
				explication_5 = "La jauge BONUS indique le nombre de FORMES differentes dans la suite de dés. La remplir ajoute des bonus au score...";
				bought = "acheté";
				newLife = "Nouvelle vie dans:";
				endLife="Besoin de vies!"
				
				btnStart = "Jouer";
				btnNext = "Suivant";
				btnPrevious = "Précédent";
				btnEnd = "Terminé";
				btnYes="Commencer";
				btnRestart="ReJouer";
				btnShare = "Partager";
				btnInvite="Inviter amis"
				btnSend = "Envoyer";
				btnAsk = "Demander vies";
				btnMoreLives = "Plus de vies";
				btnSendAll = "Envoyer à tous";
				btnBuy = "Acheter";
				btnBank = "Banque";
				btnOK = "OK";
				btnAccept = "Accepter tout";
				btnWorld = "Monde";
				btnFriend = "Amis";
				
				life = "vie";
				lives = "vies";
				
				neww = "Nouveau";
				
				worldChampion = "Record";
				worldClassement="Classement"
				score="Score";
				bestCombo = "Combo";
				scoreEver="Meilleur Score";
				bestComboEver = "Meilleur Combo";
				selectAll = "Sélectionner tous";
				ranking = "Classement";
				inviteFriends = "Inviter plus d'amis...";
				friendBeat = "Amis battus...";
				friendBeatNo = "Aucun Ami battu...";
				shareLives = "Demander Vies...";
				messageBoard = "Messages...";
				bank = "Banque...";
				
				sendMessage_SDR = " Joue à Shape Dice Rolling !";
				sendMessage_invit = "Viens jouer avec moi à Shape Dice Rolling!";
				sendMessage_needLife = "Aide moi! j'ai besoin d'une vie!";
				sendMessage_giveLife = "Je te donne une vie!";
				sendMessageMe_titleNew="Nouveau Shape Dice Rolling "
				sendMessageMe_new = " fait un nouveau Score ! Essaie de battre ";
				sendMessageMe_Score = " augmente son meilleur Score! Essaie de battre "
				sendMessageMe_Combo =" augmente son meilleur Combo! Essaie de battre "
				sendMessage_Score = "J'ai battu ton meilleur Score! Essaie de battre "
			}
		}
	}
}