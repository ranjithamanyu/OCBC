//
//  RegisterTableViewCell.swift
//  OCBC
//
//  Created by Mac on 15/03/22.
//

import UIKit


protocol RegisterTableViewCellDelegate :AnyObject {
    func registerButtonAction(_ username: String,_ password: String)
    func backButtonAction()
}

class RegisterTableViewCell: UITableViewCell {
    //MARK: - Properties
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPasswordView: UIView!

    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var userNameAlertLabel: UILabel!
    @IBOutlet weak var confirmPasswordAlertLabel: UILabel!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    weak var delegate:RegisterTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - setupView
    private func setupView() {

        userView.setBorderView(borderHeight: 1, borderColor: .black)
        passwordView.setBorderView(borderHeight: 1, borderColor: .black)
        confirmPasswordView.setBorderView(borderHeight: 1, borderColor: .black)

        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        passwordAlertLabel.isHidden = true
        userNameAlertLabel.isHidden = true
        confirmPasswordAlertLabel.isHidden = true

    }

    //MARK: - Button Action

    @IBAction func registerButtonAction(_ sender: Any) {
        
        guard let userName = usernameTextField.text, !userName.isEmpty else {
            return userNameAlertLabel.isHidden = false
        }
        
        userNameAlertLabel.isHidden = true
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            return passwordAlertLabel.isHidden = false
        }
        
        passwordAlertLabel.isHidden = true
        
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            confirmPasswordAlertLabel.isHidden = false
            confirmPasswordAlertLabel.text = "Confirm Password is required"
            return
        }

        confirmPasswordAlertLabel.isHidden = true
        
        guard confirmPassword == password else {
            confirmPasswordAlertLabel.isHidden = false
            confirmPasswordAlertLabel.text = "Password not match"
            return
        }
        self.delegate.registerButtonAction(userName, confirmPassword)

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.delegate.backButtonAction()
    }
}
