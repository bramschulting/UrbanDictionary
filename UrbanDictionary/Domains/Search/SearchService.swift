import UIKit
import RxSwift

protocol SearchService {

    func search(query: String) -> Observable<[SearchResult]>

}

enum SearchError: Error {
    case invalidArguments
}

class SearchServiceImpl: SearchService {

    // MARK: - Private Properties

    private let urlSession: URLSession

    // MARK: - Init

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - Protocol SearchService

    func search(query: String) -> Observable<[SearchResult]> {
        return Observable.create { (observer) -> Disposable in
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
                let url = URL(string: "https://api.urbandictionary.com/v0/define?term=\(encodedQuery)") else {
                    observer.onError(SearchError.invalidArguments)

                    return Disposables.create()
            }

            return Disposables.create([
                self.urlSession.rx.decodable(SearchResponse.self, url: url).map { $0.list }.subscribe(observer)
            ])
        }
    }

}

extension SearchServiceImpl {

    private struct SearchResponse: Decodable {

        let list: [SearchResult]

    }

}
