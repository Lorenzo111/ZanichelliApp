//
//  APIRouter.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 21/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Foundation
import Alamofire


enum APIRouter: URLRequestConvertible {
    
    case login(email:String, password:String)
    case createBook(title:String, author:String, vote:String,description:String)
    case updateBook(bookid: Int,title:String, author:String, vote:String,description:String)
    case registerUser(name:String, surname:String, email:String,password:String)
    case updateUserInfo

    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        //case .posts, .post,
        case .updateUserInfo:
            return .get
        case .createBook:
            return .post
        case .updateBook:
            return .put
        case .registerUser:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/login"
        case .createBook:
            return "/books"
            case .updateBook(let bookid):
            return "/posts/\(bookid)"
        case .registerUser:
            return "/register"
        case .updateUserInfo:
            return "/user"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password]
        case .updateUserInfo:
            return nil
        case .createBook(let title, let author, let vote, let description):
            return [K.APIParameterKey.title: title,
                    K.APIParameterKey.author: author,
                    K.APIParameterKey.vote: vote,
                    K.APIParameterKey.description: description]
            
        case .updateBook(let bookid, let title, let author, let vote, let description):
            return [K.APIParameterKey.title: title,
                    K.APIParameterKey.author: author,
                    K.APIParameterKey.vote: vote,
                    K.APIParameterKey.description: description]
            
        case .registerUser(let name, let surname, let email, let password):
            return [K.APIParameterKey.name: name,
                    K.APIParameterKey.surname: surname,
                    K.APIParameterKey.email: email,
                    K.APIParameterKey.password: password]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
