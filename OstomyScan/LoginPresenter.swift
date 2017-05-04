//
//  LoginPresenter.swift
//  OstomyScan
//
//  Created by Lucas Cauthen on 1/24/17.
//  Copyright © 2017 OstomyTech. All rights reserved.
//

import Foundation

class LoginPresenter {
    
}

protocol LoginView {
    func showError(errorMsg: String)
    func toggleLoading(shouldDisplayLoading: Bool)
}
