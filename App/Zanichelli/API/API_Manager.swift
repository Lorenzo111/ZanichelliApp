//
//  API_Manager.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 21/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class API_Manager{
    
    static let   sharedInstance = API_Manager()
    
    
    private var serverName = ""
    private var baseurl = ""
    
    //private var completionBlock: RequestCompletion!
    var afManager : SessionManager!
    
    private init() {
        //database = try! Realm()
        let configuration = URLSessionConfiguration.default
        afManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    func getDataWith(urlToLoad:String, completion: @escaping (ResultAPI<[[String: AnyObject]]>) -> Void) {
        
        let urlString = urlToLoad//endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["data"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
   
    
}






enum ResultAPI <T>{
    case Success(T)
    case Error(String)
}

