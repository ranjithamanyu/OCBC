//
//  TransactionTableViewCell.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import UIKit

protocol TransactionTableViewCellDelegate: AnyObject {
    func transferButtonAction(_ amount:String,_ description: String)
    func backButtonAction()
    func selectPayeedButtonAction()
}

class TransactionTableViewCell: UITableViewCell {

    //MARK: - Properties
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var payeeView: UIView!

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var desTextView: UITextView!

    @IBOutlet weak var transferButton: UIButton!
    @IBOutlet weak var selectPayeeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var alertLabel: UILabel!
    weak var delegate: TransactionTableViewCellDelegate!
    var selectedName = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    //MARK: - setupView
    private func setupView() {

        descriptionView.setBorderView(borderHeight: 1, borderColor: .black)
        amountView.setBorderView(borderHeight: 1, borderColor: .black)
        payeeView.setBorderView(borderHeight: 1, borderColor: .black)
        alertLabel.setBorderView(borderHeight: 1, borderColor: HELPER.hexStringToUIColor(hex:"e93f33"))
        alertLabel.isHidden = true
        alertLabel.layer.cornerRadius = 5
        transferButton.layer.cornerRadius = transferButton.frame.height / 2

        amountTextField.delegate = self
        desTextView.delegate = self
    }

    func updateDetails(_ payeeName:String) {
        alertLabel.isHidden = true
        selectedName = payeeName
        selectPayeeButton.setTitle(payeeName, for: .normal)

    }
    //MARK: - Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        self.delegate.backButtonAction()
    }

    @IBAction func selectPayeeButtonAction(_ sender: Any) {
        self.delegate.selectPayeedButtonAction()
    }
    
    @IBAction func transferButtonAction(_ sender: Any) {

        guard !selectedName.isEmpty  else {
            alertLabel.text = "Please select payee"
            alertLabel.isHidden = false
            return
        }

        guard let amount = amountTextField.text, !amount.isEmpty else {
            alertLabel.text = "Please enter amount"
            alertLabel.isHidden = false
            return
        }

        guard let description = desTextView.text, !description.isEmpty else {
            alertLabel.text = "Please enter description"
            alertLabel.isHidden = false
            return
            
        }
        alertLabel.isHidden = true

        self.delegate.transferButtonAction(amount,description)
    }
}

//MARK: - UITextViewDelegate, UITextFieldDelegate
extension TransactionTableViewCell: UITextViewDelegate, UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        alertLabel.isHidden = true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        alertLabel.isHidden = true
    }
}
