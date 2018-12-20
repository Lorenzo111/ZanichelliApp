<?php

/**
 * Application title 
 */
const TITLE = 'Zanichelli Test';
/**
 * Current Application version as const
 */
const VERSION = '0.9.0.0';
/**
 * Minimum password length
 */
const MIN_PASSWORD_LEN = 4;
/**
 * Minimum surname length
 */
const MIN_SURNAME_LEN = 3;
/**
 * Minimum user name length
 */
const MIN_NAME_LEN = 3;
/**
 * Minimum book title length
 */
const MIN_TITLE_LEN = 3;
/**
 * Algorithm used to hash the password.
 * @see http://php.net/manual/en/function.password-hash.php
 */
const PASSWORD_ALGO = PASSWORD_DEFAULT ;
/**
 * Key name used to store the user id in $_SESSION
 */
const USER_ID_SESSION_NAME = 'zanichelli_userid';
/**
 * Database DNS (Data Source name)
 */
const DB_DSN='mysql:dbname=zanichelliDB;host=188.121.57.61';
/**
 * Database username
 */
const DB_USER='zanichelliDB';
/**
 * Database password
 */
const DB_PASSWORD='Zanichelli2018#';
/**
 * Enable Database exception propagation
 */
const DB_DEBUG = true;
?>