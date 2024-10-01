//
//  CardCell.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import UIKit

class CardCell: UITableViewCell {
    
    private let cardTypeImageView = UIImageView()
    private let cardNameLabel = UILabel()
    private let maskedNumberLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        cardTypeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardTypeImageView)
        
        cardNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        cardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardNameLabel)
        
        maskedNumberLabel.font = UIFont.systemFont(ofSize: 14)
        maskedNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(maskedNumberLabel)
        
        NSLayoutConstraint.activate([
            cardTypeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardTypeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cardTypeImageView.widthAnchor.constraint(equalToConstant: 30),
            cardTypeImageView.heightAnchor.constraint(equalToConstant: 20),
            
            cardNameLabel.leadingAnchor.constraint(equalTo: cardTypeImageView.trailingAnchor, constant: 16),
            cardNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            maskedNumberLabel.leadingAnchor.constraint(equalTo: cardNameLabel.leadingAnchor),
            maskedNumberLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 4),
            maskedNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with card: CardToken) {
        cardTypeImageView.image = UIImage(named: card.paymentSystem.logoName)
        cardNameLabel.text = card.name
        maskedNumberLabel.text = card.maskedNumber
    }
}
