import UIKit
import RxSwift

protocol DefinitionsViewModel: DefinableTermSelectionDelegate {

    var coordinator: DefinitionsCoordinator? { get set }

    var title: String { get }

    var definitions: BehaviorSubject<[Definition]> { get }

    /// To be called when the view did load
    func viewDidLoad()

}

class DefinitionsViewModelImpl: DefinitionsViewModel {

    // MARK: - Private Properties

    private let term: String
    private let disposeBag = DisposeBag()
    private let definitionsService: DefinitionsService

    // MARK: - Init

    init(term: String, definitionsService: DefinitionsService) {
        self.term = term
        self.definitionsService = definitionsService

        definitions = .init(value: [])
    }

    // MARK: - Protocol DefinitionsViewModel

    var coordinator: DefinitionsCoordinator?

    var title: String { term }

    let definitions: BehaviorSubject<[Definition]>

    func viewDidLoad() {
        fetchDefinitions()
    }

    func didSelect(term: String) {
        coordinator?.showDefinitions(term: term)
    }

    // MARK: - Private Methods

    private func fetchDefinitions() {
        definitionsService
            .define(term: term)
            .bind(to: definitions)
            .disposed(by: disposeBag)
    }
    
}
