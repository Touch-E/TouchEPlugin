//
//  CartDataModel.swift
//  Touch E Demo
//
//  Created by Kishan on 08/02/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cartDataModel = try? JSONDecoder().decode(CartDataModel.self, from: jsonData)

import Foundation

// MARK: - CartDataModelElement
public struct CartDataModel: Codable {
    let id: Int?
    let shopID, title: JSONNull?
    let price, count, projectID: Int?
    let shipping: Shipping?
    let shippingAddress, billingAddress, orderID: JSONNull?
    let product: Product?
    let sku: ProductSkus?
    let total: Int?
    let review: JSONNull?
    let agreement: Bool?


    enum CodingKeys: String, CodingKey {
        case id
        case shopID = "shopId"
        case title, price, count
        case projectID = "projectId"
        case shipping, shippingAddress, billingAddress
        case orderID = "orderId"
        case product, sku, total, review, agreement
    }
}
public typealias CartData = [CartDataModel]
// Custom encoding strategy to filter out nil values

