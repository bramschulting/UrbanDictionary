import XCTest
import RxSwift
@testable import UrbanDictionary

class SearchViewModelTests: XCTestCase {

    // MARK: - Tests

    // MARK: Autocompletion

    func testAutocompletionCalledOnTextChange() {
        let mockAutocompleteService = MockAutocompleteService()
        let viewModel = makeViewModel(withAutocompleteService: mockAutocompleteService)

        XCTAssertNil(mockAutocompleteService.autocompleteLastCalledWithText)

        viewModel.text.onNext("T")
        XCTAssertEqual(mockAutocompleteService.autocompleteLastCalledWithText, "T")
        viewModel.text.onNext("Te")
        XCTAssertEqual(mockAutocompleteService.autocompleteLastCalledWithText, "Te")
        viewModel.text.onNext("Tes")
        XCTAssertEqual(mockAutocompleteService.autocompleteLastCalledWithText, "Tes")
        viewModel.text.onNext("Test")
        XCTAssertEqual(mockAutocompleteService.autocompleteLastCalledWithText, "Test")
    }

    func testAutocompletionUpdatesResults() {
        let firstResults = [AutocompleteResult(term: "Foo term", preview: "Foo preview")]
        let secondResults = [AutocompleteResult(term: "Bar term", preview: "Bar preview")]

        let mockAutocompleteService = MockAutocompleteService()
        mockAutocompleteService.mockResults = ["foo": firstResults, "bar": secondResults]

        let viewModel = makeViewModel(withAutocompleteService: mockAutocompleteService)

        XCTAssertEqual(getResults(of: viewModel), [])

        viewModel.text.onNext("foo")
        XCTAssertEqual(getResults(of: viewModel), firstResults)

        viewModel.text.onNext("bar")
        XCTAssertEqual(getResults(of: viewModel), secondResults)
    }

    // MARK: Selecting results

    func testSelectingResultsShowsDefinitions() {
        let results = [AutocompleteResult(term: "Foo term", preview: "Foo preview"),
                       AutocompleteResult(term: "Bar term", preview: "Bar preview")]
        let mockSearchCoordinator = MockSearchCoordinator()
        let viewModel = makeViewModel(withSearchCoordinator: mockSearchCoordinator, results: results)

        viewModel.results.onNext(results)

        XCTAssertNil(mockSearchCoordinator.lastShownTerm)

        viewModel.didSelectResultAt(indexPath: IndexPath(row: 0, section: 0), of: nil)
        XCTAssertEqual(mockSearchCoordinator.lastShownTerm, results[0].term)

        viewModel.didSelectResultAt(indexPath: IndexPath(row: 1, section: 0), of: nil)
        XCTAssertEqual(mockSearchCoordinator.lastShownTerm, results[1].term)
    }

    // MARK: - Helpers

    private func makeViewModel(
        withAutocompleteService autocompleteService: AutocompleteService
    ) -> SearchViewModelImpl {
        let viewModel = SearchViewModelImpl(autocompleteService: autocompleteService)

        return viewModel
    }

    private func makeViewModel(
        withSearchCoordinator searchCoordinator: SearchCoordinator,
        results: [AutocompleteResult] = []
    ) -> SearchViewModelImpl {
        let viewModel = SearchViewModelImpl(autocompleteService: MockAutocompleteService())
        viewModel.results.onNext(results)
        viewModel.coordinator = searchCoordinator

        return viewModel
    }

    private func getResults(of viewModel: SearchViewModel) -> [AutocompleteResult] {
        return (try? viewModel.results.value()) ?? []
    }

    // MARK: - Mocks

    class MockAutocompleteService: AutocompleteService {

        var mockResults: [String: [AutocompleteResult]] = [:]

        var autocompleteLastCalledWithText: String?

        func autocomplete(text: String) -> Observable<[AutocompleteResult]> {
            autocompleteLastCalledWithText = text
            let results = mockResults[text, default: []]

            return .of(results)
        }

    }

    class MockSearchCoordinator: SearchCoordinator {

        var viewController: UIViewController = .init()
        var navigationController: UINavigationController?

        var lastShownTerm: String?
        func showDefinitions(term: String) {
            lastShownTerm = term
        }


    }

}
