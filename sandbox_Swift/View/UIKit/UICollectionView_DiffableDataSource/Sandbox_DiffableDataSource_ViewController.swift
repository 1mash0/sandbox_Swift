import Combine
import MapKit
import SnapKit
import UIKit

final class Sandbox_DiffableDataSource_ViewController: UIViewController {
    private let viewModel: Sandbox_DiffableDataSource_ViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()

        CLGeocoder().geocodeAddressString("日本") {
            [weak self] placemark, error in
            guard let self else { return }

            guard let location = placemark?.first?.location?.coordinate else { return }

            guard let radius = (placemark?.first?.region as? CLCircularRegion)?.radius else { return }

            let region: MKCoordinateRegion = .init(
                center: location,
                latitudinalMeters: radius,
                longitudinalMeters: radius
            )

            mapView.setRegion(region, animated: false)
        }

        return mapView
    }()

    private lazy var collectionView: UICollectionView = {
        .init(frame: .zero, collectionViewLayout: compositionalLayout)
    }()

    private var layout: Sandbox_DiffableDataSource_CompositionalLayout {
        .init(dataSource: dataSource)
    }

    private lazy var compositionalLayout: UICollectionViewCompositionalLayout = {
        let sectionProvider = {(
            section: Int,
            environment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            return self.layout.createCategorySectionLayout(
                width: environment.container.contentSize.width
            )
        }

        return .init(sectionProvider: sectionProvider)
    }()

    private lazy var dataSource: DataSource = {
        let dataSource: DataSource = .init(
            collectionView: collectionView,
            cellProvider: cellProvider
        )

        dataSource.supplementaryViewProvider = self.supplementaryViewProvider

        return dataSource
    }()

    private lazy var cellProvider: DataSource.CellProvider = {
        [weak self] collectionView, indexPath, item in

        guard let self else { return .init() }

        switch item {
            case let .region(data):
                let dequeueCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CellIdentifier.cell.identifier,
                    for: indexPath
                )
                guard
                    let cell = dequeueCell as? Cell
                else {
                    return dequeueCell
                }

                cell.configureCell(with: data.region.text)

                if data.isSelected {
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                } else {
                    collectionView.deselectItem(at: indexPath, animated: true)
                }

                return cell
            case let .prefecture(data):
                let dequeueCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CellIdentifier.cell.identifier,
                    for: indexPath
                )
                guard
                    let cell = dequeueCell as? Cell
                else {
                    return dequeueCell
                }

                cell.configureCell(with: data.prefecture.text)

                if data.isSelected {
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                } else {
                    collectionView.deselectItem(at: indexPath, animated: true)
                }

                return cell
            case let .municipality(data):
                let dequeueCell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CellIdentifier.cell.identifier,
                    for: indexPath
                )
                guard
                    let cell = dequeueCell as? Cell
                else {
                    return dequeueCell
                }

                cell.configureCell(with: data.municipality)

                if data.isSelected {
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                } else {
                    collectionView.deselectItem(at: indexPath, animated: true)
                }

                return cell
        }
    }

    private lazy var supplementaryViewProvider: DataSource.SupplementaryViewProvider = {
        [weak self] collectionView, kind, indexPath in

        guard let self else { return .init() }

        switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard
                    let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: CellIdentifier.header.identifier,
                        for: indexPath
                    ) as? Header
                else {
                    return .init()
                }

                headerView.configure(with: Section.allCases[indexPath.section].title)

                return headerView
            default:
                return .init()
        }
    }

    private lazy var hideButton: UIButton = {
        let button: UIButton = .init()
        button.setBackgroundImage(.init(systemName: "eye.fill"), for: .normal)
        button.setBackgroundImage(.init(systemName: "eye.slash.fill"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addAction(.init { [weak self] _ in
            guard let self else { return }
            button.isSelected.toggle()

            collectionView.isHidden = button.isSelected
        }, for: .touchUpInside)
        return button
    }()

    init(viewModel: Sandbox_DiffableDataSource_ViewModel = .init()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Sandbox_DiffableDataSource_ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupDataSource()
        bind()
    }
}

private extension Sandbox_DiffableDataSource_ViewController {
    func setupView() {
        view.addSubview(mapView)
        view.addSubview(collectionView)
        view.addSubview(hideButton)

        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalToSuperview()
        }

        hideButton.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(26)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalToSuperview().offset(-10)
        }

        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.backgroundColor = .systemGroupedBackground.withAlphaComponent(0.7)
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        CellIdentifier.allCases.forEach { cell in
            collectionView.register(
                cell.cellType,
                forCellWithReuseIdentifier: cell.identifier
            )
        }

        collectionView.register(
            CellIdentifier.header.cellType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CellIdentifier.header.identifier
        )
    }

    func setupDataSource() {
        var snapshot = Snapshot()
        snapshot.appendSections([.regions])
        snapshot.appendItems([], toSection: .regions)

        dataSource.apply(snapshot)
    }

    func bind() {
        viewModel.$regionsData.receive(on: DispatchQueue.main)
            .sink { [weak self] regions in
                guard let dataSource = self?.dataSource else { return }

                var snapshot = Snapshot()

                guard !regions.isEmpty else {
                    dataSource.apply(snapshot, animatingDifferences: false)
                    return
                }

                snapshot.appendSections([.regions])
                let items: [Item] = regions.map {
                    .region($0)
                }
                snapshot.appendItems(items, toSection: .regions)

                dataSource.apply(snapshot, animatingDifferences: false) {
                    if regions.filter({ $0.isSelected }).isEmpty {
                        self?.geoCoding("日本")
                    }
                }
            }
            .store(in: &cancellables)

        viewModel.$prefecturesData.receive(on: DispatchQueue.main)
            .sink { [weak self] prefectures in
                guard let dataSource = self?.dataSource else { return }

                var snapshot = Snapshot()
                snapshot.appendSections([.regions])
                snapshot.appendItems(
                    dataSource.snapshot().itemIdentifiers(inSection: .regions),
                    toSection: .regions
                )

                guard !prefectures.isEmpty else {
                    dataSource.apply(snapshot, animatingDifferences: false)
                    return
                }

                snapshot.appendSections([.prefectures])
                let items: [Item] = prefectures.map {
                    .prefecture($0)
                }
                snapshot.appendItems(items, toSection: .prefectures)

                dataSource.apply(snapshot, animatingDifferences: false) {
                    guard
                        let prefecture = prefectures.first(where: {$0.isSelected})?.prefecture
                    else {
                        self?.geoCoding("日本")

                        return
                    }
                    self?.geoCoding(prefecture.text)
                }
            }
            .store(in: &cancellables)

        viewModel.$municipalityData.receive(on: DispatchQueue.main)
            .sink { [weak self] municipalities in
                guard let dataSource = self?.dataSource else { return }

                var snapshot = Snapshot()
                snapshot.appendSections([.regions])
                snapshot.appendItems(
                    dataSource.snapshot().itemIdentifiers(inSection: .regions),
                    toSection: .regions
                )

                guard !municipalities.isEmpty else {
                    dataSource.apply(snapshot, animatingDifferences: false)
                    return
                }

                snapshot.appendSections([.prefectures])
                snapshot.appendItems(
                    dataSource.snapshot().itemIdentifiers(inSection: .prefectures),
                    toSection: .prefectures
                )

                snapshot.appendSections([.municipalities])
                let items: [Item] = municipalities.map {
                    .municipality($0)
                }
                snapshot.appendItems(items, toSection: .municipalities)

                dataSource.apply(snapshot, animatingDifferences: false) {
                    let prefecturesItems = dataSource.snapshot().itemIdentifiers(inSection: .prefectures)

                    let prefecture: String = prefecturesItems.compactMap {
                        switch $0 {
                            case let .prefecture(data):
                                return data
                            default:
                                return nil
                        }
                    }.first(where: { $0.isSelected })?.prefecture.text ?? ""

                    guard
                        let municipality = municipalities.first(where: {$0.isSelected})?.municipality
                    else {
                        self?.geoCoding(prefecture)

                        return
                    }

                    self?.geoCoding(prefecture + municipality)
                }
            }
            .store(in: &cancellables)
    }

    func geoCoding(_ address: String) {
        CLGeocoder().geocodeAddressString(address.isEmpty ? "日本" : address) {
            [weak self] placemark, error in
            guard let self else { return }

            if let error = error {
                print(error)
                return
            }

            guard
                let location = placemark?.first?.location?.coordinate,
                let radius = (placemark?.first?.region as? CLCircularRegion)?.radius
            else {
                return
            }

            let region: MKCoordinateRegion = .init(
                center: location,
                latitudinalMeters: radius,
                longitudinalMeters: radius
            )

            self.mapView.setRegion(region, animated: true)
        }
    }
}

extension Sandbox_DiffableDataSource_ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.indexPath.send(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.indexPath.send(indexPath)
    }
}

extension Sandbox_DiffableDataSource_ViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias Header = Sandbox_DiffableDataSource_HeaderCell
    typealias Cell = Sandbox_DiffableDataSource_Cell
    typealias Section = Sandbox_DiffableDataSource_ViewModel.Section
    typealias Item = Sandbox_DiffableDataSource_ViewModel.Item

    enum CellIdentifier: CaseIterable {
        case header
        case cell

        var cellType: UICollectionViewCell.Type {
            switch self {
                case .header:
                    return Header.self
                case .cell:
                    return Cell.self
            }
        }

        var identifier: String {
            switch self {
                case .header:
                    return String(describing: type(of: Header.self))
                case .cell:
                    return String(describing: type(of: Cell.self))
            }
        }
    }
}
