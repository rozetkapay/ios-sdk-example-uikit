//
//  UINavigationBarExtensions.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 01.10.2024.
//


import UIKit

extension UINavigationBar {
    
    func setupNavigationBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.label] // Черный цвет текста для светлой темы
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
            
           self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
            self.tintColor = UIColor.label
        } else {
            self.barTintColor = UIColor.systemBackground
            self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
            self.tintColor = UIColor.label
        }
    }
}
