//
//  WordDisplayViewController.swift
//  Word Search
//
//  Created by Linus Huzell on 2019-02-25.
//  Copyright © 2019 Linus Huzell. All rights reserved.
//

import UIKit

class WordDisplayViewController: UIViewController {

    var wordToDisplay = String()
    
    @IBOutlet weak var wordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordLabel.text = wordToDisplay
        navigationItem.title = "Word Search"
    }
}
