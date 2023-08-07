import SnapKit
import SwiftUI
import UIKit

final class MainViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary

            return .list(using: configuration, layoutEnvironment: layoutEnvironment)
        }

        return .init(frame: .zero, collectionViewLayout: layout)
    }()

    private let headerRegistration: UICollectionView.SupplementaryRegistration<UICollectionViewListCell> = {
        return .init(elementKind: UICollectionView.elementKindSectionHeader) { headerView, elementKind, indexPath in
            let headerItem = Section.allCases[indexPath.section]
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.rawValue
            configuration.textProperties.font = .boldSystemFont(ofSize: 18)
            configuration.textProperties.color = .black
            configuration.directionalLayoutMargins = .init(
                top: 20,
                leading: 0,
                bottom: 10,
                trailing: 0
            )
            headerView.contentConfiguration = configuration
        }
    }()

    private let cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Item> = {
        return .init { cell, _, item in
            var configuration = cell.defaultContentConfiguration()
            configuration.text = item.title
            configuration.textProperties.alignment = .center
            cell.contentConfiguration = configuration
        }
    }()

    private lazy var cellProvider: DataSource.CellProvider = { collectionView, indexPath, item in
        collectionView.dequeueConfiguredReusableCell(
            using: self.cellRegistration,
            for: indexPath,
            item: item
        )
    }

    private lazy var dataSource: DataSource = {
        let dataSource: DataSource = .init(
            collectionView: collectionView,
            cellProvider: cellProvider
        )
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
                case UICollectionView.elementKindSectionHeader:
                    return collectionView.dequeueConfiguredReusableSupplementary(
                        using: self.headerRegistration,
                        for: indexPath
                    )
                case UICollectionView.elementKindSectionFooter:
                    return nil
                default:
                    return nil
            }
        }

        return dataSource
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Root"

        collectionView.delegate = self

        applyInitialnalSnapshots()

        self.view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func applyInitialnalSnapshots() {
        var snapshots = Snapshot()
        snapshots.appendSections(Section.allCases)
        Section.allCases.forEach {
            snapshots.appendItems($0.items, toSection: $0)
        }

        dataSource.apply(snapshots)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        let itemIdentifier = dataSource.snapshot().itemIdentifiers(inSection: sectionIdentifier)[indexPath.row]
        collectionView.deselectItem(at: indexPath, animated: true)

        if case .Tutorial_Scrum = itemIdentifier,
           let url = URL(string: "tutorial-scrum:") {
            UIApplication.shared.open(url)
        } else {
            navigationController?.pushViewController(itemIdentifier.viewController, animated: true)
        }
    }
}

private extension MainViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    enum Section: String, CaseIterable {
        case UIKit
        case SwiftUI
        case Other

        var items: [Item] {
            switch self {
                case .UIKit:
                    return [
                        .UICollectionView_DiffableDataSource_CompositionalLayout,
                        .Hoge
                    ]
                case .SwiftUI:
                    return [
                        .SampleTODO,
                        .Tutorial_Scrum
                    ]
                case .Other:
                    return [
                        .HogeFuga
                    ]
            }
        }
    }

    enum Item: String, CaseIterable {
        case UICollectionView_DiffableDataSource_CompositionalLayout
        case Hoge
        case SampleTODO
        case Tutorial_Scrum
        case HogeFuga

        var viewController: UIViewController {
            switch self {
                case .UICollectionView_DiffableDataSource_CompositionalLayout:
                    return Sandbox_DiffableDataSource_ViewController()
                case .SampleTODO:
                    return HideNaviBarHostingController(rootView: SampleTODOView())
                default:
                    return UIViewController()
            }
        }

        var title: String {
            switch self {
                case .Tutorial_Scrum:
                    return "Open Tutorial Scrum App"
                default:
                    return self.rawValue
            }
        }
    }
}

