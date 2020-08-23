import UIKit
import RxSwift

class SearchViewController: UIViewController, UITableViewDelegate {

    // MARK: - Private Types

    private enum Constant {
        static let title = "Search"
        static let cellIdentifier = "SearchResultCell"
    }

    // MARK: - Private Properties

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Init

    init(viewModel: SearchViewModel) {
        viewModel.search(query: "init")

        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        title = Constant.title

        configureBindings()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        viewModel.search(query: "configureSubviews")

        view.addSubview(tableView)
    }

    private func configureLayout() {
        viewModel.search(query: "configureLayout")

        NSLayoutConstraint.activate(tableView.layoutConstraints(toFill: view))
    }

    // MARK: - Protocol UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectResultAt(indexPath: indexPath, of: tableView)
    }

    // MARK: - Bindings

    private func configureBindings() {
        viewModel.search(query: "configureBindings")

        viewModel.results.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)

        viewModel.results.bind(to: tableView.rx.items(cellIdentifier: Constant.cellIdentifier)) { row, result, cell in
            cell.textLabel?.text = result
        }.disposed(by: disposeBag)
    }

}
