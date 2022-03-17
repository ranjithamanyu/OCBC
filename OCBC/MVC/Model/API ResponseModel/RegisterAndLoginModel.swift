//
//  RegisterAndLoginModel.swift
//  OCBC
//
//  Created by Mac on 16/03/22.
//

import Foundation
//MARK: - Register
struct RegisterResponse: Codable {
    let status, token,error: String?
}
//MARK: - LoginResponse
struct LoginResponse: Codable {
    let status, token, username, accountNo,error: String?
}

// MARK: - Balance Response
struct BalanceResponse: Codable {
    let status, accountNo: String?
    let balance: Int?
    let error: Error?
}

// MARK: - Trancation History Response
struct TrancationHistoryResponse: Codable {
    let status: String?
    var data: [TrancationHistory]?
    let error: Error?
}

// MARK: - Error
struct Error: Codable {
    let name, message: String
}

// MARK: - Datum
struct TrancationHistory: Codable {
    let transactionID: String?
    let amount: Double?
    var transactionDate: String!
    let datumDescription: String?
    let transactionType: String?
    let receipient, sender: Receipient?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case amount, transactionDate
        case datumDescription = "description"
        case transactionType, receipient, sender
    }
}

// MARK: - Sender
struct Receipient: Codable {
    let accountNo, accountHolder: String?
}

// MARK: - PayeeResponse
struct PayeeResponse: Codable {
    let status: String?
    let data: [PayeeDetails]?
    let error: Error?
}

// MARK: - Datum
struct PayeeDetails: Codable {
    let id, name, accountNo: String?
}

// MARK: - MoneyTransferResponse

struct MoneyTransferResponse: Codable {
    let status, transactionID: String?
    let amount: Int?
    let welcomeDescription, recipientAccount,error: String?

    enum CodingKeys: String, CodingKey {
        case status
        case transactionID = "transactionId"
        case amount
        case welcomeDescription = "description"
        case recipientAccount
        case error
    }
}
