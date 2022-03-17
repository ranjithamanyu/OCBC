//
//  TransactionsHistoryTableViewCell.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import UIKit

class TransactionsHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var accNoLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDetails(data: TrancationHistory?) {
        if let validData = data {
            if data?.transactionType == "transfer" {
                self.nameLabel.text = validData.receipient?.accountHolder ?? "-"
                self.accNoLabel.text = validData.receipient?.accountNo ?? "-"
                self.amountLabel.text = "-" + String((validData.amount ?? 0.0).withCommas())
                self.amountLabel.textColor = .gray

            } else {
                self.nameLabel.text = validData.sender?.accountHolder ?? "-"
                self.accNoLabel.text = validData.sender?.accountNo ?? "-"
                self.amountLabel.text = String((validData.amount ?? 0.0).withCommas())
                self.amountLabel.textColor = .green
                
            }
        }
    }
    
}

extension Double {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
