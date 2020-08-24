import RxSwift
import RxCocoa
import UIKit

protocol SearchViewModel: AnyObject {

    var coordinator: SearchCoordinator? { get set }

    /// Current query. Setting the value of this stream will fetch and update the results.
    var query: BehaviorSubject<String?> { get }

    /// Current results
    var results: BehaviorSubject<[SearchResult]> { get }

    /// To be called when the user selects one of the search results
    func didSelectResultAt(indexPath: IndexPath, of: UITableView)

}

class SearchViewModelImpl: SearchViewModel {

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let searchService: SearchService

    // MARK: - Init

    init(searchService: SearchService) {
        self.searchService = searchService

        query = .init(value: nil)
        results = .init(value: [])

        configureBindings()
    }

    // MARK: - Bindings

    private func configureBindings() {
        query
            .flatMap(createSearchObservable(query:))
            .bind(to: results)
            .disposed(by: disposeBag)
    }

    // MARK: - Protocol SearchViewModel

    weak var coordinator: SearchCoordinator?

    let results: BehaviorSubject<[SearchResult]>

    let query: BehaviorSubject<String?>

    func didSelectResultAt(indexPath: IndexPath, of tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
    }

    // MARK: - Private Methods

    /// Creates observable search results with error handling
    private func createSearchObservable(query: String?) -> Observable<[SearchResult]> {
        // In case of an empty query, just return an empty list
        guard let query = query, !query.isEmpty else {
            return .of([])
        }

        return searchService
            .search(query: query)
            .catchError({ error -> Observable<[SearchResult]> in
                print(error)

                return .just([])
            })
    }

}
