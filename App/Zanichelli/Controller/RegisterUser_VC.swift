//
//  RegisterUser_VC.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 19/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import UIKit

class RegisterUser_VC: UIViewController,Alertable {

    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSurname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.title = "Registrazione"
        
      
        txtName.text    = ""
        txtSurname.text = ""
        txtEmail.text   = ""
        txtPassword.text = ""
    }
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var surname = ""
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    

    @IBAction func btnSavePressed(_ sender: Any) {
        
        
        if( txtName.text!.isEmpty ||
            (txtSurname.text?.isEmpty)! ||
            (txtEmail.text?.isEmpty)! ||
            (txtPassword.text?.isEmpty)!)
        {
            showAlert("E' obbligatorio compilare tutti i campi")
        }
        else
        {
            let userToSave = User()
            
            //call network Api
            
            //save local
            userToSave.id       = String(Int.random(in: 0 ..< 9999))
            userToSave.name     = txtName.text!
            userToSave.surname  = txtSurname.text!
            userToSave.email    = txtEmail.text!
            userToSave.password = txtPassword.text!
            
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                APIClient.registerUser(name: userToSave.name, surname: userToSave.surname, email: userToSave.email, password: userToSave.password)
                { responseObject, error in
                    // Parsing JSON Below
                    if (responseObject == nil)
                    {
                        self.showAlert("Registrazione Fallita. Riprovare")
                        return
                    }
                    
                    
                    let message = responseObject?.object(forKey: "message") as! String
                
                    if (message == "ok")
                    {
                        DispatchQueue.main.async {
                            
                            DBManager.sharedInstance.deleteAllUser()
                            
                            
                            DBManager.sharedInstance.addUser(user: userToSave)
                            self.showAlert("Utente registrato correttaemente. Si può fare il login")
                            
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
    
    
    
    @IBAction func btnClosePressed(_ sender: Any) {
        self.closeModal()
    }
    
    
    private func closeModal(){
        self.dismiss(animated: true, completion: nil)
    }

}
