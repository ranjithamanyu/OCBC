//
//  CustomModel.swift
//  OCBC
//
//  Created by Mac on 17/03/22.
//

import Foundation
import UIKit

public class CustomModel {

    // MARK: - Network Properties

    public var networkManager: URLSession!
    public var networkRequest: URLRequest!
    public var statusCode: Int?

    // MARK: - Login Properties

    public var username: String?
    public var password: String?
    public var confirmPassword: String?
    public var loginEnabled = false

    public var constantEmail: String! = "daphne@machinevantage.com"
    public var constantPassword: String! = "Daphne@123"

    // MARK: - Regsitration Properties

    public var register_username: String?
    public var register_password: String?

    // MARK: - Lifecycle

    // Custom initializers go here

    init() {

        networkManager = URLSession(configuration: .default)
    }

}

// MARK: - Validation

extension CustomModel {

    /// Password Validation
    public enum PasswordValidation {
        case login
        case register
    }

    /// Registration handler
    public func enableRegistrationAttempt() {
        loginEnabled = passwordValid(.register)
    }

    /// Passowrd Validaiton
    /// - Parameter validation: Indicates one of the enum cases
    /// - Returns: Returns true if validation success otherwise false
    public func passwordValid(_ validation: PasswordValidation) -> Bool {

        switch validation {
        case .login:
            guard password != nil else {
                return false
            }
            return true

        default:
            guard let password = password,
                  let passwordConfirmation = confirmPassword else {
                return false
            }
            let isValid = (password == passwordConfirmation)
            return isValid
        }

    }
}
