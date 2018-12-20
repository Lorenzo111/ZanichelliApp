<?php
	$MESSAGES=[
		'LOGIN_REQUIRED'=>'Login is required for this functionality',
	];
	/**
	 * This is a simple placeholder method for localization.
	 * @see MESSAGES
	 * @param the string to be localized
	 * @returns if the string is present in the dictionary returns the translated version, otherwise the original string is returned.
	 */
	function tr($msg)
	{
		if(array_key_exists($MESSAGES,$msg))
			return $MESSAGES[$msg];
		return $msg;
	}
	/**
	 * Helper method.
	 * Raise an exception using the provided message after the localization.
	 * @see MESSAGES
	 * @see tr
	 * @returns This function does NOT return.
	 */
	function fatal_error($msg)
	{
		throw new Exception(tr($msg));
	}
?>