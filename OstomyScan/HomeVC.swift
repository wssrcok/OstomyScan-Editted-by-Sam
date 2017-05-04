//
//  HomeVC.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/23/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import UIKit
import SideMenu

class HomeVC: UIViewController {
    
    @IBOutlet weak var scanImage: UIImageView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var emptyView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
        menuRightNavigationController.leftSide = false
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        SideMenuManager.menuFadeStatusBar = false
        
        loadLastScreenShotIfExists()
        
    }
    
    func loadLastScreenShotIfExists() {
        if let imageData = UserDefaults.standard.value(forKey: "LatestScreenshot") {
            scanImage.image = UIImage(data: imageData as! Data)
            emptyView.isHidden = true
            scanImage.isHidden = false
            purchaseButton.isHidden = false
        } else {
            scanImage.isHidden = true
            emptyView.isHidden = true // Testing, false for real app
            purchaseButton.isHidden = false // Testing, ture for real app

        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    
    
    @IBAction func menuClicked(_ sender: Any) {
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func scanClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main_iPad", bundle: nil)
        let controler = storyboard.instantiateViewController(withIdentifier: "ScannerViewController") as UIViewController
        self.present(controler, animated: true, completion: nil)
    }
    
    @IBAction func purchaseClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Purchase", bundle: nil)
        let controler = storyboard.instantiateViewController(withIdentifier: "PrePurchaseVC") as UIViewController
        self.present(controler, animated: true, completion: nil)
    }
}
