import UIKit

final class Sandbox_DiffableDataSource_CompositionalLayout {
    typealias DataSource = Sandbox_DiffableDataSource_ViewController.DataSource

    private let dataSource: DataSource

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
}

extension Sandbox_DiffableDataSource_CompositionalLayout {
    func createGenderSectionLayout(
        width: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10,
            leading: Constants.collectionViewItemInsets / 2,
            bottom: 20,
            trailing: Constants.collectionViewItemInsets / 2
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.FashionTaste.sectionHeaderHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = Constants.Gender.groupSpacing

        return section
    }

    func createGridSectionLayout(
        width: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute((width - Constants.collectionViewItemInsets - 12) / 2),
            heightDimension: .absolute(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let items = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: [item]
        )
        items.interItemSpacing = .fixed(12)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60)
            ),
            subitems: [items]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10,
            leading: Constants.collectionViewItemInsets / 2,
            bottom: 20,
            trailing: Constants.collectionViewItemInsets / 2
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.contentInsets = .init(
            top: -10,
            leading: .zero,
            bottom: -10,
            trailing: .zero
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = 10
        return section
    }

    func createCategorySectionLayout(
        width: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(44)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let items = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            ),
            subitems: [item]
        )
        items.interItemSpacing = .fixed(10)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            ),
            subitems: [items]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 10,
            leading: Constants.collectionViewItemInsets / 2,
            bottom: 20,
            trailing: Constants.collectionViewItemInsets / 2
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.contentInsets = .init(
            top: -10,
            leading: .zero,
            bottom: -10,
            trailing: .zero
        )
        section.boundarySupplementaryItems = [sectionHeader]
        section.interGroupSpacing = 10
        return section
    }

    func createSectionHeaderLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.FashionTaste.sectionHeaderHeight)
        )

        return .init(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    func createApplyButtonLayout(width: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.ApplyButton.height)
        )

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: itemSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: .zero,
            leading: Constants.collectionViewItemInsets / 2,
            bottom: Constants.ApplyButton.bottomInset,
            trailing: Constants.collectionViewItemInsets / 2
        )
        return section
    }
}

private extension Sandbox_DiffableDataSource_CompositionalLayout {
    struct Constants {
        static var collectionViewItemInsets: CGFloat = 40
        struct Gender {
            static let itemHeight: CGFloat = 49
            static let topInset: CGFloat =  8
            static let groupSpacing: CGFloat = 12
        }

        struct Category {
        }

        struct FashionTaste {
            static var itemWidth = {(width: CGFloat) -> CGFloat in
                let itemSpacings = itemSpacing * CGFloat((itemCount - 1))
                return (width - itemSpacings - collectionViewItemInsets) / CGFloat(itemCount)
            }
            static var itemHeight = {(width: CGFloat) -> CGFloat in
                itemWidth(width) * 1.56
            }
            static var itemsWidth = {(width: CGFloat) -> CGFloat in
                return width - collectionViewItemInsets
            }
            static let topInset: CGFloat = 8
            static let multipleSectionBottomInset: CGFloat = 24
            static let itemSpacing: CGFloat = 12
            static let groupSpacing: CGFloat = 24

            static let itemCount: Int = 3

            static let sectionHeaderTopInset: CGFloat = 8
            static let sectionHeaderBottomInset: CGFloat = 4
            static var sectionHeaderHeight: CGFloat {
                18 + sectionHeaderTopInset + sectionHeaderBottomInset
            }
        }

        struct ApplyButton {
            static let height: CGFloat = 52
            static let bottomInset: CGFloat = 32
        }
    }
}
