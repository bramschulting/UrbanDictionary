import UIKit
import Foundation

protocol DefinitionViewModel {

    /// The exact word of this definition
    var word: String { get }

    /// A (couple of) sentence(s) defining the word with optionally embedded terms that have definitions too
    var definition: NSAttributedString { get }

    /// The word used in a sentence with optionally embedded terms that have definitions too
    var example: NSAttributedString { get }

    /// To be called when a term (URL) is selected
    func didSelect(url: URL)

}

protocol DefinableTermSelectionDelegate: AnyObject {

    func didSelect(term: String)

}

class DefinitionViewModelImpl: DefinitionViewModel {

    // MARK: - Private Properties

    private let model: Definition

    weak private var definableTermSelectionDelegate: DefinableTermSelectionDelegate?

    // MARK: - Init

    init(definition: Definition, definableTermSelectionDelegate: DefinableTermSelectionDelegate?) {
        model = definition
        self.definableTermSelectionDelegate = definableTermSelectionDelegate
    }

    // MARK: - Protocol DefinitionViewModel

    var word: String { model.word }

    var definition: NSAttributedString {
        return insertLinks(string: model.definition)
    }

    var example: NSAttributedString {
        return insertLinks(string: model.example)
    }

    func didSelect(url: URL) {
        guard let term = url.absoluteString.removingPercentEncoding else {
            return
        }

        definableTermSelectionDelegate?.didSelect(term: term)
    }

    // MARK: - Private Methods

    /// Insert links for all words that are between brackets, because this means there is a definition for in the Urban Dictionary
    private func insertLinks(string: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)

        // Regex that finds the words with and without brackets (without is in the first group)
        guard let regex = try? NSRegularExpression(pattern: "\\[(.*?)\\]") else {
            return attributedString
        }

        let fullRange = NSRange(location: 0, length: attributedString.length)
        let matches = regex.matches(in: attributedString.string, options: [], range: fullRange)

        // For each match, create and insert a link
        matches.forEach { match in
            let termWithoutBracketsRange = match.range(at: 1)
            guard let matchRange = Range(termWithoutBracketsRange, in: attributedString.string) else {
                return
            }

            // Convert the term to a URL. We need to encode it, because it can contains spaces and special characters
            let termWithoutBrackets = String(attributedString.string[matchRange])
            guard let url = termWithoutBrackets.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return
            }

            attributedString.addAttribute(.link,
                                          value: url,
                                          range: termWithoutBracketsRange)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: termWithoutBracketsRange)
            attributedString.addAttribute(NSAttributedString.Key.underlineColor,
                                          value: UIColor.systemBlue,
                                          range: termWithoutBracketsRange)
        }

        // Remove the brackets
        attributedString.removeOccurrences(of: ["[", "]"])

        return attributedString
    }

}

private extension NSMutableAttributedString {

    func removeOccurrences(of string: String) {
        let fullRange = NSRange(location: 0, length: length)
        mutableString.replaceOccurrences(of: string, with: "", options: [], range: fullRange)
    }

    func removeOccurrences(of strings: [String]) {
        strings.forEach(removeOccurrences(of:))
    }

}
