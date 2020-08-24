import UIKit

class DefinitionsBuilder: Builder {

    // MARK: - Private Types

    let dependencies: Dependencies

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Protocol Builder

    func build() -> Coordinator {
        let definitionsService: DefinitionsService = DefinitionsServiceImpl(urlSession: .shared)
        let viewModel: DefinitionsViewModel = DefinitionsViewModelImpl(term: dependencies.term,
                                                                       definitionsService: definitionsService)
        let viewController: DefinitionsViewController = DefinitionsViewController(viewModel: viewModel)
        let coordinator: DefinitionsCoordinator = DefinitionsCoordinatorImpl(viewController: viewController)

        return coordinator
    }

}

extension DefinitionsBuilder {

    struct Dependencies {

        let term: String

    }

}
