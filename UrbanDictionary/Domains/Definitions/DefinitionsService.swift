import UIKit
import RxSwift

protocol DefinitionsService {

    /// Define a term
    func define(term: String) -> Observable<[Definition]>

}

struct Definition: Decodable {

    /// The exact word of this definition
    let word: String

    /// A (couple of) sentence(s) defining the word
    let definition: String

    /// The word used in a sentence
    let example: String

}

enum DefineError: Error {
    case invalidArguments
}

class DefinitionsServiceImpl: DefinitionsService {

    // MARK: - Private Properties

    private let urlSession: URLSession

    // MARK: - Init

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - Protocol DefinitionsService

    func define(term: String) -> Observable<[Definition]> {
        return Observable.create { (observer) -> Disposable in
            guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                let url = URL(string: "https://api.urbandictionary.com/v0/define?term=\(encodedTerm)") else {
                    observer.onError(AutocompleteError.invalidArguments)

                    return Disposables.create()
            }

            return Disposables.create([
                self.urlSession.rx.decodable(DefineResponse.self, url: url).map { $0.list }.subscribe(observer)
            ])
        }
    }

}

extension DefinitionsServiceImpl {

    private struct DefineResponse: Decodable {

        let list: [Definition]

    }

}
