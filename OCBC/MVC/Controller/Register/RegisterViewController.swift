//
//  RegisterViewController.swift
//  OCBC
//
//  Created by Mac on 15/03/22.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!

    private let cellIdentifierRegister = "RegisterTableViewCell"

    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    //MARK: - setUpView
    private func setUpView() {
        HELPER.hideNavigationBar(aViewController: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: cellIdentifierRegister, bundle: nil), forCellReuseIdentifier: cellIdentifierRegister)
    }

    private func changeRootControllerToLogin() {

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                sceneDelegate.window?.windowScene = windowScene

                let navigationOne = UINavigationController(rootViewController: LoginViewController())
                navigationOne.navigationBar.isHidden = true
                sceneDelegate.window?.rootViewController = navigationOne
                sceneDelegate.window?.makeKeyAndVisible()

            }
        }
    }

    //MARK: - Api Request

    func registerAPIRequest(_ username:String,_ password: String) {
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: "Please Check your network connection")
            return
        }

        let aDictParameters = ["username":username,
                               "password":password]
        CustomLoader.loading(view, enable: true)
        HTTPMANAGER.callApi(viewController: self, method: .post, url: OCBC.baseURL + "/register" , parameters: aDictParameters, header: [:], decodableType: RegisterResponse.self) {
            (decodable) in

            CustomLoader.dismiss(self.view)
            guard let aModel = decodable as? RegisterResponse else {return}

            switch aModel.status {
            case "success":
                HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: "Registered your account \n"  + (aModel.status ?? ""), okActionBlock: { (action) in
                    self.changeRootControllerToLogin()
                })
            default:
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: aModel.error ?? "")
            }

        }
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RegisterViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierRegister, for: indexPath) as! RegisterTableViewCell
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height 
    }
}

//MARK: - RegisterTableViewCellDelegate
extension RegisterViewController: RegisterTableViewCellDelegate {
    func registerButtonAction(_ username: String, _ password: String) {
        registerAPIRequest(username,password)
    }

    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
