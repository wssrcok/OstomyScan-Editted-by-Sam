//
//  RegisterVC.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/16/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
