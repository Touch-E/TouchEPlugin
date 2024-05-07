//
//  CountryDataModel.swift
//  Touch E Demo
//
//  Created by Jaydip Godhani on 01/03/24.
//

import Foundation

// MARK: - Country
struct AddressCountry: Codable {
    let error: Bool?
    let msg: String?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let city, country: String?
    let populationCounts: [PopulationCount]?
}

// MARK: - PopulationCount
struct PopulationCount: Codable {
    let year: String?
    let value: String?
    let sex: Sex?
    let reliabilty: Reliabilty?
}

enum Reliabilty: String, Codable {
    case cityInner = "city inner"
    case finalFigureComplete = "Final figure, complete"
    case otherEstimate = "Other estimate"
    case provisionalFigure = "Provisional figure"
}

enum Sex: String, Codable {
    case bothSexes = "Both Sexes"
    case usually = "usually"
}
