import UIKit

class SearchBuilder: Builder {

    func build() -> Coordinator {
        let autocompleteService: AutocompleteService = AutocompleteServiceImpl(urlSession: .shared)
        let viewModel: SearchViewModel = SearchViewModelImpl(autocompleteService: autocompleteService)
        let viewController: SearchViewController = SearchViewController(viewModel: viewModel)
        let coordinator: SearchCoordinator = SearchCoordinatorImpl(viewController: viewController)
        viewModel.coordinator = coordinator

        return coordinator
    }

}
