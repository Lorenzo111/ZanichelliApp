<?php
	
	class Utils
	{
		public static function okay($msg = null)
		{
			if(is_null($msg))
				$msg = 'ok';
				
			return Utils::build_response(true,$msg);
		}
		public static function data($d)
		{
			return Utils::build_response(true,'ok',$d);
		}
		public static function error($msg)
		{
			return Utils::build_response(false,$msg);
		}
		public static function build_response($status,$message,$data=null)
		{
			if($status === true)
			{
				if(is_null($data))
				{
					return ['result'=>true,'message'=>$message];
				}
				if(!is_array($data))
				{
					$data = [$data];
				}
				return ['result'=>true,'message'=>$message, 'data'=>$data];
			}
			else
			{
				return ['result'=>false,'error'=>$message];
			}
		}
	}

?>