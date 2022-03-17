//
//  Register_View_Controller.swift
//  OCBCTests
//
//  Created by Mac on 17/03/22.
//

import XCTest
@testable import OCBC

class Register_View_Controller: XCTestCase {

    private var registerModel: CustomModel! = CustomModel()

    private var register_View_Test: RegisterViewController! = RegisterViewController()


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()

        testRegisterDetails()

    }

    func testRegisterDetails() {
        registerModel.username = "ranjitha"
        registerModel.password = "12345"
        registerModel.confirmPassword = "12345"

        XCTAssertNotNil(registerModel.username, "Please enter user name")
        XCTAssertTrue(registerModel.passwordValid(.register), "Password mismatch")

        do {
            let username = try XCTUnwrap(registerModel.username)
            XCTAssertTrue(username.count > 0)
        } catch {
            XCTFail("Import fail: \(error)")
        }

        do {
            let password = try XCTUnwrap(registerModel.password)
            XCTAssertTrue(password.count > 0)
        } catch {
            XCTFail("Import fail: \(error)")
        }

        do {
            let confirmPassword = try XCTUnwrap(registerModel.confirmPassword)
            XCTAssertTrue(confirmPassword.count > 0)
        } catch {
            XCTFail("Import fail: \(error)")
        }

        guard let userName = registerModel.username, userName.count > 0 else {
            return
        }

        guard let password = registerModel.password, password.count > 0 else {
            return
        }

        guard let confirmPassword = registerModel.confirmPassword, confirmPassword.count > 0 else {
            return
        }

        register_View_Test.registerAPIRequest(userName, confirmPassword)
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
