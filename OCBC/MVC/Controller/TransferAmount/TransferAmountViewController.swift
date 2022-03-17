//
//  TransferAmountViewController.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import UIKit
import Alamofire

class TransferAmountViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifierTransfer = "TransactionTableViewCell"
    private var payeeListArray = [PayeeDetails]()
    private var selectedPayeeName = String()
    private var selectedPayeeAccNo = String()
    private var toolBar = UIToolbar()
    private var picker  = UIPickerView()

    //MARK: - View life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        loadModel()
    }
    
    //MARK: - setUpView
    
    private func setUpView() {
        
        HELPER.hideNavigationBar(aViewController: self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: cellIdentifierTransfer, bundle: nil), forCellReuseIdentifier: cellIdentifierTransfer)
        
    }
    
    private func loadModel() {
        getPayeeDetailsAPI()
    }
    
    //MARK: - Private Methods
    
    private func createPickerView() {
        
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc
    private func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    //MARK: - API Response
    
    private func getPayeeDetailsAPI() {
        
        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: "Please Check your network connection")
            return
        }
        
        CustomLoader.loading(view, enable: true)
        HTTPMANAGER.callApi(viewController: self, method: .get, url: OCBC.baseURL + "/payees" , parameters: [:], header: [:], decodableType: PayeeResponse.self) {
            (decodable) in
            
            CustomLoader.dismiss(self.view)
            guard let aModel = decodable as? PayeeResponse else {return}
            
            switch aModel.status {
            case "success":
                self.payeeListArray = aModel.data ?? []
                self.tableView.reloadData()
                
            default:
                HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: aModel.error?.message ?? "")
            }
            
        }
    }

    private func moneyTransferAPI(_ amount: String, _ description: String) {

        if !HELPER.isConnectedToNetwork() {
            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: "Please Check your network connection")
            return
        }

        CustomLoader.loading(view, enable: true)

        guard let amountValue = Int(amount) else { return  }

        let aDictParameters = ["receipientAccountNo": selectedPayeeAccNo,
                               "amount": amountValue,
                               "description": description] as [String : Any]
        let headers: HTTPHeaders

        if SESSION.getUserToken().0.count == 0 {
            headers = []
        }  else {
            headers = ["Authorization":  SESSION.getUserToken().0]
        }


        AF.request(OCBC.baseURL + "/transfer", method: .post, parameters: aDictParameters  ,encoding: JSONEncoding.default, headers: headers)
            .responseData { response in

                CustomLoader.dismiss(self.view)

                switch response.result {

                case .failure(let error) :
                    print(error)
                    break

                case .success(let jsonSuccess):
                    do {

                        let decodable = try JSONDecoder().decode(MoneyTransferResponse.self, from: jsonSuccess)
                        
                        switch decodable.status {
                        case "success":
                            HELPER.showAlertControllerWithOkActionBlock(aViewController: self, aStrMessage: decodable.status ?? "", okActionBlock: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })

                        default:
                            HELPER.showDefaultAlertViewController(aViewController: self, alertTitle: OCBC.appName, aStrMessage: decodable.error ?? "")
                        }
                    }
                    catch {
                        print(error)
                    }
                    break
                }
            }
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource

extension TransferAmountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifierTransfer, for: indexPath) as! TransactionTableViewCell
        cell.delegate = self
        cell.updateDetails(selectedPayeeName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
}
//MARK: - RegisterTableViewCellDelegate

extension TransferAmountViewController: TransactionTableViewCellDelegate {
    func transferButtonAction(_ amount: String, _ description: String) {
        moneyTransferAPI(amount, description)
    }
    
    func selectPayeedButtonAction() {
        createPickerView()
    }
    
    func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TransferAmountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return payeeListArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return payeeListArray[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPayeeName = payeeListArray[row].name ?? ""
        selectedPayeeAccNo = payeeListArray[row].accountNo ?? ""
        tableView.reloadData()
        onDoneButtonTapped()
    }

}
