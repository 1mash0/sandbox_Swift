import Combine
import Foundation

final class CitySearchRespositoryImpl {
    private let client = APIClient()

    func fetch(code: String) async throws -> GetCitySearchRequest.Response {
        let request = GetCitySearchRequest(
            parameters: .init(area: code)
        )
        return try await client.send(request: request)
    }
}
