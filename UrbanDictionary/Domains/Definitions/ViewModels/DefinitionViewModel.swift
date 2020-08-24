import Foundation

protocol DefinitionViewModel {

    var word: String { get }

    var definition: NSAttributedString { get }

    var example: NSAttributedString { get }

}

class DefinitionViewModelImpl: DefinitionViewModel {

    // MARK: - Private Properties

    private let model: Definition

    // MARK: - Init

    init(definition: Definition) {
        model = definition
    }

    // MARK: - Protocol DefinitionViewModel

    var word: String { model.word }

    // TODO: Strip brackets and add links
    var definition: NSAttributedString { NSAttributedString(string: model.definition) }

    // TODO: Strip brackets and add links
    var example: NSAttributedString { NSAttributedString(string: model.example) }

}
