//
//  CustomAlertView.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 23.04.2025.
//

import UIKit

import UIKit

final class CustomAlertView: UIView {

    var onDismiss: (() -> Void)?
    private let item: AlertItem

    //MARK: - Inits
    init(item: AlertItem) {
        self.item = item
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = item.title
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = item.type.textColor
        label.textAlignment = .center
        return label
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = item.type.emoji
        label.font = .systemFont(ofSize: 28)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emojiCircle: UIView = {
        let view = UIView()
        view.backgroundColor = item.type.circleColor
        view.layer.cornerRadius = 30
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = item.message
        label.font = .systemFont(ofSize: 16)
        label.textColor = item.type.textColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.ok_button_title.description, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(item.type.color, for: .normal)
        button.backgroundColor = item.type.buttonColor
        button.layer.cornerRadius = Config.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false

        let action = UIAction { [weak self] _ in
            self?.didTapButton()
        }
        button.addAction(action, for: .primaryActionTriggered)

        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, emojiCircle, messageLabel, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private func setupUI() {
        backgroundColor = item.type.color
        layer.cornerRadius = 16
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            emojiCircle.widthAnchor.constraint(equalToConstant: 60),
            emojiCircle.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalTo: stack.widthAnchor),

            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }

    private func didTapButton() {
        UIView.animate(withDuration: 0.2,
                       animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.onDismiss?()
        })
    }
}
