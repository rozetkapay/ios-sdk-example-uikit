//
//  CustomAlertViewController.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 23.04.2025.
//

import UIKit

class CustomAlertViewController: UIViewController {

    private let alertItem: AlertItem

    init(alertItem: AlertItem) {
        self.alertItem = alertItem
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        showAlertView()
    }

    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }

    private func showAlertView() {
        let alertView = CustomAlertView(item: alertItem)
        alertView.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }

        view.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])
    }
}
