//
//  CardDataModel.swift
//  Touch E Demo
//
//  Created by Parth on 19/03/24.
//

import Foundation

// MARK: - OrderDataModelElement
struct CardDataModel: Codable {
    let number, expDate: String?
    let id: Int?
    let externalID: String?
    let cardType: Int?

    enum CodingKeys: String, CodingKey {
        case number, expDate, id
        case externalID = "externalId"
        case cardType
    }
}

typealias CardModel = [CardDataModel]
