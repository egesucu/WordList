//
//  PreviewViewController.swift
//  WordList
//
//  Created by Ege Sucu on 12.12.2018.
//  Copyright © 2018 Ege Sucu. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var germanWordLabel: UILabel!
    var germanText = ""
    var englishText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        englishWordLabel.text = englishText
        germanWordLabel.text = germanText
        
    }
    

   

}
