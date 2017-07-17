<?php
$firstName = $_POST["firstName"];
$lastName = $_POST["lastName"];
$meetingId = $_POST["meetingId"];

$target_dir = "uploads/preview";
if(!file_exists($target_dir))
{
	mkdir($target_dir, 0777, true);
}

$target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);

if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)) 
{
	echo json_encode([
		"Message" => "The file ". basename( $_FILES["file"]["name"]). " has been uploaded.",
		"Status" => "OK",
		"meetingId" => $_REQUEST["meetingId"]]);

} 
else {

	echo json_encode([
		"Message" => "Sorry, there was an error uploading your file.",
		"Status" => "Error",
		"meetingId" => $_REQUEST["meetingId"]
	]);
}
?>
