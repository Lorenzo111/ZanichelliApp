<?php
	// include database connection
    include 'database.php';
	include 'utils.php';

if($_POST){

    try{
     
        // insert query
        $query = "INSERT INTO books SET user_ID=:user_ID, title=:title, author=:author";
 
        // prepare query for execution
        $stmt = $con->prepare($query);
 
        // posted values
        $user_ID=htmlspecialchars(strip_tags($_POST['user_ID']));
        $title=htmlspecialchars(strip_tags($_POST['title']));
        $author=htmlspecialchars(strip_tags($_POST['author']));
 
        // bind the parameters
        $stmt->bindParam(':user_ID', $user_ID);
        $stmt->bindParam(':title', $title);
        $stmt->bindParam(':author', $author);
         
        // specify when this record was inserted to the database
        // $created=date('Y-m-d H:i:s');
        // $stmt->bindParam(':created', $created);
         
        // Execute the query
        if($stmt->execute()){
            $ret = Utils::success("Book Created");
			echo $ret;
        }else{
            $ret = Utils::error("Book not created");
			echo $ret;
        }
         
    }
     
    // show error
    catch(PDOException $exception){
        die('ERROR: ' . $exception->getMessage());
    }
	
}
else{
	echo "No post call.";
}
?>