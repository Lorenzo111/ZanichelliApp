//
//  Home_VC.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 17/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift


class Home_VC: UIViewController,Alertable,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    
    @IBOutlet weak var viewLoggedOut: UIView!
    @IBOutlet weak var viewLogged: UIView!
    
    @IBOutlet weak var lblSurname: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    
    @IBOutlet weak var tableview: UITableView!
    
    //Realm
    fileprivate var booksList: Results<Book>!
    //private var database:Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
      //createUserDemo()
        self.loadData()
    }
    
     func loadData()
    {
        booksList = DBManager.sharedInstance.getBookResult()
        //Check User
       
        let user = DBManager.sharedInstance.getUserFromDB().first
        
        
        
        self.viewLogged.isHidden = true
        self.viewLoggedOut.isHidden = false
        
        if(user != nil)
        {
            //Valid User
            
            self.viewLogged.isHidden = false
            self.viewLoggedOut.isHidden = true
            
            lblName.text    = user!.name
            lblSurname.text = user!.surname
            
            
            let usernameLogin = String(user!.email)
            let passwordLogin = String(user!.password)
            
            
            self.txtEmail.text = usernameLogin
            self.txtPassword.text = passwordLogin
            
            
            self.callLoginAsynch(username: usernameLogin, password: passwordLogin)
        }
    }
    
    
    private func callLoginAsynch(username: String, password:String)
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            APIClient.madeLoginAsynchNew(email: username, password: password) { responseObject, error in
                // Parsing JSON Below
                let resultApi = responseObject?.object(forKey: "result") as! Bool
              
                if (resultApi)
                {
                    
                    DispatchQueue.main.async {
                        self.viewLogged.isHidden = false
                        self.viewLoggedOut.isHidden = true
                        
                    }
                    self.updateUserInfo()
                    self.updateBookFromApi()
                   
                }
                else{
                    var error = ""
                    error = responseObject?.object(forKey: "error") as! String
                    self.showAlert("Login fallito: \(error)")
                    self.viewLogged.isHidden = true
                    self.viewLoggedOut.isHidden = false
                }
                return
            }
        }
    }
    
    
    private func updateUserInfo()
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            APIClient.getUserInfo()
                { responseObject, error in
                // Parsing JSON Below
                let resultApi = responseObject?.object(forKey: "result") as! Bool
                
                    if (resultApi)
                    {
                        let message = responseObject?.object(forKey: "message") as! String
                        
                        let datamsg = responseObject?.object(forKey: "data") as! [String: AnyObject]
                        
                        if (message == "ok")
                        {
                            let userTS = User()
                            userTS.name = datamsg["name"] as! String
                            userTS.surname = datamsg["surname"] as! String
                            userTS.email = self.txtEmail.text!
                            userTS.password = self.txtPassword.text!
                            userTS.id = datamsg["id"] as! String
                            
                            
                            
                            
                            DispatchQueue.main.async {
                            
                                DBManager.sharedInstance.deleteAllUser()
                                
                                DBManager.sharedInstance.addUser(user: userTS)
                                self.viewLogged.isHidden = false
                                self.viewLoggedOut.isHidden = true
                                self.lblName.text = userTS.name
                                self.lblSurname.text = userTS.surname
                            }
                            
                        }
                        else{
                            self.showAlert("Non è possibile salvare")
                        }
                        return
                    }
                    
            }
        }
    }
    
    
    private func openRegistrationPage()
    {
        let viewControllerNext:RegisterUser_VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterUser_VC") as! RegisterUser_VC
        
        viewControllerNext.modalPresentationStyle = .overCurrentContext
        present(viewControllerNext, animated: true, completion: nil)
    }
    
    
    // MARK: - ACTIONS Section

    @IBAction func btnLoginPressed(_ sender: Any) {
        
        if txtEmail.text != "" && txtPassword.text != ""  {
            
            let email       = txtEmail.text!
            let password    = txtPassword.text!
          
            self.callLoginAsynch(username: email, password: password)
        }
        else
        {
            showAlert("Inserire Username e Password")
        }
    }
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
       self.openRegistrationPage()
    }
    
    @IBAction func btnLogoutPressed(_ sender: Any) {
        
        DBManager.sharedInstance.deleteAll()
        
        self.viewLogged.isHidden = true
        self.viewLoggedOut.isHidden = false
        
        lblName.text = ""
        lblSurname.text = ""
        txtPassword.text = ""
        txtEmail.text = ""
        
        
        tableview.reloadData()
    }
    
    @IBAction func btnAddBookPressed(_ sender: Any) {
        self.openBookDetailView()
    }
    
    @IBAction func reloadBookPressed(_ sender: Any) {
        
        loadLocalBooks()
        
    }
    
    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return booksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Books_TableViewCell.reuseIdentifier, for: indexPath) as! Books_TableViewCell
        
        let bookSel = booksList[indexPath.row]
        
        cell.configureWithBook(bookSel)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        openBookDetailView(bookSelected: booksList[indexPath.row])
    
    }
    
    //Table Section End
    
    
    
    //MARK: - API CALL
    
    private func updateBookFromApi()
    {
          API_Manager.sharedInstance.getDataWith(urlToLoad: URL_BOOKS) { (result) in
            switch result{
            case .Success(let data):
               DBManager.sharedInstance.saveBookFromApiToRealm(array: data)
                DispatchQueue.main.async {
                        self.loadLocalBooks()
                }
                break
                
            case .Error( _):
                DispatchQueue.main.async {
                    self.showAlert("Errore Aggiornando il Database.")
                    //self.updateDbFromApi_Finish()
                }
                break
            }
        }
    }
    
    
    
    
    //MARK: - Functions Controller
    
    fileprivate func loadLocalBooks()
    {
        booksList = DBManager.sharedInstance.getBookResult()
        self.tableview.reloadData()
    }
    
    
    fileprivate func openBookDetailView()
    {
        let viewControllerNext:AddEditBook_VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditBook_VC") as! AddEditBook_VC
        
        viewControllerNext.bookPassed = nil
        //self.navigationController?.pushViewController(viewControllerNext, animated: true)
        
        viewControllerNext.modalPresentationStyle = .overCurrentContext
        present(viewControllerNext, animated: true, completion: nil)
    }
    
    
    
    fileprivate func openBookDetailView(bookSelected: Book)
    {
        let viewControllerNext:BookDetails_VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookDetails_VC") as! BookDetails_VC
        
        
        
        viewControllerNext.bookPassed = bookSelected
        
        self.navigationController?.pushViewController(viewControllerNext, animated: true)
    }
    
    
    
    //MARK:- DEMO Data
    
    
    
    fileprivate func createUserDemo()
    {
        let demoUser = User()
        
        demoUser.id         = "7"
        demoUser.name       = "Lorenzo"
        demoUser.surname    = "Orlandi"
        demoUser.email      = "orlandil@gmail.com"
        demoUser.password   = "password"
        
        DBManager.sharedInstance.addUser(user: demoUser)
        
        self.createDemoData()
    }
    
    fileprivate func createDemoData(){
        
        let book1 = Book()
        book1.id = "1"
        book1.title = "Il morso della reclusa"
        book1.author = "Fred Vargas"
        book1.vote = "3"
        book1.user_id = "1"
        book1.descrizione = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        let book2 = Book()
        book2.id = "2"
        book2.title = "Resto qui"
        book2.author = "Marco Balzano"
        book2.vote = "4"
        book2.user_id = "1"
        book2.descrizione = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        let book3 = Book()
        book3.id = "3"
        book3.title = "Manhattan beach"
        book3.author = "Jennifer Egan"
        book3.vote = "1"
        book3.user_id = "1"
        book3.descrizione = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        DBManager.sharedInstance.addBook(book: book1)
        DBManager.sharedInstance.addBook(book: book2)
        DBManager.sharedInstance.addBook(book: book3)
        
    }
    
   
    
    
    
    
    
}


