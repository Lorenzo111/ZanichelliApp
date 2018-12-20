<?php
require_once('Utils.php');
require_once('BaseController.php');

class BookController extends BaseController
{
	public function __construct($db) 
	{
       parent::__construct($db);
	}
	/*
     * Book Managment routes
     */
	public function do_book_list($request,$response)
	{
		$user_id = $this->get_user_id();
		$books = $this->db->select(QUERY_BOOKS_BY_USERID,[
			'user_id'=>$user_id
		]);
		$response->json(Utils::data($books));
	}
	public function do_book_delete($request,$response,$book_id)
	{
		$user_id = $this->get_user_id();
		$books = $this->db->select(QUERY_BOOK_BY_USERID_AND_ID,[
			'user_id'=>$user_id,
			'id'=>$book_id
		]);
		if($this->is_db_empty($books))
			throw new Exception(tr('THIS_BOOK_DOES_NOT_EXISTS'));
		$book = $this->get_book_by_id($book_id);
		$books = $this->db->execute(QUERY_DELETE_BOOKS_BY_USERID_AND_BOOKID,[
			'user_id'=>$user_id,
			'id'=>$book_id,
		]);
		
		$response->json(Utils::data($book));
	}
	public function do_book_update($request,$response,$book_id)
	{
		$user_id = $this->get_user_id();
		$body = $this->jsonBody();
		if(isset($body['id']))
			unset($body['id']);
		if(isset($body['user_id']))
			unset($body['user_id']);
		$book = $this->db->single(QUERY_BOOK_BY_USERID_AND_ID,[
			'user_id'=>$user_id,
			'id'=>$book_id
		]);
		if($this->is_db_empty($book))
			throw new Exception(tr('THIS_BOOK_DOES_NOT_EXISTS'));
		$book = array_merge($book,$body);
		$this->db->execute(QUERY_BOOK_UPDATE,[
			'id' => $book['id'],
			'title'=>$book['title'],
			'author'=>$book['author'],
			'user_id'=>$book['user_id'],
			'description'=>$book['description'],
		]);
		$book = $this->db->single(QUERY_BOOK_BY_USERID_AND_ID,[
			'user_id'=>$user_id,
			'id'=>$book_id
		]);
		
		$response->json(Utils::data($book));
	}
	private function get_book_by_id($id)
	{
		return $this->db->single(QUERY_BOOK_BY_ID,['id'=>$id]);
	}
	public function do_book_create($request,$response)
	{
		$user_id = $this->get_user_id();
		$body = $this->jsonBody();
		$title = Validator::ensure_title($body,'title');
		$author = Validator::ensure_author($body,'author');
		$description = Validator::ensure_description($body,'description');
		$already_same_title = $this->db->single(QUERY_BOOK_BY_TITLE_AND_USERID,[
			'title'=>$title,
			'user_id'=>$user_id,
		]);
		if(!$this->is_db_empty($already_same_title))
			throw new Exception(tr('A_BOOK_WITH_THE_SAME_TITLE_ALREADY_EXISTS'));
		$last_id=$this->db->execute(QUERY_BOOK_INSERT,[
			'title'=>$title,
			'author'=>$author,
			'user_id'=>$user_id,
			'description'=>$description
		]);
		$book = $this->get_book_by_id($last_id);
		$response->json(Utils::data($book));
	}
}


?>