//
//  UrbanDictionaryUITests.swift
//  UrbanDictionaryUITests
//
//  Created by Bram Schulting on 25/08/2020.
//  Copyright © 2020 Bram Schulting. All rights reserved.
//

import XCTest

class UrbanDictionaryUITests: XCTestCase {

    // MARK: - Private Properties

    private let app = XCUIApplication()
    private let server = EchoServer()

    // MARK: - Setup and tear down

    override func setUpWithError() throws {
        continueAfterFailure = false

        try server.start()

        app.launchArguments = ["-API_BASE_URL", "http://localhost:8080"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        server.stop()
    }

    // MARK: - Tests

    func testShowingAutocompletionResults() throws {
        app.typeText("Test")

        let tablesQuery = app.tables
        let resultRowTitle = tablesQuery.staticTexts["Test 0"]
        let resultRowPreview = tablesQuery.staticTexts["Test preview 0"]

        assertWillEventuallyExist(resultRowTitle)
        assertWillEventuallyExist(resultRowPreview)
    }

    func testOpeningDefinitions() throws {
        openFirstDefinition(forTerm: "Test")

        let definitionNavigationBar = app.navigationBars["Test 0"]
        let definitionRowTitle = app.tables.staticTexts["Test 0 0"]
        let definitionRowDefinition = app.tables.staticTexts["Definition 0 of Test 0. With sub term."]
        let definitionRowExample = app.tables.staticTexts["Example 0 of Test 0. With sub term."]

        assertWillEventuallyExist(definitionNavigationBar)
        assertWillEventuallyExist(definitionRowTitle)
        assertWillEventuallyExist(definitionRowDefinition)
        assertWillEventuallyExist(definitionRowExample)
    }

    func testOpeningSubDefinitionsFromDefinition() throws {
        openFirstDefinition(forTerm: "Test")

        let definitionTextField = app.tables.staticTexts["Definition 0 of Test 0. With sub term."]
        tapLink(withText: "sub term", in: definitionTextField)

        let subDefinitionNavigationBar = app.navigationBars["sub term"]
        let subDefinitionRowTitle = app.tables.staticTexts["sub term 0"]
        let subDefinitionRowDefinition = app.tables.staticTexts["Definition 0 of sub term. With sub term."]
        let subDefinitionRowExample = app.tables.staticTexts["Example 0 of sub term. With sub term."]

        assertWillEventuallyExist(subDefinitionNavigationBar)
        assertWillEventuallyExist(subDefinitionRowTitle)
        assertWillEventuallyExist(subDefinitionRowDefinition)
        assertWillEventuallyExist(subDefinitionRowExample)
    }

    func testOpeningSubDefinitionsFromExample() throws {
        openFirstDefinition(forTerm: "Test")

        let exampleTextField = app.tables.staticTexts["Example 0 of Test 0. With sub term."]
        tapLink(withText: "sub term", in: exampleTextField)

        let subDefinitionNavigationBar = app.navigationBars["sub term"]
        let subDefinitionRowTitle = app.tables.staticTexts["sub term 0"]
        let subDefinitionRowDefinition = app.tables.staticTexts["Definition 0 of sub term. With sub term."]
        let subDefinitionRowExample = app.tables.staticTexts["Example 0 of sub term. With sub term."]

        assertWillEventuallyExist(subDefinitionNavigationBar)
        assertWillEventuallyExist(subDefinitionRowTitle)
        assertWillEventuallyExist(subDefinitionRowDefinition)
        assertWillEventuallyExist(subDefinitionRowExample)
    }

    // MARK: - Helpers

    private func assertWillEventuallyExist(_ element: XCUIElement, file: StaticString = #file, line: UInt = #line) {
        guard element.waitForExistence(timeout: 5) else {
            XCTFail("Expected element \(element) to exist, but it can no be found.", file: file, line: line)
            return
        }
    }

    private func openFirstDefinition(forTerm term: String) {
        app.typeText(term)

        let tablesQuery = app.tables
        tablesQuery.staticTexts["\(term) 0"].tap()
    }

    private func tapLink(withText text: String, in element: XCUIElement) {
        element.links[text].tap()
    }

}
