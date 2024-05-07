//
//  dataModel.swift
//  Touch E
//
//  Created by Kishan on 15/01/24.
//

import Foundation

// MARK: - WelcomeElement
public struct HomeListModel: Codable {
    let id: Int?
    let name, info, tags, status: String?
    let createdDate: Int?
    public let images: [Image]?
    let mainImage: Image?
    let relatedMedia: [HomeListModel]?
    let loadContents: Bool?
    let externalID: String?
    let ownerID: OwnerID?
    let rating: JSONNull?
    let reviewsCnt: Int?
    let reviews, parentID, parentExternalID, children: JSONNull?
    let directors, producers, actors: [Actor]?
    let guestActors: JSONNull?
    let brands: [Brand]?
    let products: JSONNull?
    let loadHierarchy: Bool?
    let number: JSONNull?
    let type: String?
    let subtype: String?
    let year: Int?
    let genres: [Genre]?
    let videoURL: String?
    let duration: Double?
    let videoEntityID: Int?
    let readyForEdit, mergeWithMarketpace: Bool?
    let startTime, width, height, frames: Int?
    let urlSpriteS, urlSpriteL, urlSpriteG: String?

    enum CodingKeys: String, CodingKey {
        case id, name, info, tags, status, createdDate, images, mainImage, relatedMedia, loadContents
        case externalID = "externalId"
        case ownerID = "ownerId"
        case rating, reviewsCnt, reviews
        case parentID = "parentId"
        case parentExternalID = "parentExternalId"
        case children, directors, producers, actors, guestActors, brands, products, loadHierarchy, number, type, subtype, year, genres
        case videoURL = "videoUrl"
        case duration
        case videoEntityID = "videoEntityId"
        case readyForEdit, mergeWithMarketpace, startTime, width, height, frames, urlSpriteS, urlSpriteL, urlSpriteG
    }
}

// MARK: - Actor
struct Actor: Codable {
    let id: Int?
    let name, info, tags: String?
    let status: String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID: String?
    let ownerID: OwnerID?
    let projectsActed, projectsDirected, projectsProduced, interactiveAreas: JSONNull?
    let shotsCount: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, name, info, tags, status, createdDate, images, mainImage, relatedMedia, loadContents
        case externalID = "externalId"
        case ownerID = "ownerId"
        case projectsActed, projectsDirected, projectsProduced, interactiveAreas, shotsCount
    }
}

// MARK: - Image
public struct Image: Codable {
    let id: Int?
    let contentType: ContentType?
    public let url: String?
    let label: String?
    let mainImage: Bool?
    let originalWidth, originalHeight: Int?
    let portraitWidth, portraitX, portraitY, squareWidth: Double?
    let squareX, squareY: Double?
    let portrait, square: Bool?
}

enum ContentType: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case videoMp4 = "video/mp4"
}

enum OwnerID: String, Codable {
    case o1 = "O1"
}

enum ActorStatus: String, Codable {
    case new = "NEW"
}

// MARK: - Brand
struct Brand: Codable {
    let id: Int?
    let name: String?
    let info: String?
    let tags: String?
    let status: String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID: String?
    let ownerID: OwnerID?
    let rating: Double?
    let reviewsCnt: Int?
    let reviews: JSONNull?
    let websiteURL: String?
    let numberProducts: Int?
    let projects: JSONNull?
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

//enum BrandNameEnum: String, Codable {
//    case adidas = "Adidas"
//    case castro = "Castro"
//    case foxHome = "FoxHome"
//    case guitarCenter = "Guitar Center"
//}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let name: String?
    let info, tags: String?
    let status: String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID: String?
    let ownerID: OwnerID?
    let rating: Double?
    let reviewsCnt: Int?
    let reviews: [Review]?
    let brandID: Int?
    let brandExternalID: String?
    let brandName: String? //BrandNameEnum
    let numberSkus: Int?
    let productSkus: [ProductSkus]?
    let projects: JSONNull?
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

// MARK: - AttGroup
struct AttGroup: Codable {
    let id: Int?
    let externalID: JSONNull?
    let name: String?
    let type: TypeEnum?
    let opt: Bool?
    let values: [Value]?

    enum CodingKeys: String, CodingKey {
        case id
        case externalID = "externalId"
        case name, type, opt, values
    }
}

//enum AttributeNameEnum: String, Codable {
//    case color = "Color"
//    case nameColor = "Color "
//    case pattern = "Pattern"
//    case print = "Print"
//    case size = "Size"
//}

enum TypeEnum: String, Codable {
    case color = "Color"
    case custom = "Custom"
    case sizeClothing = "Size: Clothing"
    case sizeShoesUS = "Size: Shoes(US)"
    case empty = ""
    case i = "I"
    case o = "O"
}

// MARK: - Value
struct Value: Codable {
    let id: Int?
    let name: String?
    let type: TypeEnum?
    let attributeName: String?
    let value: String?
    let externalID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, type, attributeName, value
        case externalID = "externalId"
    }
}

// MARK: - ProductSkus
struct ProductSkus: Codable {
    let id: Int?
    let name, info, tags: JSONNull?
    let status: String?
    let createdDate: JSONNull?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID: String?
    let ownerID: JSONNull?
    let sku: String?
    let curr: Curr?
    let price, stock: Int?
    let attributes: [Value]?

    enum CodingKeys: String, CodingKey {
        case id, name, info, tags, status, createdDate, images, mainImage, relatedMedia, loadContents
        case externalID = "externalId"
        case ownerID = "ownerId"
        case sku, curr, price, stock, attributes
    }
}

enum Curr: String, Codable {
    case usd = "USD"
}

// MARK: - Review
struct Review: Codable {
    let id: Int?
    let rating: Double?
    let review: String?
    let userID: Int?
    let userName: String?
    let userImageURL: JSONNull?
    let productID: Int?
    let projectID: JSONNull?
    let brandID: Int?
    let createdDate: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id, rating, review
        case userID = "userId"
        case userName
        case userImageURL = "userImageUrl"
        case productID = "productId"
        case projectID = "projectId"
        case brandID = "brandId"
        case createdDate, status
    }
}

enum ReviewStatus: String, Codable {
    case active = "ACTIVE"
}

// MARK: - Shipping
struct Shipping: Codable {
    let id: Int?
    let name: ShippingName?
    let zone: JSONNull?
    let price: Int?
    let currency: Curr?
    let externalID: String?
    let freeAmount: Int?
    let countries: [Country]?

    enum CodingKeys: String, CodingKey {
        case id, name, zone, price, currency
        case externalID = "externalId"
        case freeAmount, countries
    }
}

enum Country: String, Codable {
    case bulgaria = "Bulgaria"
    case israel = "Israel"
    case worldwide = "worldwide"
}

enum ShippingName: String, Codable {
    case air = "air"
    case freeShipping = "free shipping"
    case land = "land"
    case nameAir = "Air"
    case nameLand = "Land"
    case shippingNew = "Shipping new "
}

enum Genre: String, Codable {
    case action = "Action"
    case comedy = "Comedy"
    case family = "Family"
}

public typealias HomeData = [HomeListModel]


class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
