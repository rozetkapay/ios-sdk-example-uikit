//
//  UIViewControllerExtensions.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 23.04.2025.
//

import UIKit

extension UIViewController {
    func showCustomAlert(item: AlertItem) {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            print("⚠️ Couldn't find key window.")
            return
        }

        let backgroundView = UIView(frame: keyWindow.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        backgroundView.alpha = 0

        let alertView = CustomAlertView(item: item)
        alertView.alpha = 0
        alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

        alertView.onDismiss = {
            UIView.animate(withDuration: 0.2, animations: {
                alertView.alpha = 0
                alertView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                backgroundView.alpha = 0
            }, completion: { _ in
                alertView.removeFromSuperview()
                backgroundView.removeFromSuperview()
            })
        }

        keyWindow.addSubview(backgroundView)
        keyWindow.addSubview(alertView)

        alertView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor),
            alertView.widthAnchor.constraint(lessThanOrEqualToConstant: 300)
        ])

        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseInOut]) {
            backgroundView.alpha = 1
            alertView.alpha = 1
            alertView.transform = .identity
        }
    }
}
