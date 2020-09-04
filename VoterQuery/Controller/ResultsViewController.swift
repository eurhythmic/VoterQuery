//
//  ResultsViewController.swift
//  VoterQuery
//
//  Created by RnD on 9/1/20.
//  Copyright © 2020 RnD. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    var districtName = ""
    
    @IBOutlet weak var districtNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !districtName.isEmpty {
            districtNameLabel.text = districtName
        } else {
            districtNameLabel.text = "Nothing was found for this address"
        }
    }
    
}
