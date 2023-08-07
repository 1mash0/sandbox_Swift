import Combine
import Foundation
import MapKit

final class Sandbox_DiffableDataSource_ViewModel {
    @Published var regionsData: [RegionData] = []
    @Published var prefecturesData: [PrefectureData] = []
    @Published var municipalityData: [MunicipalityData] = []

    let indexPath = PassthroughSubject<IndexPath, Never>()

    private let usecase: CitySearchUsecase

    private var cancellables = Set<AnyCancellable>()

    init(usecase: CitySearchUsecase = .init()) {
        self.usecase = usecase
        setupData()
        bind()
    }
}

private extension Sandbox_DiffableDataSource_ViewModel {
    func setupData() {
        regionsData = Regions.allCases.map {
            .init(region: $0, isSelected: false)
        }
    }

    func bind() {
        indexPath
            .sink { [weak self] indexPath in
                guard let self else { return }

                guard let section = Section(rawValue: indexPath.section) else { return }

                switch section {
                    case .regions:
                        regionsData = regionsData.enumerated().map { index, data in
                                .init(
                                    region: data.region,
                                    isSelected: indexPath.row == index ? !data.isSelected : false
                                )
                        }

                        let selectedRegions = regionsData.filter({ $0.isSelected })

                        guard !selectedRegions.isEmpty else {
                            prefecturesData = []
                            municipalityData = []
                            return
                        }

                        prefecturesData = regionsData[indexPath.row].region.prefectures.map {
                            .init(prefecture: $0, isSelected: false)
                        }
                    case .prefectures:
                        prefecturesData = prefecturesData.enumerated().map { index, data in
                                .init(
                                    prefecture: data.prefecture,
                                    isSelected: indexPath.row == index ? !data.isSelected : false
                                )
                        }

                        guard
                            let prefecture = prefecturesData.first(where: {$0.isSelected})?.prefecture
                        else {
                            return
                        }

                        Task {
                            let municipalities = try await self.usecase.fetch(code: String(format: "%02d", prefecture.rawValue))

                            self.municipalityData = municipalities.map {
                                .init(id: $0.id, municipality: $0.name, isSelected: false)
                            }
                        }
                    case .municipalities:
                        municipalityData = municipalityData.enumerated().map { index, data in
                                .init(
                                    id: data.id,
                                    municipality: data.municipality,
                                    isSelected: indexPath.row == index ? !data.isSelected : false
                                )
                        }
                }
            }
            .store(in: &cancellables)
    }
}

extension Sandbox_DiffableDataSource_ViewModel {
    typealias Regions = Sandbox_DiffableDataSource_Model.Regions
    typealias RegionData = Sandbox_DiffableDataSource_Model.RegionData
    typealias PrefectureData = Sandbox_DiffableDataSource_Model.PrefectureData
    typealias MunicipalityData = Sandbox_DiffableDataSource_Model.MunicipalityData

    enum Section: Int, CaseIterable {
        case regions = 0
        case prefectures
        case municipalities

        var title: String {
            switch self {
                case .regions:
                    return "地方"
                case .prefectures:
                    return "都道府県"
                case .municipalities:
                    return "市区町村"
            }
        }
    }

    enum Item: Hashable {
        case region(RegionData)
        case prefecture(PrefectureData)
        case municipality(MunicipalityData)
    }
}
