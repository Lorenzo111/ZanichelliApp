<?php
	// include database connection
    include 'database.php';
	include 'utils.php';

if($_POST){

    try{
        // insert query
        $query = "INSERT INTO users SET nome=:nome, cognome=:cognome, email=:email, password=:password";
 
        // prepare query for execution
        $stmt = $con->prepare($query);
 
        // posted values
        $nome=htmlspecialchars(strip_tags($_POST['nome']));
        $cognome=htmlspecialchars(strip_tags($_POST['cognome']));
        $email=htmlspecialchars(strip_tags($_POST['email']));
		$password=htmlspecialchars(strip_tags($_POST['password']));
 
        // bind the parameters
        $stmt->bindParam(':nome', $nome);
        $stmt->bindParam(':cognome', $cognome);
        $stmt->bindParam(':email', $email);
		$stmt->bindParam(':password', $password);
         
       
        // Execute the query
        if($stmt->execute()){
            $ret = Utils::success("User Created");
			echo $ret;
        }else{
            $ret = Utils::error("User not created");
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