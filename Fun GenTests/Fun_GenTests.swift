//
//  Fun_GenTests.swift
//  Fun GenTests
//
//  Created by Apollo Zhu on 5/3/22.
//

import XCTest
import Firebase
@testable import Fun_Gen

class Fun_GenTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserLogin() async throws {
        let expectation = XCTestExpectation(description: "User eventually logs in")
        let viewModel = UserViewModel()
        try viewModel.signOut()
        let cancellable = viewModel.$user.sink { user in
            if user?.username == "Test123" {
                expectation.fulfill()
            }
        }
        try await viewModel.signIn(email: "test123@gmail.com", password: "123123")
        wait(for: [expectation], timeout: 10)
        cancellable.cancel()
    }
    
    func testUserViewModelFetchUser() async throws {
        let userByEmail = try await UserViewModel.user(email: "test123@gmail.com")
        let userByName = try await UserViewModel.user(named: "Test123")
        let userByID = try await UserViewModel.user(id: "eOUU1RDjcphzXd0VTUDhALy6ZB53")
        XCTAssertNotNil(userByEmail)
        XCTAssertNotNil(userByName)
        XCTAssertNotNil(userByID)
        XCTAssertEqual(userByEmail, userByName)
        XCTAssertEqual(userByName, userByID)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
