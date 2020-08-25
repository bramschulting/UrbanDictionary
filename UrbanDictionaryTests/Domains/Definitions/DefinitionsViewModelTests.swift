import XCTest
import RxSwift
@testable import UrbanDictionary

class DefinitionsViewModelTests: XCTestCase {

    // MARK: - Tests

    // MARK: Loading definitions

    func testLoadingOfDefinitionsWhenViewDidLoad() throws {
        let mockDefinitions = [Definition(word: "Word 1", definition: "Definition 1", example: "Example 1"),
                               Definition(word: "Word 2", definition: "Definition 2", example: "Example 2")]
        let mockDefinitionsService = MockDefinitionsService(mockResponse: .of(mockDefinitions))
        let viewModel = makeViewModel(withDefinitionsService: mockDefinitionsService)

        XCTAssertEqual(getDefinitions(of: viewModel), [])

        viewModel.viewDidLoad()

        XCTAssertEqual(getDefinitions(of: viewModel), mockDefinitions)
    }

    // MARK: Opening sub terms

    func testOpeningSubTermsViaCoordinator() {
        let mockDefinitionsCoordinator = MockDefinitionsCoordinator()
        let mockDefinitionsService = MockDefinitionsService(mockResponse: .of([]))
        let viewModel = makeViewModel(withDefinitionsService: mockDefinitionsService)
        viewModel.coordinator = mockDefinitionsCoordinator

        XCTAssertNil(mockDefinitionsCoordinator.lastShownSubTerm)

        viewModel.didSelect(term: "test")

        XCTAssertEqual(mockDefinitionsCoordinator.lastShownSubTerm, "test")
    }

    // MARK: - Helpers

    private func makeViewModel(
        withDefinitionsService definitionsService: DefinitionsService
    ) -> DefinitionsViewModelImpl {
        let viewModel = DefinitionsViewModelImpl(term: "Test", definitionsService: definitionsService)

        return viewModel
    }

    private func getDefinitions(of viewModel: DefinitionsViewModel) -> [Definition] {
        return (try? viewModel.definitions.value()) ?? []
    }

    // MARK: - Mocks

    private class MockDefinitionsService: DefinitionsService {

        init(mockResponse: Observable<[Definition]>) {
            self.mockResponse = mockResponse
        }

        let mockResponse: Observable<[Definition]>

        func define(term: String) -> Observable<[Definition]> {
            return mockResponse
        }

    }

    private class MockDefinitionsCoordinator: DefinitionsCoordinator {

        var viewController: UIViewController = .init()

        var lastShownSubTerm: String?

        func showDefinitions(term: String) {
            lastShownSubTerm = term
        }

    }

}
