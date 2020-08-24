import UIKit

protocol SearchCoordinator: Coordinator {

    var navigationController: UINavigationController? { get set }

    func showDefinitions(term: String)

}

class SearchCoordinatorImpl: SearchCoordinator {

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Protocol SearchCoordinator

    var viewController: UIViewController

    weak var navigationController: UINavigationController?

    func showDefinitions(term: String) {
        let dependencies = DefinitionsBuilder.Dependencies(term: term)
        let builder = DefinitionsBuilder(dependencies: dependencies)
        let coordinator = builder.build()
        let viewController = coordinator.viewController

        navigationController?.pushViewController(viewController, animated: UIView.areAnimationsEnabled)
    }

}
