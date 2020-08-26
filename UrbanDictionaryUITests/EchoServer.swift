import Foundation
import Swifter

/// The EchoServer is a wrapper around HttpServer that returns 10 results, each echoing the passed query parameter
class EchoServer {

    // MARK: - Private Properties

    let server: HttpServer

    // MARK: - Init

    init(server: HttpServer = HttpServer()) {
        self.server = server

        configureRoutes()
    }

    // MARK: - Internal Methods

    func start() throws {
        try server.start()
    }

    func stop() {
        server.stop()
    }

    // MARK: - Private Methods

    private func configureRoutes() {
        // Autocomplete 10 results
        server["/v0/autocomplete-extra"] = { request in
            guard let term = request.queryParamValue(forKey: "term") else {
                return .badRequest(nil)
            }

            let response = [
                "results": (0..<10).map { index in
                    [
                        "term": "\(term) \(index)",
                        "preview": "\(term) preview \(index)"
                    ]
                }
            ]

            return Self.jsonOrErrorResponse(dictionary: response)
        }

        // Define 10 results
        server["/v0/define"] = { request in
            guard let term = request.queryParamValue(forKey: "term") else {
                return .badRequest(nil)
            }

            let response = [
                "list": (0..<10).map { index in
                    [
                        "definition": "Definition \(index) of \(term). With [sub term].",
                        "permalink": "https://example.com/\(term)\(index)",
                        "thumbs_up": 42,
                        "sound_urls": [],
                        "author": "Author \(index) of \(term)",
                        "word": "\(term) \(index)",
                        "defid": index,
                        "current_vote": "",
                        "written_on": "1970-01-01T00:00:00.000Z",
                        "example": "Example \(index) of \(term). With [sub term].",
                        "thumbs_down": 42
                    ]
                }
            ]

            return Self.jsonOrErrorResponse(dictionary: response)
        }
    }

    private static func jsonOrErrorResponse(dictionary: [AnyHashable: Any]) -> HttpResponse {
        guard let string = String(dictionary: dictionary) else {
            return .internalServerError
        }

        return .ok(.text(string))
    }

}

private extension String {

    init?(dictionary: [AnyHashable: Any]) {
        guard let json = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
            let string = String(data: json, encoding: .ascii) else {
                return nil
        }

        self.init(string)
    }

}

private extension HttpRequest {

    func queryParamValue(forKey key: String) -> String? {
        let param = queryParams.first { $0.0 == "term" }

        return param?.1
    }

}
