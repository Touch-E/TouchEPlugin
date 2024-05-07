//
//  OrderDataModel.swift
//  Touch E Demo
//
//  Created by Parth on 26/02/24.
//


import Foundation

// MARK: - OrderDataModelElement
struct OrderDataModel: Codable {
    let id, number: Int?
    let userID: JSONNull?
    let brand: Brand?
    let brandReview: Review?
    let date, processStatus, errorStatus: String?
    let externalID, total, productsTotal, shippingTotal: Int?
    let products: [ProductElement]?

    enum CodingKeys: String, CodingKey {
        case id, number
        case userID = "userId"
        case brand, brandReview, date, processStatus, errorStatus
        case externalID = "externalId"
        case total, productsTotal, shippingTotal, products
    }
}

// MARK: - ProductElement
struct ProductElement: Codable {
    let id: Int?
    let shopID, title: JSONNull?
    let price, count, projectID: Int?
    let shipping: Shipping?
    let shippingAddress, billingAddress: IngAddress?
    let orderID: Int?
    let product: Product?
    let sku: ProductSkus?
    let total: Int?
    let review: Review?
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

typealias OrderData = [OrderDataModel]
