import UIKit

protocol DefinitionsCoordinator: Coordinator {

    func showDefinitions(term: String)

}

class DefinitionsCoordinatorImpl: DefinitionsCoordinator {

    // MARK: - Private Properties

    private var navigationController: UINavigationController? {
        viewController.navigationController
    }

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Protocol DefinitionsCoordinator

    var viewController: UIViewController

    func showDefinitions(term: String) {
        let dependencies = DefinitionsBuilder.Dependencies(term: term)
        let builder = DefinitionsBuilder(dependencies: dependencies)
        let coordinator = builder.build()
        let viewController = coordinator.viewController

        navigationController?.pushViewController(viewController, animated: UIView.areAnimationsEnabled)
    }

}
