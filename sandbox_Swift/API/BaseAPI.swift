import Foundation

public enum HTTPMethod: String {
    case delete = "DELETE"
    case `get` = "GET"
    case patch = "PATCH"
    case post = "POST"
}

extension Encodable {
    var dictionary: [String: CustomStringConvertible?] {
        (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: CustomStringConvertible?] ?? [:]
    }
}

public protocol APIBaseRequest {
    associatedtype Response: Decodable
    associatedtype Parameters: Encodable

    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem] { get }

    func buildURLRequest() -> URLRequest
}

public extension APIBaseRequest {
    var body: Data? {
        try? JSONEncoder().encode(parameters)
    }

    var queryItems: [URLQueryItem] {
        parameters.dictionary.map { key, value in
                .init(name: key, value: value?.description ?? "")
        }
    }

    func buildURLRequest() -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var component = URLComponents(url: url, resolvingAgainstBaseURL: true)

        switch method {
            case .get:
                component?.queryItems = queryItems
            default:
                fatalError()
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = component?.url
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
}
