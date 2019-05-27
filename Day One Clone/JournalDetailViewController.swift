//
//  JournalDetailViewController.swift
//  Day One Clone
//
//  Created by Phizer Cost on 5/13/19.
//  Copyright © 2019 Phizer Cost. All rights reserved.
//

import UIKit

class JournalDetailViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var journalTextLabel: UILabel!
    
    var entry: Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entry = self.entry {
            title = entry.datePrettyString()
            journalTextLabel.text = entry.text
            for picture in entry.pictures {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFit
                let ratio = picture.fullImage().size.height / picture.fullImage().size.width
                imageView.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0)
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: ratio).isActive = true
                imageView.image = picture.fullImage()
                stackView.addArrangedSubview(imageView)
            }
        } else {
            journalTextLabel.text = ""
        }
    }
    
    
    
    

}
