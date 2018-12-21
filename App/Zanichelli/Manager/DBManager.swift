//
//  DBManager.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 19/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Foundation
import RealmSwift


//Singleton DB Manager

class DBManager{
    private var   database:Realm
    static let   sharedInstance = DBManager()

    private init() {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        database = try! Realm()
        
        
    }
    
    //MARK: - ADD
    
    /*  Add User    */
    func addUser(user: User)   {
        try! database.write {
            database.add(user)
        }
    }
    
    /*  Add Book    */
    func addBook(book: Book)   {
        try! database.write {
            database.add(book, update: true)
        }
    }
    
    //MARK: - GET
    /*  User    */
    func getUserFromDB() ->  Results<User> {
        let results =  database.objects(User.self).sorted(byKeyPath: "surname", ascending: true)
        return results
    }
    
    func getUserById(UserId: String) -> User {
        var userRet = User()
        userRet.id = "-100"
        userRet = database.object(ofType: User.self, forPrimaryKey: UserId)!
        return userRet
    }
    
    
    /*  Book    */
    func getBookResult() -> Results<Book> {
        let results =  database.objects(Book.self).sorted(byKeyPath: "title", ascending: true)
        return results
    }
    
    func getBooks() -> List<Book>{
        
        let books = List<Book>()
        let results =  database.objects(Book.self).sorted(byKeyPath: "title", ascending: true)
        
        for rel in results{
            books.append(rel)
        }
        
        return books
    }
    
    func getBookById(BooklId: String) -> Book  {
        var bookRet = Book()
        bookRet.id = "-100"
        bookRet = database.object(ofType: Book.self, forPrimaryKey: BooklId)!
        return bookRet
    }
    
    
    
    
    //MARK: - Delete
    
     /*  Delete Book    */
    func deleteBook(book: Book)   {
        try!   database.write {
            database.delete(book)
        }
    }
    
    /*  Delete User: for demo    */
    func deleteUser(user: User)   {
        try!   database.write {
            database.delete(user)
        }
    }
    
    /* For Logout Demo*/
    func deleteAll()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    
    func deleteAllUser(){
        let allUser = database.objects(User.self)
        
        try! database.write {
            database.delete(allUser)
        }
    }
    
    
    //MARK: - Network
    func saveBookFromApiToRealm(array: [[String: AnyObject]]){
        
        var setBooksNetworkId = [String]()
        
        for object in array {
            
            
            let book = Book()
            book.id     = object["id"] as! String
            book.title  = object["title"] as! String
            book.author = object["author"] as! String
            book.vote   = object["vote"] as! String
            book.descrizione  = object["description"] as! String
            
            setBooksNetworkId.append(book.id)
            
            try! database.write {
                database.add(book, update: true)
            }
        }
        self.removeUnusedBook(actualID: setBooksNetworkId)
    }
    
    
    /*
    func saveUserInfoFromApiToReal(array: [[String: AnyObject]]){
        
        
        if(array.count == 0)
        {
            return
        }
        
        DBManager.sharedInstance.deleteAllUser()
        
        
        
        let userTS = User()
        
        let test = array[0]
        
        userTS.id = test["id"] as! String
            userTS.name  = test["name"] as! String
            userTS.surname = test["surname"] as! String
            userTS.email   = test["email"] as! String
            userTS.password  = test["password"] as! String
    
    
        try! database.write {
            database.add(userTS, update: true)
        }
        
    }*/
    
    
    
    
    
    //Remove UnUsed Book
    func removeUnusedBook (actualID : [String])
    {
        let bokLocal = database.objects(Book.self)
        for sl in bokLocal{
            if actualID.contains(sl.id) {
                
            }
            else{
                try! database.write {
                    database.delete(sl)
                }
            }
        }
        
    }
}
