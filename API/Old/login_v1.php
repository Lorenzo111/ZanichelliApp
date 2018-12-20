<?php
// include database connection
include 'database.php';
include 'utils.php';
 
// get passed parameter value, in this case: username and password
$email= isset($_GET['email']) ? $_GET['email'] : "";
$password= isset($_GET['password']) ? $_GET['password'] : "";
 
//get all books 
if($email != "" && $password != "")
{
	try
	{
		$query = "SELECT * FROM users WHERE email = :email AND password = :password";
		$stmt = $con->prepare($query);
		
	    // this are the two parameters
		$stmt->bindParam(':email', $email);		
		$stmt->bindParam(':password', $password);
				
		// execute our query
		$stmt->execute();
		$num = $stmt->rowCount();
		 
		if($num === 1){
		 
			 // data from database will be here
			 $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
			 $ret = Utils::success($data);
			 echo $ret;
		}
		// if no records found
		else{
			 $ret = Utils::error("Login Error.");
			 echo $ret;
		}
	}
	// show error
	catch(PDOException $exception){
		die('ERROR: ' . $exception->getMessage());
	}
}	
else 
{
	Utils::missingFields();
}
?>