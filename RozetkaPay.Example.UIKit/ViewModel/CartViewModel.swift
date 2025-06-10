//
//  CartViewModel.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 01.10.2024.
//
import RozetkaPaySDK
import Foundation

final class CartViewModel {
    
    //MARK: - Credentials
    private let credentials = AppConfiguration.shared.credentials
    var clientParameters: ClientAuthParameters {
        ClientAuthParameters(
            token: credentials.AUTH_TOKEN,
            widgetKey: credentials.WIDGET_KEY
        )
    }
    
    var testApplePayConfig: ApplePayConfig {
        ApplePayConfig.Test(
            merchantIdentifier: credentials.APPLE_PAY_MERCHANT_ID,
            merchantName: credentials.APPLE_PAY_MERCHANT_NAME
        )
    }
    
    var testCardToken: String {
        credentials.TEST_CARD_TOKEN_1
    }
    
    var errorCardToken: String {
        credentials.ERROR_CARD_TOKEN_1
    }
    
    //MARK: - Properties
    var items: [Product]
    var orderId: String
    var isNeedToUseTokenizedCard = false
    
    var totalNetAmountInCoins: Int64 {
        items.reduce(0) { $0 + $1.netAmountInCoins }
    }

    var totalVatAmountInCoins: Int64 {
        items.reduce(0) { $0 + $1.vatAmountInCoins }
    }

    var totalAmountInCoins: Int64 {
        totalNetAmountInCoins + totalVatAmountInCoins
    }
    
    var totalAmount: Double {
        totalAmountInCoins.currencyFormatAmount()
    }
    
    var shipment: String {
        Localization.cart_shipment_cost_free.description
    }
    
    //MARK: - Init
    init(
        orderId: String,
        items: [Product]
    ) {
        self.orderId = orderId
        self.items = items
    }
    
    //MARK: - MocData
    static var mocData: [Product] = {
        return [
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemFirst.name,
                name: "Air Pods RZTK",
                price: 700.00,
                quantity: 3,
                url: "url"
            ),
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemSecond.name,
                name: "RZTK Power Bank",
                price: 300,
                quantity: 1,
                url: "url"
            ),
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemThird.name,
                name: "RZTK Macbook Pro 16",
                price: 6000,
                quantity: 2,
                url: "url"
            ),
            Product(
                category: "category1",
                currency: Config.defaultCurrencyCode,
                description: "description test",
                image: Images.cartItemFourth.name,
                name: "RZTK magic mouse",
                price: 1200.00,
                quantity: 2,
                url: "url"
            )
        ]
    }()
}

//MARK: - Private methods
private extension CartViewModel {
    
    private func add(item: Product) {
        items.append(item)
    }
}

//MARK: - Methods
extension CartViewModel {
    
    static func generateOrderId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let uuidSuffix = UUID().uuidString.prefix(8)
        let orderId = "order-apple-\(timestamp)-\(uuidSuffix)"
        return orderId
    }
}
