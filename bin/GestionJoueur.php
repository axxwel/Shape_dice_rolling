<?php
	if($_SERVER['REQUEST_URI'] != "/ShapeDiceRolling/GestionJoueur.php"){
		echo 'Accés interdit !'.$_SERVER['REQUEST_URI'];
	}
	else {
//PARAMS----------------------------------
		$serveur = $_POST['serveur'];
		$utilisateur = $_POST['utilisateur'];
		$motDePasse = $_POST['motDePasse'];
		$base = $_POST['base'];
		$method = $_POST['method'];
//CONNECT---------------------------------
		$idConnect = mysqli_connect($serveur, $utilisateur, $motDePasse,$base);
		if (mysqli_connect_errno($idConnect)) {echo 'Connexion impossible : ' . mysqli_connect_error();}	
//CHECK USER-------------------------------
		if ($method == "checkUser") {
			$idFB = $_POST['idFB'];
			$nom = $_POST['nom'];
	//insert joueur------------------------
			$sql_qry_insert = 'INSERT INTO sdr_joueur  VALUES (NULL,'.$idFB.',\' '.$nom.'\', 0, 0,NULL,NULL)';
			mysqli_query($idConnect, $sql_qry_insert);
			
	//changer nom--------------------------
			$sql_qry_nom = 'SELECT * FROM sdr_joueur WHERE idFB='.$idFB;
			$resNom = mysqli_query($idConnect, $sql_qry_nom);
			$rowNom = mysqli_fetch_assoc($resNom);
			if ($rowNom['nom'] != $nom) { 
				$sql_qry_changeNom = 'UPDATE sdr_joueur SET nom =\''.$nom.'\' WHERE idFB='.$idFB;
				$newNom = mysqli_query($idConnect, $sql_qry_changeNom);
			}
	//retourner joueur---------------------
			$sql_qry = 'SELECT * FROM sdr_joueur WHERE idFB='.$idFB;
			$res = mysqli_query($idConnect,$sql_qry );
			$row = mysqli_fetch_assoc($res);
			$response = 'idFB='.$row['idFB'].'&nom='.$row['nom'].'&score='.$row['score'].'&combo='.$row['combo'];
			echo $response;
			mysql_close(idConnect);
		}
//CHECK FRIENDS----------------------------
		if ($method == "checkFriends") {
			$chSQL = "SELECT * FROM sdr_joueur" ;
			$res = mysqli_query($idConnect, $chSQL);
			while($row = mysqli_fetch_assoc($res)){
				$response.='idFB='.$row['idFB'].'&nom='.$row['nom'].'&score='.$row['score'].'&combo='.$row['combo'].'##';	
			}
			$response=substr($response,0,-2);
			echo $response;
			mysql_close(idConnect);
		}
//UPDATE SCORE--------------------------------
		if($method=="updateScore"){
			$idfb = $_POST['idFB'];
			$score = $_POST['score'];
			$sql_qry = 'UPDATE sdr_joueur SET score='.$score.' WHERE idFB='.$idfb;
			mysqli_query($idConnect, $sql_qry);
			mysql_close(idConnect);
		}
//UPDATE COMBO--------------------------------
		if($method=="updateCombo"){
			$idfb = $_POST['idFB'];
			$combo = $_POST['combo'];
			$sql_qry = 'UPDATE sdr_joueur SET combo='.$combo.' WHERE idFB='.$idfb;
			mysqli_query($idConnect, $sql_qry);
			mysql_close(idConnect);
		}
//GET SCORE----------------------------------
		if($method=="getScore"){
			$idfb = $_POST['idFB'];
			$sql_qry = 'SELECT * FROM sdr_joueur WHERE idFB='.$idfb;
			$res = mysqli_query($idConnect,$sql_qry );
			$row = mysqli_fetch_assoc($res);
			$response = 'idFB='.$row['idFB'].'&nom='.$row['nom'].'&score='.$row['score'].'&combo='.$row['combo'];
			echo $response;
			mysql_close(idConnect);
		}
//SET VIE----------------------------------
		if($method=="setVie"){
			$idfb = $_POST['idFB'];
			$date = $_POST['date'];
			$sql_qry_date = 'UPDATE sdr_joueur SET  time_vie=\''.$date.'\' WHERE idFB='.$idfb;
			mysqli_query($idConnect, $sql_qry_date);
			mysql_close(idConnect);
		}
//GET VIE-----------------------------------
		if ($method=="getVie") {
			$idfb = $_POST['idFB'];
			$sql_qry = 'SELECT * FROM sdr_joueur WHERE idFB='.$idfb;
			$res = mysqli_query($idConnect,$sql_qry );
			$row = mysqli_fetch_assoc($res);
			$response = 'time_vie='.$row['time_vie'];
			echo $response;
			mysql_close(idConnect);
		}
//SET COIN----------------------------------
		if($method=="setCoin"){
			$idfb = $_POST['idFB'];
			$coin = $_POST['diceCoin'];
			$sql_qry_coin = 'UPDATE sdr_joueur SET  dice_coin='.$coin.' WHERE idFB='.$idfb;
			mysqli_query($idConnect, $sql_qry_coin);
			mysql_close(idConnect);
		}
//GET COIN-----------------------------------
		if ($method=="getCoin") {
			$idfb = $_POST['idFB'];
			$sql_qry = 'SELECT * FROM sdr_joueur WHERE idFB='.$idfb;
			$res = mysqli_query($idConnect,$sql_qry );
			$row = mysqli_fetch_assoc($res);
			$response = 'dice_coin='.$row['dice_coin'];
			echo $response;
			mysql_close(idConnect);
		}
//FACTURE CREATE-----------------------------
		if ($method == "createFacture") {
			$idfb = $_POST['idFB'];
			$nom = $_POST['nom'];
			$date = $_POST['date'];
			$monnaie = $_POST['monnaie'];
			$montant = $_POST['montant'];
			$nbrCoin = $_POST['nbrCoin'];
			$sql_qry_insert = 'INSERT INTO sdr_factures VALUES (NULL,'.$idfb.',\' '.$nom.'\', \''.$date.'\', \''.$monnaie.'\', '.$montant.', '.$nbrCoin.', \'initiated\', NULL, NULL)';
			mysqli_query($idConnect, $sql_qry_insert);
			$sql_qry_idRequest = 'SELECT * FROM sdr_factures WHERE idFB='.$idfb.' AND date_payment=\''.$date.'\'';
			$res = mysqli_query($idConnect, $sql_qry_idRequest);
			$row = mysqli_fetch_assoc($res);
			$response = 'id_request='.$row['id_request'];
			echo $response;
			mysql_close(idConnect);
		}
//FACTURE UPDATE--------------------------
		if ($method == "updateFacture") {
			$idRequest = $_POST['idRequest'];
			$statut = $_POST['statut'];
			$idPayment = $_POST['idPayment'];
			$signedRequest = $_POST['signedRequest'];
			$sql_qry_update = 'UPDATE sdr_factures SET  statut=\''.$statut.'\', id_payment='.$idPayment.', signed_request=\''.$signedRequest.'\' WHERE id_request='.$idRequest;
			mysqli_query($idConnect, $sql_qry_update);
			$sql_qry_idRequest = 'SELECT * FROM sdr_factures WHERE id_request='.$idRequest;
			$res = mysqli_query($idConnect, $sql_qry_idRequest);
			$row = mysqli_fetch_assoc($res);
			$response = 'nbr_dice_coin='.$row['nbr_dice_coin'].'&statut='.$row['statut'];
			echo $response;
			mysql_close(idConnect);
		}
	}
?>