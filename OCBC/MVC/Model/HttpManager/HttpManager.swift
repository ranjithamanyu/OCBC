//
//  HttpManager.swift
//  OCBC
//
//  Created by Mac on 15/03/22.
//

import Foundation
import UIKit
import Alamofire

public enum OCBC {

    static var appName = "OCBC"

    static let baseURL =  "https://green-thumb-64168.uc.r.appspot.com/"

}


let HTTPMANAGER = HttpManager.sharedInstance
let HELPER = Helper.sharedInstance
let SESSION = Session.sharedInstance


let kRESPONSE_CODE_DATA_SUCCESS             = "200"
let kRESPONSE_CODE_INVALID_TOKEN            = "498"
let kRESPONSE_CODE_DATA_SERVER_ERROR        = "500"


class HttpManager: NSObject {

    static let sharedInstance: HttpManager = {
        let instance = HttpManager()

        return instance
    }()

    // MARK: - GET & POST

    func callApi<T: Decodable>(

        viewController: UIViewController? = nil,
        method: HTTPMethod = .get,
        url: String,
        parameters: [String: Any] = [:],
        header: HTTPHeaders = [:],
        decodableType: T.Type,
        sucessBlock: @escaping (Decodable)->() = {_ in }

    ) {

        if !Reachability.isConnectedToNetwork() {


            if let viewController = viewController {

                HELPER.showDefaultAlertViewController(aViewController: viewController, alertTitle: OCBC.appName, aStrMessage: "Please check your Internet connection")
            }

            return
        }

        if let viewController = viewController {
            CustomLoader.loading(viewController.view, enable: true)
        }

        let headers: HTTPHeaders

        if SESSION.getUserToken().0.count == 0 {
            headers = []
        }  else {
            headers = ["Authorization":  SESSION.getUserToken().0]
        }

        print(url)
        print(parameters)
        print(headers)

        AF.request(url, method : method, parameters : parameters, headers : headers).responseData {
            response in

            CustomLoader.dismiss((viewController?.view)!)

            switch response.result {
            case .success(let value):
                do {

                    //let str = String(decoding: value, as: UTF8.self)
                    let decodable = try JSONDecoder().decode(decodableType.self, from: value)
                    let jsonDictionary = try JSONSerialization.jsonObject(with: value, options: []) as! [String: Any]

                    if let viewController = viewController,
                       let statuscode = jsonDictionary["status"] as? String,

                        statuscode == kRESPONSE_CODE_INVALID_TOKEN {

                        HELPER.showAlertControllerWithOkActionBlock(aViewController: viewController, aStrMessage: "Error") { (okAction) in

                        }
                    }
                    else {
                        sucessBlock(decodable)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
