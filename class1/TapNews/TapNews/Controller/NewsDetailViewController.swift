//
//  NewsDetailViewController.swift
//  TapNews
//
//  Created by Sam Zhang on 5/14/18.
//  Copyright © 2018 Sam Zhang. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var imageUrl: String?
    var strTitle: String?
    var strSource: String?
    var strDescription: String?
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newsSource: UILabel!
    
    @IBOutlet weak var newsContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsTitle.text = strTitle
        newsSource.text = strSource
        newsContent.text = strDescription
        
        DispatchQueue.global().async {
            let urlImage = try? Data(contentsOf: URL(string: self.imageUrl!)!)
            if let imageData = urlImage {
                DispatchQueue.main.async {
                    self.newsImage.image = UIImage(data: imageData)
                }
            }
        }
    }


    

}
