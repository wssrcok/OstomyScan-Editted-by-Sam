//
//  MockLoginProvider.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/23/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import Foundation

class MockLoginProvider: LoginProvider {
    func login(username: String, password: String, callback: @escaping (Bool)->(Void)) {
        callback(true)
        //Uncomment for testing
        /*DispatchQueue.background(background: {
            print("In the backgorund!")
            DispatchQueue.main.async(execute: {
                print("Returned to foreground!")
                if username == "lucas@" {
                    callback(true)
                } else {
                    callback(false)
                }
            })
        }, completion: nil)
         */
    }
}
