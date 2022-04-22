# Fun Gen

UW CSE 403 Spring 2022 Group Project

### What is Fun Gen?

Fun Gen is an iOS app with a user created list of activities in a friend, coworker, or family group. Users propose an activity in a user defined category (vacation, road trip, movie night, etc.) and the options can be voted on or just randomly selected if the group does not want to vote. Example activities include a family trip with family members submitting and/or voting on a destination, a couple having trouble deciding on what to watch on Netflix, or coworkers picking a restaurant for a company outing.

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

Follow the [setup guide](https://github.com/Fun-Gen/Fun-Gen/wiki/Setup) to build the project.
If you are new to SwiftUI, you can follow UWAppDev's guide on
[getting started with SwiftUI](https://uwdev.app/resources/getting-started/swiftui).

### Project Structure

- `Fun Gen.xcodeproj`: Xcode project file.
- `Shared`: The main SwiftUI codebase for Fun Gen.
    - `Model`: data structure definitions.
    - `View`: user interface.
    - `ViewModel`: bindings and operations for model, interfacing with Firebase.
- `macOS`: SwiftUI allows running code on macOS at the same time.
    Any macOS specific code or resources files will be in this directory.
- `reports`: weekly reports for communicating with our TA/project manager.
- `Configuration`: to support building the project using different Apple IDs.
- `.github`: configuration files for GitHub related settings.

## Academic Integrity

While the Allen School institutes an academic misconduct policy where

> If you have CSE homeworks, including from previous quarters, publicly available (e.g., in a GitHub repository), this is a violation of our academic misconduct policy and you should make them private immediately

..., this is a public repository on GitHub per the [assignment spec](https://homes.cs.washington.edu/~rjust/courses/CSE403/project/03_github.html) and the [project description](https://homes.cs.washington.edu/~rjust/courses/CSE403/project/project.html):

> Create a ***public*** repository for your project on GitHub, make all team members contributors, and add a link to this repository to your living document.

> We require that you use a ***public*** GitHub repository for version control, issue tracking, and continuous integration.
