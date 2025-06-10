//
//  CardsViewModel.swift
//  RozetkaPay.Example.UIKit
//
//  Created by Ruslan Kasian Dev on 29.09.2024.
//

import Foundation
import RozetkaPaySDK

class CardsViewModel {
    //MARK: - Credentials
    var clientWidgetParameters = ClientWidgetParameters(
        widgetKey: AppConfiguration.shared.credentials.WIDGET_KEY
    )
    
    //MARK: - Properties
    var items: [CardToken]
    
    //MARK: - Init
    init() {
        self.items = []
    }
    
    required init(items: [CardToken]) {
        self.items = items
    }
    
    //MARK: - MocData
    static var mocData: [CardToken] = {
        return [
            CardToken(
                paymentSystem: .visa,
                name: "Mono Black",
                maskedNumber: "**** **** **** 1234",
                cardToken: "token1"
            ),
            CardToken(
                paymentSystem: .masterCard,
                name: "Mono White",
                maskedNumber: "**** **** **** 5858",
                cardToken: "token1"
            ),
            CardToken(
                paymentSystem: PaymentSystem.other(name: "ПРОСТІР"),
                name: "Oschad Пенсійна",
                maskedNumber: "**** **** **** 9999",
                cardToken: "token1"
            ),
            CardToken(
                paymentSystem: .prostir,
                name: "GlobusBank Light",
                maskedNumber: "**** **** **** 1234",
                cardToken: "token1"
            ),
        ]
    }()
    
    //MARK: - Methods
    func add(item: CardToken) {
        items.append(item)
    }
}
