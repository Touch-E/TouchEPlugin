//
//  MappingDataModel.swift
//  Touch E Demo
//
//  Created by Parth on 21/02/24.
//

import Foundation

// MARK: - MappingDataModel
struct MappingDataModel: Codable {
    let id, projectID: Int?
    let externalProjectID: JSONNull?
    let mapping: [Mapping]?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case externalProjectID = "externalProjectId"
        case mapping
    }
}

// MARK: - Mapping
struct Mapping: Codable {
    let id, interactiveAreaID, entityID: Int?
    let externalEntityID: JSONNull?
    let type: String?
    let maxAttachTime, maximumTimeInStack: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case interactiveAreaID = "interactiveAreaId"
        case entityID = "entityId"
        case externalEntityID = "externalEntityId"
        case type, maxAttachTime, maximumTimeInStack
    }
}

