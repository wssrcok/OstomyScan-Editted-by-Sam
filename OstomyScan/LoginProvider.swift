//
//  LoginProvider.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/17/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//



protocol LoginProvider {
    func login(username: String, password: String, callback: @escaping (Bool)->(Void))
}
