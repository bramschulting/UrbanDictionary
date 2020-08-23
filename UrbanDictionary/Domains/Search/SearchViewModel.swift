protocol SearchViewModel: AnyObject {

    var coordinator: SearchCoordinator? { get set }

}

class SearchViewModelImpl: SearchViewModel {

    // MARK: - Internal Properties

    weak var coordinator: SearchCoordinator?

}
