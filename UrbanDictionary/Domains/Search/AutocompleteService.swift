import UIKit
import RxSwift

protocol AutocompleteService {

    func autocomplete(text: String) -> Observable<[AutocompleteResult]>

}

struct AutocompleteResult: Decodable, Equatable {

    /// Term for which the Urban Dictionary has at least one definition
    let term: String

    /// A preview of the most popular definition for the term
    let preview: String

}

enum AutocompleteError: Error {
    case invalidArguments
}

class AutocompleteServiceImpl: AutocompleteService {

    // MARK: - Private Properties

    private let urlSession: URLSession

    // MARK: - Init

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - Protocol AutocompleteService

    func autocomplete(text: String) -> Observable<[AutocompleteResult]> {
        return Observable.create { (observer) -> Disposable in
            guard let encodedTerm = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                let url = URL(string: "https://api.urbandictionary.com/v0/autocomplete-extra?term=\(encodedTerm)") else {
                    observer.onError(AutocompleteError.invalidArguments)

                    return Disposables.create()
            }

            return Disposables.create([
                self.urlSession.rx.decodable(AutocompleteResponse.self, url: url).map { $0.results }.subscribe(observer)
            ])
        }
    }

}

extension AutocompleteServiceImpl {

    private struct AutocompleteResponse: Decodable {

        let results: [AutocompleteResult]

    }

}
