<?php 
session_start();

require_once('Configuration.php');
require_once('klein.php');
require_once('Utils.php');
require_once('UserController.php');
require_once('BookController.php');
require_once('DatabaseManager.php');

$base  = dirname($_SERVER['PHP_SELF']);

// Update request when we have a subdirectory    


if(ltrim($base, '/')){ 
	$_SERVER['REQUEST_URI'] = substr($_SERVER['REQUEST_URI'], strlen($base));
	
}

// Pass our request to our dispatch method


/*
 * Variable used in routes.
 * Note that while this object are all created for each request
 * The real initialization is lazy
 */
$db = new DatabaseManager();
$user_controller = new UserController($db);
$book_controller = new BookController($db);

/*
 * Index Page route registration
 */
respond('/',function ($req, $res) {
    return $res->json(Utils::data([
		'application'=>TITLE,
		'version'=>VERSION,
	]));
});

/*
 * Middleware Registration
 */
 
/*
 * Generic error handler for runtime exception
 */
respond('*',function($req,$res)
{
	$res->onError(function($resp,$msg,$err_type)
	{
		$resp->json(Utils::error($msg));
		die();
	});
});

/*
 * Api request on /user endpoint requires authentication
 */
respond('@/user*',function($req,$res)
{
	BaseController::ensure_logged();
});

/*
 * Api request on /book endpoint requires authentication
 */
 /*
respond('@/books*',function($req,$res)
{
	BaseController::ensure_logged();
});*

/*
 * Login / Logout / Registration routes
 */
respond('POST','/login',[$user_controller,'do_login']);
respond('POST','/logout',[$user_controller,'do_logout']);
respond('POST','/register',[$user_controller,'do_user_create']);

/*
 * Profile managment routes (Read/Update/Delete)
 */
respond('GET'   ,'/user',[$user_controller,'do_user_profile']);
respond('DELETE','/user',[$user_controller,'do_user_delete']);
respond('PUT','/user',[$user_controller,'do_user_update']);

/*
 * Book Managment routes
 */
respond('GET'   ,'/books',[$book_controller,'do_book_list']);

respond('DELETE','/books/[:bookid]',function($req,$res) use ($book_controller) {
	$book_controller->do_book_delete($req,$res,$req->bookid);
});
respond('PUT','/books/[:bookid]',function($req,$res) use ($book_controller) {
	$book_controller->do_book_update($req,$res,$req->bookid);
});
respond('POST','/books',[$book_controller,'do_book_create']);

dispatch();
?>
