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

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
    }
    
    // UI test for frontend, adding an option on the VoteView page
    func testAddOption() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Movie Night"].tap()
        app.scrollViews.otherElements.textFields["Suggest an option"].tap()
        app.scrollViews.otherElements.textFields["Suggest an option"].typeText("Spider Man")
        app/*@START_MENU_TOKEN@*/.keyboards.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[2,0]]@END_MENU_TOKEN@*/.tap()
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
