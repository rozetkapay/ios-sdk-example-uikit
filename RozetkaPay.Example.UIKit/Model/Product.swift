//
//  Product.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let quantity: Int
    let imageName: String
}
