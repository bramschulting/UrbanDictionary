import UIKit
import RxSwift

class SearchViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating {

    // MARK: - Private Types

    private enum Constant {
        static let title = "Search"
        static let cellIdentifier = "SearchResultCell"
    }

    // MARK: - Private Properties

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController()

    // MARK: - Init

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        title = Constant.title

        configureBindings()
        configureSubviews()
        configureLayout()
        configureSearchController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override UIViewController

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }

    // MARK: - UISearchController

    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Urban Dictionary"

        navigationItem.searchController = searchController

        definesPresentationContext = true
    }

    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.cellIdentifier)

        return tableView
    }()

    private func configureSubviews() {
        view.addSubview(tableView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate(tableView.layoutConstraints(toFill: view))
    }

    // MARK: - Protocol UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectResultAt(indexPath: indexPath, of: tableView)
    }

    // MARK: - Protocol UISearchResultsUpdating

    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else {
            return
        }

        viewModel.search(query: query)
    }

    // MARK: - Bindings

    private func configureBindings() {
        viewModel.results.bind(to: tableView.rx.items(cellIdentifier: Constant.cellIdentifier)) { row, result, cell in
            cell.textLabel?.text = result
        }.disposed(by: disposeBag)
    }

}
