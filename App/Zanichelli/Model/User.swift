//
//  User.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 17/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object{
    
    
    //MARK: - Init
    
    //MARK: - Properties
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var surname = ""
    @objc dynamic var email = ""
    @objc dynamic var password = ""
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }
}

