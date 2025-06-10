//
//  ContentViewController.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import UIKit


import UIKit

final class ContentViewController: UIViewController {

    private lazy var cardsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.main_cards_button_title.description, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = UIColor.label
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.layer.cornerRadius = Config.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            self?.didTapCardsButton()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()

    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.main_pay_button_title.description, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Config.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            self?.didTapPayButton()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var batchPayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.main_batch_pay_button_title.description, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Config.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        let action = UIAction { [weak self] _ in
            self?.didTapBatchPayButton()
        }
        button.addAction(action, for: .primaryActionTriggered)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            cardsButton,
            payButton,
            batchPayButton
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = Localization.main_title.description
        view.backgroundColor = .systemBackground

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            cardsButton.heightAnchor.constraint(equalToConstant: 50),
            payButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func didTapCardsButton() {
        let vc = CardsListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func didTapPayButton() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func didTapBatchPayButton() {
        let vc = BatchCartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

@available(iOS 17, *)
#Preview {
    let vc = ContentViewController()
    return vc
}

