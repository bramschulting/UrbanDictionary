import UIKit

protocol DefinitionsCoordinator: Coordinator {

}

class DefinitionsCoordinatorImpl: DefinitionsCoordinator {

    // MARK: - Init

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Protocol DefinitionsCoordinator

    var viewController: UIViewController

}
