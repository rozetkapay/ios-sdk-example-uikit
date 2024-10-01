//
//  PaymentSystem.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import Foundation

enum PaymentSystem: Equatable {
    case visa
    case masterCard
    case prostir
    case other(name: String)
    
    static func parsePaymentSystem(from input: String?) -> PaymentSystem {
        guard let input = input?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) else {
            return .other(name: "Unknown")
        }
        
        switch input {
        case PaymentSystem.visa.toString().lowercased():
            return .visa
        case PaymentSystem.masterCard.toString().lowercased():
            return .masterCard
        case PaymentSystem.prostir.toString().lowercased():
            return .prostir
        default:
            return .other(name: input)
        }
    }
    
    private func toString() -> String {
        switch self {
        case .visa:
            return "Visa"
        case .masterCard:
            return "MasterCard"
        case .prostir:
            return "Prostir"
        case .other(let name):
            return name
        }
    }
 
    var logoName: String {
        switch self {
        case .visa:
            return "paymentSystem.visa"
        case .masterCard:
            return "paymentSystem.mastercard"
        case .prostir:
            return "paymentSystem.prostir"
        case .other:
            return "paymentSystem.default"
        }
    }
}
