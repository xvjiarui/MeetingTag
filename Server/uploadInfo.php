<?php
$secret = $_POST["secretWord"];
if ("xvjiarui0826" != $secret) exit;

$id = $_POST["id"];
$title = $_POST["title"];
$photoPath = $_POST["photoPath"];

$con = mysqli_connect("localhost", "id2232623_admin", "000000", "id2232623_minutes");

//Check connection
if (mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$query = "insert into `Meeting` (`id`, `title`, `photoPath`) value (".$id.",'".$title."','".$photoPath."')";
$result = mysqli_query($con, $query);

echo $result; // sends 1 if insert workded

?>
