//
//  BookDetails_VC.swift
//  Zanichelli
//
//  Created by Lorenzo Orlandi on 17/12/2018.
//  Copyright © 2018 IoAppo. All rights reserved.
//

import UIKit

class BookDetails_VC: UIViewController {

    var bookPassed:Book!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
    @IBOutlet weak var imgStar_1: UIImageView!
    @IBOutlet weak var imgStar_2: UIImageView!
    @IBOutlet weak var imgStar_3: UIImageView!
    @IBOutlet weak var imgStar_4: UIImageView!
    @IBOutlet weak var imgStar_5: UIImageView!
    
    
    @IBOutlet weak var txtViewDescrizione: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.backBarButtonItem?.title = "Back"
        self.navigationItem.title = "Book Info"
      
        self.prepareGui()
    }
    
    
    fileprivate func prepareGui(){
        
        
        lblTitle.text = bookPassed.title
        lblAuthor.text = bookPassed.author
        txtViewDescrizione.text = bookPassed.descrizione
        
        
        
        let vote = Int(bookPassed.vote)
        
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
    
    
    
    @IBAction func btnEditPressed(_ sender: Any) {
        
        
        self.openBookDetailView()
        
    }
    
    fileprivate func openBookDetailView()
    {
        let viewControllerNext:AddEditBook_VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditBook_VC") as! AddEditBook_VC
        
        viewControllerNext.bookPassed = bookPassed
    //self.navigationController?.pushViewController(viewControllerNext, animated: true)
    
        viewControllerNext.modalPresentationStyle = .overCurrentContext
        present(viewControllerNext, animated: true, completion: nil)
    }
    
    

}
