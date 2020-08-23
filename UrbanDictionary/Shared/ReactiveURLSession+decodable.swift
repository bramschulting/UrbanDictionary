import UIKit
import RxSwift

extension Reactive where Base: URLSession {

    /// Send a request to the provided URL and decode the response
    func decodable<Type: Decodable>(_ type: Type.Type,
                                    url: URL,
                                    decoder: JSONDecoder = JSONDecoder()) -> Observable<Type> {
        let request = URLRequest(url: url)

        return data(request: request).map { try decoder.decode(Type.self, from: $0) }
    }
}
