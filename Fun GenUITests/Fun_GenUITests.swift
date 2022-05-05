//
//  Fun_GenUITests.swift
//  Fun GenUITests
//
//  Created by Apollo Zhu on 5/3/22.
//

import XCTest

class Fun_GenUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state
        // - such as interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // UI test for frontend, adding an option on the VoteView page
    func testAddOption() throws {
        let app = XCUIApplication()
        app.launch()
        if app.buttons["Sign out"].exists {
            app.buttons["Sign out"].tap()
        }

        app.textFields["Email"].tap()
        if app.buttons["continue"].exists {
            app.buttons["continue"].tap()
        }
        app.textFields["Email"].typeText("test123@gmail.com\n")

        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("123123\n")

        app.buttons["Sign in"].tap()
        
        app.buttons["Movie Night"].tap()
        app.scrollViews.otherElements.textFields["Suggest an option"].tap()
        app.scrollViews.otherElements.textFields["Suggest an option"].typeText("Spider Man\n")
        XCTAssert(app.scrollViews.otherElements.buttons["Spider Man"].exists)
        app.scrollViews.otherElements.buttons["Spider Man"].tap()
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
