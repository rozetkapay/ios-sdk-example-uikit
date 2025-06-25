//
//  CartSectionHeaderView.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//


import UIKit

final class CartSectionHeaderView: UIView {

    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel, sumLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .firstBaseline
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = UIColor.systemGroupedBackground
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.4).cgColor

        addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }

    // MARK: - Configure

    func configure(with order: Order, section: Int) {
        titleLabel.text = "\(Localization.batch_cart_group_order_title.description) \(section + 1)"
        let currency = order.products.first?.currency ?? Config.defaultCurrencyCode
        let formattedSum = order.totalAmount.currencyString(currencyCode: currency)
        sumLabel.text = "\(Localization.batch_cart_group_order_total_title.description): \(formattedSum)"
    }
}
