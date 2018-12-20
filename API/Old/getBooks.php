<?php
// include database connection
include 'database.php';
include 'utils.php';
 
// get passed parameter value, in this case, the user_ID
// isset() is a PHP function used to verify if a value is there or not
$userId= isset($_GET['user_ID']) ? $_GET['user_ID'] : "";
 
echo "User id: ".$userId; 

//get all books 
if($userId === "")
{
	echo "Get All Books";

	// select all data
	try
	{
		$query = "SELECT * FROM books ORDER BY book_ID DESC";
		$stmt = $con->prepare($query);
		// execute our query
		$stmt->execute();
		// this is how to get number of rows returned
		$num = $stmt->rowCount();
		 
		//check if more than 0 record found
		if($num>0){
		 
			 // data from database will be here
			 $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
			 $ret = Utils::success($data);
			 echo $ret;
		}
		// if no records found
		else{
			 $ret = Utils::error("No records found.");
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
	echo "Get UserId Books";
	try {
		// prepare select query
		$query = "SELECT * FROM books WHERE user_ID = :user_ID";
		$stmt = $con->prepare( $query );
		
		// this is the first question mark
		$stmt->bindParam(':user_ID', $userId);
		
		// execute our query
		$stmt->execute();	
		$num = $stmt->rowCount();
		 
		//check if more than 0 record found
		if($num>0){
		 
			// data from database will be here
			 $data = $stmt->fetchAll(PDO::FETCH_ASSOC);
			 $ret = Utils::success($data);
			 echo $ret;
		}
		// if no records found
		else{
			$ret = Utils::error("No records found.");
			 echo $ret;
		}
	}
 
	// show error
	catch(PDOException $exception){
		die('ERROR: ' . $exception->getMessage());
		}
}
?>