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
    
    // UI test for activity creation
    func testAddOption() throws {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        app.launch()
        app.navigationBars["FunGen"].buttons["Add"].tap()
        app.textFields["Enter in activity title"].tap()
        app.textFields["Enter in activity title"].typeText("Ice Cream Day\n")
        app.textFields["Suggest an option"].tap()
        app.textFields["Suggest an option"].typeText("Matcha\n")
        XCTAssert(app.staticTexts["Matcha"].exists)
        app.staticTexts["Matcha"].tap()
        app.buttons["Create"].tap()
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
