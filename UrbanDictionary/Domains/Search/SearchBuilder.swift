import UIKit

class SearchBuilder: Builder {

    func build() -> Coordinator {
        let viewModel: SearchViewModel = SearchViewModelImpl()
        let viewController: SearchViewController = SearchViewController(viewModel: viewModel)
        let coordinator: SearchCoordinator = SearchCoordinatorImpl(viewController: viewController)
        viewModel.coordinator = coordinator

        return coordinator
    }

}
