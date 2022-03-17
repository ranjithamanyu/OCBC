//
//  BalanceTableViewCell.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import UIKit

class BalanceTableViewCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var accountHolderNameLabel: UILabel!
    @IBOutlet weak var accountNoLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    var balance : BalanceResponse?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setUpView() {
      //  baseView.roundCorners(with: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner], radius: 20)
        baseView.layer.cornerRadius = 20
    }

    func updateDetails(_ details: BalanceResponse) {

        balance = details
        guard let balance1 = balance?.balance else { return  }
        guard let accountNo = balance?.accountNo else { return  }
        let acctName = SESSION.getUserToken().1

        let strbalance = "You have \n SGD \(Double(balance1).withCommas())"
        let range = (strbalance as NSString).range(of: "You have")
        let mutableAttributedString = NSMutableAttributedString.init(string: strbalance)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
        balanceLabel.attributedText = mutableAttributedString

        let strAccNo = "Account No \n \(accountNo)"
        let rangeNo = (strAccNo as NSString).range(of: "Account No")
        let mutableAttributedStringNo = NSMutableAttributedString.init(string: strAccNo)
        mutableAttributedStringNo.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: rangeNo)
        accountNoLabel.attributedText = mutableAttributedStringNo

        let strAccName = "Account Holder \n \(acctName)"
        let rangeName = (strAccName as NSString).range(of: "Account Holder")
        let mutableAttributedStringName = NSMutableAttributedString.init(string: strAccName)
        mutableAttributedStringName.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: rangeName)
        accountHolderNameLabel.attributedText = mutableAttributedStringName
    }


}
