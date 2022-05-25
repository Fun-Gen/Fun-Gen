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
        let activityID = try await createTestActivity()
        addTeardownAsync {
            try await ActivityViewModel.deleteActivity(activityID)
        }
        let randomOptionTitle = "Test-\(#function)-Option-\(UUID().uuidString)"
        let newOptionID = try await ActivityViewModel
            .addOption(title: randomOptionTitle, byUser: IDs.User.test123,
                       toActivity: activityID)
        let activity = try await ActivityViewModel.activity(id: activityID)
        XCTAssert(activity.options.keys.contains(newOptionID))
    }
    
    func testActivityViewModelVoteForOption() async throws {
        let activityID = try await createTestActivity()
        addTeardownAsync {
            try await ActivityViewModel.deleteActivity(activityID)
        }
        let initialActivity = try await ActivityViewModel.activity(id: activityID)
        let maybeOptionID = initialActivity.options.keys.first
        XCTAssertNotNil(maybeOptionID)
        // already checked not nil, okay to force unwrap
        let optionID = maybeOptionID! // swiftlint:disable:this force_unwrapping
        
        enum State {
            case withoutVote, withVote
        }
        var currentState = State.withoutVote, nextState = State.withVote
        let viewModel = ActivityViewModel(activityID: activityID)
        let receiveNonNilActivity = XCTestExpectation(description: "Has no nil activity")
        let subscription = viewModel.$activity.sink { activity in
            guard let activity = activity,
                  let option = activity.options[optionID]
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
        
        try await userVoteThenUndoVote(for: optionID, inActivity: activityID)
        
        wait(for: [receiveNonNilActivity], timeout: 5)
        XCTAssertEqual(currentState, nextState)
        subscription.cancel()
    }
    
    private func userVoteThenUndoVote(for optionID: Option.ID, inActivity activityID: Activity.ID) async throws {
        try await ActivityViewModel.changeVote(ofUser: IDs.User.testTest,
                                               addTo: optionID,
                                               inActivity: activityID)
        let optionWithVote = try await ActivityViewModel
            .activity(id: activityID)
            .options[optionID]
        XCTAssertNotNil(optionWithVote)
        XCTAssert(optionWithVote?.members.contains(IDs.User.testTest) == true)
        
        try await ActivityViewModel.changeVote(ofUser: IDs.User.testTest,
                                               removeFrom: optionID,
                                               inActivity: activityID)
        let optionWithOutVote = try await ActivityViewModel
            .activity(id: activityID)
            .options[optionID]
        XCTAssertNotNil(optionWithOutVote)
        XCTAssert(optionWithOutVote?.members.contains(IDs.User.testTest) == false)
    }
    
    func testActivityViewModelRandomSelection() async throws {
        let activityID = try await createTestActivity()
        addTeardownAsync {
            try await ActivityViewModel.deleteActivity(activityID)
        }
        let activityBefore = try await ActivityViewModel.activity(id: activityID)
        let beforeSelection = activityBefore.selectedOption
        XCTAssertNil(beforeSelection)
        let selected = try await ActivityViewModel.selectRandomOption(forActivity: activityID)
        XCTAssertEqual(selected, activityBefore.options.keys.first)
        let activityAfter = try await ActivityViewModel.activity(id: activityID)
        XCTAssertEqual(selected, activityAfter.selectedOption)
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
    
    private func createTestActivity(function: String = #function) async throws -> Activity.ID {
        return try await ActivityViewModel.createActivity(
            title: "Test-\(function)-title-\(UUID().uuidString)",
            // Category should have more than one case, random should pick something
            // swiftlint:disable:next force_unwrapping
            category: Category.allCases.randomElement()!,
            author: IDs.User.testTest,
            optionTitles: ["Test-\(function)-init-\(UUID().uuidString)"],
            additionalMembers: [IDs.User.test123]
        )
    }
    
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
