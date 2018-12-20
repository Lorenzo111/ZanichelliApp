<?php
	require_once('Configuration.php');
	require_once('Messages.php');
	class DatabaseManager
	{
		private $pdo = null;
		public function execute($query,$arg)
		{
			$db = $this->connection();
			if($db->beginTransaction()===true)
			{
				if(($sth = $db->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY))) !== false)
				{
					if($sth->execute($arg) === true)
					{
						$lid  = $db->lastInsertId();
						$db->commit();
						return intval($lid,10);
					}
				}
			}
			throw new Exception(tr('Invalid execution point, no exception raised by PDO, but error encountered'));
		}
		public function single($query,$arg)
		{
			$result = $this->select($query,$arg);
			if($result === null || (is_array($result) && count($result) == 0))
				return null;
			return $result[0];
		}
		public function select($query,$arg)
		{
			$db = $this->connection();
			$sth = $db->prepare($query, array(PDO::ATTR_CURSOR => PDO::CURSOR_FWDONLY));
			$sth->execute($arg);
			return $sth->fetchAll(PDO::FETCH_ASSOC);
		}
		public function connection()
		{
			if($this->pdo ===null)
			{
				try
				{
					$this->pdo = new PDO(DB_DSN, DB_USER, DB_PASSWORD);
					$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
				}
				catch(PDOException $e)
				{
					$this->handle_db_error($e);
				}
			}
			return $this->pdo;
		}
		/*
		 * It's common for DB-related exception to leak information.
		 * this method will strip down all the error information 
		 * when not in DEBUG
		 */
		public function handle_db_error($ex)
		{
			if(DB_DEBUG === true)
			{
				throw $ex;
			}
			else
				throw new Exception("Database error");
		}
	}
?>