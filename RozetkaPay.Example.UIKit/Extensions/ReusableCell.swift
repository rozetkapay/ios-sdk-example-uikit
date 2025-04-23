//
//  ReusableCell.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 23.04.2025.
//

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
   static var reuseIdentifier: String {
        return String(describing: self)
    }
}
