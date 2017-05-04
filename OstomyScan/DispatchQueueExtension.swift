//
//  DispatchQueueExtension.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/23/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static func background(background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    completion()
                })
            }
        }
    }
    
}

extension DispatchQueue {
    
    static func foreground(background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .userInteractive).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    completion()
                })
            }
        }
    }
    
}
