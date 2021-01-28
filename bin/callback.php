<?php                                    

$verify_token='270rt81master2018diacnornip';                                 
$method = $_SERVER['REQUEST_METHOD'];                             

if ($method == 'GET' && $_GET['hub_mode'] == 'subscribe' && $_GET['hub_verify_token'] === $verify_token) {
	echo $_GET['hub_challenge'];
}
else if ($method == 'GET'){
	echo"<h1>REAL TIME UPDATES</h1>";
}
else if ($method == 'POST') {
	$time_now = date("Y-m-d H:i:s");
	$updates = json_decode(file_get_contents("php://input"), true);
	
	error_log('updates = ' . print_r($updates, true));              
}
?>