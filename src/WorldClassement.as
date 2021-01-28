package 
{
	import com.greensock.core.SimpleTimeline;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.system.Security;
	
	public class WorldClassement extends Sprite{
		
		private var conteneurBest:Sprite = new Sprite();
		private var conteneurList:Sprite = new Sprite();
		private var conteneurListMask:Bitmap = new Bitmap(new BitmapData(128, 368, false, 0xffffff));
		
		private var monLangage:Langage = new Langage();
		
		private var friendList:Array = new Array();
		private var playerList:Array = new Array();
		private var joueurObj:Object = new Object();
		private var bestPlayer:Object = new Object();
		
		private var monBoutonWorld:Bouton = new Bouton("Vert");
		private var monBoutonFriend:Bouton = new Bouton("Bleu");
		
		private var rank_best:Sprite = new Sprite();
		private var rank_0:Sprite = new Sprite();
		private var rank_1:Sprite = new Sprite();
		private var rank_2:Sprite = new Sprite();
		private var rank_3:Sprite = new Sprite();
		private var rank_4:Sprite = new Sprite();
		private var rank_5:Sprite = new Sprite();
		private var rank_player:Sprite = new Sprite();
		
		public var scoreJoueur:int = 0;
		private var scoreJoueurBattre:int = 0;
		
		[Embed(source = "Libs/CooperBlackStd.otf",
			fontName = "Cooper Std black",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontCooper:Class;
		
		[Embed(source = "Libs/Lucida Grande.ttf",
			fontName = "Lucida Grande",
			mimeType = "application/x-font", 
			fontWeight="normal", 
			fontStyle="normal", 
			advancedAntiAliasing="true", 
			embedAsCFF = "false")]
		private var EmbedFontLucida:Class;
		
		public function WorldClassement() {
			rank_0.name = "rank_0";
			rank_1.name = "rank_1";
			rank_2.name = "rank_2";
			rank_3.name = "rank_3";
			rank_4.name = "rank_4";
			rank_5.name = "rank_5";
			
			rank_player.name = "rank_player"
			rank_best.name="rank_best"
		}
//INIT==============================================================================================================================
		public function init(joueurObjTemp:Object, friendListTemp:Array, playerListTemp:Array, langueTemp:String = "us_US") {
			
			removeAll();
			while (this.numChildren > 0) { this.removeChildAt(0);}
			
			joueurObj = joueurObjTemp;
			friendList = friendListTemp;
			playerList = playerListTemp;
			monLangage.setLangage(langueTemp);
			
			var dataFond:BitmapData = new FondWorldClassement();
			var fond:Bitmap=new Bitmap(dataFond);
			addChild(fond);
			
			monBoutonWorld.texte = monLangage.btnWorld;
			monBoutonWorld.scaleY = 0.4;
			monBoutonWorld.scaleX = 0.4;
			monBoutonWorld.x = 64-monBoutonWorld.width/2;
			monBoutonWorld.y = 16;
			monBoutonFriend.texte = monLangage.btnFriend;
			monBoutonFriend.scaleY = 0.4;
			monBoutonFriend.scaleX = 0.4;
			monBoutonFriend.x = 64-monBoutonWorld.width/2;
			monBoutonFriend.y = 16;
			addChild(monBoutonFriend);
			
			var recordText:TexteScore = new TexteScore(monLangage.worldChampion, 20, 0x1e7fcb, true, false, true, 0xf7ff3c, "center");
			recordText.justifier(128);
			recordText.y = 68;
			addChild(recordText);
			
			conteneurBest.x = 8;
			addChild(conteneurBest);
			
			conteneurListMask.y = 256;
			addChild(conteneurListMask);
			conteneurList.x = 8;
			conteneurList.mask = conteneurListMask;
			addChild(conteneurList);
			
			var classementText:TexteScore = new TexteScore(monLangage.worldClassement, 20, 0x1e7fcb, true, false, true, 0xf7ff3c, "center");
			classementText.justifier(128);
			classementText.y = 228;
			addChild(classementText);
			
			initBestPlayer(playerList);
			initListePlayer(playerList);
		}
//RUN==================================================================================================================================
		public function run() {
			if (monBoutonWorld.boutonClick == true) {
				removeChild(monBoutonWorld);
				removeAll();
				initBestPlayer(playerList);
				initListePlayer(playerList);
				addChild(monBoutonFriend);
				monBoutonWorld.boutonClick = false;
			}
			if (monBoutonFriend.boutonClick == true) {
				removeChild(monBoutonFriend);
				removeAll();
				initBestPlayer(friendList);
				initListePlayer(friendList);
				addChild(monBoutonWorld);
				monBoutonFriend.boutonClick = false;
			}
			if (scoreJoueur > joueurObj.score) {
				animateClassement();
			}
		}
//ANIMATE CLASSEMENT===================================================================================================================
		private function animateClassement() {
			if (scoreJoueur > scoreJoueurBattre) {
				
			}
		}
//INIT BEST============================================================================================================================
		private function initBestPlayer(listTemp:Array) {
			var list:Array = listTemp;
			var player:Boolean = false;
			var bPlayer:Object = list[0];
			
			var joueurInside:Boolean = false;
			for (var j:int = 0; j < list.length; j++) { if (list[j].id == joueurObj.id) { joueurInside = true; }}
			if (joueurInside == false) { list.push(joueurObj); }
			
			var bestScore:int = list[0].score;
			for (var p:int = 0; p < list.length; p++) {
				if (list[p].score > bestScore) { bestScore = list[p].score; bPlayer = list[p];  }
			}
			bPlayer.rank = 1;
			bestPlayer = bPlayer;
			if (bPlayer.id == joueurObj.id) { player = true;}
			creerJoueur(bPlayer, rank_best, player);
			rank_best.y = 100;
			conteneurBest.addChild(rank_best);			
		}
//INIT CLASSEMENT=======================================================================================================================
		private function initListePlayer(listTemp:Array) {
			var listVrac:Array = listTemp;
			var list:Array = new Array();
			var playerRank:int = 0;
			var decalage:int = 0;
			
			var joueurInside:Boolean = false;
			for (var v:int = 0; v < listVrac.length; v++) { 
				if (listVrac[v].id == joueurObj.id || listVrac[v].score > 0) { 
					if (listVrac[v].id == joueurObj.id) { joueurInside = true;}
					list.push(listVrac[v]);
				}
			}
			if (joueurInside == false) { list.push(joueurObj); }
			
			list.sortOn("score", Array.NUMERIC );
			for (var p:int = 0; p < list.length; p++) { 
				list[p].rank = list.length - p  ;
				if (list[p].id == joueurObj.id) { playerRank = p;  }
			}
			
			if (list[playerRank + 3] is Object) { creerJoueur(list[playerRank + 3], rank_0); conteneurList.addChild(rank_0); }
			if (list[playerRank + 2] is Object) { creerJoueur(list[playerRank + 2], rank_1); conteneurList.addChild(rank_1); }
			if (list[playerRank + 1] is Object) { creerJoueur(list[playerRank + 1], rank_2); conteneurList.addChild(rank_2); } else { decalage = -128;}
			if (list[playerRank] is Object) { creerJoueur(list[playerRank], rank_player, true); conteneurList.addChildAt(rank_player,conteneurList.numChildren); }
			if (list[playerRank - 1] is Object) { creerJoueur(list[playerRank - 1], rank_3); conteneurList.addChild(rank_3); } else { decalage = 128; }
			if (list[playerRank - 2] is Object) { creerJoueur(list[playerRank - 2], rank_4); conteneurList.addChild(rank_4); }
			if (list[playerRank - 3] is Object) { creerJoueur(list[playerRank - 3], rank_5); conteneurList.addChild(rank_5); }
			
			if (list[playerRank].id == bestPlayer.id) { decalage = -256;}
			if (list[playerRank].id != bestPlayer.id) {scoreJoueurBattre = list[playerRank + 1].score;}
			rank_0.y = 0 + decalage;
			rank_1.y = 128 + decalage;
			rank_2.y = 256 + decalage;
			rank_player.y = 384 + decalage;
			rank_3.y = 512 + decalage;
			rank_4.y = 640 + decalage;
			rank_5.y = 768 + decalage;
		}
//CREER VIGNETTTE=======================================================================================================================
		private function creerJoueur(joueur:Object, conteneurTemp:Sprite, player:Boolean = false) {
	//LOADING----------------------------------------------------------------
			var monLoading:LoadingCircle = new LoadingCircle();
			monLoading.name = "loading";
			monLoading.alpha = 0.7;
			monLoading.scaleX = monLoading.scaleY = 0.3;
			monLoading.x = monLoading.y = 56 - monLoading.width / 2;
			conteneurTemp.addChild(monLoading);
			
			var idBox:String = joueur.id;
			var nomBox:String = joueur.nom;
			var score:int = joueur.score;
			var combo:int = joueur.combo;
			var rank:int = joueur.rank;
			var pictureURL:String = "https://graph.facebook.com/" + idBox +"/picture";
	//FOND--------------------------------------------------------------------
			var fond:Bitmap = new Bitmap(new BitmapData(98, 98, false, 0xffffff));
			fond.name = "fond";
			if (player == true) { fond.alpha = 1; } else { fond.alpha = 0.4; }
			fond.x = 8;
			fond.y = 4;
			
	//USER NAME----------------------------------------------------------------
			var nom:TextField=new TextField();
			var nomFormat:TextFormat = new TextFormat();
			nom.name = "nom";
			nom.text = nomBox;
			
			nomFormat.font="Lucida Grande";
			nomFormat.bold=true;
			nomFormat.size=14;
			nomFormat.color=0x3b5998;
			nomFormat.align = "center";
			nom.embedFonts = true;
			nom.selectable = false;
			nom.wordWrap = true;
			nom.setTextFormat(nomFormat);
			nom.height = 32;
			nom.width = 112;
			
	//USER RANK----------------------------------------------------------------
			var rankTxt:TexteScore = new TexteScore("0", 26, 0xf7ff3c, true, true, true, 0x1e7fcb, "left");
			rankTxt.name = "rank";
			rankTxt.newTexte("#" + String(rank));
			rankTxt.y = 10;
			if (rank >= 100) { rankTxt.setFormat(0xf7ff3c, 24); rankTxt.y = 11;}
			if (rank >= 1000) { rankTxt.setFormat(0xf7ff3c, 22); rankTxt.y = 12;}
			if (rank >= 10000) { rankTxt.setFormat(0xf7ff3c, 20); rankTxt.y = 13;}
			if (rank >= 100000) { rankTxt.setFormat(0xf7ff3c, 18); rankTxt.y = 14;}
			if (rank >= 1000000) { rankTxt.setFormat(0xf7ff3c, 16); rankTxt.y = 15;}
			if (rank >= 10000000) { rankTxt.setFormat(0xf7ff3c, 14); rankTxt.y = 16;}
			if (rank >= 100000000) { rankTxt.setFormat(0xf7ff3c, 12); rankTxt.y = 17;}
			if (player == true) { rankTxt.setCouleur(0xf400a1, 0xf7ff3c, true, true); }
			
	//USER IMAGE---------------------------------------------------------------
			var image_donnee:BitmapData = new BitmapData(50, 50);
			var imageVierge:FB_anonyme = new FB_anonyme();
			image_donnee.draw(imageVierge);
			
			var image:Bitmap = new Bitmap(image_donnee);
			image.name = "image";
			image.smoothing = true;
			image.x = 24;
			image.y = 18;
			image.height = 64;
			image.width = 64;
			
			var rqt:String = pictureURL;
			var imageURL:URLRequest = new URLRequest(rqt);
			var chargeur:Loader = new Loader();
			
			Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			chargeur.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			chargeur.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, erreurChargement);
			chargeur.load(imageURL); 
			
			function imageLoaded(e:Event) {
				image = e.target.content;
				image.smoothing = true;
				image.x = 28;
				image.y = 28;
				image.height = 56;
				image.width = 56;
				conteneurTemp.addChild(image);
				addScore();
				chargeur.removeEventListener(Event.COMPLETE, imageLoaded);
			}
			function erreurChargement(e:IOErrorEvent) {
				trace("erreurChargement_imageFB");
				conteneurTemp.addChild(image);
				addScore();
				chargeur.removeEventListener(Event.COMPLETE, imageLoaded);
			}
			function addScore() {
	//SCORE----------------------------------------------------------------------
				var monScoreNbr:TexteScore = new TexteScore("0", 18, 0xf7ff3c, true, false, true, 0xf400a1, "center");
				var monComboNbr:TexteScore = new TexteScore("0", 12, 0x1e7fcb, true, false, true, 0xf7ff3c, "center");
				monScoreNbr.name = "score";
				monScoreNbr.newTexte(String(score));
				monScoreNbr.x = 56-monScoreNbr.width/2;
				monScoreNbr.y = 72;
				conteneurTemp.addChild(monScoreNbr);
				monComboNbr.name = "combo";
				monComboNbr.newTexte(String(combo));
				monComboNbr.x = 56-monComboNbr.width/2;
				monComboNbr.y = 90;
				conteneurTemp.addChild(monComboNbr);
				conteneurTemp.alpha = 1;
	//ADD--------------------------------------------------------------------------
				conteneurTemp.removeChild(monLoading);
				monLoading = null;
				conteneurTemp.addChild(nom);
				conteneurTemp.addChild(rankTxt);
				conteneurTemp.addChildAt(fond, 0);
				if (player == true) {
					conteneurTemp.scaleX = conteneurTemp.scaleY = 1.1;
					for (var c:int = 0; c < conteneurTemp.numChildren; c++) {
						Object(conteneurTemp.getChildAt(c)).x -= 6;
						Object(conteneurTemp.getChildAt(c)).y -= 6;
					}
				}else { conteneurTemp.scaleX = conteneurTemp.scaleY = 1;}
			}
		}
//REMOVE ALL===========================================================================================
		private function removeAll() {
			while (conteneurBest.numChildren > 0) { remove(conteneurBest.getChildAt(0)); conteneurBest.removeChildAt(0);}
			while (conteneurList.numChildren > 0) { remove(conteneurList.getChildAt(0)); conteneurList.removeChildAt(0);}
			function remove(ctTemp:Sprite){
				var ct:Sprite = ctTemp;
				while (ct.numChildren > 0) {
					var obj:DisplayObject = ct.getChildAt(0);
					ct.removeChildAt(0);
					obj = null;
				}
				ctTemp = null;
			}
		}
//PORTRAIT PAYSAGE=====================================================================================
		public function portraitPaysage(){
			this.rotation=-90;
			this.y = 960;
		}
	}
}