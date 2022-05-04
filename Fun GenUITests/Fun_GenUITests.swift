//
//  Fun_GenUITests.swift
//  Fun GenUITests
//
//  Created by Apollo Zhu on 5/3/22.
//

import XCTest

// Had an issue with Failed to scroll to visible (by AX action) Button, stackoverflow solution
extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}

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
        app.buttons["return"].forceTapElement()
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
