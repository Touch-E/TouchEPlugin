//
//  AddressDataModel.swift
//  Touch E Demo
//
//  Created by Parth on 21/02/24.
//


import Foundation

// MARK: - AddressDataModelElement
struct AddressDataModel: Codable {
    let name: String?
    let id: Int?
    let shippingAddress, billingAddress: IngAddress?
    let primary: Bool?
}

// MARK: - IngAddress
struct IngAddress: Codable {
    let country, city, address, zipcode: String?
    let id: Int?
}

typealias AddressData = [AddressDataModel]
