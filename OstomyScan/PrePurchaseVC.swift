//
//  PrePurchaseVC.swift
//  OstomyScan
//
//  Created by Sam Shen on 5/3/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import UIKit
import SideMenu

class PrePurchaseVC : UIViewController {

    @IBAction func manuClicked(_ sender: Any) {
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
    }
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
