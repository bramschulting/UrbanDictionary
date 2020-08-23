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

    // MARK: - Init

    init() {
        results = BehaviorSubject<[String]>(value: [])
    }

    // MARK: - Protocol SearchViewModel

    weak var coordinator: SearchCoordinator?

    let results: BehaviorSubject<[String]>

    func search(query: String) {
        let currentResults = (try? results.value()) ?? []

        results.onNext(currentResults + [query])
    }

    func didSelectResultAt(indexPath: IndexPath, of tableView: UITableView) {
        tableView.deselectRow(at: indexPath, animated: UIView.areAnimationsEnabled)
    }

}
