import UIKit
import RxSwift

class SearchViewController: UIViewController {

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
        searchController.searchBar.placeholder = "Search Urban Dictionary"

        navigationItem.searchController = searchController

        definesPresentationContext = true
    }

    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self

        return tableView
    }()

    private func configureSubviews() {
        view.addSubview(tableView)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate(tableView.layoutConstraints(toFill: view))
    }

    // MARK: - Bindings

    private func configureBindings() {
        viewModel.results.bind(to: tableView.rx.items) { tableView, row, result in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constant.cellIdentifier)
            cell.textLabel?.text = result.term
            cell.detailTextLabel?.text = result.preview

            return cell
        }.disposed(by: disposeBag)

        searchController.searchBar.rx.text.bind(to: viewModel.text).disposed(by: disposeBag)
    }

}

// MARK: - Protocol UITableViewDelegate

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectResultAt(indexPath: indexPath, of: tableView)
    }

}
