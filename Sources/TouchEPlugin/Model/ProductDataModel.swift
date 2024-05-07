//
//  ProductDataModel.swift
//  Touch E Demo
//
//  Created by Kishan on 07/02/24.
//

import Foundation

// MARK: - ProductDetails
struct ProductDataModel: Codable {
    let id: Int?
    let name, info, tags, status: String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID, ownerID: String?
    let rating, reviewsCnt: Double?
    let reviews: [Review]?
    let brandID: Int?
    let brandExternalID, brandName: String?
    let numberSkus: Int?
    let productSkus: [ProductSkus]?
    let projects: [ProjectsCted1]?
    let attGroups: [AttGroup]?
    let interactiveAreas: JSONNull?
    let shippings: [Shipping]?
    let shotsCount, agreements: JSONNull?
    let removable: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, info, tags, status, createdDate, images, mainImage, relatedMedia, loadContents
        case externalID = "externalId"
        case ownerID = "ownerId"
        case rating, reviewsCnt, reviews
        case brandID = "brandId"
        case brandExternalID = "brandExternalId"
        case brandName, numberSkus, productSkus, projects, attGroups, interactiveAreas, shippings, shotsCount, agreements, removable
    }
}

