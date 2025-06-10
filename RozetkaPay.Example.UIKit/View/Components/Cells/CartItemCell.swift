//
//  CartItemCell.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 01.10.2024.
//

import UIKit

import UIKit

class CartItemCell: UITableViewCell, ReusableCell {

    // MARK: - UI

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()

    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var itemQuantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGreen
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemNameLabel, itemQuantityLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()

    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [itemImageView, infoStack, itemPriceLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            horizontalStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            horizontalStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            horizontalStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            horizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
        ])
    }

    // MARK: - Configure

    func configure(with item: Product) {
        itemImageView.image = UIImage(named: item.image)
        itemNameLabel.text = item.name
        itemQuantityLabel.text = "\(item.quantity) x \(item.price)"
        itemPriceLabel.text = String(format: "%.2f", item.amount)
    }
}


