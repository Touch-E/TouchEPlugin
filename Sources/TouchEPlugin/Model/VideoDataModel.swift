//
//  VideoDataModel.swift
//  Touch E
//
//  Created by Kishan on 17/01/24.
//

import Foundation

// MARK: - Welcome
struct VideoDataModel: Codable {
    let id: Int?
    let loadContents, loadHierarchy: Bool?
    let videoURL: String?
    let duration: Double?
    let videoEntityID: Int?
    let readyForEdit, mergeWithMarketpace: Bool?
    let startTime: Double?
    let width, height, frames: Int?
    let urlSpriteS, urlSpriteL, urlSpriteG: String?
    let shots: [Int]?
    let events: [Event]?
    let screeningFile: ScreeningFile?
    let vovs: [Vov]?

    enum CodingKeys: String, CodingKey {
        case id, loadContents, loadHierarchy
        case videoURL = "videoUrl"
        case duration
        case videoEntityID = "videoEntityId"
        case readyForEdit, mergeWithMarketpace, startTime, width, height, frames, urlSpriteS, urlSpriteL, urlSpriteG, shots, events, screeningFile, vovs
    }
}

// MARK: - Event
struct Event: Codable {
    let eventID, interactiveAreaID, id, t: Int?
    let r: [Double]?
    let type: TypeEnum?

    enum CodingKeys: String, CodingKey {
        case eventID = "eventId"
        case interactiveAreaID = "interactiveAreaId"
        case id, t, r, type
    }
}


// MARK: - ScreeningFile
struct ScreeningFile: Codable {
    let id, projectID: Int?
    let externalProjectID: JSONNull?
    let productMappingID: Int?
    let operatorID: String?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case externalProjectID = "externalProjectId"
        case productMappingID = "productMappingId"
        case operatorID = "operatorId"
    }
}

// MARK: - Vov
struct Vov: Codable {
    let shotID, startFrame, endFrame: Int?
    let relatedProjects: [RelatedProject]?

    enum CodingKeys: String, CodingKey {
        case shotID = "shotId"
        case startFrame, endFrame, relatedProjects
    }
}

// MARK: - RelatedProject
struct RelatedProject: Codable {
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
    let type, subtype: String?
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



