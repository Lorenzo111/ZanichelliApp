//
//  AddEditBook_VC.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 19/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

class AddEditBook_VC: UIViewController,Alertable {

    var isNew = false
    var bookPassed: Book!
    var bookNew:Book!
    var isUpdateBook = false
    var bookId = ""
    
    
    @IBOutlet weak var txtTitolo: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    
    @IBOutlet weak var txtViewDescription: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtViewDescription.isScrollEnabled = false
        
        if(bookPassed == nil)
        {
           isUpdateBook = false;
           bookNew = Book()
        }
        else{
            isUpdateBook = true;
            self.initGui()
        }
       
    }
    
    
    

    // MARK: - Actions
  @IBAction func btnClosePressed(_ sender: Any) {
    self.closeModal()
    }
    
    @IBAction func btnSavePresed(_ sender: Any) {
        self.saveBookCheck()
    }
    
    // MARK: - Controller Functions
    
    fileprivate func saveBookCheck()
    {
        
        if( txtTitolo.text!.isEmpty || txtAuthor.text!.isEmpty)
        {
            showAlert("E' obbligatorio compilare tutti i campi")
        }
        else
        {
            if(bookNew == nil)
            {
                //Edit book
                bookNew = Book()
                bookNew.id = bookId
            }
            else{
                //new book
                bookNew.id = String(Int.random(in: 0 ..< 9999))
            }
            bookNew.title  = txtTitolo.text!
            bookNew.author = txtAuthor.text!
            bookNew.descrizione  = txtViewDescription.text!
            self.saveBook(book: bookNew)
        }
    }
    
    
    
    fileprivate func initGui(){
        
        bookId = bookPassed.id
        
        txtTitolo.text = bookPassed.title
        txtAuthor.text = bookPassed.author
        txtViewDescription.text = bookPassed.descrizione
    }
    
  
    fileprivate func saveBook(book: Book)
   {
        //call Network
        //1)check login
    
        let localUser = DBManager.sharedInstance.getUserFromDB().first
        if localUser == nil
        {
            showAlert("Impossibile salvare online")
            return
            
        }
        else{
            saveBookAsynchNew(user: localUser!)
        }
    }
    
    private func closeModal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Network Functions
    
    private func saveBookAsynchNew(user: User){
        
        //Check Login
        //mettere singleton user logged
        let username   = user.email
        let password   = user.password
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            APIClient.madeLoginAsynchNew(email: username, password: password)
            { responseObject, error in
                // Parsing JSON Below
                let resultApi = responseObject?.object(forKey: "result") as! Bool
                if (resultApi)
                {
                    self.selectBookAPI()
                }
                else{
                    var error = ""
                    error = responseObject?.object(forKey: "error") as! String
                    self.showAlert("Salvataggio fallito: \(error)")
                   
                }
                return
            }
        }
    }
    
    
    
    fileprivate func selectBookAPI()
    {
        if(isUpdateBook)
        {
            //self.updateBookNew()
            self.showAlert("Update non disponibile in questa versione dell'app. Solo disponibile tramite API")
        }
        else{
            createNewBookNew()
        }
        
        
    }
    
    
    
    fileprivate func createNewBookNew(){
        
        self.bookNew.vote = "3"
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            APIClient.createBook(title: self.bookNew.title, author: self.bookNew.author, vote: self.bookNew.vote, description: self.bookNew.descrizione)
            { responseObject, error in
                // Parsing JSON Below
                if (responseObject == nil)
                {
                    self.showAlert("Non è possibile salvare")
                    return
                }
                
                let resultApi = responseObject?.object(forKey: "result") as! Bool
                if (resultApi)
                {
                    let message = responseObject?.object(forKey: "message") as! String
                    
                    let datamsg = responseObject?.object(forKey: "data") as! [String: AnyObject]
               
                    if (message == "ok")
                    {
                        let bookF = Book()
                        bookF.author = datamsg["author"] as! String
                        bookF.title = datamsg["title"] as! String
                        bookF.vote = datamsg["vote"] as! String
                        bookF.descrizione = datamsg["description"] as! String
                        bookF.id = datamsg["id"] as! String
                        bookF.user_id = datamsg["user_id"] as! String
                        
                        DispatchQueue.main.async {
                            DBManager.sharedInstance.addBook(book: bookF)
                            self.showAlert("Libro salvato corerttamente")
                        }
                        
                    }
                    else{
                        self.showAlert("Non è possibile salvare")
                        return
                    }
                    return
                }
                else{
                    self.showAlert("Non è possibile salvare")
                }
                
                
                
                
            }
        }
    }//createNewBookNew end
    
    
    
    
    fileprivate func updateBookNew(){
     
        self.bookNew.vote = "3"
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            
            
            let bookid = Int(self.bookNew.id)
            
            APIClient.updateBook(bookid: bookid! ,title: self.bookNew.title, author: self.bookNew.author, vote: self.bookNew.vote, description: self.bookNew.descrizione){
                responseObject, error in
                // Parsing JSON Below
                if (responseObject == nil)
                {
                    self.showAlert("Non è possibile salvare")
                    return
                }
                
                let resultApi = responseObject?.object(forKey: "result") as! Bool
                if (resultApi)
                {
                    let message = responseObject?.object(forKey: "message") as! String
                    
                    let datamsg = responseObject?.object(forKey: "data") as! [String: AnyObject]
                    //let jsonResponse = responseObject
                    print(message)
                    print(datamsg)
                    if (message == "ok")
                    {
                        let bookF = Book()
                        bookF.author = datamsg["author"] as! String
                        bookF.title = datamsg["title"] as! String
                        bookF.vote = datamsg["vote"] as! String
                        bookF.descrizione = datamsg["description"] as! String
                        bookF.id = datamsg["id"] as! String
                        bookF.user_id = datamsg["user_id"] as! String
                        
                        DispatchQueue.main.async {
                            DBManager.sharedInstance.addBook(book: bookF)
                            self.showAlert("Libro salvato corerttamente")
                        }
                        
                    }
                    else{
                        self.showAlert("Non è possibile salvare")
                        return
                    }
                    return
                }
                else{
                      self.showAlert("Non è possibile salvare")
                }
                
                
                
              
            }
        }
    }//updateBookNew end

    
}
