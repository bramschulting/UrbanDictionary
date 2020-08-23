import UIKit

protocol SearchCoordinator: Coordinator {

    var navigationController: UINavigationController? { get set }

}

class SearchCoordinatorImpl: SearchCoordinator {

    var viewController: UIViewController

    weak var navigationController: UINavigationController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

}
