//
//  APIConfiguration.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 21/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Foundation
import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}
