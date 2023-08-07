import SnapKit
import UIKit

final class Sandbox_DiffableDataSource_HeaderCell: UICollectionViewCell {
    private let headerTitleLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(headerTitleLabel)

        headerTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with headerTitle: String) {
        headerTitleLabel.text = headerTitle
    }
}
