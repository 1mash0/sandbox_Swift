import Foundation

public struct GetCitySearchRequest: APIBaseRequest {
    public typealias Response = GetCitySearchResponse

    public struct Parameters: Encodable {
        public let area: String
    }

    public var parameters: Parameters

    public var baseURL: URL {
        URL(string: "https://www.land.mlit.go.jp")!
    }
    public var method: HTTPMethod {
        .get
    }
    public var path: String {
        "/webland/api/CitySearch"
    }

    init(parameters: Parameters) {
        self.parameters = parameters
    }
}

public struct GetCitySearchResponse: Codable {
    let data: [CityData]

    struct CityData: Codable {
        let id: String
        let name: String
    }
}
