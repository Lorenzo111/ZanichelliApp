//
//  APIClient.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 21/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Alamofire
import SwiftyJSON

class APIClient {
    
    static func madeLoginAsynchNew(email: String, password: String,
                         completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        
        Alamofire.request(APIRouter.login(email: email, password: password))
            .responseJSON { response in
                switch response.result
                {
                    case .success(let JSON):
                        completionHandler(JSON as? NSDictionary, nil)
                        break
                    case .failure(let error):
                        completionHandler(nil, error as NSError)
                }
        }
    }
    
    //Craete Book
    static func createBook(title:String, author:String, vote:String,description:String,  completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        Alamofire.request(APIRouter.createBook(title: title, author: author, vote: vote, description: description))
            .responseJSON { response in
                switch response.result
                {
                case .success(let JSON):
                    completionHandler(JSON as? NSDictionary, nil)
                    break
                case .failure(let error):
                    completionHandler(nil, error as NSError)
                }
            }
    }//createBook end
    
    //Update Book
    static func updateBook(bookid:Int, title:String, author:String, vote:String,description:String,  completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        Alamofire.request(APIRouter.updateBook(bookid: bookid, title: title, author: author, vote: vote, description: description))
            .responseJSON { response in
                switch response.result
                {
                case .success(let JSON):
                    completionHandler(JSON as? NSDictionary, nil)
                    break
                case .failure(let error):
                    completionHandler(nil, error as NSError)
                }
        }
    }//Update end
    
    
    
    
     //Register User
    static func registerUser(name:String, surname:String, email:String,password:String,  completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        Alamofire.request(APIRouter.registerUser(name: name, surname: surname, email: email, password: password)).responseJSON { response in
                switch response.result
                {
                case .success(let JSON):
                    completionHandler(JSON as? NSDictionary, nil)
                    break
                case .failure(let error):
                    completionHandler(nil, error as NSError)
                }
        }
    }//createBook end
    

    //getUserInfo
    static func getUserInfo(completionHandler: @escaping (NSDictionary?, NSError?) -> ()){
        
        Alamofire.request(APIRouter.updateUserInfo).responseJSON { response in
            switch response.result
            {
            case .success(let JSON):
                completionHandler(JSON as? NSDictionary, nil)
                break
            case .failure(let error):
                completionHandler(nil, error as NSError)
            }
        }
    }//getUserInfo end
}
