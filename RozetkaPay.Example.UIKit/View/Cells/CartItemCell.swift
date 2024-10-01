//
//  CartItemCell.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 01.10.2024.
//

import UIKit

class CartItemCell: UITableViewCell {
    
    private let itemImageView = UIImageView()
    private let itemNameLabel = UILabel()
    private let itemQuantityLabel = UILabel()
    private let itemPriceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.contentMode = .scaleAspectFit
        itemImageView.layer.cornerRadius = 8
        itemImageView.clipsToBounds = true
        contentView.addSubview(itemImageView)
        
        itemNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        itemQuantityLabel.font = UIFont.systemFont(ofSize: 14)
        itemQuantityLabel.textColor = .gray
        itemPriceLabel.font = UIFont.systemFont(ofSize: 16)
        itemPriceLabel.textColor = .systemGreen
        let stackView = UIStackView(arrangedSubviews: [itemNameLabel, itemQuantityLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(itemPriceLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalToConstant: 50),
            itemImageView.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            itemPriceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            itemPriceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: Product) {
        itemImageView.image = UIImage(named: item.imageName)
        itemNameLabel.text = item.name
        itemQuantityLabel.text = "\(item.quantity) x \(item.price)"
        itemPriceLabel.text = String(format: "%.2f", item.price * Double(item.quantity))
    }
}
