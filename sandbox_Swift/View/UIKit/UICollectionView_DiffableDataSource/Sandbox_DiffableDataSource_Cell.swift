import SnapKit
import UIKit

final class Sandbox_DiffableDataSource_Cell: UICollectionViewCell {
    private let textLabel: UILabel = {
        let label: UILabel = .init()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected
            ? UIColor.black.cgColor
            : UIColor.systemGray.cgColor

            textLabel.font = isSelected
            ? .boldSystemFont(ofSize: 16)
            : .systemFont(ofSize: 16)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 10.0
        addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with text: String) {
        textLabel.text = text
    }
}
