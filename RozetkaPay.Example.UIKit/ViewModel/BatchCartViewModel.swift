//
//  BatchCartViewModel.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 30.05.2025.
//
import RozetkaPaySDK
import Foundation

final class BatchCartViewModel {
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
    
    private static var batchApiKey: String {
        AppConfiguration.shared.credentials.BATCH_API_KEY
    }
    
    //MARK: - Properties
    var orders: [Order]
    var externalId: String
    var isNeedToUseTokenizedCard = false
    
    var totalNetAmountInCoins: Int64 {
        orders.reduce(0) { $0 + $1.totalNetAmountInCoins }
    }

    var totalVatAmountInCoins: Int64 {
        orders.reduce(0) { $0 + $1.totalVatAmountInCoins }
    }

    var totalAmountInCoins: Int64 {
        orders.reduce(0) { $0 + $1.totalAmountInCoins }
    }
    
    var totalAmount: Double {
        orders.reduce(0) { $0 + $1.totalAmount }
    }
    
    var shipment: String {
        Localization.cart_shipment_cost_free.description
    }
    
    //MARK: - Init
    init(
        externalId: String,
        orders: [Order]
    ) {
        self.externalId = externalId
        self.orders = orders
    }
    
    //MARK: - MocData
    static func generateMocData() ->[Order] {
        return [
            Order(
                apiKey: batchApiKey,
                description: "order description",
                externalId: generateOrderId(),
                unifiedExternalId: "test_unifiedExternalId",
                products: [
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemFirst.name,
                        name: "Air Pods RZTK",
                        price: 700.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemSecond.name,
                        name: "RZTK Power Bank",
                        price: 300.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemThird.name,
                        name: "RZTK Macbook Pro 16",
                        price: 6000.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemFourth.name,
                        name: "RZTK magic mouse",
                        price: 1000.00,
                        quantity: 1,
                        url: "url"
                    )
                ]
            ),
            Order(
                apiKey: batchApiKey,
                description: "order description",
                externalId: generateOrderId(),
                products: [
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemFifth.name,
                        name: "Комп'ютер Apple Mac Mini M4",
                        price: 1000.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemSixth.name,
                        name: "RZTK Apple iPad 10.9",
                        price: 800.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemSeventh.name,
                        name: "RZTK Apple Watch Ultra 2",
                        price: 900.00,
                        quantity: 1,
                        url: "url"
                    ),
                    Product(
                        category: "category1",
                        currency: Config.defaultCurrencyCode,
                        description: "description test",
                        image: Images.cartItemEighth.name,
                        name: "Моноблок Apple iMac М4 4.5К",
                        price: 1200.00,
                        quantity: 1,
                        url: "url"
                    )
                ]
            )
            
        ]
    }
}

//MARK: - Private methods
private extension BatchCartViewModel {
    private func add(item: Order) {
        orders.append(item)
    }
}

//MARK: - Methods
extension BatchCartViewModel {
    static func generateExternalId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let uuidSuffix = UUID().uuidString.prefix(8)
        let orderId = "external-apple-\(timestamp)-\(uuidSuffix)"
        return orderId
    }
    
    static func generateOrderId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970 * 1000)
        let uuidSuffix = UUID().uuidString.prefix(8)
        let orderId = "order-apple-\(timestamp)-\(uuidSuffix)"
        return orderId
    }
    
}
