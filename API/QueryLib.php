<?php
	/**
	 * Query used to retrieve the user information using the email as search criteria
	 */
	const QUERY_USER_BY_EMAIL = 'select * from users where email = :email';
	/**
	 * Query used to retrieve the user information using the user ID as search criteria
	 */
	const QUERY_USER_BY_ID = 'select * from users where id = :id';
	/**
	 * Query used to insert a new user inside the database. The password MUST be hashed.
	 * @see PASSWORD_ALGO
	 */
	const QUERY_REGISTER_USER = 'insert into users (email,name,surname,password) values (:email,:name,:surname,:hash_password)';
	/**
	 * Query used to delete user using the ID
	 */
	const QUERY_USER_DELETE_BY_ID = 'delete from users where id = :id';
	/**
	 * Query used to update user using the ID. It assumes all the field are always provided. Merge before update is required.
	 */
	const QUERY_USER_UPDATE_BY_ID = 'update users set name=:name, surname=:surname, password=:password, email=:email where id = :id';
	/**
	 * Query used to retrieve all books assigned to an user.
	 */
	const QUERY_BOOKS_BY_USERID = 'select * from books where user_id = :user_id order by title asc';
	/**
	 * Delete a book using both the book id and the user id. 
	 */
	const QUERY_DELETE_BOOKS_BY_USERID_AND_BOOKID = 'delete from books where user_id = :user_id and id = :id';
	/**
	 * Search a book by title for a given user. The search is case-insensitive. 
	 */
	const QUERY_BOOK_BY_TITLE_AND_USERID ='select * from books where user_id = :user_id and  LOWER( title )  like LOWER( :title )';
	/**
	 * Search a book by id. It's not limited to a single user
	 */
	const QUERY_BOOK_BY_ID = 'select * from books where id = :id';
	/**
	 * Insert a book for a given user.
	 */
	const QUERY_BOOK_INSERT = 'insert into books (title,author,vote,description,user_id) values(:title,:author,:vote,:description,:user_id)';
	/**
	 * Search a book using the book id and the user id
	 */
	const QUERY_BOOK_BY_USERID_AND_ID = 'select * from books where id = :id and user_id = :user_id';
	/**
	 * Query used to update book using the ID. It assumes all the field are always provided. Merge before update is required.
	 */
	const QUERY_BOOK_UPDATE = 'update books set title=:title, author=:author, description=:description, user_id=:user_id where id = :id';
	
?>