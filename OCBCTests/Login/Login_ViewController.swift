//
//  Login_ViewController.swift
//  OCBCTests
//
//  Created by Mac on 17/03/22.
//

import XCTest
@testable import OCBC

class Login_ViewController: XCTestCase {

    private var loginModel: CustomModel! = CustomModel()

    private var login_View_Test: LoginViewController! = LoginViewController()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()
        
        testLoginDetails()

    }
    
    func testLoginDetails() {
        
        loginModel.username = "ranjitha"
        loginModel.password = "12345"
        
        XCTAssertNotNil(loginModel.username, "Please enter user name")
        XCTAssertTrue(loginModel.passwordValid(.login), "Invalid Password")
        
        do {
            let username = try XCTUnwrap(loginModel.username)
            XCTAssertTrue(username.count > 0)
        } catch {
            XCTFail("Import fail: \(error)")
        }
        
        do {
            let password = try XCTUnwrap(loginModel.password)
            XCTAssertTrue(password.count > 0)
        } catch {
            XCTFail("Import fail: \(error)")
        }
        
        guard let userName = loginModel.username, userName.count > 0 else {
            return
        }
        
        guard let password = loginModel.password, password.count > 0 else {
            return
        }

        login_View_Test.loginRequestApi("ranjitha", "123456")
        //testNetworkRequest(userName, password)
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
