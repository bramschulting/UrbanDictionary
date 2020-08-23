import RxSwift
import RxCocoa
import UIKit

protocol SearchViewModel: AnyObject {

    var coordinator: SearchCoordinator? { get set }

    /// Current results
    var results: BehaviorSubject<[String]> { get }

    /// Perform a new search request with the provided query
    func search(query: String)

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

        results = BehaviorSubject<[String]>(value: [])
    }

    // MARK: - Protocol SearchViewModel

    weak var coordinator: SearchCoordinator?

    let results: BehaviorSubject<[String]>

    func search(query: String) {
        guard !query.isEmpty else {
            results.onNext([])
            return
        }

        searchService.search(query: query)
            .catchError({ error -> Observable<[SearchResult]> in
                print(error)

                return .from([])
            })
            .map { $0.map(\.definition) }
            .subscribe({ [weak self] event in
                guard case Event.next(let results) = event else {
                    return
                }

                self?.results.onNext(results)
            })
            .disposed(by: disposeBag)
    }

    func didSelectResultAt(indexPath: IndexPath, of tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
    }

}
