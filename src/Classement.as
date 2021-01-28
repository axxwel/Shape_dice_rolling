package 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.IOErrorEvent;
	import flash.system.Security;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	
	public class Classement extends MovieClip {
		
		public var console:String = "";
		
		private var monLangage:Langage = new Langage();
		public var langue:String = "en_US";
		
		private var titre:TextField=new TextField;
		private var titreFormat:TextFormat = new TextFormat();
		
		private var monOmbre:DropShadowFilter = new DropShadowFilter(5, 45, 0x000000, 0.5);
		
		public var joueurObj:Object = new Object();
		
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
		
		public function Classement() {
			
		}
//INIT=================================================================================================
		public function init(friendListTemp:Array) {
			
			monLangage.setLangage(langue);
			titre.text = monLangage.ranking;
			titre.y = 108; 
			titre.width = 280;
			
			titreFormat.font="Cooper Std black";
			titreFormat.bold=true;
			titreFormat.size=24;
			titreFormat.color=0x000000;
			titreFormat.align = "center";
			titre.embedFonts = true;
			titre.selectable = false;
			titre.setTextFormat(titreFormat);
			
			addChild(titre);
			
			var fListTemp:Array = new Array();
			for (var n:int = 0; n < friendListTemp.length; n++) { 
				fListTemp.push(friendListTemp[n]);
			}
			fListTemp.push(joueurObj);
			fListTemp.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			var rj:int = 0;
			var rjb:Boolean = false;
			var rjp:int = -5;
			for (var c:int = 0; c < fListTemp.length; c++) {
				fListTemp[c].rank = c+1;
				if (fListTemp[c].id == joueurObj.id) { rj = c; rjb = true }
				if (rjb == true && rjp < -2) { rjp++;}
			}
			var place:int = 0;
			var nplace:int = 2;
			for (var cj:int = rjp; cj <= nplace; cj++) {
				if(fListTemp[rj + cj]!=undefined){
					var rank:int = fListTemp[rj+cj].rank;
					var nomFB:String = fListTemp[rj+cj].nom;
					var idFB:int = fListTemp[rj+cj].id;
					var scoreBD:int = fListTemp[rj+cj].score;
					var comboBD:int = fListTemp[rj+cj].combo;
					var joueurJ:Boolean = false; if (cj == 0) { joueurJ = true }
					
					createCadre(rank, nomFB, idFB, scoreBD, comboBD, joueurJ, place);
					place++;
				}else if (nplace < rjp + 6) { nplace++; }
			}
		}
//LISTE JOUEUR BATTU======================================================================================================
		public function doneJoueurScore_Battu(friendListTemp:Array,oldScoreTemp:int,newScoreTemp:int):Array {
			var listeJoueurBattu:Array = new Array();
			for (var j:int = 0; j < friendListTemp.length; j++) {
				if (friendListTemp[j].score >= oldScoreTemp && friendListTemp[j].score < newScoreTemp) {
					listeJoueurBattu.push(friendListTemp[j]);
				}
			}
			return(listeJoueurBattu);
		}
		public function doneJoueurCombo_Battu(friendListTemp:Array,oldComboTemp:int,newComboTemp:int):Array {
			var listeJoueurBattu:Array = new Array();
			for (var j:int = 0; j < friendListTemp.length; j++) {
				if (friendListTemp[j].combo >= oldComboTemp && friendListTemp[j].combo < newComboTemp) {
					listeJoueurBattu.push(friendListTemp[j]);
				}
			}
			return(listeJoueurBattu);
		}
//CREATE CLASSEMENT CADRE===================================================================================================
		private function createCadre(rangTemp:int,
									nomTemp:String,
									idTemp:int,
									scoreTemp:int,
									comboTemp:int,
									persoTemp:Boolean = false,
									nCadre:int = 0 ) 
		{
			var conteneurCadre:Sprite = new Sprite();
	//Fond cadre=============================================
			var  monFond:FacebookBox = new FacebookBox();
			if (persoTemp == true) { monFond.gotoAndStop(2); }
			if (persoTemp == false) { monFond.gotoAndStop(1); }
			
			conteneurCadre.addChildAt(monFond,0);
	//Image FB===============================================
			var image_donnee:BitmapData = new BitmapData(50, 50);
			var imageVierge:FB_anonyme = new FB_anonyme();
			image_donnee.draw(imageVierge);
			
			var image:Bitmap = new Bitmap(image_donnee);
			var idfb:int = idTemp;
			var rqt:String="https://graph.facebook.com/"+ idfb +"/picture"
			var imageURL:URLRequest = new URLRequest(rqt);
			var chargeur:Loader = new Loader();
			
			Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
			chargeur.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
			chargeur.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, erreurChargement);
			chargeur.load(imageURL); 
			
			function imageLoaded(e:Event) {
				image = e.target.content;
				image.x = 16;
				image.y = 16;
				if (persoTemp == true) {image.height = 40;image.width = 40;}
				if (persoTemp == false) { image.height = 32; image.width = 32; }
				
				conteneurCadre.addChildAt(image,1);
				chargeur.removeEventListener(Event.COMPLETE, imageLoaded);
			}
			function erreurChargement(e:IOErrorEvent) {
				trace("erreurChargement_imageFB");
			}
	//Rank===================================================
			var conteneurRank:Sprite = new Sprite();
			var monRondRank:RondRank = new RondRank();
			var nbrRank:TextField=new TextField;
			var nbrRankFormat:TextFormat = new TextFormat();
			
			var nbrRank_size:int = 24; nbrRank.y = -3;
			if (rangTemp > 9) { nbrRank_size = 20; nbrRank.y = 1; }
			if (rangTemp > 99) { nbrRank_size = 14; nbrRank.y = 5; }
			if (rangTemp > 999) { nbrRank_size = 10; nbrRank.y = 7; }
			
			nbrRank.embedFonts = true;
			nbrRank.text = String(rangTemp);
			nbrRank.width = 32;
			
			nbrRankFormat.font="Cooper Std black";
			nbrRankFormat.bold=true;
			nbrRankFormat.size=nbrRank_size;
			nbrRankFormat.color=0x3b5998;
			nbrRankFormat.align = "center";
			nbrRank.setTextFormat(nbrRankFormat);
			
			conteneurRank.addChild(monRondRank);
			conteneurRank.addChild(nbrRank);
			
			if (persoTemp == true) { conteneurRank.scaleX = 1; conteneurRank.scaleY = 1;}
			if (persoTemp == false) { conteneurRank.scaleX = 0.8; conteneurRank.scaleY = 0.8; }
			
			conteneurCadre.addChild(conteneurRank);
	//Nom====================================================
			var nom:TextField=new TextField;
			var nomFormat:TextFormat = new TextFormat();
			nom.text = nomTemp;
			
			nomFormat.font="Lucida Grande";
			nomFormat.bold=true;
			if (persoTemp == true) {nomFormat.size=12;}else {nomFormat.size=10;}
			nomFormat.color=0x3b5998;
			nomFormat.align = "left";
			nom.embedFonts = true;
			nom.selectable = false;
			nom.setTextFormat(nomFormat);
			
			if (persoTemp == true) {nom.x = 60;}else {nom.x = 50;}
			nom.y = 10;
			nom.height = 16;
			nom.width = 166;
			
			conteneurCadre.addChild(nom);
	//Score==================================================
			var monScore:int=scoreTemp;
			var monScoreNbr:TexteScore = new TexteScore("0", 18, 0xf7ff3c, true, false, true, 0xf400a1);
			monScoreNbr.newTexte(String(monScore));
			monScoreNbr.x = 148-(monScoreNbr.width/2);
			monScoreNbr.y = 20;
			
			conteneurCadre.addChild(monScoreNbr);
	//Combo==================================================
			var monCombo:int=comboTemp;
			var monComboNbr:TexteScore = new TexteScore("0", 13, 0x1e7fcb, true, false, true, 0xf7ff3c);
			monComboNbr.newTexte(String(monCombo));
			monComboNbr.x = 148-(monComboNbr.width/2);
			monComboNbr.y = 40;
			
			conteneurCadre.addChild(monComboNbr);
	//ADD CADRE===================================================
			conteneurCadre.x = 24;
			conteneurCadre.y = 68 * nCadre + 140;
			addChild(conteneurCadre);
		}
	}
}