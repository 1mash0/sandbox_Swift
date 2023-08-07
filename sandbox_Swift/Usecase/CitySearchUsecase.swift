import Foundation

final class CitySearchUsecase {
    func fetch(code: String) async throws -> [GetCitySearchEntity] {
        let result = try await CitySearchRespositoryImpl().fetch(code: code)
        return result.data.map {
            .init(id: $0.id, name: $0.name)
        }
    }
}
