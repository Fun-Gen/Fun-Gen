# Fun Gen

UW CSE 403 Spring 2022 Group Project

**Please check out our user manual on our [Wiki](https://github.com/Fun-Gen/Fun-Gen/wiki) to get started!**

### Goals

Major Features for MVP (Minimum Viable Product)

- List of options to vote on for the activity
- Predefined set of options to select from and separated into categories
- Option selection system including voting, polling, or randomized selection
- Account system

Stretch Features

- Seeing and interacting with friends’ activity lists
- Shared music playlist for activity
- Map (either Google or Apple map) showing possible venues to choose from

## Get Started

If you are new to SwiftUI, you can follow UWAppDev's guide on
[getting started with SwiftUI](https://uwdev.app/resources/getting-started/swiftui).

### Setup

1. You should have a Mac computer
2. Install Xcode from the Mac [App Store](https://apps.apple.com/app/id497799835) if you don't have it installed already
3. Install SwiftLint by following the [official documentation](https://github.com/realm/SwiftLint#installation)
4. Double click to open `Fun Gen.xcodeproj` in Xcode

### Project Structure

- `Fun Gen.xcodeproj`: Xcode project file.
- `Shared`: The main SwiftUI codebase for Fun Gen.
    - `Model`: data structure definitions.
    - `View`: user interface.
    - `ViewModel`: bindings and operations for model, interfacing with Firebase.
- `macOS`: SwiftUI allows running code on macOS at the same time.
    Any macOS specific code or resources files will be in this directory.
- `Fun GenTests`: unit tests for Fun Gen backend. 
    See [XCTest documentation](https://developer.apple.com/documentation/xctest) 
    on how to use and create unit tests.
- `Fun GenUITests`: UI tests for Fun Gen frontend.
    See [User Interface Tests](https://developer.apple.com/documentation/xctest/user_interface_tests)
    and [UI Testing in Xcode](https://developer.apple.com/videos/play/wwdc2015/406/) 
    on how to use and create UI tests.
- `reports`: weekly reports for communicating with our TA/project manager.
- `Configuration`: to support building the project using different Apple IDs.
- `.github`: configuration files for GitHub related settings.

### Build

All our tasks are automated there are no sanity checkcs that the developer has to perform. 

Select build destination and run the app by following Apple's documentation on [Running Your App in the Simulator or on a Device
](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device)

#### Build Release

Each pull request against `main` branch as well as each commit on the `main` branch will also be automatically build by Xcode Cloud,
and built artifact for the `main` branch commits will be automatically submitted to App Store Connect for release on TestFlight for external installation.

#### Common Issue

To resolve common compile time errors that happen after pulling a new branch:

1. Make sure you have an iPhone simulator selected as the run destination
2. If you are getting multiple errors, click on menu item File > Packages > Resolve Package Versions

### Run

After building the project by following the build instructions,
make sure to [select the scheme](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device#Choose-a-Scheme) "Fun Gen (iOS)"
and [select a simulated device](https://developer.apple.com/documentation/xcode/running-your-app-in-the-simulator-or-on-a-device#Choose-a-Scheme#Select-a-Simulated-Device) as the run destination.

You can also download and run the latest beta release version by 
following the [installation instructions](https://github.com/Fun-Gen/Fun-Gen/wiki#installation),
and tap open the app on your own iPhone or iPad running iOS/iPadOS 15.

### Test

After building the project by following the build instructions,
you can run all the tests by pressing the shortcut <kbd>command</kbd> + <kbd>u</kbd> or
through menu options **Product > Test**.

You can see [Running Tests and Viewing Results](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/05-running_tests.html) for more details,
or view the results of tests in the checks section of each open pull request against the `main` branch.

#### Add New Test for Codebase
 
There are two folders for Unit testing and UI testing. For each test case, add a new function starting with the word test, such as testExample.
For unit tests, one can directly construct instances of classes/structs and call methods inside the new test function, and use XCTAssert to assert the actual values match expected values.

For UITests, on Xcode, users can click the record button to record a series of actions and it will be turned to testing code automatically, and one can adjust the code if needed.

### User Sign In Test Account

|Email|Password|
|--|--|
|test123@gmail.com|123123|
|test@test.test|testtest|

## Use Cases & Implementation Status

- [x] Elena's Use Case: Sign up
- [ ] Angkana’s Use Case: Add/remove Options for an Activity
    - [x] Add options during activity creation
    - [ ] Remove options during activity creation
    - [ ] Add options during voting
    - [ ] Remove options during voting
- [ ] Joon’s Use Case: Randomly pick an Option for an Activity
- [ ] Apollo’s Use Case: Top voted Option becomes selected Option for an Activity
- [ ] Finnigan’s Use Case: Tie breaking for top voted Options through random selection
- [ ] Julian’s Use Case: Anonymous voting

## Academic Integrity

While the Allen School institutes an academic misconduct policy where

> If you have CSE homeworks, including from previous quarters, publicly available (e.g., in a GitHub repository), this is a violation of our academic misconduct policy and you should make them private immediately

..., this is a public repository on GitHub per the [assignment spec](https://homes.cs.washington.edu/~rjust/courses/CSE403/project/03_github.html) and the [project description](https://homes.cs.washington.edu/~rjust/courses/CSE403/project/project.html):

> Create a ***public*** repository for your project on GitHub, make all team members contributors, and add a link to this repository to your living document.

> We require that you use a ***public*** GitHub repository for version control, issue tracking, and continuous integration.
