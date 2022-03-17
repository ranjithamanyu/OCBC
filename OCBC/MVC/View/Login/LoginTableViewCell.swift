//
//  LoginTableViewCell.swift
//  OCBC
//
//  Created by Mac on 15/03/22.
//

import UIKit

protocol LoginTableViewCellDelegate :AnyObject {
    func loginButtonAction(_ username: String,_ password: String)
    func registerButtonAction()
}

class LoginTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var passwordView: UIView!

    @IBOutlet weak var passwordAlertLabel: UILabel!
    @IBOutlet weak var userNameAlertLabel: UILabel!

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    weak var delegate:LoginTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - setupView
    private func setupView() {

        userView.setBorderView(borderHeight: 1, borderColor: .black)
        passwordView.setBorderView(borderHeight: 1, borderColor: .black)
        registerButton.setBorderView(borderHeight: 1, borderColor: .black)
        registerButton.layer.cornerRadius = registerButton.frame.height / 2
        loginButton.layer.cornerRadius = registerButton.frame.height / 2
        passwordAlertLabel.isHidden = true
        userNameAlertLabel.isHidden = true

    }
    //MARK: - Button Action
    @IBAction func loginButtonAction(_ sender: Any) {

        guard let userName = usernameTextField.text, !userName.isEmpty else { return userNameAlertLabel.isHidden = false }
        userNameAlertLabel.isHidden = true
        guard let password = passwordTextField.text, !password.isEmpty else { return passwordAlertLabel.isHidden = false }
        passwordAlertLabel.isHidden = true

        self.delegate.loginButtonAction(userName, password)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        self.delegate.registerButtonAction()
    }
    
    
}
