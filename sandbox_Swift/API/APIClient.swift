import Foundation

enum APIClientError: Error {
    case connectionError(Data)
    case apiError
}

public struct APIClient {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return .init(configuration: config)
    }()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public init() {}

    public func send<Request: APIBaseRequest>(request: Request) async throws -> Request.Response {
        let result = try await session.data(for: request.buildURLRequest())
        try validate(data: result.0, response: result.1)
        return try decoder.decode(Request.Response.self, from: result.0)
    }

    func validate(data: Data, response: URLResponse) throws {
        guard let code = (response as? HTTPURLResponse)?.statusCode else {
            throw APIClientError.connectionError(data)
        }

        guard (200..<300).contains(code) else {
            throw APIClientError.apiError
        }
    }
}
