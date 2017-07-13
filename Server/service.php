<?php

//Create connection
$con = mysqli_connect("localhost", "id2232623_admin", "000000", "id2232623_minutes");

//Check connection
if (mysqli_connect_errno())
{
	echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$sql = "SELECT * FROM Meetings";

if ($result = mysqli_query($con, $sql))
{
	$resultArray = array();
	$tempArray = array();

	while($row = $result->fetch_object())
	{
		$tempArray = $row;
		array_push($resultArray, $tempArray);
	}
	echo json_encode($resultArray);
}

mysqli_close($con);
?>
