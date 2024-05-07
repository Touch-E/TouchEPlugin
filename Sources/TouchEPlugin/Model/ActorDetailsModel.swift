// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetails = try? JSONDecoder().decode(ActorDetails.self, from: jsonData)

import Foundation

// MARK: - ActorDetails
struct ActorDetailsModel: Codable {
    let id: Int?
    let name, info, tags: String?
    let status : String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID, ownerID: String?
    let projectsActed, projectsDirected: [HomeListModel]?
    let interactiveAreas, shotsCount: JSONNull?
    let projectsProduced: [HomeListModel]?

    enum CodingKeys: String, CodingKey {
        case id, name, info, tags, createdDate, images, mainImage, relatedMedia, loadContents
        case externalID = "externalId"
        case ownerID = "ownerId"
        case status = "status"
        case projectsActed, projectsDirected, projectsProduced, interactiveAreas, shotsCount
    }
}

// MARK: - Image
//struct Image1: Codable {
//    let id: Int?
//    let contentType: String?
//    let url: String?
//    let label: String?
//    let mainImage: Bool?
//    let originalWidth, originalHeight: Int?
//    let portraitWidth, portraitX, portraitY, squareWidth: Double?
//    let squareX, squareY: Double?
//    let portrait, square: Bool?
//}

// MARK: - ProjectsCted
struct ProjectsCted1: Codable {
    let id: Int?
    let name, info, tags, status: String?
    let createdDate: Int?
    let images: [Image]?
    let mainImage: Image?
    let relatedMedia: JSONNull?
    let loadContents: Bool?
    let externalID, ownerID: String?
    let rating: JSONNull?
    let reviewsCnt: Int?
    let reviews, parentID, parentExternalID, children: JSONNull?
    let directors, producers, actors, guestActors: JSONNull?
    let brands, products: JSONNull?
    let loadHierarchy: Bool?
    let number: JSONNull?
    let type: String?
    let subtype: String?
    let year: Int?
    let genres: [String]?
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

