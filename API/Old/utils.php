<?php

class Utils
{
	static function jsonBody()
	{
		$inputJSON = file_get_contents('php://input');
		$input = json_decode($inputJSON, TRUE); //convert JSON into array
		return $input;
	}
	static function isPOST()
	{
		return $_SERVER['REQUEST_METHOD'] === 'POST';
	}
	static function isGET()
	{
		return $_SERVER['REQUEST_METHOD'] === 'GET';
	}
	static function isDELETE()
	{
		return $_SERVER['REQUEST_METHOD'] === 'DELETE';
	}
	static function isPUT()
	{
		return $_SERVER['REQUEST_METHOD'] === 'PUT';
	}
	
	static function send_str($str,$content_type='application/json') 
	{
		header("Content-type: ${content_type}");
		echo $str;
	}
	static function send_json($obj)
	{
		return Utils::send_str(json_encode($obj),'application/json');
	}
	static function error($message)
	{
		Utils::send_json(['success'=>false,'error'=>$message]);
		exit(0);
	}
	static function success($data)
	{
		if(is_array($data) === FALSE)
		{
			$data =[$data];
		}
		Utils::send_json(['success'=>true,'data'=>$data]);
		exit(0);
	}
	static function data($data)
	{
		if(is_array($data) === FALSE)
		{
			$data =[$data];
		}
		Utils::success($data);
		exit(0);
	}
	static function done()
	{
		Utils::success(["ok"]);
		exit(0);
	}
	static function notSupported()
	{
		Utils::error(["NOT SUPPORTED"]);
		exit(0);
	}
	static function missingFields()
	{
		Utils::error(["MISSING REQUIRED FIELDS"]);
		exit(0);
	}
	static function loginRequired()
	{
		Utils::error(["LOGIN REQUIRED"]);
		exit(0);
	}
	static function unknowUser()
	{
		Utils::error("INVALID USERNAME/PASSWORD");
		exit(0);
	}
	
	
}





?>