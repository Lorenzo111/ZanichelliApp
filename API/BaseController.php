<?php
/**
 * This file contains the base class for all controllers.
 */
	require_once('Utils.php');
	require_once('Messages.php');
	require_once('Validator.php');
	require_once('QueryLib.php');
	require_once('DatabaseManager.php');
	
	/**
	 * This class is the base class for all controller.
	 * It contains method and proprieties that are not specific of any given controller
	 */
	class BaseController
	{
		/**
		 * PDO handle.
		 * Lazy initialization
		 */
		protected $db = null;
		/**
		 * Contructor
		 * This method is "light". The database connection is postponed until required
		 * @param string db reference
		 */
		public function __construct($db)
		{
			$this->db = $db;
		}
		/**
		 * This method read the request body and decodes it in JSON format.
		 * @returns dictionary the json-decoded request body
		 */
		protected function jsonBody()
		{
			$inputJSON = file_get_contents('php://input');
			$input = json_decode($inputJSON, TRUE); //convert JSON into array
			return $input;
		}
		/**
		 * This method ensures that the current request is coming from a logged user.
		 * This method returns only if the user is logged
		 */
		public static function ensure_logged()
		{
			if(!BaseController::is_logged_in())
				fatal_error('LOGIN_REQUIRED');
		}
		/**
		 * Update the user id stored in the current session
		 * @param string New user id for the current session
		 */
		protected static function set_user_id($user_id)
		{
			$_SESSION[USER_ID_SESSION_NAME]=$user_id;
		}
		/**
		 * Retrieve the user id from the current session
		 * @return integer|0 User id or 0 on no-user for this session 
		 */
		protected static function get_user_id()
		{
			if(session_id())
			{
				if( isset($_SESSION[USER_ID_SESSION_NAME]) )
				{
					$id = intval($_SESSION[USER_ID_SESSION_NAME],10);
					if($id > 0)
						return $id;
				}
			}
			return 0;
		}
		/**
		 * This is an helper method used to enstablish if a result from PDO is "empty"
		 * "Empty" can be: null, empty array, a string (error) an integer(error)....
		 * @param mixed data The target variable
		 * @return true if the argument is empty 
		 * @return false otherwise
		 */
		protected function is_db_empty($data)
		{
			if($data == null)
			{
				return true;
			}
			else if(is_array($data))
			{
				return count($data) == 0;

			}
			return false;
		}
		/**
		 * No-throw check if the current session is authenticated.
		 * @return true|false true if an user is logged in the current session, false otherwise
		 */
		protected static function is_logged_in()
		{
			return  BaseController::get_user_id() > 0;
		}
	}
?>