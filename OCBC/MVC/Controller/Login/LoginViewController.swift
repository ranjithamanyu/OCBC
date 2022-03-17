//
//  LoginViewController.swift
//  OCBC
//
//  Created by Mac on 15/03/22.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!

    private let cellIdentifierLogin = "LoginTableViewCell"

    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    //MARK: - setUpView
    private func setUpView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: cellIdentifierLogin, bundle: nil), forCellReuseIdentifier: cellIdentifierLogin)
    }

    //MARK: - API Request
    func loginRequestApi(_ userName: String,_ password:String) {

        if !HELPER.isConnectedToNetwork() {

            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: "Please Check your network connection")
            return
        }

        CustomLoader.loading(view, enable: true)
        let aDictParameters = ["username":userName,
                               "password":password]

        HTTPMANAGER.callApi(viewController: self, method: .post, url: OCBC.baseURL + "/login" , parameters: aDictParameters, header: [:], decodableType: LoginResponse.self) {
            (decodable) in
            CustomLoader.dismiss(self.view)

            guard let aModel = decodable as? LoginResponse else { return }

            switch aModel.status {
            case "success":
                guard let token = aModel.token else {  return }
                guard let username = aModel.username else {  return }
                guard let accountNo = aModel.accountNo else {  return }
                SESSION.setUserToken(aStrUserToken: token, username: username, accountNo: accountNo)
                debugPrint(SESSION.getUserToken())

                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                        sceneDelegate.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
                        sceneDelegate.window?.windowScene = windowScene

                        let navigationOne = UINavigationController(rootViewController: DashboardViewController())
                        navigationOne.navigationBar.isHidden = true
                        sceneDelegate.window?.rootViewController = navigationOne
                        sceneDelegate.window?.makeKeyAndVisible()
                    }
                }

            default:
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: aModel.error ?? "")
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension LoginViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierLogin, for: indexPath) as! LoginTableViewCell
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height - 100
    }
}

//MARK: - LoginTableViewCellDelegate
extension LoginViewController: LoginTableViewCellDelegate {

    func loginButtonAction(_ username: String,_ password: String) {

        loginRequestApi(username,password)
    }

    func registerButtonAction() {
        let ViewController = RegisterViewController()
        self.navigationController?.pushViewController(ViewController, animated: true)
    }

}
