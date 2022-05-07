//
//  Fun_GenTests.swift
//  Fun GenTests
//
//  Created by Apollo Zhu on 5/3/22.
//

import XCTest
import FirebaseFirestore
@testable import Fun_Gen

class Fun_GenTests: XCTestCase {
    /// Constants for quickly referencing known identifiers in the database.
    enum IDs {
        enum User {
            static let test123 = "eOUU1RDjcphzXd0VTUDhALy6ZB53"
            static let testTest = "MEXIFk2ocFZsJ6eYqab24Hj6ioQ2"
        }
        enum Activity {
            static let testActivity = "testActivityID"
        }
        enum Option {
            static let testOption = "testOptionID"
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // Workaround for FB10009783
    private var tearDownBlocks: [() async throws -> Void] = []
    override func tearDown() async throws {
        for tearDownBlock in tearDownBlocks.reversed() {
            try await tearDownBlock()
        }
    }

    func testUserLogin() async throws {
        let expectation = XCTestExpectation(description: "User eventually logs in")
        let viewModel = UserViewModel()
        try viewModel.signOut()
        let cancellable = viewModel.$user.sink { user in
            if let user = user,
               user.username == "Test123",
               user.id == IDs.User.test123 {
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
        let userByID = try await UserViewModel.user(id: IDs.User.test123)
        XCTAssertNotNil(userByEmail)
        XCTAssertNotNil(userByName)
        XCTAssertNotNil(userByID)
        XCTAssertEqual(userByEmail, userByName)
        XCTAssertEqual(userByName, userByID)
        // All equal by transitivity
    }
    
    func testActivityViewModelCreateActivity() async throws {
        let optionID = OptionViewModel
            .createOption(title: "Test-\(#function)-init-\(UUID().uuidString)")
        addTeardownAsync {
            try await self.deleteOptions(ids: [optionID])
        }
        // Create new activity
        let title = "Test-\(#function)-title-\(UUID().uuidString)"
        let activityID = ActivityViewModel.createActivity(
            title: title,
            category: .destination,
            author: IDs.User.test123,
            options: [optionID],
            additionalMembers: [IDs.User.testTest]
        )
        addTeardownAsync {
            try await self.deleteActivity(id: activityID,
                                          andFromUsers: [IDs.User.test123, IDs.User.testTest])
        }
        // Check activity has the correct info
        let activity = try await ActivityViewModel.activity(id: activityID)
        XCTAssertEqual(activity.id, activityID)
        XCTAssertEqual(activity.title, title)
        XCTAssertEqual(activity.category, Category.destination)
        XCTAssertEqual(activity.author, IDs.User.test123)
        XCTAssert(activity.members.contains(IDs.User.test123))
        XCTAssert(activity.members.contains(IDs.User.testTest))
        // Check users' activities are updated
        let users = try await UserViewModel.users(ids: [IDs.User.test123, IDs.User.testTest])
        XCTAssertEqual(users.count, 2)
        for user in users {
            XCTAssert(user.activities.contains(activityID))
        }
    }
    
    func testActivityViewModelAddOption() async throws {
        let randomOptionTitle = "Test-\(#function)-Option-\(UUID().uuidString)"
        let newOptionID = OptionViewModel.createOption(title: randomOptionTitle)
        addTeardownAsync {
            try await self.deleteOptions(ids: [newOptionID])
        }
        ActivityViewModel.addOption(newOptionID, byUser: IDs.User.test123,
                                    toActivity: IDs.Activity.testActivity)
        addTeardownAsync {
            ActivityViewModel
                .removeOption(newOptionID, fromActivity: IDs.Activity.testActivity)
        }
        let activity = try await ActivityViewModel.activity(id: IDs.Activity.testActivity)
        XCTAssert(activity.options.keys.contains(newOptionID))
    }
    
    func testActivityViewModelVoteForOption() async throws {
        try await ActivityViewModel.changeVote(ofUser: IDs.User.testTest,
                                               addTo: IDs.Option.testOption,
                                               inActivity: IDs.Activity.testActivity)
        let optionWithVote = try await ActivityViewModel
            .activity(id: IDs.Activity.testActivity)
            .options[IDs.Option.testOption]
        XCTAssertNotNil(optionWithVote)
        XCTAssert(optionWithVote?.members.contains(IDs.User.testTest) == true)
        try await ActivityViewModel.changeVote(ofUser: IDs.User.testTest,
                                               removeFrom: IDs.Option.testOption,
                                               inActivity: IDs.Activity.testActivity)
        let optionWithOutVote = try await ActivityViewModel
            .activity(id: IDs.Activity.testActivity)
            .options[IDs.Option.testOption]
        XCTAssertNotNil(optionWithOutVote)
        XCTAssert(optionWithOutVote?.members.contains(IDs.User.testTest) == false)
    }
    
    func testOptionViewModel() async throws {
        let randomText = "Test-\(#function)-\(UUID().uuidString)"
        let optionID = OptionViewModel.createOption(title: randomText)
        addTeardownAsync {
            try await self.deleteOptions(ids: [optionID])
        }
        let option = try await OptionViewModel.option(id: optionID)
        XCTAssertNotNil(option)
        XCTAssertEqual(option?.title, randomText)
    }
    
    // MARK: - Helpers
    
    private func deleteOptions(ids: [Option.ID]) async throws {
        for id in ids {
            try await Firestore.firestore()
                .collection(OptionViewModel.optionsCollection)
                .document(id)
                .delete()
        }
    }
    
    private func deleteActivity(id activityID: Activity.ID,
                                andFromUsers userIDs: [User.ID]) async throws {
        // Remove activity from activities
        try await Firestore.firestore()
            .collection(ActivityViewModel.activitiesCollection)
            .document(activityID)
            .delete()
        // Remove activity from each of its member's records
        for userID in userIDs {
            try await Firestore.firestore()
                .collection(UserViewModel.usersCollection)
                .document(userID)
                .updateData([
                    "activities": FieldValue.arrayRemove([activityID])
                ])
        }
    }
    
    // Normally you'd use addTeardownBlock, but there's a bug (FB10009783):
    // Undefined symbol: (extension in XCTest):__C.XCTestCase.
    // addTeardownBlock(() async throws -> ()) -> ()
    func addTeardownAsync(_ block: @escaping () async throws -> Void) {
        tearDownBlocks.append(block)
    }
}
