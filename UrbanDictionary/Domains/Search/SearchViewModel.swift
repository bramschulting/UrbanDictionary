import RxSwift
import RxCocoa
import UIKit

protocol SearchViewModel: AnyObject {

    var coordinator: SearchCoordinator? { get set }

    /// Current text. Setting the value of this stream will fetch and update the autocompletion results.
    var text: BehaviorSubject<String?> { get }

    /// Current results
    var results: BehaviorSubject<[AutocompleteResult]> { get }

    /// To be called when the user selects one of the search results
    func didSelectResultAt(indexPath: IndexPath, of tableView: UITableView)

}

class SearchViewModelImpl: SearchViewModel {

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let autocompleteService: AutocompleteService

    // MARK: - Init

    init(autocompleteService: AutocompleteService) {
        self.autocompleteService = autocompleteService

        text = .init(value: nil)
        results = .init(value: [])

        configureBindings()
    }

    // MARK: - Bindings

    private func configureBindings() {
        text
            .flatMap(createAutocompleteObservable(text:))
            .bind(to: results)
            .disposed(by: disposeBag)
    }

    // MARK: - Protocol SearchViewModel

    weak var coordinator: SearchCoordinator?

    let results: BehaviorSubject<[AutocompleteResult]>

    let text: BehaviorSubject<String?>

    func didSelectResultAt(indexPath: IndexPath, of tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)

        let results = (try? self.results.value()) ?? []
        guard let result = results[safe: indexPath.row] else {
            return
        }

        coordinator?.showDefinitions(term: result.term)
    }

    // MARK: - Private Methods

    /// Creates observable autocompletion results with error handling
    private func createAutocompleteObservable(text: String?) -> Observable<[AutocompleteResult]> {
        // In case of a empty text, just return an empty list
        guard let text = text, !text.isEmpty else {
            return .of([])
        }

        return autocompleteService
            .autocomplete(text: text)
            .catchError({ error -> Observable<[AutocompleteResult]> in
                print(error)

                return .just([])
            })
    }

}
