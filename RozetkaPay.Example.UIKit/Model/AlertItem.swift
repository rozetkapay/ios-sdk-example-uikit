//
//  AlertItem.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 23.04.2025.
//

import UIKit

struct AlertItem: Identifiable {
    let id = UUID()
    let type: AlertType
    let title: String
    let message: String
}

enum AlertType {
    case success
    case error
    case info
    case soon
    case warning
    case custom(emoji: String)
    
    var color: UIColor {
        switch self {
        case .success:
            return .systemGreen
        case .error:
            return .systemRed
        case .info:
            return .systemBlue
        case .soon:
            return .systemBlue
        case .custom:
            return .white
        case .warning:
            return .systemOrange
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .black
        case .warning:
            return .black
        }
    }
    
    var buttonColor: UIColor {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .systemGreen
        case .warning:
            return .white
        }
    }
    
    var emoji: String {
        switch self {
        case .success:
            return "✅"
        case .error:
            return "❌"
        case .info:
            return "ℹ️"
        case .soon:
            return "🔜"
        case .custom(let emoji):
            return emoji
        case .warning:
            return "⚠️"
        }
    }
    
    var circleColor: UIColor {
        switch self {
        case .success:
            return .white
        case .error:
            return .white
        case .info:
            return .white
        case .soon:
            return .white
        case .custom:
            return .gray
        case .warning:
            return .white
        }
    }
}
