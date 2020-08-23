import UIKit

class SearchBuilder: Builder {

    func build() -> Coordinator {
        let searchService: SearchService = SearchServiceImpl(urlSession: .shared)
        let viewModel: SearchViewModel = SearchViewModelImpl(searchService: searchService)
        let viewController: SearchViewController = SearchViewController(viewModel: viewModel)
        let coordinator: SearchCoordinator = SearchCoordinatorImpl(viewController: viewController)
        viewModel.coordinator = coordinator

        return coordinator
    }

}
