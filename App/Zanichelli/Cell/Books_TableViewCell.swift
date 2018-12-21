//
//  Books_TableViewCell.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 18/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import UIKit

internal class Books_TableViewCell: UITableViewCell {

    
    static let reuseIdentifier = "Books_TableViewCell"
    
    @IBOutlet weak var imgStar_1: UIImageView!
    @IBOutlet weak var imgStar_2: UIImageView!
    @IBOutlet weak var imgStar_3: UIImageView!
    @IBOutlet weak var imgStar_4: UIImageView!
    @IBOutlet weak var imgStar_5: UIImageView!
    
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    private var book: Book?
 
    func configureWithBook(_ book: Book ) {
        
        self.book = book
        
        lblTitle.text   = self.book?.title
        lblAuthor.text  = self.book?.author
        let vote = Int((self.book?.vote)!)
        
        switch vote {
        case 1:
            self.imgStar_1.image = UIImage(named: "StarFill")!
            break
        case 2:
            self.imgStar_1.image = UIImage(named: "StarFill")!
            self.imgStar_2.image = UIImage(named: "StarFill")!
            break
        case 3:
            self.imgStar_1.image = UIImage(named: "StarFill")!
            self.imgStar_2.image = UIImage(named: "StarFill")!
            self.imgStar_3.image = UIImage(named: "StarFill")!
            break
        case 4:
            self.imgStar_1.image = UIImage(named: "StarFill")!
            self.imgStar_2.image = UIImage(named: "StarFill")!
            self.imgStar_3.image = UIImage(named: "StarFill")!
            self.imgStar_4.image = UIImage(named: "StarFill")!
            break
        case 5:
            self.imgStar_1.image = UIImage(named: "StarFill")!
            self.imgStar_2.image = UIImage(named: "StarFill")!
            self.imgStar_3.image = UIImage(named: "StarFill")!
            self.imgStar_4.image = UIImage(named: "StarFill")!
            self.imgStar_4.image = UIImage(named: "StarFill")!
            break
        default:
            break
        }
        
    }
        

}
