//
//  Book.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 18/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object,Codable {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
     @objc dynamic var author: String = ""
    @objc dynamic var isbn: String = ""
    @objc dynamic var descrizione: String = ""
    @objc dynamic var user_id: String = ""
    @objc dynamic var vote: String = ""
    
    // MARK: - Meta
    override static func primaryKey() -> String? {
        return "id"
    }
}
