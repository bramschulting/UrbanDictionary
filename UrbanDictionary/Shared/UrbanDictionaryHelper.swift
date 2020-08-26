import Foundation

struct UrbanDictionaryHelper {

    // MARK: - Private Properties

    private static let apiBaseDomain: String = {
        let apiBaseDomain = UserDefaults.standard.string(forKey: "API_BASE_URL") ?? "https://api.urbandictionary.com"

        return apiBaseDomain
    }()

    // MARK: - Internal Methods

    /// Constructs a URL for autocomplete requests. The passed term should not be encoded, because this method will encode it before adding it as a param
    static func autocompleteURL(term: String) -> URL? {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: "\(Self.apiBaseDomain)/v0/autocomplete-extra?term=\(encodedTerm)") else {
                return nil
        }

        return url
    }

    /// Constructs a URL for definition requests. The passed term should not be encoded, because this method will encode it before adding it as a param
    static func definitionsURL(term: String) -> URL? {
        guard let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }

        return URL(string: "\(Self.apiBaseDomain)/v0/define?term=\(encodedTerm)")
    }

}
