//
//  CleanseGithubBrowserUITests.swift
//  CleanseGithubBrowserUITests
//
//  Created by Mike Lewis on 6/10/16.
//  Copyright © 2016 Square, Inc. All rights reserved.
//

import XCTest

/// Example for UI testing an app.
/// In an actual app, there should probably be many more and the test organized by screen
class CleanseGithubBrowserUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()


        app = XCUIApplication()

        // We want our app to enable fake mode when we launch
        app.launchEnvironment["USE_FAKES"] = "YES"

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
    }

    func testRepositories() {
        XCTAssertTrue(app.tabBars.buttons["Repositories"].hittable)

        XCTAssertTrue(app.tables.cells.staticTexts["okhttp"].hittable)
        XCTAssertTrue(app.tables.cells.staticTexts["cleanse"].hittable)
    }

    func testMembers() {
        app.tabBars.buttons["Members"].tap()

        XCTAssertTrue(app.tables.cells.staticTexts["abrons"].hittable)
        XCTAssertTrue(app.tables.cells.staticTexts["mikelikespie"].hittable)
    }


    func testSettings() {
        app.tabBars.buttons["Settings"].tap()

        XCTAssertTrue(app.tables.cells.staticTexts["Repositories"].hittable)
        XCTAssertTrue(app.tables.cells.staticTexts["Members"].hittable)
        XCTAssertTrue(app.tables.cells.staticTexts["Fake Mode"].hittable)
    }


    func testSettings_repositories() {
        app.tabBars.buttons["Settings"].tap()

        app.tables.cells.staticTexts["Repositories"].tap()

        XCTAssertTrue(app.tables.cells.staticTexts["Show Watcher Count"].hittable)
    }

    func testSettings_members() {
        app.tabBars.buttons["Settings"].tap()

        app.tables.cells.staticTexts["Members"].tap()

        XCTAssertTrue(app.tables.cells.staticTexts["Use Green Cell Text"].hittable)
    }
}
