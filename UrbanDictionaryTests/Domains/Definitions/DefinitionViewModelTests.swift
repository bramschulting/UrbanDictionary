import XCTest
@testable import UrbanDictionary

class DefinitionViewModelTests: XCTestCase {

    // MARK: - Tests

    // MARK: Definable term detection

    func testDefinitionWithDefinableTerms() {
        let viewModel = makeViewModel(withDefinition: "This is a [test] definition. [Multiple words should] work too.")

        XCTAssertEqual(findURLs(in: viewModel.definition), [URL(string: "test"),
                                                            URL(string: "Multiple%20words%20should")])
    }

    func testDefinitionWithoutDefinableTerms() {
        let viewModel = makeViewModel(withDefinition: "This is a test definition. Multiple words should work too.")

        XCTAssertEqual(findURLs(in: viewModel.definition), [])
    }

    func testExampleWithDefinableTerms() {
        let viewModel = makeViewModel(withExample: "This is a [test] example. [Multiple words should] work too.")

        XCTAssertEqual(findURLs(in: viewModel.example), [URL(string: "test"),
                                                         URL(string: "Multiple%20words%20should")])
    }

    func testExampleWithoutDefinableTerms() {
        let viewModel = makeViewModel(withExample: "This is a test example. Multiple words should work too.")

        XCTAssertEqual(findURLs(in: viewModel.example), [])
    }

    // MARK: Term selection

    func testSelectingTermCallsTheDelegateWithSelectedTerm() throws {
        let mockDefinableTermSelectionDelegate = MockDefinableTermSelectionDelegate()
        let viewModel = makeViewModel(withDefinableTermSelectionDelegate: mockDefinableTermSelectionDelegate)
        let url = try XCTUnwrap(URL(string: "word"))

        XCTAssertNil(mockDefinableTermSelectionDelegate.lastSelectedTerm)

        viewModel.didSelect(url: url)

        XCTAssertNotNil(mockDefinableTermSelectionDelegate.lastSelectedTerm)
        XCTAssertEqual(mockDefinableTermSelectionDelegate.lastSelectedTerm, "word")
    }

    func testSelectingTermCallsTheDelegateWithDecodedSelectedTerm() throws {
        let mockDefinableTermSelectionDelegate = MockDefinableTermSelectionDelegate()
        let viewModel = makeViewModel(withDefinableTermSelectionDelegate: mockDefinableTermSelectionDelegate)
        let url = try XCTUnwrap(URL(string: "two%20words"))

        viewModel.didSelect(url: url)

        XCTAssertEqual(mockDefinableTermSelectionDelegate.lastSelectedTerm, "two words")
    }

    // MARK: - Helpers

    private func makeViewModel(withDefinition definition: String) -> DefinitionViewModelImpl {
        let definition = Definition(word: "Word", definition: definition, example: "Example")
        let viewModel = DefinitionViewModelImpl(definition: definition, definableTermSelectionDelegate: nil)

        return viewModel
    }

    private func makeViewModel(withExample example: String) -> DefinitionViewModelImpl {
        let definition = Definition(word: "Word", definition: "Definition", example: example)
        let viewModel = DefinitionViewModelImpl(definition: definition, definableTermSelectionDelegate: nil)

        return viewModel
    }

    private func makeViewModel(
        withDefinableTermSelectionDelegate definableTermSelectionDelegate: DefinableTermSelectionDelegate
    ) -> DefinitionViewModelImpl {
        let definition = Definition(word: "Word", definition: "Definition", example: "Example")
        let viewModel = DefinitionViewModelImpl(definition: definition,
                                                definableTermSelectionDelegate: definableTermSelectionDelegate)

        return viewModel
    }

    private func findURLs(in attributedString: NSAttributedString) -> [URL] {
        var allURLs: [URL] = []

        let fullRange = NSRange(location: 0, length: attributedString.length)
        attributedString.enumerateAttributes(in: fullRange, options:[]) { attributes, _, _ in
            let linkAttributes = attributes.filter { $0.key == .link }
            let stringValues = linkAttributes.compactMap { $0.value as? String }

            allURLs.append(contentsOf: stringValues.compactMap { URL(string: $0) })
        }

        return allURLs
    }

    // MARK: - Mocks

    private class MockDefinableTermSelectionDelegate: DefinableTermSelectionDelegate {

        var lastSelectedTerm: String?

        func didSelect(term: String) {
            lastSelectedTerm = term
        }

    }

}
