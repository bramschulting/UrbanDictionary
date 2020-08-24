import UIKit
import RxSwift

protocol DefinitionsViewModel {

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

    var title: String { term }

    let definitions: BehaviorSubject<[Definition]>

    func viewDidLoad() {
        fetchDefinitions()
    }

    // MARK: - Private Methods

    private func fetchDefinitions() {
        definitionsService
            .define(term: term)
            .bind(to: definitions)
            .disposed(by: disposeBag)
    }
    
}
