//
//  DashboardViewController.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import UIKit
import Alamofire

class DashboardViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!

    private let cellIdentifierBalance = "BalanceTableViewCell"
    private let cellIdentifierTransactions = "TransactionsHistoryTableViewCell"
    private let cellIdentifierTransactionsDate = "TrancasctionDateTableViewCell"

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var makeTransferButton: UIButton!
    
    private var transactionDetailsDict: [String? : [TrancationHistory]]!
    private var keysArray: [String]!
    
    //MARK: - View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keysArray = []
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadModel()
    }

    //MARK: - setUpView
    private func setUpView() {

        HELPER.hideNavigationBar(aViewController: self)
        makeTransferButton.layer.cornerRadius = makeTransferButton.frame.height / 2
        makeTransferButton.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: cellIdentifierBalance, bundle: nil), forCellReuseIdentifier: cellIdentifierBalance)
        tableView.register(UINib.init(nibName: cellIdentifierTransactions, bundle: nil), forCellReuseIdentifier: cellIdentifierTransactions)
        tableView.register(UINib.init(nibName: cellIdentifierTransactionsDate, bundle: nil), forCellReuseIdentifier: cellIdentifierTransactionsDate)

    }

    private func loadModel() {
        getAccountBalanceAPI()
        getTransactionHistory()
    }

    private func sortTheData(finalResponse: TrancationHistoryResponse) {
        
        if var data = finalResponse.data {
            for index in 0..<data.count {
                if let date = data[index].transactionDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: date)
                    let dateFormatter1 = DateFormatter()
                    dateFormatter1.dateFormat = "yyyy-MM-dd"
                    let dateStr = dateFormatter1.string(from: date ?? Date())
                    data[index].transactionDate = dateStr
                }
            }
            
            let finalDict = Dictionary(grouping: data, by: { $0.transactionDate ?? ""})
            self.transactionDetailsDict = finalDict
            self.keysArray = finalDict.keys.sorted { key1, key2 in
                key1 > key2
            }
            self.tableView.reloadData()
            
        }
        
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
    //MARK: -  API Response
    private func getTransactionHistory() {

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: "Please Check your network connection")
            return
        }

        CustomLoader.loading(view, enable: true)

        HTTPMANAGER.callApi(viewController: self, method: .get, url: OCBC.baseURL + "/transactions" , parameters: [:], header: [:], decodableType: TrancationHistoryResponse.self) {
            (decodable) in

            CustomLoader.dismiss(self.view)
            guard let finalResponse = decodable as? TrancationHistoryResponse else {return}
            
            switch finalResponse.status {
            case "success":
                self.makeTransferButton.isHidden = false
                self.sortTheData(finalResponse: finalResponse)

            default:
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: finalResponse.error?.message ?? "")
                self.changeRootControllerToLogin()
            }

        }
    }

    private func getAccountBalanceAPI() {

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: "Please Check your network connection")
            return
        }

        CustomLoader.loading(view, enable: true)
        HTTPMANAGER.callApi(viewController: self, method: .get, url: OCBC.baseURL + "/balance" , parameters: [:], header: [:], decodableType: BalanceResponse.self) {
            (decodable) in

            CustomLoader.dismiss(self.view)
            guard let aModel = decodable as? BalanceResponse else {return}

            switch aModel.status {
            case "success":
                self.makeTransferButton.isHidden = false
                let cellHeader = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifierBalance) as! BalanceTableViewCell
                cellHeader.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.width - 40, height: 230)
                cellHeader.updateDetails(aModel)
                self.tableView.tableHeaderView = cellHeader
                
                self.tableView.reloadData()

            default:
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: aModel.error?.message ?? "")
                self.changeRootControllerToLogin()
            }

        }
    }

    //MARK: - Button action
    @IBAction func logoutButtonAction(_ sender: Any) {
        HELPER.showAlertControllerWithOkCancelActionBlock(aViewController: self, aStrMessage: "Are you sure do you want to logout?", okActionBlock: { (action) in
            SESSION.setUserToken(aStrUserToken: "", username: "", accountNo: "")
            self.changeRootControllerToLogin()
        })
    }

    @IBAction func makeTransferButtonAction(_ sender: Any) {
        let ViewController = TransferAmountViewController()
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        self.keysArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = transactionDetailsDict[keysArray[section]]?.count ?? 0
        return count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTransactionsDate, for: indexPath) as! TrancasctionDateTableViewCell
            cell.dateLabel.text = keysArray[indexPath.section]
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTransactions, for: indexPath) as! TransactionsHistoryTableViewCell
            let data = transactionDetailsDict[keysArray[indexPath.section]]
            cell.updateDetails(data: data?[indexPath.row - 1])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
