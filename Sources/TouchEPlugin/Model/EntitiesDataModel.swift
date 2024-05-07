//
//  EntitiesDataModel.swift
//  Touch E Demo
//
//  Created by Parth on 20/02/24.
//
import Foundation

// MARK: - EntitiesDataModel
struct EntitiesDataModel: Codable {
    let directors: [Actor]?
    let producers: [Actor]?
    let actors: [Actor]?
    let brands: [Brand]?
    let products: [Product]?
    let relatedMedia: [RelatedMedia]?
}
