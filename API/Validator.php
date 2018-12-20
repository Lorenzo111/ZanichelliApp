<?php
	
	require_once('Utils.php');
	require_once('Messages.php');
	require_once('Configuration.php');
	
	class Validator
	{
		private static function array_or_var(&$body,&$value)
		{
			if($value === null)
				$value = $body;
			else
			{
				if(isset($body[$value]))
					$value = $body[$value];
				else
					$value=null;
			}
		}
		public static function ensure_title($body,$title=null)
		{
			Validator::array_or_var($body,$title);
			if(strlen($title) < MIN_TITLE_LEN)
				throw new Exception(tr('INVALID_TITLE'));
			return $title;
		}
		public static function ensure_author($body,$author=null)
		{
			Validator::array_or_var($body,$author);
			return $author;
		}
		public static function ensure_description($body,$description=null)
		{
			Validator::array_or_var($body,$description);
			return $description;
		}
		public static function ensure_surname($body,$surname=null)
		{
			Validator::array_or_var($body,$surname);
			if(strlen($surname) < MIN_SURNAME_LEN)
				throw new Exception(tr('INVALID_SURNAME'));
			return $surname;
		}
		public static function ensure_name($body,$name=null)
		{
			Validator::array_or_var($body,$name);

			if(strlen($name) < MIN_NAME_LEN)
				throw new Exception(tr('INVALID_NAME'));

			return $name;
		}
		public static function ensure_vote($body,$vote=null)
		{
			Validator::array_or_var($body,$vote);
			return $vote;
		}
		
		
		public static function ensure_email($body,$email=null)
		{
			Validator::array_or_var($body,$email);
		
			if(filter_var($email, FILTER_VALIDATE_EMAIL) === $email)
				return $email;
			throw new Exception(tr('INVALID_EMAIL'));
		}
		public static function ensure_password($body,$password=null)
		{
			Validator::array_or_var($body,$password);

			if(strlen($password) < MIN_PASSWORD_LEN)
				throw new Exception(tr('INVALID_PASSWORD_LEN'));
			return $password;
		}
		
	}
	
?>