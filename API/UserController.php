<?php
	require_once('BaseController.php');
	
	class UserController extends BaseController	
	{
		public function __construct($db) 
		{
		   parent::__construct($db);
		}
		/*
		 * Login / Logout / Registration routes
		 */
		public function do_login($request,$response)
		{
			$body = $this->jsonBody();
			$email=Validator::ensure_email($body,'email');
			$password=Validator::ensure_password($body,'password');
			
			$user = $this->db->single(QUERY_USER_BY_EMAIL,
				[
					'email'=>$email,
					]);
			if(!$this->is_db_empty($user))
			{
				if(password_verify($password,$user['password']))
				{
					$this->set_user_id($user['id']);
					unset($user['password']);
					return $response->json(Utils::data($user));
				}
			}	
			throw new Exception(tr('INVALID_LOGIN_CREDENTIAL'));	

		}
		public function do_logout($request,$response)
		{
			session_destroy();
			$response->json(Utils::okay());
		}
		public function do_user_create($request,$response)
		{
			$body = $this->jsonBody();
			
			$email=Validator::ensure_email($body,'email');
			$password=Validator::ensure_password($body,'password');
			$name=Validator::ensure_name($body,'name');
			$surname=Validator::ensure_surname($body,'surname');
			
			$same_email = $this->db->single(QUERY_USER_BY_EMAIL,[
				'email'=>$email
			]);
			if($this->is_db_empty($same_email) !== true)
				throw new Exception(tr('EMAIL_ALREADY_REGISTERED'));
				
			
			$this->db->execute(QUERY_REGISTER_USER,[
				'email'=>$email,
				'name'=>$name,
				'surname'=>$surname,
				'hash_password'=>password_hash($password,PASSWORD_ALGO),
			]);
			return $response->json(Utils::okay());
			
		}
		/*
		 * Profile managment routes (Read/Update/Delete)
		 */
		public function do_user_profile($request,$response)
		{
			$id = $this->get_user_id();
			$user = $this->db->single(QUERY_USER_BY_ID,[
				'id'=>$id
			]);
			unset($user['password']);
			$response->json(Utils::data($user));
		}
		public function do_user_delete($request,$response)
		{
			$id = $this->get_user_id();
			$user = $this->db->single(QUERY_USER_BY_ID,[
				'id'=>$id
			]);
			unset($user['password']);
			$this->db->execute(QUERY_USER_DELETE_BY_ID,[
				'id'=>$id
			]);
			session_destroy();
			unset($user['password']);
			$response->json(Utils::data($user));
			
		}
		public function do_user_update($request,$response)
		{
			$body = $this->jsonBody();
			if(isset($body['id']))		//Prevent ID changes
				unset($body['id']);
			if(isset($body['email']))	//Prevent email changes
				unset($body['email']);
			if(isset($body['password']))	
			{
				// if updating the password, the same rules applies
				$password=Validator::ensure_password($body,'password');
				$body['password'] = password_hash($password,PASSWORD_ALGO);
			}
			$id = $this->get_user_id();
			$user = $this->db->single(QUERY_USER_BY_ID,[
				'id'=>$id
			]);
			$merged=array_merge($user,$body);
			Validator::ensure_name($merged,'name');
			Validator::ensure_surname($merged,'surname');
			
			$this->db->execute(QUERY_USER_UPDATE_BY_ID,$merged);
			$user = $this->db->single(QUERY_USER_BY_ID,[
				'id'=>$id
			]);
			unset($user['password']);
			$response->json(Utils::data($user));
		}
	}
	
?>
