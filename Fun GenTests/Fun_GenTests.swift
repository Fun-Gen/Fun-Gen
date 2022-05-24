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
        XCTAssertEqual(userByEmail?.id, userByName?.id)
        XCTAssertEqual(userByName?.id, userByID?.id)
        // All equal by transitivity
    }
    
    func testActivityViewModelCreateActivity() async throws {
        let optionTitle = "Test-\(#function)-init-\(UUID().uuidString)"
        // Create new activity
        let title = "Test-\(#function)-title-\(UUID().uuidString)"
        let activityID = try await ActivityViewModel.createActivity(
            title: title,
            category: .destination,
            author: IDs.User.test123,
            optionTitles: [optionTitle],
            additionalMembers: [IDs.User.testTest]
        )
        addTeardownAsync {
            try await ActivityViewModel.deleteActivity(activityID)
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
        // Check options have correct titles
        XCTAssertEqual(activity.options.keys.count, 1)
        let optionID = Array(activity.options.keys)[0]
        let option = try await OptionViewModel.option(id: optionID)
        XCTAssertNotNil(option)
        XCTAssertEqual(option?.title, optionTitle)
    }
    
    func testActivityViewModelAddOption() async throws {
        let randomOptionTitle = "Test-\(#function)-Option-\(UUID().uuidString)"
        let newOptionID = try await ActivityViewModel
            .addOption(title: randomOptionTitle, byUser: IDs.User.test123,
                       toActivity: IDs.Activity.testActivity)
        addTeardownAsync {
            try await self.deleteOptions(ids: [newOptionID])
            try await ActivityViewModel
                .removeOption(newOptionID, fromActivity: IDs.Activity.testActivity)
        }
        let activity = try await ActivityViewModel.activity(id: IDs.Activity.testActivity)
        XCTAssert(activity.options.keys.contains(newOptionID))
    }
    
    func testActivityViewModelVoteForOption() async throws {
        enum State {
            case withoutVote, withVote
        }
        var currentState = State.withoutVote, nextState = State.withVote
        let viewModel = ActivityViewModel(activityID: IDs.Activity.testActivity)
        let receiveNonNilActivity = XCTestExpectation(description: "Has no nil activity")
        let subscription = viewModel.$activity.sink { activity in
            guard let activity = activity,
                  let option = activity.options[IDs.Option.testOption]
            else { return }
            receiveNonNilActivity.fulfill()
            let containsUser = option.members.contains(IDs.User.testTest)
            switch (currentState, nextState, containsUser) {
            case (.withoutVote, .withoutVote, true):
                XCTFail("Expect to not have user vote")
            case (.withoutVote, .withoutVote, false):
                break
            case (.withoutVote, .withVote, true):
                currentState = nextState
                nextState = .withoutVote
            case (.withoutVote, .withVote, false):
                break // awaiting update
            case (.withVote, .withoutVote, true):
                break // awaiting update
            case (.withVote, .withoutVote, false):
                currentState = nextState
            case (.withVote, .withVote, true):
                break
            case (.withVote, .withVote, false):
                XCTFail("Expect to have user vote")
            }
        }
        
        try await userVoteThenUndoVoteForOptionInTestActivity()
        
        wait(for: [receiveNonNilActivity], timeout: 5)
        XCTAssertEqual(currentState, nextState)
        subscription.cancel()
    }
    
    private func userVoteThenUndoVoteForOptionInTestActivity() async throws {
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
    
    func testActivityViewModelRandomSelection() async throws {
        addTeardownAsync {
            try await ActivityViewModel._vetoSelectedOption(forActivity: IDs.Activity.testActivity)
        }
        let beforeSelection = try await ActivityViewModel
            .activity(id: IDs.Activity.testActivity)
            .selectedOption
        XCTAssertNil(beforeSelection)
        let selected = try await ActivityViewModel.selectRandomOption(forActivity: IDs.Activity.testActivity)
        XCTAssertEqual(selected, IDs.Option.testOption)
    }
    
    func testOptionViewModel() async throws {
        let randomText = "Test-\(#function)-\(UUID().uuidString)"
        let optionID = try await OptionViewModel.createOption(title: randomText)
        addTeardownAsync {
            try await self.deleteOptions(ids: [optionID])
        }
        let option = try await OptionViewModel.option(id: optionID)
        XCTAssertNotNil(option)
        XCTAssertEqual(option?.title, randomText)
    }
    
    // MARK: - Helpers
    
    private func deleteOptions<S: Sequence>(ids: S) async throws
    where S.Element == Option.ID {
        for id in ids {
            try await Firestore.firestore()
                .collection(OptionViewModel.optionsCollection)
                .document(id)
                .delete()
        }
    }
    
    // Normally you'd use addTeardownBlock, but there's a bug (FB10009783):
    // Undefined symbol: (extension in XCTest):__C.XCTestCase.
    // addTeardownBlock(() async throws -> ()) -> ()
    func addTeardownAsync(_ block: @escaping () async throws -> Void) {
        tearDownBlocks.append(block)
    }
}
