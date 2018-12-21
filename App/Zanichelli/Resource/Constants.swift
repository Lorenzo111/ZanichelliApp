//
//  Constants.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 20/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Foundation


// URL
let URL_BASE = "http://www.ioappo.com/zanichelli"
let URL_USER_CREATE = "/register"
let URL_USER_LOGIN = "/login"
let URL_USER_LOGOUT = "/logout"

let URL_BOOKS = URL_BASE + "/books"
let URL_USER = URL_BASE + "/user"

struct K {
    struct ProductionServer {
        static let baseURL = "http://www.ioappo.com/zanichelli"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        
        static let title = "title"
        static let author = "author"
        static let vote = "vote"
        static let description = "description"
        
        static let name = "name"
        static let surname = "surname"
        
        
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
