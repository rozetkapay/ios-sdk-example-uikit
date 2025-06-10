//
//  CardCell.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import UIKit

final class CardCell: UITableViewCell, ReusableCell {

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

    private lazy var cardTypeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var maskedNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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

    // MARK: - UI Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(cardTypeImageView)
        containerView.addSubview(cardNameLabel)
        containerView.addSubview(maskedNumberLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            cardTypeImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            cardTypeImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cardTypeImageView.widthAnchor.constraint(equalToConstant: 30),
            cardTypeImageView.heightAnchor.constraint(equalToConstant: 20),

            cardNameLabel.leadingAnchor.constraint(equalTo: cardTypeImageView.trailingAnchor, constant: 16),
            cardNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            cardNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            maskedNumberLabel.leadingAnchor.constraint(equalTo: cardNameLabel.leadingAnchor),
            maskedNumberLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 4),
            maskedNumberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            maskedNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Public
    func configure(with card: CardToken) {
        cardTypeImageView.image = UIImage(named: card.paymentSystem.logoName)
        cardNameLabel.text = card.name
        maskedNumberLabel.text = card.maskedNumber
    }
}
