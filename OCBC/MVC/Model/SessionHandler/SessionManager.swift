//
//  SessionManager.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import Foundation
import UIKit

class Session: NSObject {

    static let sharedInstance: Session = {

        let instance = Session()

        // setup code

        return instance
    }()

    // SET and get Token
    func setUserToken(aStrUserToken : String, username: String, accountNo:String) {
        UserDefaults.standard.set(aStrUserToken, forKey: "token")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(accountNo, forKey: "accountNo")
        userdefaultsSynchronize()
    }

    func getUserToken() -> (String,String,String) {

        var userToken = ""
        var username = ""
        var accountNo = ""

        if let usertoken = UserDefaults.standard.string(forKey: "token") {
            userToken = usertoken
        }

        if let userName = UserDefaults.standard.string(forKey: "username") {
            username = userName
        }

        if let accountNumber = UserDefaults.standard.string(forKey: "accountNo") {
            accountNo = accountNumber
        }

        return (userToken,username,accountNo)

    }

    private func userdefaultsSynchronize() {

        UserDefaults.standard.synchronize()
    }
    
}
