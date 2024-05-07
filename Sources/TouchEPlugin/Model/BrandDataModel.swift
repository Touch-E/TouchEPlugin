//
//  BrandDataModel.swift
//  Touch E Demo
//
//  Created by Kishan on 07/02/24.
//

import Foundation

// MARK: - BrandDetails
struct BrandDataModel: Codable {
    let id: Int?
    let name, info, tags, status: String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: ImageBrand?
    let relatedMedia: [String]?
    let loadContents: Bool?
    let externalID, ownerID: String?
    let rating: Double?
    let reviewsCnt: Int?
    let reviews: [Review]?
    let websiteURL: String?
    let numberProducts: Int?
    let projects: [HomeListModel]?
    let products: [Product]?
    let shippings: [Shipping]?
    let activeAgreementsCnt: Int?
    let marketplaceType: String?

    enum CodingKeys: String, CodingKey {
        case id, name, info, tags, status, createdDate, images, mainImage, relatedMedia, loadContents
        case externalID = "externalId"
        case ownerID = "ownerId"
        case rating, reviewsCnt, reviews
        case websiteURL = "websiteUrl"
        case numberProducts, projects, products, shippings, activeAgreementsCnt, marketplaceType
    }
}

// MARK: - Image
struct ImageBrand: Codable {
    let id: Int?
    let contentType: ContentTypeBrand?
    let url: String?
    let label: String?
    let mainImage: Bool?
    let originalWidth, originalHeight: Int?
    let portraitWidth, portraitX, portraitY, squareWidth: Double?
    let squareX, squareY: Double?
    let portrait, square: Bool?
}

enum ContentTypeBrand: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case videoMp4 = "video/mp4"
}

