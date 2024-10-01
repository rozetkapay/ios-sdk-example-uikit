//
//  ContentViewController.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import UIKit

class ContentViewController: UIViewController {
    
    private let cardsButton = UIButton(type: .system)
    private let payButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "RozetkaPay.Example"
        view.backgroundColor = UIColor.systemBackground
        
        cardsButton.setTitle("Cards", for: .normal)
        cardsButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        cardsButton.backgroundColor = UIColor.label
        cardsButton.setTitleColor(UIColor.systemBackground, for: .normal)
        cardsButton.layer.cornerRadius = 10
        cardsButton.translatesAutoresizingMaskIntoConstraints = false
        cardsButton.addTarget(self, action: #selector(didTapCardsButton), for: .touchUpInside)
        
        payButton.setTitle("Pay", for: .normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        payButton.backgroundColor = .systemGreen
        payButton.setTitleColor(.white, for: .normal)
        payButton.layer.cornerRadius = 10
        payButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        
        
        let stackView = UIStackView(arrangedSubviews: [
            cardsButton,
            payButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            cardsButton.heightAnchor.constraint(equalToConstant: 50),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc private func didTapCardsButton() {
        let cardsVC = CardsListViewController(items: CardsViewModel.mocData)
        navigationController?.pushViewController(cardsVC, animated: true)
    }
    
    @objc private func didTapPayButton() {
        // Navigate to CartViewController
        //        let cartVC = CartViewController(orderId: "order_test_3232-445", items: CartViewModel.mocData)
        //        navigationController?.pushViewController(cartVC, animated: true)
    }
}

@available(iOS 17, *)
#Preview {
    let vc = ContentViewController()
    return vc
}

