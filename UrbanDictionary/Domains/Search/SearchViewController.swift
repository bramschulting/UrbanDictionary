import UIKit

class SearchViewController: UIViewController {

    // MARK: - Private Properties

    private let viewModel: SearchViewModel

    // MARK: - Init

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        title = "Search"
        view.backgroundColor = .systemYellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
