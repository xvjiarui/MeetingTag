<?php
$photoPath = "uploads/preview/" . $_POST["photoPath"]; 

if(file_exists($photoPath))
{
	$imageInfo = getimagesize($photoPath);
	switch ($imageInfo[2])
	{
	case IMAGETYPE_JPEG:
		header("Content-Type: image/jpeg");
		break;
	case IMAGETYPE_GIF:
		header("Content-Type: image/gif");
		break;
	case IMAGETYPE_PNG:
		header("Content-Type: image/png");
		break;
	default:
		break;
	}
	header("Content-Length:" . filesize($photoPath));

	readfile($photoPath);
}
else
{
	echo json_encode([
		"Message" => "Sorry, there was an error download your photo"
	]);
}


?>
