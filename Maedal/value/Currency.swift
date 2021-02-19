//
//  Currency.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/14.
//

import Foundation

class Currency {
    private let currencies: [String: CountryInfo] = [
        "KRW" : CountryInfo(country: 82, currency: "KRW", symbol: "₩")
    ]
}

class CountryInfo {
    var country: Int
    var currency: String
    var symbol: Character
    
    init(country: Int, currency: String, symbol: Character) {
        self.country = country
        self.currency = currency
        self.symbol = symbol
    }
}

class CurrencyUnit {
    static let currencies = [
        "$", "₩", "€", "£", "¥", "฿", "₵", "₡", "₫", "֏", "ƒ", "₲", "₴", "₭", "₾", "₺",
        "₼", "₦", "₱", "៛", "₽", "₹", "₿"
    ]
}
