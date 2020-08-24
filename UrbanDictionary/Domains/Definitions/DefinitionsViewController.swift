import UIKit
import RxSwift

class DefinitionsViewController: UIViewController {

    // MARK: - Private Types

    private enum Constant {
        static let cellIdentifier = "DefinitionCell"
    }

    // MARK: - Private Properties

    private let disposeBag = DisposeBag()
    private let viewModel: DefinitionsViewModel

    // MARK: - Init

    init(viewModel: DefinitionsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        title = viewModel.title

        configureBindings()
        configureSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.viewDidLoad()
    }

    // MARK: - Subviews

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false

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
        viewModel.definitions.bind(to: tableView.rx.items) { tableView, row, definition in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: Constant.cellIdentifier)
            cell.textLabel?.text = definition.word
            cell.detailTextLabel?.text = definition.definition
            cell.detailTextLabel?.numberOfLines = 0

            return cell
        }.disposed(by: disposeBag)
    }

}
